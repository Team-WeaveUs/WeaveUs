import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weave_us/views/widgets/profile_view/my_post_widget.dart';
import 'package:weave_us/views/widgets/profile_view/my_subscriber_widget.dart';
import '../views/widgets/profile_view/i_subscribe_widget.dart';
import 'profile_controller.dart';

class TabViewController extends GetxController with GetTickerProviderStateMixin{
  late TabController tabController;
  List<Tab> tabs = [];
  List<Widget> tabViews = [];

  final isTabReady = false.obs; // 렌더링 여부
  final profileController = Get.find<ProfileController>();

  @override
  void onReady() {
    super.onReady();

    _setupTabs(profileController.isToggled.value);
    tabController = TabController(length: tabs.length, vsync: this);
    isTabReady.value = true;

    ever(profileController.isToggled, (bool isToggled) {
      isTabReady.value = false; // 먼저 숨김
      _setupTabs(isToggled);
      tabController.dispose();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        tabController = TabController(length: tabs.length, vsync: this);
        isTabReady.value = true; // 준비 완료 시 보여주기
        update();
      });
    });
  }

  void _setupTabs(bool isToggled) {
    if (isToggled) {
      tabs = [
        const Tab(text: '구독한 사람'),
        const Tab(text: '나를 구독한 사람'),
      ];
      tabViews = [
        Center(child: ISubscribeWidget()),
        Center(child: MySubscribeWidget()),
      ];
    } else {
      tabs = [
        const Tab(text: '게시물'),
        const Tab(text: '위브 리스트'),
        const Tab(text: '내 위브 리스트'),
      ];
      tabViews = [
        Center(child: MyPostWidget()),
        Center(child: Text('위브 리스트')),
        Center(child: Text('내 위브 리스트')),
      ];
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
