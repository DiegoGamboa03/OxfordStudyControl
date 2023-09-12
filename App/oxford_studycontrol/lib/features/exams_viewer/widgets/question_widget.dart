import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxford_studycontrol/config/theme/app_theme.dart';
import 'package:oxford_studycontrol/models/question.dart';

class QuestionWidget extends ConsumerStatefulWidget {
  final Question question;
  const QuestionWidget({super.key, required this.question});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends ConsumerState<QuestionWidget> {
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
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    /*24 is for notification bar on Android*/
    final double itemHeight = (screenHeight - kToolbarHeight - 24) / 8;
    final double itemWidth = screenWidth / 2;

    return Card(
      child: Padding(
        padding: EdgeInsets.only(bottom: screenHeight * 0.05),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: screenHeight * 0.01,
                bottom: screenHeight * 0.03,
                right: screenWidth * 0.05,
                left: screenHeight * 0.02,
              ),
              alignment: Alignment.centerLeft,
              child: Text(questionString,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                        color: seedColor,
                      )),
            ),
            isMultipleSelection
                ? GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: (itemWidth / itemHeight),
                      crossAxisCount: 2, // number of items in each row
                      mainAxisSpacing:
                          screenWidth * 0.02, // spacing between rows
                      crossAxisSpacing: screenHeight * 0.01,
                    ),
                    padding: EdgeInsets.zero,
                    itemCount: widget.question.options.length,
                    itemBuilder: (context, index) {
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
                          value: selectedIndex == index,
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding:
                              EdgeInsets.only(bottom: screenHeight * 0.005),
                          visualDensity: VisualDensity.compact,
                          dense: true,
                          onChanged: (value) {
                            setState(
                              () {
                                if (value != null && value) {
                                  selectedIndex = index;
                                } else {
                                  selectedIndex = null;
                                }
                              },
                            );
                          },
                        ),
                      );
                    },
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
/*class QuestionWidget extends ConsumerWidget {
  final Question question;
  const QuestionWidget({super.key, required this.question});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String questionString = '${question.questionPosition}-. ${question.id}';
    bool isMultipleSelection = question.type == 'seleccion Multiple';
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    int? selectedIndex;
    return Card(
      child: Column(
        children: [
          Text(questionString),
          isMultipleSelection
              ? GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // number of items in each row
                    mainAxisSpacing: screenWidth * 0.05, // spacing between rows
                    crossAxisSpacing:
                        screenHeight * 0.01, // spacing between columns
                  ),
                  itemCount: question.options.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      title: Text(question.options[index].toString()),
                      value: selectedIndex == index,
                      onChanged: (value) {
                        if (value != null && value) {
                          selectedIndex = index;
                        } else {
                          selectedIndex = null;
                        }
                      },
                    );
                  },
                )
              : Container()
        ],
      ),
    );
  }
}*/
