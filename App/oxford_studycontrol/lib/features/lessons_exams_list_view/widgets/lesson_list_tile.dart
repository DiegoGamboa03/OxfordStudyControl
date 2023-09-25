import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:oxford_studycontrol/config/router/app_router.dart';
import 'package:oxford_studycontrol/config/theme/app_theme.dart';
import 'package:oxford_studycontrol/providers/exams_providers.dart';
import 'package:oxford_studycontrol/providers/lesson_provider.dart';
import '../../../models/blocks.dart';
import '../../../providers/user_provider.dart';

class LessonListTile extends ConsumerWidget {
  final Block block;

  const LessonListTile({super.key, required this.block});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final bool isEnabled = user!.currentBlock! >= block.id;
    return Column(
      children: [
        for (var lesson in block.lessons)
          Card(
            child: ListTile(
              textColor: seedColor,
              leading: const Icon(LineIcons.play),
              title: Text(lesson),
              enabled: isEnabled,
              onTap: () async {
                await ref.read(lessonFetcher(lesson).future).then((data) {
                  final lesson = ref.read(lessonProvider);
                  ref
                      .read(appRouterProvider)
                      .push('/viewLesson', extra: lesson);
                });
              },
            ),
          ),
        if (block.requiredExam != null)
          Card(
            child: ListTile(
              textColor: seedColor,
              leading: const Icon(LineIcons.pen),
              title: Text(block.requiredExam!),
              enabled: block.id == user.currentBlock,
              onTap: () async {
                await ref
                    .read(examFetcher(block.requiredExam!).future)
                    .then((value) {
                  ref.read(appRouterProvider).go('/examPreview');
                });
              },
            ),
          ),
      ],
    );
    /*return ListView.builder(
      itemCount: block.lessons.length,
      itemBuilder: (context, index) {
        final lesson = block.lessons[index];

        return Card(
          child: ListTile(
            leading: const FlutterLogo(),
            title: Text(lesson),
            onTap: () {},
          ),
        );
      },
    );*/
  }
}
