import 'package:dio/dio.dart';

class ExceptionHelper implements Exception {
  String tag;
  String message;

  ExceptionHelper([this.message, this.tag]);

  static parse({Exception err, String message}) {
    String eMsg = 'Unknown Error';
    String nMsg = eMsg;

    try {
      if (err is DioError) {
        //TODO handle error response
        if (err.response != null) {
          eMsg = err.response.data['message'];
        } else {
          eMsg =
              'Could not connect to Server, Please check internet connection';
        }
      }
    } catch (e) {} finally {
      if (message != null) {
        nMsg = '${message}\n${eMsg}';
      } else {
        nMsg = eMsg;
      }
    }

    return ExceptionHelper(nMsg);
  }
}
