import 'package:dio/dio.dart';
import 'package:oxford_studycontrol/models/blocks.dart';

import '../../constants.dart';

class BlocksApi {
  static Future<List<Block>> getBlocks() async {
    final dio = Dio();
    final url = Constants.baseUrl;
    try {
      final response = await dio.get('$url/blocks');
      List<Block> blockList = [];
      response.data.forEach((block) {
        blockList.add(Block.fromJson(block));
      });
      return blockList;
    } catch (e) {
      throw Exception('Error');
    }
  }
}
