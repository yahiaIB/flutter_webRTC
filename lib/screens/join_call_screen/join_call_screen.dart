import 'package:flutter/material.dart';
import 'package:webrtc/app/routes.dart';
import 'package:webrtc/web_services/socket.dart';

class JoinCallScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Web RTC Test")
      ),
      body: Center(
        child: FlatButton(
          onPressed: (){
            Navigator.pushNamed(context, Routes.call_screen,arguments: "60105595127e17316eecbc7f");
          },
          child: Text("Join Call"),
        ),
      ),
    );
  }
}
