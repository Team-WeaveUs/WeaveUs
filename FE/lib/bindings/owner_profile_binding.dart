import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../controllers/tab_view_controller.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';

class OwnerProfileBinding extends Bindings {
  @override

  void dependencies() {
    print('✅ Owner프로필Binding called!');

    // 서비스들 먼저 lazy 등록
    Get.lazyPut<TokenService>(() => TokenService());
    Get.lazyPut<ApiService>(() => ApiService());

    // 탭 컨트롤러 등록
    Get.lazyPut<TabViewController>(() => TabViewController());

    // ProfileController 주입형 생성
    Get.lazyPut<ProfileController>(() => ProfileController(
      apiService: Get.find<ApiService>(),
      tokenService: Get.find<TokenService>(),
    ));
  }
}