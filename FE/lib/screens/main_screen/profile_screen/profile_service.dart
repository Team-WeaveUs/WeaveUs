import 'package:weave_us/Auth/api_end_points.dart';
import 'package:weave_us/Auth/token_storage.dart';
import 'package:weave_us/screens/main_screen/profile_screen/profile.dart';

import '../../../Auth/api_client.dart';

class ProfileService {
  static Future<Profile?> getProfile() async {
    final userId = await TokenStorage.getUserID();
    final response = await ApiService.sendRequest('WeaveAPI/ProfileInfo', ApiEndpoints.profileInfoBody(userId!, userId, 5));

    if (response != null && response['statusCode'] == 200) {
      // API 응답에서 'body' 부분만 추출
      return Profile.fromJson(response['body']);
    }
    return null;
  }
}