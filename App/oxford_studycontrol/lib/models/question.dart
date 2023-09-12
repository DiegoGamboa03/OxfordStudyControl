class Question {
  String id;
  int questionPosition;
  List options;
  String? type;

  Question(
      {required this.id,
      required this.questionPosition,
      required this.options,
      this.type});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
        id: json['question_id'],
        questionPosition: json['question_position'],
        options: json['options'],
        type: json['type']);
  }
}
