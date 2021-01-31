import 'package:flutter/material.dart';

import 'app/app.dart';
import 'web_services/socket.dart';

void main() async {
  SocketManager.getInstance();
  runApp(App());
}
