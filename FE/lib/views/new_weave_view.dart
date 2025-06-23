import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:weave_us/views/widgets/new_weave_widget/friend_invite.dialog.dart';
import 'package:weave_us/views/widgets/new_weave_widget/new_name.input.dart';
import 'package:weave_us/views/widgets/new_weave_widget/weave_explanation.dart';
import '../../controllers/new_weave_controller.dart';

class NewWeaveView extends GetView<NewWeaveController> {
  const NewWeaveView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          '새 위브',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: Colors.grey[850], thickness: 1),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 2),
              child: Text(
                '위브 종류',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Pretendard',
                ),
              ),
            ),
            Obx(() => (ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ListTile(
                        onTap: () {
                          controller.weaveTypeExpanded.value =
                              !controller.weaveTypeExpanded.value;
                        },
                        leading: Icon(controller.selectedWeaveType.value == 1
                            ? HugeIcons.strokeRoundedGlobal
                            : controller.selectedWeaveType.value == 2
                                ? HugeIcons.strokeRoundedGift
                                : controller.selectedWeaveType.value == 3
                                    ? HugeIcons.strokeRoundedUser
                                    : HugeIcons.strokeRoundedGlobal),
                        title: controller.selectedWeave.value == ''
                            ? const Text('위브 종류를 선택하세요')
                            : Text(controller.selectedWeave.value),
                        trailing: controller.weaveTypeExpanded.value
                            ? const Icon(Icons.keyboard_arrow_up)
                            : const Icon(Icons.keyboard_arrow_down),
                      ),
                      if (controller.weaveTypeExpanded.value) ...[
                        ListTile(
                          onTap: () {
                            controller.selectedWeave.value = 'Global';
                            controller.selectedWeaveType.value = 1;
                            controller.selectedOpenRangeType.value = 3;
                            controller.weaveTypeExpanded.value = false;
                          },
                          // leading: ,
                          title: const Text('Global'),
                        ),
                        ListTile(
                          onTap: () {
                            controller.selectedWeave.value = 'Local';
                            controller.selectedWeaveType.value = 3;
                            controller.weaveTypeExpanded.value = false;
                          },
                          title: const Text('Local'),
                        ),
                      ],
                      if (controller.selectedWeaveType.value == 3) ...[
                        const Padding(padding: EdgeInsets.only(left: 16),
                          child: Text("공개 범위"),
                        ),
                        ListTile(
                          onTap: () {
                            controller.openRangeExpanded.value =
                                !controller.openRangeExpanded.value;
                          },
                          leading: Icon(
                              controller.selectedOpenRangeType.value == 3
                                  ? HugeIcons.strokeRoundedGlobe02
                                  : controller.selectedOpenRangeType.value == 2 ?
                                  HugeIcons.strokeRoundedUserLock01 : HugeIcons.strokeRoundedCircleLock02),
                          title: controller.selectedOpenRange.value == ''
                              ? const Text('공개 범위를 선택하세요')
                              : Text(controller.selectedOpenRange.value),
                          trailing: controller.openRangeExpanded.value
                              ? const Icon(Icons.keyboard_arrow_up)
                              : const Icon(Icons.keyboard_arrow_down),
                        ),
                        if (controller.openRangeExpanded.value) ...[
                          ListTile(
                              title: const Text("모두 보기"),
                              onTap: () {
                                controller.selectedOpenRangeType.value = 3;
                                controller.selectedOpenRange.value = '모두 보기';
                                controller.openRangeExpanded.value = false;
                              }),
                          ListTile(
                            title: const Text("나만 보기"),
                            onTap: () {
                              controller.selectedOpenRangeType.value = 1;
                              controller.selectedOpenRange.value = '나만 보기';
                              controller.openRangeExpanded.value = false;
                            },
                          ),
                          ListTile(
                            title: const Text("초대한 사용자"),
                            onTap: () {
                              controller.selectedOpenRangeType.value = 2;
                              controller.selectedOpenRange.value = '초대한 사용자';
                              controller.openRangeExpanded.value = false;
                            },
                          )
                        ],
                        if (controller.selectedOpenRangeType.value != 1) ...[
                          Padding(padding: EdgeInsets.only(left: 16),
                            child: Text("사용자 초대"),
                          ),
                          ListTile(
                            leading: Icon(HugeIcons.strokeRoundedUserLock01),
                            title: Text("${controller.selectedFriends.length}명 업로드 가능"),
                          ),
                          ListTile(
                            title: Text('가능한 친구'),
                            onTap: () {
                              Get.dialog(
                                FriendInviteDialog(
                                  onFriendSelected: controller.addFriend,
                                ),
                              );
                            },
                            trailing: Icon(Icons.add_circle_outline),
                          ),
                          if (controller.selectedFriends.isNotEmpty) ...[
                            Divider(color: Colors.grey[850], thickness: 1),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.selectedFriends.length,
                              itemBuilder: (context, index) {
                                final friend = controller.selectedFriends[index];
                                return ListTile(
                                  leading: friend.mediaUrl.isEmpty
                                      ? const CircleAvatar() : CircleAvatar(backgroundImage: NetworkImage(friend.mediaUrl)),
                                  title: Text(friend.nickname),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.remove_circle_outline),
                                    onPressed: () {
                                      controller.selectedFriends.remove(friend);
                                    },)
                            );})
                          ]
                        ]
                      ]
                    ]))),
            // WeaveTypeSelector(
            //   onChanged: (model) {
            //     controller.updateSelections(
            //       weave: model.weave,
            //       range: model.range,
            //       invite: model.invite,
            //     );
            //   },
            // ),
            Divider(color: Colors.grey[850], thickness: 1),
            NewNameInput(
              controller: controller.nameController,
              focusNode: controller.nameFocusNode,
            ),
            Divider(color: Colors.grey[850], thickness: 1),
            WeaveExplanation(
              controller: controller.descriptionController,
              focusNode: controller.descriptionFocusNode,
            ),

            Divider(color: Colors.grey[850], thickness: 1),
            const SizedBox(height: 30),

            Obx(() {
              return Column(
                children: [
                  if (controller.isFormValid.value && controller.selectedWeaveType.value == 1)
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            fontFamily: 'Pretendard',
                          ),
                          children: [
                            TextSpan(text: '위브는 '),
                            TextSpan(
                              text: '그 누구의 소유도 아닙니다.  ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: '추가하시겠습니까?'),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20, left: 20),
                      child: ElevatedButton(
                        onPressed: controller.isFormValid.value
                            ? controller.createWeave
                            : null,
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
                            "위브 생성",
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
              );
            }),
          ],
        ),
      ),
    );
  }
}
