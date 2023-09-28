import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxford_studycontrol/config/theme/app_theme.dart';
import '../../../config/router/app_router.dart';
import '../../../providers/user_provider.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends ConsumerState<Login> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
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
        body: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              margin: margin,
              child: TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: seedColor),
                    hintText: "Email",
                    hintStyle: TextStyle(color: seedColor)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El campo de correo electrónico no puede estar vacío';
                  }
                  return null; // La validación pasó
                },
              ),
            ),
            Container(
              margin: margin,
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    labelStyle: TextStyle(color: seedColor),
                    hintText: "Contraseña",
                    hintStyle: TextStyle(color: seedColor)),
                keyboardType: TextInputType.visiblePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La contraseña no puede estar vacía';
                  }
                  return null; // La validación pasó
                },
              ),
            ),
          ],
        ),
      ),
      Container(
        margin: margin,
        child: ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                String userData =
                    '${_emailController.text.trim()} ${_passwordController.text.trim()}';
                try {
                  await ref.read(userFetcher(userData).future).then((value) {
                    ref.read(appRouterProvider).go('/homepage');
                  });
                } catch (e) {
                  if (mounted) {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                                title: const Text('AlertDialog Title'),
                                content: const Text('AlertDialog description'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'OK'),
                                    child: const Text('OK'),
                                  ),
                                ]));
                  }
                }
              }
            },
            child: const Text('Iniciar sesion')),
      ),
      Container(
        margin: EdgeInsets.only(bottom: screenHeight * 0.05),
        child: TextButton(
          onPressed: () {},
          child: const Text('¿Olvidaste tu contraseña?'),
        ),
      )
    ]));
  }
}
