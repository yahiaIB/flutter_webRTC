import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:webrtc/screens/call_screen/call_screen_view_model.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (_) => CallScreenViewModel()),
];
