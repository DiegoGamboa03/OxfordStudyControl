import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:oxford_studycontrol/constants.dart';
import 'package:oxford_studycontrol/helpers/utils/date_utils.dart';
import 'package:oxford_studycontrol/models/answers.dart';
import 'package:oxford_studycontrol/models/exams.dart';
import 'package:oxford_studycontrol/models/question.dart';
import 'package:intl/intl.dart';

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

      DateTime date = formatStringToDateTime(response.data['test_date']);

      response.data['questions'].forEach((question) {
        questionList.add(Question.fromJson(question));
      });
      return (questionList, date);
    } catch (e) {
      throw Exception('Error');
    }
  }

  static Future<double> evaluate(List<Answer> answers, String examID,
      String studentID, DateTime testDate) async {
    final dio = Dio();
    final url = Constants.baseUrl;

    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(testDate);
    var params = {
      "exam_id": examID,
      "student_id": studentID,
      "generated_test_date": formattedDate,
      "answers": answers.map((answer) => answer.toJson()).toList()
    };
    try {
      final response = await dio.post('$url/exams/evaluateExam',
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          }),
          data: jsonEncode(params));

      return response.data['score'].toDouble();
    } catch (e) {
      throw Exception('Error');
    }
  }

  static Future<(bool, DateTime?)> getIsInBreak(String studentID) async {
    final dio = Dio();
    final url = Constants.baseUrl;
    try {
      final response = await dio.get('$url/exams/checkBreak/$studentID');
      bool isInBreak = (response.data['studentCount'] >= 1 ? true : false);
      DateTime? date;
      if (response.data['date'] != null) {
        String dateTimeString = response.data['date'];

        List<String> parts = dateTimeString.split(' ');
        List<String> dateParts = parts[0].split('-');
        List<String> timeParts = parts[1].split(':');

        int year = int.parse(dateParts[0]);
        int month = int.parse(dateParts[1]);
        int day = int.parse(dateParts[2]);
        int hour = int.parse(timeParts[0]);
        int minute = int.parse(timeParts[1]);
        int second = int.parse(timeParts[2]);

        date = DateTime(year, month, day, hour, minute, second);
      }

      return (isInBreak, date);
    } catch (e) {
      throw Exception('Error');
    }
  }
}
