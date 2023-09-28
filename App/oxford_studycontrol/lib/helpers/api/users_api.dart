import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:oxford_studycontrol/constants.dart';
import '../../models/users.dart';

class UsersApi {
  static Future<User> login(String userEmail, String password) async {
    final dio = Dio();
    final url = Constants.baseUrl;
    try {
      final response = await dio.get('$url/users/login/$userEmail/$password');
      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Error');
    }
  }

  static Future<User> updateBlock(String userEmail, String password) async {
    final dio = Dio();
    final url = Constants.baseUrl;
    try {
      final response = await dio.get('$url/users/login/$userEmail/$password');
      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Error');
    }
  }

  static Future<User> updateUserData(User updatedUser) async {
    final dio = Dio();
    final url = Constants.baseUrl;
    final userEmail = updatedUser.email;
    final password = updatedUser.password;
    try {
      var params = {
        "newPassword": updatedUser.password,
        "phone_number": updatedUser.phoneNumber,
        "address": updatedUser.address
      };
      final responseUpdate =
          await dio.put('$url/users/update/$userEmail/$password',
              options: Options(headers: {
                HttpHeaders.contentTypeHeader: "application/json",
              }),
              data: jsonEncode(params));
      if (responseUpdate.statusCode == 200) {
        final response = await dio.get('$url/users/login/$userEmail/$password');
        return User.fromJson(response.data);
      }
      throw Exception('Error');
    } catch (e) {
      throw Exception('Error');
    }
  }
}
