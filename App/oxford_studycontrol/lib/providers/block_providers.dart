import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxford_studycontrol/helpers/api/blocks_api.dart';
import 'package:oxford_studycontrol/models/blocks.dart';

enum BlocksFilter { basico, intermedio, avanzado }

final blocksFilterProvider = StateProvider<BlocksFilter>((ref) {
  return BlocksFilter.basico;
});

final blocksStateNotifierProvider =
    StateNotifierProvider<BlocksNotifier, List<Block>>((ref) {
  return BlocksNotifier();
});

class BlocksNotifier extends StateNotifier<List<Block>> {
  BlocksNotifier() : super([]);

  void addBlock(Block block) {
    state = [...state, block];
  }

  void addMultipleBlocks(List<Block> blocks) {
    for (var block in blocks) {
      addBlock(block);
    }
  }
  //Aqui va cualquier funcion que le quiera poner a la lista de blocks
}

final filteredBlockProvider = Provider<List<Block>>((ref) {
  final selectedFilter = ref.watch(blocksFilterProvider);
  final blocks = ref.watch(blocksStateNotifierProvider);

  switch (selectedFilter) {
    case BlocksFilter.basico:
      return blocks.where((block) => block.level == 'Basico').toList();

    case BlocksFilter.intermedio:
      return blocks.where((block) => block.level == 'Intermedio').toList();

    case BlocksFilter.avanzado:
      return blocks.where((block) => block.level == 'Avanzado').toList();
  }
});

final blocksFetcher = FutureProvider((ref) async {
  try {
    await BlocksApi.getBlocks().then((blocks) {
      ref.watch(blocksStateNotifierProvider.notifier).addMultipleBlocks(blocks);
      return blocks;
    });
  } catch (e) {
    rethrow;
  }
  return null;
});
