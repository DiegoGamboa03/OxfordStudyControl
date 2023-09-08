import 'package:dio/dio.dart';
import 'package:oxford_studycontrol/constants.dart';
import 'package:oxford_studycontrol/models/students.dart';
import '../models/users.dart';
import 'api_exceptions.dart';

class UsersApi {
  static Future<User?> login(String userEmail, String password) async {
    final dio = Dio();
    final url = Constants.baseUrl;
    try {
      final response = await dio.get('$url/users/login/$userEmail/$password');
      if (response.data['role'] == 'Estudiante') {
        return User.fromJson(response.data);
      } else {
        throw ApiException('Error: Rol desconocido');
      }
    } catch (e) {
      throw Exception('Error');
    }
  }
}
