class Lesson {
  String name;
  String url;
  int block;

  Lesson({required this.name, required this.url, required this.block});

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(name: json['name'], url: json['url'], block: json['block']);
  }
}
