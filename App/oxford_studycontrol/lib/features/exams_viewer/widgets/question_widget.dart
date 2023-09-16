import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxford_studycontrol/config/theme/app_theme.dart';
import 'package:oxford_studycontrol/models/question.dart';
import 'package:oxford_studycontrol/providers/exams_providers.dart';

class QuestionWidget extends ConsumerStatefulWidget {
  final Question question;
  const QuestionWidget({super.key, required this.question});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends ConsumerState<QuestionWidget>
    with AutomaticKeepAliveClientMixin {
  int? selectedIndex;
  late String questionString;
  late bool isMultipleSelection;
  @override
  void initState() {
    final question = widget.question;
    questionString = '${question.questionPosition}-. ${question.id}';
    isMultipleSelection = question.type == 'seleccion Multiple';
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    /*24 is for notification bar on Android*/
    final double itemHeight = (screenHeight - kToolbarHeight - 24) / 8;
    final double itemWidth = screenWidth / 2;

    return Card(
      child: Padding(
        padding: EdgeInsets.only(bottom: screenHeight * 0.02),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: screenHeight * 0.03,
                bottom: screenHeight * 0.01,
                right: screenWidth * 0.05,
                left: screenHeight * 0.02,
              ),
              alignment: Alignment.centerLeft,
              child: Text(questionString,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        color: seedColor,
                      )),
            ),
            isMultipleSelection
                ? GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    childAspectRatio: (itemWidth / itemHeight),
                    crossAxisCount: 2, // number of items in each row
                    mainAxisSpacing: screenWidth * 0.02, // spacing between rows
                    crossAxisSpacing: screenHeight * 0.001,
                    padding: EdgeInsets.zero,
                    children:
                        List.generate(widget.question.options.length, (index) {
                      return Center(
                        child: CheckboxListTile(
                          title: Text(
                            widget.question.options[index].toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: 17,
                                  color: seedColor,
                                ),
                          ),
                          checkColor: Colors.white,
                          value: selectedIndex == index,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          dense: true,
                          onChanged: (value) {
                            setState(
                              () {
                                Question question = widget.question;
                                if (value != null && value) {
                                  selectedIndex = index;
                                  ref
                                      .read(questionsStateNotifierProvider
                                          .notifier)
                                      .answerQuestion(
                                          question.id, question.options[index]);
                                } else {
                                  ref
                                      .read(questionsStateNotifierProvider
                                          .notifier)
                                      .answerQuestion(question.id, null);
                                  selectedIndex = null;
                                }
                              },
                            );
                          },
                        ),
                      );
                    }),
                  )
                : Container() //Aqui va la estructura para preguntas de tipo desarrollo
          ],
        ),
      ),
    );
  }
}
