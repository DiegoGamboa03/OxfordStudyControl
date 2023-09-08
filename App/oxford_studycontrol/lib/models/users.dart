class User {
  final String id;
  final String email;
  final String password;
  final String phoneNumber;
  final String address;
  final String firstName;
  final String? middleName;
  final String surname;
  final String? secondSurname;
  final String role;
  final int? currentBlock;

  User(
      {required this.id,
      required this.email,
      required this.password,
      required this.phoneNumber,
      required this.address,
      required this.firstName,
      this.middleName,
      required this.surname,
      this.secondSurname,
      required this.role,
      this.currentBlock});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
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
