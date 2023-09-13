import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:oxford_studycontrol/constants.dart';
import 'package:oxford_studycontrol/models/exams.dart';
import 'package:oxford_studycontrol/models/question.dart';

class ExamApi {
  static Future<Exam?> getExam(String name) async {
    final dio = Dio();
    final url = Constants.baseUrl;
    try {
      final response = await dio.get('$url/exams/getExam/$name');
      return Exam.fromJson(response.data);
    } catch (e) {
      throw Exception('Error');
    }
  }

  static Future<(List<Question>?, DateTime)> generate(
      String name, String studentId) async {
    final dio = Dio();
    final url = Constants.baseUrl;

    var params = {"exam_id": name, "student_id": studentId};
    try {
      final response = await dio.get('$url/exams/generate',
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: jsonEncode(params));
      List<Question> questionList = [];

      String dateTimeString = response.data['test_date'];

      List<String> parts = dateTimeString.split(' ');
      List<String> dateParts = parts[0].split('-');
      List<String> timeParts = parts[1].split(':');

      int year = int.parse(dateParts[0]);
      int month = int.parse(dateParts[1]);
      int day = int.parse(dateParts[2]);
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);
      int second = int.parse(timeParts[2]);

      DateTime date = DateTime(year, month, day, hour, minute, second);
      response.data['questions'].forEach((question) {
        questionList.add(Question.fromJson(question));
      });
      return (questionList, date);
    } catch (e) {
      throw Exception('Error');
    }
  }
}
