import 'package:flutter/material.dart';
import 'package:oxford_studycontrol/config/theme/app_theme.dart';

class TitleSubtitleText extends StatelessWidget {
  final String title;
  final String subtitle;
  const TitleSubtitleText(
      {super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    var margin = EdgeInsets.symmetric(
        vertical: screenHeight * 0.02, horizontal: screenWidth * 0.03);
    return Container(
      margin: margin,
      child: Text.rich(
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: seedColor, fontSize: 16),
        TextSpan(children: [
          TextSpan(
              text: '$title ',
              style: const TextStyle(
                  color: seedColor, fontWeight: FontWeight.w700)),
          TextSpan(
            text: subtitle,
          ),
        ]),
      ),
    );
  }
}
