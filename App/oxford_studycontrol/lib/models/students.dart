import 'package:oxford_studycontrol/models/users.dart';

class Students extends User {
  Students(
      {required String id,
      required String email,
      required String password,
      required String phoneNumber,
      required String address,
      required String firstName,
      String? middleName,
      required String surname,
      String? secondSurname,
      required String role,
      required int? currentBlock})
      : super(
            id: id,
            email: email,
            password: password,
            phoneNumber: phoneNumber,
            address: address,
            firstName: firstName,
            middleName: middleName,
            surname: surname,
            secondSurname: secondSurname,
            role: role);

  factory Students.fromJson(Map<String, dynamic> json) {
    return Students(
        id: json['id'],
        email: json['email'],
        password: json['password'],
        phoneNumber: json['phone_number'],
        address: json['address'],
        firstName: json['first_name'],
        middleName: json['middle_name'],
        surname: json['surname'],
        secondSurname: json['second_surname'],
        role: json['role'],
        currentBlock: json['current_block']);
  }
}
