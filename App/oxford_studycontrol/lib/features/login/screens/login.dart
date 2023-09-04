import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    return Scaffold(
        body: Center(
      child: Column(children: [
        TextField(controller: _emailController),
        TextField(controller: _passwordController),
        TextButton(
            onPressed: () async {
              String userData =
                  '${_emailController.text} ${_passwordController.text}';
              await ref.read(userFetcher(userData).future).then((value) {
                ref.read(appRouterProvider).go('/');
              });
            },
            child: const Text('Presiona'))
      ]),
    ));
  }
}
