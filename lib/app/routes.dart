import 'package:flutter/material.dart';
import 'package:webrtc/screens/call_screen/call_screen.dart';
import 'package:webrtc/screens/join_call_screen/join_call_screen.dart';

class Routes {
  Routes._();

  //static variables
  static const String initRoute = '/';
  static const String call_screen = '/call)screen';


  static Route<dynamic> generateRoute(RouteSettings settings) {

    switch (settings.name) {
      case initRoute:
        return MaterialPageRoute(builder: (_) => JoinCallScreen());
      case call_screen:
        var sessionId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => CallScreen(sessionId: sessionId,));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }

  static final routes = <String, WidgetBuilder>{
    initRoute: (BuildContext context) => JoinCallScreen(),
  };
}
