import 'package:dio/dio.dart';
import 'package:oxford_studycontrol/constants.dart';
import 'package:oxford_studycontrol/models/lessons.dart';
import 'package:oxford_studycontrol/models/resources.dart';

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

  static Future<List<Resource>?> getResources(String name) async {
    final dio = Dio();
    final url = Constants.baseUrl;
    try {
      final response = await dio.get('$url/Lessons/getResources/$name');
      List<Resource> resources = [];
      response.data.forEach((resource) {
        resources.add(Resource.fromJson(resource));
      });
      return resources;
    } catch (e) {
      throw Exception('Error');
    }
  }
}
