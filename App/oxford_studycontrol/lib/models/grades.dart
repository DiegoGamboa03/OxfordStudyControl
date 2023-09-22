import 'package:oxford_studycontrol/helpers/utils/date_utils.dart';

class Grade {
  String examId;
  String studentId;
  DateTime testDate;
  double score;
  bool approved;

  Grade(
      {required this.examId,
      required this.studentId,
      required this.testDate,
      required this.score,
      required this.approved});

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
        examId: json['exam_id'],
        studentId: json['student_id'],
        testDate: formatStringToDateTime(json['test_date']),
        score: json['score'].toDouble(),
        approved: json['approved'] > 0);
  }
}
