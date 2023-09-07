class Block {
  final int id;
  final String level;
  final String? requiredExam;
  final int? nextBlock;
  final List<String> lessons;

  Block(
      {required this.id,
      required this.level,
      required this.requiredExam,
      this.nextBlock,
      required this.lessons});

  factory Block.fromJson(Map<String, dynamic> json) {
    List<dynamic> dynamicList = json['lessons'];
    List<String> lessonsList =
        dynamicList.map((item) => item.toString()).toList();

    return Block(
      id: json['id'],
      level: json['level'],
      requiredExam: json['required_exam'],
      nextBlock: json['next_block'],
      lessons: lessonsList,
    );
  }
}
