import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:webrtc/app/app_keys.dart';
import 'package:webrtc/repositories/session_repository.dart';
import 'package:webrtc/view_models/base_model.dart';
import 'package:webrtc/web_services/socket.dart';

typedef void StreamStateCallback(MediaStream stream);

enum CallingState {
  Loading,
  Calling,
  Ending,
}

class CallScreenViewModel extends BaseViewModel {
  SocketManager _socketManager = SocketManager.getInstance();
  SessionRepository sessionRepository = SessionRepository();

  Map<String, dynamic> _iceServers = {
    'iceServers': [
      {'url': 'stun:api.clinic.vio.health:5349'},
      {
        'url': 'turn:api.clinic.vio.health:5349',
        'username': 'vio',
        'credential':
            'kIPSYW9dtkOUVVXeBjRDA3mneaN6T1j4xZKkJJl2RXNDIyHaFmB6dNhhNSdvIkn3'
      },
    ]
  };

  final Map<String, dynamic> _config = {
    'mandatory': {},
    'optional': [
      {'DtlsSrtpKeyAgreement': true},
    ],
  };

  final Map<String, dynamic> constraints = {
    'mandatory': {
      'OfferToReceiveAudio': true,
      'OfferToReceiveVideo': true,
    },
    'optional': [],
  };

  MediaStream _localStream;
  MediaStream _remoteStream;
  StreamStateCallback onLocalStream;
  StreamStateCallback onRemoteStream;
  StreamStateCallback onAddRemoteStream;
  StreamStateCallback onRemoveRemoteStream;
  RTCPeerConnection pc;

  CallingState _state;
  var _session;

  get session => _session;

  CallingState get state => _state;

  init(id) {
    print('asdsadasda');
    _socketManager.subscribe(id);
    _socketManager.socketInstance.on(id, (data) => getSession(id));
    listenToCandidate();
    _state = CallingState.Loading;
  }

  getSession(sessionId, {notify = true}) async {
    try {
      setBusyWithOutNotify(true);
      var response = await sessionRepository.getSession(sessionId);
      _session = response;
      onUpdateSession();
      if (notify) notifyListeners();
      setBusy(false);
    } catch (e) {
      setBusy(false);
      print(handelError(e));
    }
  }

  listenToCandidate() {
    _socketManager.socketInstance.on("candidate", (data) async {
      print("candidate");
      print(data);
      var candidateMap = data['candidate'];
      RTCIceCandidate candidate = new RTCIceCandidate(candidateMap['candidate'],
          candidateMap['sdpMid'], candidateMap['sdpMLineIndex']);
      if (pc != null) {
        await pc.addCandidate(candidate);
      }
    });
  }

  _createPeerConnection() async {
    _localStream = await createStream('video');
    pc = await createPeerConnection(_iceServers, _config);
    pc.addStream(_localStream);
    pc.onIceCandidate = (candidate) {
      sessionRepository.updateSessionCandidate(
        _session["_id"],
        {
          "author": AppKeys.userId,
          "data": {
            'candidate': {
              'sdpMLineIndex': candidate.sdpMlineIndex,
              'sdpMid': candidate.sdpMid,
              'candidate': candidate.candidate,
            },
          },
        },
      );
    };
    pc.onIceConnectionState = (state) {
      print("pc state");
      print(state);
    };
    pc.onAddStream = (stream) {
      print("onAddStream");
      _remoteStream = stream;
      if (this.onAddRemoteStream != null) this.onAddRemoteStream(stream);
//      _establishConnection();
    };
    pc.onRemoveStream = (stream) {
      _remoteStream = null;
      if (this.onRemoveRemoteStream != null) this.onRemoveRemoteStream(stream);
    };
  }

  Future<MediaStream> createStream(media) async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'mandatory': {
          'minWidth': '640',
          // Provide your own width, height and frame rate here
          'minHeight': '480',
          'minFrameRate': '30',
        },
        'facingMode': 'user',
        'optional': [],
      }
    };

    MediaStream stream = await navigator.getUserMedia(mediaConstraints);
    if (this.onLocalStream != null) {
      this.onLocalStream(stream);
    }
    return stream;
  }

  createCall() {
    if (_localStream != null) {
      _localStream.dispose();
      _localStream = null;
    }
    if (pc != null) {
      pc.dispose();
    }
    _createPeerConnection().then(_createOffer);
  }

  _createOffer(data) async {
    try {
      RTCSessionDescription s = await pc.createOffer(constraints);
      pc.setLocalDescription(s);
      sessionRepository.updateSessionOffer(_session["_id"], {
        'author': AppKeys.userId,
        'description': {
          'sdp': s.sdp,
        },
        'media': 'video',
        'type': s.type
      });
    } catch (e) {
      print(e.toString());
    }
  }

  _createAnswer() async {
    try {
      RTCSessionDescription s = await pc.createAnswer(constraints);
      pc.setLocalDescription(s);
      sessionRepository.updateSessionAnswer(_session["_id"], {
        'author': AppKeys.userId,
        'description': {'sdp': s.sdp},
        'type': s.type
      });
    } catch (e) {
      print(e.toString());
    }
  }

  onUpdateSession() async {
    if (_session["offer"] == null && _session["answer"] == null) {
      createCall();
    } else if (_session["offer"] != null &&
        _session["offer"]["author"] != AppKeys.userId) {
      await _createPeerConnection();
      await setRemoteStream(_session["offer"]);
      await _createAnswer();
      this._state = CallingState.Calling;
    } else if (_session["answer"] != null &&
        _session["answer"]["author"] != AppKeys.userId) {
      await setRemoteStream(_session["answer"]);
      this._state = CallingState.Calling;
    }
    notifyListeners();
  }

  setRemoteStream(data) async {
    print("setRemoteStream");
    print(data);
    await pc.setRemoteDescription(
        RTCSessionDescription(data['description']['sdp'], data['type']));
  }

  outFromCall() {}

  @override
  dispose() {
    if (_localStream != null) {
      _localStream.dispose();
      _localStream = null;
    }
    _socketManager.unsubscribe(_session["_id"]);
    _socketManager.socketInstance.off(_session["_id"], null);
    _socketManager.socketInstance.off("candidate", null);
    if (pc != null) {
      pc.dispose();
    }
    super.dispose();
  }
}
