import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:webrtc/app/app_keys.dart';

class SocketManager {
  IO.Socket socketInstance;
  static SocketManager _instance;

  static SocketManager getInstance() {
    if (_instance == null) {
      _instance = new SocketManager._();
    }
    if (_instance.socketInstance == null) {
      _instance.init();
    }
    return _instance;
  }

  SocketManager._() {}

  void init() {
    var url = AppKeys.baseUrl;
    print("socket url $url");
    socketInstance = IO.io(
        url,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setPath("/io")
            .setExtraHeaders({"Authorization": AppKeys.userId})
            .build());
    socketInstance.on('error', (error) {
      print('error');
      print(error);
    });
    socketInstance.on('disconnect', (data) {
      print("Disconnet");
      print(data.toString());
    });
    socketInstance.connect();
  }

  void subscribe(String roomId, {type}) {
    try {
      if (_instance.socketInstance == null) {
        this.init();
      }
      if (!socketInstance.connected) {
        print("Socket is not connected, connect again");
        socketInstance.connect();
        print("sad asd asd asd asd ad asd");
      }
      var data = {"room": roomId};
      if (type != null) data['type'] = type;
      socketInstance.emit('subscribe', data);
    } on Exception catch (e) {
      print("herrrrrrrrrrrrrrrrrr");
      print(e.toString());
    }
  }

  void unsubscribe(roomId) {
    this.socketInstance.emit('unsubscribe', {"room": roomId});
  }
}
