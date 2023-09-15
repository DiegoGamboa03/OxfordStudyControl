class Answer {
  String questionID;
  String? answer;

  Answer({required this.questionID, this.answer});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'question_id': questionID,
      'answer': answer,
    };
    return data;
  }
}
