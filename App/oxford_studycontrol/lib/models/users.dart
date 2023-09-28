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

  get getCompleteName {
    String completeName = '';
    completeName += firstName;
    if (middleName != null) completeName += ' ${middleName!}';
    completeName += ' $surname';
    if (secondSurname != null) completeName += ' ${secondSurname!}';
    return completeName;
  }

  User copyWith({
    String? id,
    String? email,
    String? password,
    String? phoneNumber,
    String? address,
    String? firstName,
    String? middleName,
    String? surname,
    String? secondSurname,
    String? role,
    int? currentBlock,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      surname: surname ?? this.surname,
      secondSurname: secondSurname ?? this.secondSurname,
      role: role ?? this.role,
      currentBlock: currentBlock ?? this.currentBlock,
    );
  }
}
