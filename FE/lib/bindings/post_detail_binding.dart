import 'package:get/get.dart';
import '../controllers/comment_input_controller.dart';
import '../controllers/post_detail_contoller.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';

class PostDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService());
    Get.lazyPut<TokenService>(() => TokenService());
    Get.lazyPut<PostDetailController>(() => PostDetailController(
      apiService: Get.find(),
      tokenService: Get.find(),
    ));
    Get.lazyPut<CommentInputController>(() => CommentInputController(
      apiService: Get.find(),
      tokenService: Get.find(),
    ));
  }
}
