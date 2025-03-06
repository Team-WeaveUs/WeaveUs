import 'package:weave_us/Auth/token_storage.dart';

import '../../../Auth/api_client.dart';

class ListService {
  static Future<List<int>> fetchMainList() async {
    final response = await ApiService.sendGetRequest('WeaveAPI/main');

    if (response.containsKey('body') && response['body'].containsKey('post_id')) {
      final List<dynamic> postIdList = response['body']['post_id'];

      return postIdList.map<int>((id) => id as int).toList();
    } else {
      throw Exception("Invalid response format: ${response['body']}");
    }
  }
}
