import 'dart:convert';
import 'dart:io';

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

  static Future<List<String>> getReservedOnlineClasses(String studentId) async {
    final dio = Dio();
    final url = Constants.baseUrl;
    try {
      final response =
          await dio.get('$url/onlineClasses/getReservations/$studentId');
      List<String> onlineClasses = [];
      response.data.forEach((onlineClass) {
        onlineClasses.add(onlineClass['online_class_id']);
      });
      return onlineClasses;
    } catch (e) {
      throw Exception('Error');
    }
  }

  static Future<int> makeReservation(
      String onlineClass, String studentId) async {
    final dio = Dio();
    final url = Constants.baseUrl;

    var params = {"online_class_id": onlineClass, "student_id": studentId};
    try {
      final response = await dio.post('$url/onlineClasses/makeReservation',
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: jsonEncode(params));

      if (response.statusCode == 200) {
        return 1; // Se logro hacer la reserva
      } else if (response.statusCode == 403) {
        return 0; //Sitio full
      } else {
        return -1; //Error
      }
    } catch (e) {
      throw Exception('Error');
    }
  }
}
