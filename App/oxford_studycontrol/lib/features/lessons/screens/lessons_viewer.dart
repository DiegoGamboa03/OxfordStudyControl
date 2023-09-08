import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxford_studycontrol/features/lessons/widgets/lesson_list_tile.dart';
import '../../../providers/block_providers.dart';

class LessonViewer extends ConsumerWidget {
  const LessonViewer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.watch(blocksFilterProvider);
    final blocks = ref.watch(filteredBlockProvider);
    final blockAsync = ref.watch(blocksFetcher);

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    var margin = EdgeInsets.symmetric(
        vertical: screenHeight * 0.05, horizontal: screenWidth * 0.05);

    return Center(
      child: blockAsync.when(
        data: (_) {
          return Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: screenHeight * 0.05, bottom: screenHeight * 0.02),
                child: SegmentedButton(
                  segments: const [
                    ButtonSegment(
                        value: blocksFilter.basico, icon: Text('Basico')),
                    ButtonSegment(
                        value: blocksFilter.intermedio,
                        icon: Text('Intermedio')),
                    ButtonSegment(
                        value: blocksFilter.avanzado, icon: Text('Avanzado')),
                  ],
                  selected: <blocksFilter>{currentFilter},
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
