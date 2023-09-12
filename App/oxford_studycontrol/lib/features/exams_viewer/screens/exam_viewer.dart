import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxford_studycontrol/features/exams_viewer/widgets/question_widget.dart';
import 'package:oxford_studycontrol/providers/exams_providers.dart';

class ExamViewer extends ConsumerWidget {
  const ExamViewer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exam = ref.watch(examProvider);
    final questionAsync = ref.watch(questionFetcher(exam!.name));
    return Scaffold(
      body: Center(
        child: questionAsync.when(
            data: (_) {
              return CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {},
                    ),
                    centerTitle: true,
                    title: Expanded(child: Text(exam.name)),
                  ),
                  SliverList.builder(
                      itemCount: exam.questions?.length,
                      itemBuilder: (context, index) {
                        final question = exam.questions![index];

                        return QuestionWidget(question: question);
                      }),
                  SliverFillRemaining(
                    child: Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                          onPressed: () {},
                          child: const Text('Terminar examen')),
                    ),
                  )
                ],
              );
            },
            error: (_, __) => const Text('No se pudo cargar el nombre'),
            loading: () => const CircularProgressIndicator()),
      ),
    );
  }
}

   /*Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: exam.questions?.length,
                        itemBuilder: (context, index) {
                          final question = exam.questions![index];

                          return QuestionWidget(question: question);
                        }),
                  ),
                  Center(
                    child: ElevatedButton(
                        onPressed: () {}, child: Text('Entregar examen')),
                  )
                ],
              );*/