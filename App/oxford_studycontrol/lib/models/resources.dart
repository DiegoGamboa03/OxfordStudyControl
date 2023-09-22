class Resource {
  String url;
  String lesson;
  String type;

  Resource({
    required this.url,
    required this.lesson,
    required this.type,
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
        url: json['url'], lesson: json['lesson'], type: json['type']);
  }
}
