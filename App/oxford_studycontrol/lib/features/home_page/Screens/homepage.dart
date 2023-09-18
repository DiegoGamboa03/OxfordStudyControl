import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:oxford_studycontrol/features/lessons_exams_list_view/screens/lessons_exams_list_viewer.dart';
import 'package:oxford_studycontrol/features/online_classes/screens/online_classes_viewer.dart';

class AppNavigationBar extends ConsumerStatefulWidget {
  const AppNavigationBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AppNavigationBarState();
}

class _AppNavigationBarState extends ConsumerState<AppNavigationBar> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(LineIcons.school),
            icon: Icon(LineIcons.school),
            label: 'Lecciones',
          ),
          NavigationDestination(
            icon: Icon(Icons.business),
            label: 'Clases',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.school),
            icon: Icon(Icons.school_outlined),
            label: 'Perfil',
          ),
        ],
      ),
      body: <Widget>[
        const LessonAndExamsListViewer(),
        const OnlineClassesViewer(),
        Container(
          color: Colors.blue,
          alignment: Alignment.center,
          child: const Text('Page 3'),
        ),
      ][currentPageIndex],
    );
  }
}
