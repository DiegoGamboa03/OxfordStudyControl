import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oxford_studycontrol/features/exams_viewer/screens/exam_preview.dart';
import 'package:oxford_studycontrol/features/exams_viewer/screens/exam_score_viewer.dart';
import 'package:oxford_studycontrol/features/exams_viewer/screens/exam_viewer.dart';
import 'package:oxford_studycontrol/features/home_page/Screens/homepage.dart';
import 'package:oxford_studycontrol/features/login/screens/login.dart';
import 'package:oxford_studycontrol/features/profile/screens/edit_profile_screen.dart';
import 'package:oxford_studycontrol/features/profile/screens/grades_viewer.dart';
import 'package:oxford_studycontrol/features/profile/screens/profile_screen.dart';
import 'package:oxford_studycontrol/models/answers.dart';
import 'package:oxford_studycontrol/models/users.dart';

import '../../features/lessons_viewer/screens/lesson_viewer.dart';
import '../../models/lessons.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Login(),
    ),
    GoRoute(
      path: '/homepage',
      builder: (context, state) => const AppNavigationBar(),
    ),
    GoRoute(
      path: '/viewLesson',
      builder: (context, state) {
        Lesson lesson = state.extra as Lesson;
        return LessonViewer(lesson: lesson);
      },
    ),
    GoRoute(
      path: '/examPreview',
      builder: (context, state) => const ExamPreview(),
    ),
    GoRoute(
      path: '/exam',
      builder: (context, state) => const ExamViewer(),
    ),
    GoRoute(
      path: '/examScore',
      builder: (context, state) {
        List<Answer> answers = state.extra as List<Answer>;
        return ExamScoreViewer(answers: answers);
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/gradesViewer',
      builder: (context, state) => const GradesViewer(),
    ),
    GoRoute(
        path: '/editProfile',
        builder: (context, state) {
          User user = state.extra as User;
          return EditProfile(
            user: user,
          );
        }),
  ]);
});
