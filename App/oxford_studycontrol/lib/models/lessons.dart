class Lesson {
  String name;
  String url;
  int block;
  String? resourceUrl;

  Lesson(
      {required this.name,
      required this.url,
      required this.block,
      this.resourceUrl});

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
        name: json['name'],
        url: json['url'],
        block: json['block'],
        resourceUrl: json['resource_url']);
  }
}
