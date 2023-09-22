import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxford_studycontrol/models/lessons.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LessonViewer extends ConsumerStatefulWidget {
  final Lesson lesson;
  const LessonViewer({super.key, required this.lesson});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LessonViewerState();
}

class _LessonViewerState extends ConsumerState<LessonViewer> {
  late final Uri url;

  Future<void> _launchUrl() async {
    /*launchUrlString(widget.lesson.resourceUrl!, mode: LaunchMode.externalApplication);*/
    if (!await launchUrlString(widget.lesson.resourceUrl!,
        mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  void initState() {
    if (widget.lesson.resourceUrl != null) {
      Uri uri = Uri.parse(widget.lesson.resourceUrl!);

      url = Uri(scheme: uri.scheme, host: uri.host, path: uri.path);
      /*url = Uri(scheme: 'https', host: 'www.cylog.org', path: 'headers/');*/
      //url = Uri.parse(widget.lesson.resourceUrl!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    return Scaffold(
      body: Column(children: [
        Align(
          alignment: Alignment.center,
          child: Text(lesson.name),
        ),
        if (lesson.resourceUrl != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              child: ListTile(
                title: const Text('Recursos'),
                onTap: () {
                  debugPrint('HOLAAAAAAAAAAA');
                  _launchUrl();
                },
              ),
            ),
          )
      ]),
    );
  }
}
