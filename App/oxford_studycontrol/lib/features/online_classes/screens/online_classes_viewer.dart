import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxford_studycontrol/providers/online_class_provider.dart';

class OnlineClassesViewer extends ConsumerWidget {
  const OnlineClassesViewer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onlineClassesAsync = ref.watch(onlineClassesFetcher);
    final onlineClassesFiltered = ref.watch(filteredOnlineClassProvider);

    return Center(
      child: onlineClassesAsync.when(
          data: (_) {
            return Container();
          },
          error: (_, __) => const Text('No se pudo cargar el nombre'),
          loading: () => const CircularProgressIndicator()),
    );
  }
}
