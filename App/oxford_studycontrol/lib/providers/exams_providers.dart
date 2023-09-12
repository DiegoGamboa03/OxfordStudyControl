import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxford_studycontrol/helpers/exams_api.dart';
import 'package:oxford_studycontrol/models/exams.dart';
import 'package:oxford_studycontrol/models/question.dart';
import 'package:oxford_studycontrol/providers/user_provider.dart';

final examProvider = StateProvider<Exam?>((ref) => null);

final examFetcher = FutureProvider.family<Exam?, String>((ref, examName) async {
  try {
    await ExamApi.getExam(examName).then((data) {
      ref.watch(examProvider.notifier).update((state) => data);
      return data;
    });
  } catch (e) {
    rethrow;
  }
  return null;
});

final questionFetcher =
    FutureProvider.family<List<Question>?, String>((ref, examName) async {
  try {
    final userId = ref.read(userProvider)!.id;
    await ExamApi.generate(examName, userId).then((data) {
      if (data != null) {
        ref.watch(examProvider.notifier).update((state) {
          state!.setQuestions = data;
          return state;
        });
      }
      return data;
    });
  } catch (e) {
    rethrow;
  }
  return null;
});
