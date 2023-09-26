import 'package:oxford_studycontrol/models/question.dart';

class Exam {
  String name;
  double? passingGrade;
  int? numQuestions;
  String? type;
  DateTime? generatedDate;
  List<Question>? questions;

  Exam({required this.name, this.passingGrade, this.numQuestions, this.type});

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
        name: json['name'],
        passingGrade: json['passing_grade'].toDouble(),
        numQuestions: json['num_questions'],
        type: json['type']);
  }

  set setQuestions(List<Question>? newQuestions) {
    questions = newQuestions;
  }

  set setGeneratedDate(DateTime newDate) {
    generatedDate = newDate;
  }
}
