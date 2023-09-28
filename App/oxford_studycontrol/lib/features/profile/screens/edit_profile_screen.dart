import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxford_studycontrol/config/router/app_router.dart';
import 'package:oxford_studycontrol/config/theme/app_theme.dart';
import 'package:oxford_studycontrol/models/users.dart';
import 'package:oxford_studycontrol/providers/user_provider.dart';

class EditProfile extends ConsumerStatefulWidget {
  final User user;

  const EditProfile({super.key, required this.user});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  late TextEditingController _phoneNumberController;
  late TextEditingController _passwordController;
  late TextEditingController _addressController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _phoneNumberController =
        TextEditingController(text: widget.user.phoneNumber);
    _passwordController = TextEditingController(text: widget.user.password);
    _addressController = TextEditingController(text: widget.user.address);
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
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
          onPressed: () {
            ref.read(appRouterProvider).pop();
          },
        ),
        title: const Text('Edita tu informacion'),
      ),
      body: Column(children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                margin: margin,
                child: TextFormField(
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Numero telefonico',
                    labelStyle: TextStyle(color: seedColor),
                    hintText: "Numero telefonico",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El campo de numero telefonico no puede estar vacío';
                    }
                    return null; // La validación pasó
                  },
                ),
              ),
              Container(
                margin: margin,
                child: TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    labelStyle: TextStyle(color: seedColor),
                    hintText: "Contraseña",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El campo de la contraseña no puede estar vacío';
                    }
                    return null; // La validación pasó
                  },
                ),
              ),
              Container(
                margin: margin,
                child: TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                      labelText: 'Dirección',
                      hintText: "Dirección",
                      labelStyle: TextStyle(color: seedColor)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El campo de la dirección no puede estar vacío';
                    }
                    return null; // La validación pasó
                  },
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: screenHeight * 0.05),
                    child: ElevatedButton(
                      child: const Text('Actualizar tus datos'),
                      onPressed: () async {
                        final newUser = user?.copyWith(
                            password: _passwordController.text,
                            address: _addressController.text,
                            phoneNumber: _phoneNumberController.text);
                        if (_formKey.currentState!.validate()) {
                          try {
                            ref
                                .read(userUpdateFetcher(newUser!).future)
                                .then((value) {
                              ref.read(appRouterProvider).pop();
                            });
                          } catch (e) {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                        title: const Text(
                                            'Ha ocurrido un error al actualizar los datos'),
                                        content: const Text(
                                            'Por favor intentelo mas tarde'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, 'OK'),
                                            child: const Text('OK'),
                                          ),
                                        ]));
                          }
                        }
                      },
                    ),
                  )),
            ],
          ),
        ),
      ]),
    );
  }
}
