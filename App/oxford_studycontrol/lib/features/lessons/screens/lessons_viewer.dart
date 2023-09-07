import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxford_studycontrol/models/blocks.dart';
import 'package:oxford_studycontrol/providers/user_provider.dart';
import '../../../providers/block_providers.dart';
/*
class LessonViewer extends ConsumerStatefulWidget {
  const LessonViewer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LessonViewerState();
}

class _LessonViewerState extends ConsumerState<LessonViewer> {
  late final blockAsync;
  @override
  void initState() {
    blockAsync = ref.read(blocksFetcher);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return Center(
      child: blockAsync.when(
        data: (_) => Text(user!.id),
        error: (_, __) => const Text('No se pudo cargar el nombre'),
        loading: () => const CircularProgressIndicator(),
      ),
    );
  }
}
*/

class LessonViewer extends ConsumerWidget {
  const LessonViewer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final currentFilter = ref.watch(blocksFilterProvider);
    final blocks = ref.watch(filteredBlockProvider);
    final blockAsync = ref.watch(blocksFetcher);

    return Center(
      child: blockAsync.when(
        data: (_) {
          return Column(
            children: [
              SegmentedButton(
                segments: const [
                  ButtonSegment(
                      value: blocksFilter.basico, icon: Text('Basico')),
                  ButtonSegment(
                      value: blocksFilter.intermedio, icon: Text('Intermedio')),
                  ButtonSegment(
                      value: blocksFilter.avanzado, icon: Text('Avanzado')),
                ],
                selected: <blocksFilter>{currentFilter},
                onSelectionChanged: (value) {
                  ref.read(blocksFilterProvider.notifier).state = value.first;
                },
              ),
              const SizedBox(height: 5),
              Expanded(
                child: ListView.builder(
                  itemCount: blocks.length,
                  itemBuilder: (context, index) {
                    final block = blocks[index];

                    return SwitchListTile(
                        title: Text(block.id.toString()),
                        value: true,
                        onChanged: (value) {});
                  },
                ),
              )
            ],
          );
        },
        error: (_, __) => const Text('No se pudo cargar el nombre'),
        loading: () => const CircularProgressIndicator(),
      ),
    );
  }
}
