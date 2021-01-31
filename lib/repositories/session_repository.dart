import 'package:webrtc/web_services/end_points.dart';
import 'package:webrtc/web_services/http_client.dart';

class SessionRepository {
  Future getSession(id) async {
    try {
      var response =
          await HttpClient.getInstance().get(EndPoints.getOneSession(id));
      return response.data;
    } catch (e) {
      throw e;
    }
  }

  Future updateSessionOffer(id, data) async {
    try {
      print(data["description"]["sdp"]);
      print(data["description"]["sdp"].runtimeType);
      var response = await HttpClient.getInstance()
          .put(EndPoints.updateSessionOffer(id), data: data);
      return response.data;
    } catch (e) {
      throw e;
    }
  }

  Future updateSessionAnswer(id, data) async {
    try {
      var response = await HttpClient.getInstance()
          .put(EndPoints.updateSessionAnswer(id), data: data);
      return response.data;
    } catch (e) {
      throw e;
    }
  }

  Future updateSessionCandidate(id, data) async {
    try {
      var response = await HttpClient.getInstance()
          .put(EndPoints.updateSessionCandidate(id), data: data);
      return response.data;
    } catch (e) {
      throw e;
    }
  }
}
