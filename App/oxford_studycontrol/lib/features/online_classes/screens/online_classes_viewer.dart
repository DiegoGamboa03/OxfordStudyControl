import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:oxford_studycontrol/config/theme/app_theme.dart';
import 'package:oxford_studycontrol/features/online_classes/widgets/online_class_card.dart';
import 'package:oxford_studycontrol/providers/online_class_provider.dart';
import 'package:oxford_studycontrol/providers/user_provider.dart';

class OnlineClassesViewer extends ConsumerWidget {
  const OnlineClassesViewer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final onlineClassesAsync = ref.watch(onlineClassesFetcher(user!.id));
    final onlineClasses = ref.watch(filteredOnlineClassProvider);

    /*double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    var margin = EdgeInsets.symmetric(
        vertical: screenHeight * 0.05, horizontal: screenWidth * 0.05);*/

    return Center(
      child: onlineClassesAsync.when(
          data: (_) {
            return LoaderOverlay(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    title: Expanded(
                        child: Text(
                      'Clases en vivo disponibles',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: seedColor,
                          ),
                    )),
                  ),
                  SliverList.builder(
                    itemCount: onlineClasses.length,
                    itemBuilder: (context, index) {
                      final onlineClass = onlineClasses[index];
                      return OnlineClassCard(onlineClass: onlineClass);
                    },
                  )
                ],
              ),
            );
          },
          error: (_, __) => const Text('No se pudo cargar el nombre'),
          loading: () => const CircularProgressIndicator()),
    );
  }
}
