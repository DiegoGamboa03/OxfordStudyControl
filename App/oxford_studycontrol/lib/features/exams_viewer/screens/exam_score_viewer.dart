import 'package:confetti/confetti.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExamScoreViewer extends ConsumerStatefulWidget {
  const ExamScoreViewer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ExamScoreViewerState();
}

class _ExamScoreViewerState extends ConsumerState<ExamScoreViewer> {
  late ConfettiController _controllerBottomCenter;

  @override
  void initState() {
    super.initState();
    _controllerBottomCenter =
        ConfettiController(duration: const Duration(seconds: 10));
  }

  @override
  void dispose() {
    _controllerBottomCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
