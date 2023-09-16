import 'package:confetti/confetti.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxford_studycontrol/config/theme/app_theme.dart';
import 'package:oxford_studycontrol/models/answers.dart';
import 'package:oxford_studycontrol/providers/exams_providers.dart';

class ExamScoreViewer extends ConsumerStatefulWidget {
  final List<Answer> answers;
  const ExamScoreViewer({super.key, required this.answers});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ExamScoreViewerState();
}

class _ExamScoreViewerState extends ConsumerState<ExamScoreViewer> {
  late ConfettiController _controllerBottomCenter;

  @override
  void initState() {
    _controllerBottomCenter =
        ConfettiController(duration: const Duration(seconds: 4));
    super.initState();
  }

  @override
  void dispose() {
    _controllerBottomCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ConfettiController(duration: const Duration(seconds: 1));
    final scoreAsync = ref.watch(scoreFetcher(widget.answers));
    final exam = ref.watch(examProvider);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    var margin = EdgeInsets.symmetric(
        vertical: screenHeight * 0.05, horizontal: screenWidth * 0.05);

    return Scaffold(
        body: scoreAsync.when(
            data: (score) {
              String text;
              String passingGrade = exam!.passingGrade!.toString();
              String scoreText =
                  'Has coseguido una puntuacion de: $score\nnecesitando: $passingGrade para pasar';
              if (score > exam.passingGrade!) {
                _controllerBottomCenter.play();
                text = '¡Felicidades has pasado el examen!';
              } else {
                text =
                    'No has logrado pasar el examen, ¡Esfuerzate para la proxima!';
              }
              return Stack(
                children: <Widget>[
                  Container(
                    margin: margin,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: seedColor,
                            ),
                      ),
                    ),
                  ),
                  Container(
                    margin: margin,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        scoreText,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.normal,
                              color: seedColor,
                            ),
                      ),
                    ),
                  ),
                  Container(
                    margin: margin,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                          onPressed: () {}, child: const Text('Siguiente')),
                    ),
                  ),
                  Container(
                    margin: margin,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ConfettiWidget(
                        confettiController: _controllerBottomCenter,
                        blastDirection: -pi / 2,
                        shouldLoop: false,
                        emissionFrequency: 0.03,
                        numberOfParticles: 20,
                        maxBlastForce: 100,
                        minBlastForce: 80,
                        gravity: 0.3,
                      ),
                    ),
                  ),
                ],
              );
            },
            error: (_, __) => const Text('No se pudo cargar el nombre'),
            loading: () => const CircularProgressIndicator()));
  }
}
