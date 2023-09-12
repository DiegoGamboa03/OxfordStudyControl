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

  static Future<List<Question>?> generate(String name, String studentId) async {
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
      response.data.forEach((question) {
        questionList.add(Question.fromJson(question));
      });
      return questionList;
    } catch (e) {
      throw Exception('Error');
    }
  }
}
