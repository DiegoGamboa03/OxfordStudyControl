import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxford_studycontrol/helpers/exams_api.dart';
import 'package:oxford_studycontrol/models/exams.dart';
import 'package:oxford_studycontrol/models/question.dart';
import 'package:oxford_studycontrol/providers/user_provider.dart';

final examProvider = StateProvider<Exam?>((ref) => null);

final answeredQuestionProvider = StateProvider<int>((ref) => 0);

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
      var (questions, date) = data;
      if (questions != null) {
        ref.watch(examProvider.notifier).update((state) {
          state!; //Le estoy diciendo que no es null
          state.setQuestions = questions;
          state.setGeneratedDate = date;
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
