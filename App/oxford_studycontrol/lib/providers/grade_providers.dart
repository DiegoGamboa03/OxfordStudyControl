import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxford_studycontrol/helpers/api/grades_api.dart';
import 'package:oxford_studycontrol/models/grades.dart';
import 'package:oxford_studycontrol/providers/user_provider.dart';

final gradesStateNotifierProvider =
    StateNotifierProvider<GradesNotifier, List<Grade>>((ref) {
  return GradesNotifier();
});

class GradesNotifier extends StateNotifier<List<Grade>> {
  GradesNotifier() : super([]);

  void addGrade(Grade grade) {
    state = [...state, grade];
  }

  void addMultipleGrades(List<Grade> grades) {
    for (var block in grades) {
      addGrade(block);
    }
  }
}

final gradesFetcher = FutureProvider((ref) async {
  try {
    final user = ref.watch(userProvider);
    await GradesApi.getGrades(user!.id).then((grades) {
      ref.watch(gradesStateNotifierProvider.notifier).addMultipleGrades(grades);
      return grades;
    });
  } catch (e) {
    rethrow;
  }
  return null;
});
