import 'dart:html';

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxford_studycontrol/helpers/api/online_classes_api.dart';
import 'package:oxford_studycontrol/models/online_classes.dart';
import 'package:oxford_studycontrol/providers/user_provider.dart';

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

final filteredOnlineClassProvider =
    Provider<List<CalendarEventData<Event>?>>((ref) {
  final user = ref.watch(userProvider);
  final onlineClasses = ref.watch(onlineClassesStateNotifierProvider);
  List<CalendarEventData<Event>> events = [];

  for (var onlineClass in onlineClasses) {
    if (onlineClass.requiredBlock == user!.currentBlock) {
      /*CalendarEventData eventData = CalendarEventData(
        date: ,
        event: Event(title: "Joe's Birthday"),
        title: "Project meeting",
        description: "Today is project meeting.",
        startTime: DateTime(_now.year, _now.month, _now.day, 18, 30),
        endTime: DateTime(_now.year, _now.month, _now.day, 22),
      );
      events.add(eventData);*/
    }
  }
  return events;
});

final onlineClassesFetcher = FutureProvider((ref) async {
  try {
    await OnlineClassApi.getOnlineClasses().then((onlineClasses) {
      ref
          .watch(onlineClassesStateNotifierProvider.notifier)
          .addMultipleOnlineClass(onlineClasses);
      return onlineClasses;
    });
  } catch (e) {
    rethrow;
  }
  return null;
});
