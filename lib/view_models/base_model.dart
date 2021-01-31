import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

abstract class BaseViewModel with ChangeNotifier {
  //TODO if you need handle the base progress changes or errors provide setters getters for your values and notify your listener

  bool _busy = false;
  String _error = '';

  String get error => _error;

  set error(String value) {
    _error = value;
  }

  handelErrorMessage(e) {
    String error_message = "";
    print(e.runtimeType);
    if (e.runtimeType == DioError) {
      switch (e.type) {
        case DioErrorType.CANCEL:
          error_message = "Request Cancelled";
          break;
        case DioErrorType.CONNECT_TIMEOUT:
          error_message = "Request Timeout";
          break;
        case DioErrorType.DEFAULT:
          error_message = "No Internet Connection";
          break;
        case DioErrorType.RECEIVE_TIMEOUT:
          error_message = "Send Timeout";
          break;
        case DioErrorType.RESPONSE:
          switch (e.response.statusCode) {
            case 400:
              error_message = e.response.data['message'];
              break;
            case 401:
              error_message = "Unauthorised Request";
              break;
            case 403:
              error_message = "Unauthorised Request";
              break;
            case 404:
              error_message = "Not Found";
              break;
            case 409:
              error_message = "Conflict";
              break;
            case 408:
              error_message = "Request Timeout";
              break;
            case 500:
              error_message = "Internal Server Error";
              break;
            case 503:
              error_message = "Service Unavailable";
              break;
            case 504:
              error_message = "Gateway Time-out";
              break;
            default:
              var responseCode = e.response.statusCode;
              error_message = "Received invalid status code: $responseCode";
          }
          break;
        case DioErrorType.SEND_TIMEOUT:
          error_message = "Send Timeout";
          break;
      }
    } else {
      error_message = "Internal Server Error";
    }
    print(error_message);
    error = error_message;
    return error_message;
  }

  handelError(e, {BuildContext context , scaffoldKey }) {
    String error_message = handelErrorMessage(e);
//    if(context != null) {
//      UtilsFunctions.showSnackBar(context: context,text: error_message);
//    }else if (scaffoldKey != null){
//      UtilsFunctions.showSnackBarWithScaffoldKey(scaffoldKey: scaffoldKey,text: error_message);
//    }
    return error_message;
  }

  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }

  void setBusyWithOutNotify(bool value) {
    _busy = value;
  }
}
