import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helpers/users_api.dart';
import '../models/users.dart';

final userProvider = StateProvider<User?>((ref) => null);

final userFetcher = FutureProvider.family<User?, String>((ref, userData) async {
  final userEmail = userData.split(' ')[0];
  final password = userData.split(' ')[1];

  await UsersApi.login(userEmail, password).then((data) {
    ref.watch(userProvider.notifier).update((state) => data);
    return data;
  });
  return null;
});
/*The return type 'User? (where User is defined in C:\Users\Diego Gamboa\Desktop\OxfordStudyControl\App\oxford_studycontrol\lib\models\Users.dart)' isn't a 'User? (where User is defined in C:\Users\Diego Gamboa\Desktop\OxfordStudyControl\App\oxford_studycontrol\lib\models\users.dart)', as required by the closure's context.

C:\Users\Diego Gamboa\Desktop\OxfordStudyControl\App\oxford_studycontrol\lib\models\Users.dart
C:\Users\Diego Gamboa\Desktop\OxfordStudyControl\App\oxford_studycontrol\lib\models\users.dart*/