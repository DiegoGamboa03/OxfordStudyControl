import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxford_studycontrol/helpers/utils/date_utils.dart';
import 'package:oxford_studycontrol/providers/grade_providers.dart';

class GradesViewer extends ConsumerWidget {
  const GradesViewer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gradesAsync = ref.watch(gradesFetcher);
    final grades = ref.watch(gradesStateNotifierProvider);
    return Scaffold(
      body: Center(
        child: gradesAsync.when(
            data: (data) {
              return ListView.builder(
                  itemCount: grades.length,
                  itemBuilder: (BuildContext context, int index) {
                    final grade = grades[index];
                    final title =
                        '${grade.examId} - ${getDateFormat(grade.testDate)}';
                    final approvedString =
                        grade.approved ? 'aprobado' : 'desaprobado';
                    final subtitle = '${grade.score} - $approvedString';
                    return ListTile(
                      title: Text(title),
                      subtitle: Text(subtitle),
                    );
                  });
            },
            error: (_, __) => const Text('Error al cargar las notas'),
            loading: () => const CircularProgressIndicator()),
      ),
    );
  }
}
