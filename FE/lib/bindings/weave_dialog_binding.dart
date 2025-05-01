import 'package:get/get.dart';
import '../../controllers/weave_dialog_controller.dart';
import '../../services/api_service.dart';

class WeaveDialogBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WeaveDialogController(apiService: Get.find<ApiService>()));
  }
}
