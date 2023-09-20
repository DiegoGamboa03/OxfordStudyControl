import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxford_studycontrol/helpers/api/online_classes_api.dart';
import 'package:oxford_studycontrol/models/online_classes.dart';
import 'package:oxford_studycontrol/providers/user_provider.dart';

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
  List<OnlineClass> list = [];

  for (var onlineClass in onlineClasses) {
    if (onlineClass.requiredBlock <= user!.currentBlock! &&
        onlineClass.availablePositions < onlineClass.maxPositions) {
      list.add(onlineClass);
    }
  }

  return list;
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

final makeReservationFetcher =
    FutureProvider.family<int, OnlineClass>((ref, onlineClass) async {
  try {
    final user = ref.watch(userProvider);
    await OnlineClassApi.makeReservation(onlineClass.name, user!.id)
        .then((value) {
      if (value == 1) {
        ref
            .watch(reservedOnlineClassesStateNotifierProvider.notifier)
            .addReservedOnlineClass(onlineClass.name);
      }
      return value;
    });
  } catch (e) {
    rethrow;
  }
  return -1;
});
