import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxford_studycontrol/providers/lesson_provider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class LessonViewer extends ConsumerWidget {
  const LessonViewer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lesson = ref.watch(lessonProvider);
    final videoID = YoutubePlayerController.convertUrlToId(lesson!.url);
    final controller = YoutubePlayerController.fromVideoId(
      videoId: videoID!,
      autoPlay: true,
      params: const YoutubePlayerParams(
        enableCaption: false,
        showFullscreenButton: false,
        showControls: false,
        enableJavaScript: false,
      ),
    );

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: YoutubePlayerScaffold(
        controller: controller,
        aspectRatio: 16 / 9,
        builder: (context, player) {
          return Column(
            children: [
              Container(
                  margin: EdgeInsets.only(
                      top: screenHeight * 0.08, bottom: screenHeight * 0.02),
                  child: player),
              Text(lesson.name),
            ],
          );
        },
      ),
    );
  }
}


/*final lesson = ref.watch(lessonProvider);
    final videoID = YoutubePlayerController.convertUrlToId(lesson!.url);
    final controller = YoutubePlayerController.fromVideoId(
      videoId: videoID!,
      autoPlay: true,
      params: const YoutubePlayerParams(
        enableCaption: false,
        showFullscreenButton: false,
        showControls: false,
        enableJavaScript: false,
      ),
    );

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: YoutubePlayerScaffold(
        controller: controller,
        aspectRatio: 16 / 9,
        builder: (context, player) {
          return Column(
            children: [
              Container(
                  margin: EdgeInsets.only(
                      top: screenHeight * 0.08, bottom: screenHeight * 0.02),
                  child: player),
              Text(lesson.name),
            ],
          );
        },
      ),
    );*/