import 'package:dio/dio.dart';
import 'package:webrtc/app/app_keys.dart';

class HttpClient {
  static Dio _dio;
  static String token;

  static Dio getInstance() {
    if (_dio == null) {
      _dio = Dio();
      _dio..options.baseUrl = AppKeys.baseUrl
      ..interceptors.add(LogInterceptor())
      ..interceptors
          .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
        // Do something before request is sent
        return options; //continue
      }, onResponse: (Response response) {
        // Do something with response data
        return response; // continue
      }, onError: (DioError e) {
        // Do something with response error
        return e; //continue
      }));
    }

    return _dio;
  }
}
