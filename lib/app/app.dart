import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './routes.dart';
import './provider_setup.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: MultiProvider(
        providers: providers,
        child: Application(),
      ),
    );
  }
}

class Application extends StatefulWidget {
  Application({Key key}) : super(key: key);

  @override
  _ApplicationState createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Web_RTC",
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.initRoute,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
