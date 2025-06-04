import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weave_us/views/components/bottom_nav_bar.dart';
import '../../controllers/new_reward_controller.dart';
import '../components/app_nav_bar.dart';
import '../widgets/new_post_widgets/post_content.input.dart';
import '../widgets/new_reward_widgets/reward_content_input.dart';

class NewRewardView extends GetView<NewRewardController> {
  const NewRewardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
          title: const Text(
              '새 리워드',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25,
                letterSpacing: 1.0,
              ),
          ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: Colors.grey[850], thickness: 1),
            RewardContentInput(controller: controller.rewardContentController),
            Divider(color: Colors.grey[850], thickness: 1),
            PostContentInput(
              controller: controller.postContentController,
              onChanged: controller.setDescription,
            ),
            Divider(color: Colors.grey[850], thickness: 1),
            const Text('만료 기간',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Pretendard',
                )),
            Divider(color: Colors.grey[850], thickness: 1),
            Obx(() => DropdownButton<String>(
                  value: controller.validityString.value,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      controller.validityString.value = newValue;
                    }
                  },
                  items: [
                    DropdownMenuItem(
                      value: '30d',
                      child: Text('지급일로부터 30일',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Pretendard',
                      )
                    ),
                    ),
                    DropdownMenuItem(
                      value: '60d',
                        child: Text('지급일로부터 60일',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Pretendard',
                            )
                        ),
                    ),
                    // 필요하면 더 추가 가능
                    DropdownMenuItem(
                      value: '90d',
                      child: Text('지급일로부터 90일',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Pretendard',
                          )
                      ),
                    ),
                    DropdownMenuItem(
                      value: '0d',
                      child: Text('무제한',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Pretendard',
                          )
                      ),
                    ),
                  ],
                )),
            Divider(color: Colors.grey[850], thickness: 1),

            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: const Text(
                '리워드 비밀번호',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Pretendard',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: TextField(
                controller: controller.passwordController,
                decoration: const InputDecoration(
                hintText: '리워드 비밀번호를 입력해주세요.',
                hintStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Pretendard',
                  color: Colors.grey,
                  letterSpacing: 1
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                obscureText: true,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Pretendard',
                  color: Colors.black,
                  letterSpacing: 1
                ),
              ),
            ),
            Divider(color: Colors.grey[850], thickness: 1),
            const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
              child: ElevatedButton(
                onPressed: controller.submitReward,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8000),
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    "공유하기",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                ),
              ),
            ),
        ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
