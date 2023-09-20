import '../helpers/utils/date_utils.dart';

class OnlineClass {
  String name;
  String teacherId;
  int requiredBlock;
  DateTime startTime;
  DateTime endTime;
  int maxPositions;
  int availablePositions;
  String url;

  OnlineClass(
      {required this.name,
      required this.teacherId,
      required this.requiredBlock,
      required this.startTime,
      required this.endTime,
      required this.maxPositions,
      required this.availablePositions,
      required this.url});

  factory OnlineClass.fromJson(Map<String, dynamic> json) {
    return OnlineClass(
        name: json['name'],
        teacherId: json['teacher_id'],
        requiredBlock: json['required_block'],
        startTime: formatStringToDateTime(json['start_date']),
        endTime: formatStringToDateTime(json['end_date']),
        maxPositions: json['max_positions'],
        availablePositions: json['available_positions'],
        url: json['url_meeting']);
  }
}
