import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxford_studycontrol/config/theme/app_theme.dart';
import 'package:oxford_studycontrol/features/lessons_exams_list_view/widgets/lesson_list_tile.dart';
import '../../../providers/block_providers.dart';

class LessonAndExamsListViewer extends ConsumerWidget {
  const LessonAndExamsListViewer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.watch(blocksFilterProvider);
    final blocks = ref.watch(filteredBlockProvider);
    final blockAsync = ref.watch(blocksFetcher);

    //double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    /*var margin = EdgeInsets.symmetric(
        vertical: screenHeight * 0.05, horizontal: screenWidth * 0.05);
*/
    return Center(
      child: blockAsync.when(
        data: (_) {
          return Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: screenHeight * 0.05, bottom: screenHeight * 0.02),
                child: SegmentedButton(
                  style: ButtonStyle(
                    shadowColor: MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return seedColor;
                        }
                        return Colors.white;
                      },
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return Colors.white;
                        }
                        return Colors.black;
                      },
                    ),
                  ),
                  segments: const [
                    ButtonSegment(
                        value: BlocksFilter.basico, icon: Text('Basico')),
                    ButtonSegment(
                        value: BlocksFilter.intermedio,
                        icon: Text('Intermedio')),
                    ButtonSegment(
                        value: BlocksFilter.avanzado, icon: Text('Avanzado')),
                  ],
                  selected: <BlocksFilter>{currentFilter},
                  onSelectionChanged: (value) {
                    ref.read(blocksFilterProvider.notifier).state = value.first;
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: blocks.length,
                  itemBuilder: (context, index) {
                    final block = blocks[index];

                    return LessonListTile(block: block);
                  },
                ),
              )
            ],
          );
        },
        error: (_, __) => const Text(
            'No se pudo cargar el nombre'), //Tengo que poner un alertDialog o algo asi
        loading: () => const CircularProgressIndicator(),
      ),
    );
  }
}
