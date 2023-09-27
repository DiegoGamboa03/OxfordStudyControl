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
    final currentFilter = ref.watch(onlineClassFilterProvider);
    final onlineClasses = ref.watch(filteredOnlineClassProvider);

    //double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    /*var margin = EdgeInsets.symmetric(
        vertical: screenHeight * 0.05, horizontal: screenWidth * 0.05);
*/
    return Center(
      child: onlineClassesAsync.when(
          data: (_) {
            return LoaderOverlay(
                child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: screenHeight * 0.05, bottom: screenHeight * 0.02),
                  child: SegmentedButton(
                    style: ButtonStyle(
                      shadowColor:
                          MaterialStateProperty.all<Color>(Colors.white),
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
                          value: OnlineClassFilter.all,
                          icon: Text('Clases disponibles')),
                      ButtonSegment(
                          value: OnlineClassFilter.reserved,
                          icon: Text('Clases reservadas')),
                    ],
                    selected: <OnlineClassFilter>{currentFilter},
                    onSelectionChanged: (value) {
                      ref.read(onlineClassFilterProvider.notifier).state =
                          value.first;
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: onlineClasses.length,
                    itemBuilder: (context, index) {
                      final onlineClass = onlineClasses[index];
                      return OnlineClassCard(onlineClass: onlineClass);
                    },
                  ),
                )
              ],
            ));
          },
          error: (_, __) => const Text('No'),
          loading: () => const CircularProgressIndicator()),
    );
  }
}


/*CustomScrollView(
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
              ),*/