import 'package:dio/dio.dart';
import 'package:oxford_studycontrol/constants.dart';
import '../models/users.dart';

class UsersApi {
  static Future<User?> login(String userEmail, String password) async {
    final dio = Dio();
    final url = Constants.baseUrl;
    try {
      final response = await dio.get('$url/users/login/$userEmail/$password');
      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Error');
    }
  }

  static Future<User?> updateBlock(String userEmail, String password) async {
    final dio = Dio();
    final url = Constants.baseUrl;
    try {
      final response = await dio.get('$url/users/login/$userEmail/$password');
      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Error');
    }
  }
}
