import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helpers/api/users_api.dart';
import '../models/users.dart';

final userProvider = StateProvider<User?>((ref) => null);

final userUpdateFetcher = FutureProvider<User?>((ref) async {
  final userEmail = ref.watch(userProvider)!.email;
  final password = ref.watch(userProvider)!.password;

  try {
    UsersApi.login(userEmail, password).then((data) {
      ref.refresh(userProvider.notifier).update((state) {
        return data;
      });
      return data;
    });
  } catch (e) {
    rethrow;
  }
  return null;
});

final userFetcher = FutureProvider.family<User?, String>((ref, userData) async {
  final userEmail = userData.split(' ')[0];
  final password = userData.split(' ')[1];

  try {
    await UsersApi.login(userEmail, password).then((data) {
      ref.watch(userProvider.notifier).update((state) => data);
      return data;
    });
  } catch (e) {
    rethrow;
  }
  return null;
});
