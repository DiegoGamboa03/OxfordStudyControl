import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxford_studycontrol/config/router/app_router.dart';
import 'package:oxford_studycontrol/config/theme/app_theme.dart';
import 'package:oxford_studycontrol/models/lessons.dart';
import 'package:oxford_studycontrol/providers/block_providers.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:video_player/video_player.dart';

class LessonViewer extends ConsumerStatefulWidget {
  final Lesson lesson;
  const LessonViewer({super.key, required this.lesson});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LessonViewerState();
}

class _LessonViewerState extends ConsumerState<LessonViewer> {
  late final Uri url;
  late VideoPlayerController _videoPlayerController;
  late ChewieController chewieController;

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
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.lesson.url))
          ..initialize().then((_) {
            setState(() {});
          });
    chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      showControls: true,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(
              Icons.navigate_before,
              color: seedColor,
            ),
            onPressed: () {
              ref.read(appRouterProvider).pop();
            }),
      ),
      body:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: chewieController.videoPlayerController.value.isInitialized
              ? Chewie(
                  controller: chewieController,
                )
              : const Center(child: CircularProgressIndicator()),
        ),
        Text(
          lesson.name,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: seedColor,
              ),
        ),
        SizedBox.fromSize(
          size: const Size.fromRadius(100),
          child: FittedBox(
            child: IconButton(
                color: seedColor,
                icon: chewieController.isPlaying
                    ? const Icon(
                        Icons.pause_circle_outline,
                      )
                    : const Icon(Icons.play_circle_outline),
                onPressed: () {
                  setState(() {
                    if (chewieController.isPlaying) {
                      chewieController.pause();
                    } else {
                      chewieController.play();
                    }
                  });
                }),
          ),
        ),
        Card(
          color: seedColor,
          child: ListTile(
            title: Text(
              'Revisa los recursos de esta leccion',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
            ),
            onTap: () {
              if (lesson.resourceUrl != null) {
                _launchUrl();
              } else {}
            },
          ),
        )
      ]),
    );
  }
}
