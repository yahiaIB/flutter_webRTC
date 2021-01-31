import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';
import 'package:webrtc/screens/call_screen/call_screen_view_model.dart';
import 'package:webrtc/utils/dialogs.dart';

class CallScreen extends StatefulWidget {
  final String sessionId;

  CallScreen({this.sessionId});

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {

  RTCVideoRenderer _localRenderer = new RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = new RTCVideoRenderer();

  @override
  void initState() {
    // TODO: implement initState
    CallScreenViewModel _callVM = Provider.of<CallScreenViewModel>(context,listen:false);
    _callVM.getSession(widget.sessionId);
    _callVM.init(widget.sessionId);
    initRenderers();
    super.initState();
  }

  initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }



  endCall() async{
    bool confirm = await Dialogs.confirmDialog3(context , "Do you want to end this call");
    if(confirm){
      try{
//        await model.endCall();
//                                await Navigator.pushReplacement(
//                                  context,
//                                  MaterialPageRoute(
//                                    builder: (context) => SessionDetailsScreen(session: widget.session.sId,backToHome: true,),
//                                  ),
//                                );
        print("call end so");
        return;
      }catch(e){
        print(e);
      }
    }
    Navigator.pop(context,false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CallScreenViewModel>(
        builder: (context , model , child) {
          model.onLocalStream = ((stream) {
            _localRenderer.srcObject = stream;
          });
          model.onAddRemoteStream = ((stream) {
            _remoteRenderer.srcObject = stream;
          });
          model.onRemoveRemoteStream = ((stream) {
            _remoteRenderer.srcObject = null;
          });
          return OrientationBuilder(builder: (context, orientation) {
            return Stack(children: <Widget>[
              Positioned(
                  left: 0.0,
                  right: 0.0,
                  top: 0.0,
                  bottom: 0,
                  child: new Container(
                    child:
//                    model.busy != CallingState.Loading ?
                    new RTCVideoView(_remoteRenderer)
//                        : Center(
//                        child: Column(
//                          crossAxisAlignment: CrossAxisAlignment.center,
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            Text(
//                              'Waiting for Appointment...',
//                              style: TextStyle(color: Colors.white),
//                            ),
//                            SizedBox(
//                              height: 15,
//                            ),
//                            CircularProgressIndicator(
//                                backgroundColor: Colors.white),
//                          ],
//                        )),
                  )),
              Positioned(
                right: 20.0,
                top: 50.0,
                child: new Container(
                  width: orientation == Orientation.portrait ? 90.0 : 120.0,
                  height: orientation == Orientation.portrait ? 120.0 : 90.0,
                  decoration: new BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(5)),
                  child: ClipRRect(borderRadius: BorderRadius.circular(5), child: new RTCVideoView(_localRenderer)),
                ),
              ),
              Positioned(
                left: 30,
                top: 40,
                child: InkWell(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius:
                        BorderRadius.circular(30)),
                    child: Icon(
                      Icons.refresh,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    model.dispose();
//                    Navigator.of(context).pushReplacementNamed(Routes.call,
//                        arguments: widget.session);
                  },
                ),
              ),
//              Positioned(
//                bottom: 0,
//                child: Container(
//                    width: MediaQuery.of(context).size.width,
//                    padding: EdgeInsets.all(25),
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
////                              Icon(Icons.video_call, size: 50),
//                        InkWell(
//                          child: Container(
//                            padding: EdgeInsets.all(12),
//                            decoration: BoxDecoration(
//                                color: model.isMicEnabled
//                                    ? Colors.black12
//                                    : Colors.red,
//                                borderRadius: BorderRadius.circular(30)),
//                            child: Icon(
//                              model.isMicEnabled
//                                  ? Icons.mic
//                                  : Icons.mic_off,
//                              size: 35,
//                              color: Colors.white,
//                            ),
//                          ),
//                          onTap: () {
//                            model.enableMic(!model.isMicEnabled);
//                          },
//                        ),
//                        InkWell(
//                          child: Container(
//                            padding: EdgeInsets.all(12),
//                            decoration: BoxDecoration(
//                                color: model.isVideoEnabled
//                                    ? Colors.black12
//                                    : Colors.red,
//                                borderRadius: BorderRadius.circular(30)),
//                            child: Icon(
//                              model.isVideoEnabled
//                                  ? Icons.videocam
//                                  : Icons.videocam_off,
//                              size: 35,
//                              color: Colors.white,
//                            ),
//                          ),
//                          onTap: () {
//                            model.enableVideo(!model.isVideoEnabled);
//                          },
//                        ),
//                        InkWell(
//                          child: Container(
//                            padding: EdgeInsets.all(12),
//                            decoration: BoxDecoration(
//                                color: Colors.black12,
//                                borderRadius: BorderRadius.circular(30)),
//                            child: Icon(
//                              Icons.switch_camera,
//                              size: 35,
//                              color: Colors.white,
//                            ),
//                          ),
//                          onTap: () {
//                            model.switchCamera();
//                          },
//                        ),
//                        InkWell(
//                          child: Container(
//                            padding: EdgeInsets.all(12),
//                            decoration: BoxDecoration(
//                                color: model.isSpeakerEnabled
//                                    ? Colors.white
//                                    : Colors.black12,
//                                borderRadius:
//                                BorderRadius.circular(30)),
//                            child: ImageIcon(
//                              AssetImage("res/assets/images/speaker-icon2.png"),
//                              size: 33,
//                              color: model.isSpeakerEnabled ? Colors.black87 : Colors.white,
//                            ),
//                          ),
//                          onTap: () {
//                            model.enableSpeaker(!model.isSpeakerEnabled);
//                          },
//                        ),
//                        InkWell(
//                          child: Container(
//                            padding: EdgeInsets.all(12),
//                            decoration: BoxDecoration(
//                                color: Colors.red,
//                                borderRadius: BorderRadius.circular(30)),
//                            child: Icon(
//                              Icons.call_end,
//                              size: 35,
//                              color: Colors.white,
//                            ),
//                          ),
//                          onTap: endCall,
//                        ),
//                      ],
//                    )),
//              ),
            ]);
          });
        },

      ),
    );
  }

  @override
  void deactivate() {
    this._localRenderer.dispose();
    this._remoteRenderer.dispose();
//    Wakelock.disable();
    super.deactivate();
  }
}
