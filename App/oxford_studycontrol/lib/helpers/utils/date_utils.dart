DateTime formatStringToDateTime(String dateTimeString) {
  List<String> parts = dateTimeString.split(' ');
  List<String> dateParts = parts[0].split('-');
  List<String> timeParts = parts[1].split(':');

  int year = int.parse(dateParts[0]);
  int month = int.parse(dateParts[1]);
  int day = int.parse(dateParts[2]);
  int hour = int.parse(timeParts[0]);
  int minute = int.parse(timeParts[1]);
  int second = int.parse(timeParts[2]);

  DateTime date = DateTime(year, month, day, hour, minute, second);

  return date;
}
