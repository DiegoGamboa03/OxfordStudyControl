import 'package:dio/dio.dart';
import 'package:oxford_studycontrol/constants.dart';
import 'package:oxford_studycontrol/models/online_classes.dart';

class OnlineClassApi {
  static Future<List<OnlineClass>> getOnlineClasses() async {
    final dio = Dio();
    final url = Constants.baseUrl;
    try {
      final response =
          await dio.get('$url/onlineClasses/getAvailableOnlineClasses');
      List<OnlineClass> onlineClasses = [];
      response.data.forEach((onlineClass) {
        onlineClasses.add(OnlineClass.fromJson(onlineClass));
      });
      return onlineClasses;
    } catch (e) {
      throw Exception('Error');
    }
  }
}
