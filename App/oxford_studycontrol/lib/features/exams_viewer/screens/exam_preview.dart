import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxford_studycontrol/config/router/app_router.dart';
import 'package:oxford_studycontrol/providers/exams_providers.dart';

class ExamPreview extends ConsumerWidget {
  const ExamPreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exam = ref.watch(examProvider);
    return Center(
      child: ElevatedButton(
        onPressed: () {
          ref.read(appRouterProvider).go('/exam');
        },
        child: const Text('Iniciar el examen'),
      ),
    );
  }
}
