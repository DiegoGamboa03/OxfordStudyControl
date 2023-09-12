import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxford_studycontrol/helpers/lessons_api.dart';
import 'package:oxford_studycontrol/models/lessons.dart';

final lessonProvider = StateProvider<Lesson?>((ref) => null);

final lessonFetcher =
    FutureProvider.family<Lesson?, String>((ref, lessonName) async {
  try {
    await LessonApi.getLesson(lessonName).then((data) {
      ref.watch(lessonProvider.notifier).update((state) => data);
      return data;
    });
  } catch (e) {
    rethrow;
  }
  return null;
});
