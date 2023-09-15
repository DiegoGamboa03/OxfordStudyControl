import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:oxford_studycontrol/config/router/app_router.dart';
import 'package:oxford_studycontrol/config/theme/app_theme.dart';
import 'package:oxford_studycontrol/providers/exams_providers.dart';

class ExamPreview extends ConsumerWidget {
  const ExamPreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInBreakAsync = ref.watch(isInBreakFetcher);

    return Scaffold(
        body: Center(
      child: isInBreakAsync.when(
          data: (data) {
            var (isInBreak, date) = data;
            DateFormat formatMonthsDays = DateFormat('MM-dd');
            DateFormat formatHoursSeconds = DateFormat('hh:mm a');
            String text;
            if (isInBreak) {
              String stringDateMonthsDays = formatMonthsDays.format(date!);
              String stringDateHoursSeconds = formatHoursSeconds.format(date);
              text =
                  'Has fallado 3 veces este examen \n\nDebes esperar hasta el $stringDateMonthsDays a las $stringDateHoursSeconds';
            } else {
              text = '¡Preparate bien para el examen!';
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  text,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: seedColor,
                      ),
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
                  onPressed: !isInBreak
                      ? () {
                          ref.read(appRouterProvider).go('/exam');
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    disabledBackgroundColor:
                        Colors.grey, // The background Color
                    disabledForegroundColor: Colors.white, // The text Color
                  ),
                  child: const Text('Iniciar el examen'),
                ),
              ],
            );
          },
          error: (_, __) => const Text('No se pudo cargar el nombre'),
          loading: () => const CircularProgressIndicator()),
    ));
  }
}
