import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxford_studycontrol/helpers/api/online_classes_api.dart';
import 'package:oxford_studycontrol/models/online_classes.dart';
import 'package:oxford_studycontrol/providers/user_provider.dart';

enum OnlineClassFilter { all, reserved }

final onlineClassFilterProvider = StateProvider<OnlineClassFilter>((ref) {
  return OnlineClassFilter.all;
});

//Todas las clases online
final onlineClassesStateNotifierProvider =
    StateNotifierProvider<OnlineClassesNotifier, List<OnlineClass>>((ref) {
  return OnlineClassesNotifier();
});

class OnlineClassesNotifier extends StateNotifier<List<OnlineClass>> {
  OnlineClassesNotifier() : super([]);

  void addOnlineClass(OnlineClass onlineClass) {
    state = [...state, onlineClass];
  }

  void addMultipleOnlineClass(List<OnlineClass> onlineClasses) {
    for (var onlineClass in onlineClasses) {
      addOnlineClass(onlineClass);
    }
  }
  //Aqui va cualquier funcion que le quiera poner a la lista de blocks
}

final filteredOnlineClassProvider = Provider<List<OnlineClass>>((ref) {
  final user = ref.watch(userProvider);
  final onlineClasses = ref.watch(onlineClassesStateNotifierProvider);
  final reservedOnlineClasses =
      ref.watch(reservedOnlineClassesStateNotifierProvider);
  final selectedFilter = ref.watch(onlineClassFilterProvider);

  switch (selectedFilter) {
    case OnlineClassFilter.all:
      return onlineClasses.where((onlineClass) {
        bool isAvailable = onlineClass.requiredBlock <= user!.currentBlock! &&
            onlineClass.availablePositions < onlineClass.maxPositions;

        return isAvailable && !reservedOnlineClasses.contains(onlineClass.name);
      }).toList();
    case OnlineClassFilter.reserved:
      return onlineClasses.where((onlineClass) {
        bool isAvailable = onlineClass.requiredBlock <= user!.currentBlock! &&
            onlineClass.availablePositions < onlineClass.maxPositions;
        return isAvailable && reservedOnlineClasses.contains(onlineClass.name);
      }).toList();
  }
});

//Clases online Reservadas por el estudiante
final reservedOnlineClassesStateNotifierProvider =
    StateNotifierProvider<ReservedOnlineClassesNotifier, List<String>>((ref) {
  return ReservedOnlineClassesNotifier();
});

class ReservedOnlineClassesNotifier extends StateNotifier<List<String>> {
  ReservedOnlineClassesNotifier() : super([]);

  void addReservedOnlineClass(String onlineClass) {
    state = [...state, onlineClass];
  }

  void addMultipleReservedOnlineClass(List<String> onlineClasses) {
    for (var onlineClass in onlineClasses) {
      addReservedOnlineClass(onlineClass);
    }
  }
  //Aqui va cualquier funcion que le quiera poner a la lista de blocks
}

final onlineClassesFetcher =
    FutureProvider.family<void, String>((ref, studentId) async {
  try {
    await OnlineClassApi.getOnlineClasses().then((onlineClasses) {
      ref
          .watch(onlineClassesStateNotifierProvider.notifier)
          .addMultipleOnlineClass(onlineClasses);
    });
    await OnlineClassApi.getReservedOnlineClasses(studentId)
        .then((onlineClasses) {
      ref
          .watch(reservedOnlineClassesStateNotifierProvider.notifier)
          .addMultipleReservedOnlineClass(onlineClasses);
    });
  } catch (e) {
    rethrow;
  }
});

final makeReservationFetcher = FutureProvider.autoDispose
    .family<int, OnlineClass>((ref, onlineClass) async {
  try {
    final user = ref.watch(userProvider);
    final value =
        await OnlineClassApi.makeReservation(onlineClass.name, user!.id);

    if (value == 1) {
      ref
          .watch(reservedOnlineClassesStateNotifierProvider.notifier)
          .addReservedOnlineClass(onlineClass.name);
    }
    return value;
  } catch (e) {
    rethrow;
  }
});
