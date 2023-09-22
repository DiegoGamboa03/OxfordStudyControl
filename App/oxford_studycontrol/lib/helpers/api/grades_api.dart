import 'package:dio/dio.dart';
import 'package:oxford_studycontrol/constants.dart';
import 'package:oxford_studycontrol/models/grades.dart';

class GradesApi {
  static Future<List<Grade>> getGrades(String studentId) async {
    final dio = Dio();
    final url = Constants.baseUrl;
    try {
      final response = await dio.get('$url/grades/$studentId');
      List<Grade> grades = [];
      response.data.forEach((grade) {
        grades.add(Grade.fromJson(grade));
      });
      return grades;
    } catch (e) {
      throw Exception('Error');
    }
  }
}
