import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxford_studycontrol/helpers/api/exams_api.dart';
import 'package:oxford_studycontrol/models/answers.dart';
import 'package:oxford_studycontrol/models/exams.dart';
import 'package:oxford_studycontrol/models/question.dart';
import 'package:oxford_studycontrol/providers/user_provider.dart';

final examProvider = StateProvider<Exam?>((ref) => null);

final answersProvider = StateProvider<List<Answer>>((ref) {
  List<Answer> answers = [];

  ref.watch(questionsStateNotifierProvider).forEach((question) {
    answers.add(Answer(questionID: question.id, answer: question.answer));
  });

  return answers;
});

final isAllAnswered = StateProvider<bool>((ref) => false);

final questionsStateNotifierProvider =
    StateNotifierProvider<QuestionsNotifier, List<Question>>((ref) {
  return QuestionsNotifier(ref);
});

class QuestionsNotifier extends StateNotifier<List<Question>> {
  QuestionsNotifier(this.ref) : super([]);

  final Ref ref;

  void addQuestion(Question question) {
    state = [...state, question];
  }

  void addMultipleQuestion(List<Question> questions) {
    for (var question in questions) {
      addQuestion(Question(
          id: question.id,
          questionPosition: question.questionPosition,
          options: question.options,
          type: question.type,
          answer: question.answer));
    }
  }

  void answerQuestion(String questionID, String? answer) {
    var temp = List<Question>.of(state);
    int index = temp.indexWhere((element) => element.id == questionID);
    var question = temp[index];
    temp.replaceRange(index, index + 1, [
      Question(
          id: question.id,
          questionPosition: question.questionPosition,
          options: question.options,
          type: question.type,
          answer: answer)
    ]);
    state = temp;
    checkAllAnswered();
  }

  void deleteAll() {
    List<Question> temp = [];
    state = temp;
  }

  void checkAllAnswered() {
    var flag = true;

    for (var element in state) {
      if (element.answer == null) {
        flag = false;
      }
    }
    ref.watch(isAllAnswered.notifier).update((state) {
      return flag;
    });
  }
}

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
        ref
            .watch(questionsStateNotifierProvider.notifier)
            .addMultipleQuestion(questions);
      }
      return data;
    });
  } catch (e) {
    rethrow;
  }
  return null;
});

final scoreFetcher =
    FutureProvider.family<double, List<Answer>>((ref, answers) async {
  try {
    final userId = ref.read(userProvider)!.id;
    final examId = ref.read(examProvider)!.name;
    final examDate = ref.read(examProvider)!.generatedDate!;
    final data = await ExamApi.evaluate(answers, examId, userId, examDate);
    return data;
  } catch (e) {
    rethrow;
  }
});

final isInBreakFetcher = FutureProvider<(bool, DateTime?)>((ref) async {
  try {
    final userId = ref.read(userProvider)!.id;
    final data = await ExamApi.getIsInBreak(userId);
    return data;
  } catch (e) {
    rethrow;
  }
});
