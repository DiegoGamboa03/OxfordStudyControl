import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxford_studycontrol/config/router/app_router.dart';
import 'package:oxford_studycontrol/config/theme/app_theme.dart';
import 'package:oxford_studycontrol/features/exams_viewer/widgets/question_widget.dart';
import 'package:oxford_studycontrol/models/answers.dart';
import 'package:oxford_studycontrol/providers/exams_providers.dart';

class ExamViewer extends ConsumerWidget {
  const ExamViewer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exam = ref.watch(examProvider);
    final questionAsync = ref.watch(questionFetcher(exam!.name));

    const snackBar = SnackBar(
      content: Text(' ¡Cuidado! no todas tus preguntas han sido respondidas'),
    );
    int buttonPresses = 0;

    return Scaffold(
      body: Center(
        child: questionAsync.when(
            data: (_) {
              return CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        ref.read(appRouterProvider).pop();
                      },
                    ),
                    centerTitle: true,
                    title: Expanded(
                        child: Text(
                      exam.name,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: seedColor,
                          ),
                    )),
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
                          onPressed: () async {
                            final allAnswered = ref.read(isAllAnswered);
                            if (allAnswered || buttonPresses > 0) {
                              List<Answer> answers = ref.read(answersProvider);
                              ref
                                  .read(questionsStateNotifierProvider.notifier)
                                  .deleteAll();
                              ref
                                  .read(appRouterProvider)
                                  .push('/examScore', extra: answers);
                            } else if (!allAnswered) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              buttonPresses++;
                            }
                          },
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
