import 'package:dio/dio.dart';
import 'package:oxford_studycontrol/constants.dart';
import 'package:oxford_studycontrol/models/lessons.dart';

class LessonApi {
  static Future<Lesson?> getLesson(String name) async {
    final dio = Dio();
    final url = Constants.baseUrl;
    try {
      final response = await dio.get('$url/lessons/$name');
      return Lesson.fromJson(response.data);
    } catch (e) {
      throw Exception('Error');
    }
  }
}
