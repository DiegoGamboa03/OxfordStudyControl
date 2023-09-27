import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxford_studycontrol/config/theme/app_theme.dart';
import 'package:oxford_studycontrol/models/users.dart';

class EditProfile extends ConsumerStatefulWidget {
  final User user;

  const EditProfile({super.key, required this.user});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.user.email);
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    var margin = EdgeInsets.symmetric(
        vertical: screenHeight * 0.02, horizontal: screenWidth * 0.05);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: seedColor,
          ),
          onPressed: () {},
        ),
      ),
      body: Column(children: [
        Container(
          margin: margin,
          child: TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              hintText: "Email",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El campo de correo electrónico no puede estar vacío';
              }
              return null; // La validación pasó
            },
          ),
        ),
      ]),
    );
  }
}
