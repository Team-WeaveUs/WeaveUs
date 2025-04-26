import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../controllers/friend_invite_dialog_controller.dart';
import '../../../models/friend_invite_model.dart';
import '../../../models/weave_type_model.dart';
import 'friend_invite.dialog.dart';

class WeaveTypeSelector extends StatefulWidget {
  final Function(WeaveTypeModel model) onChanged;

  const WeaveTypeSelector({super.key, required this.onChanged});

  @override
  State<WeaveTypeSelector> createState() => _WeaveTypeSelectorState();
}

class _WeaveTypeSelectorState extends State<WeaveTypeSelector> {
  final List<String> weaveTypes = ['Weave', '내 Weave', 'Global', 'Private'];
  final List<String> openRanges = ['모두 공개', '초대한 사용자', '나만 보기'];
  final List<String> inviteOptions = ['인원', '로직', '필요'];

  late final FriendInviteDialogController inviteController;

  String? selectedWeave;
  String? selectedOpenRange;
  String? selectedInviteOption;

  bool isOpenRangeExpanded = false;
  bool isInviteExpanded = false;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<FriendInviteDialogController>()) {
      inviteController = Get.put(
        FriendInviteDialogController(
          apiService: Get.find(),
          tokenService: Get.find(),
        ),
      );
    } else {
      inviteController = Get.find();
    }
  }

  void _notifyParent() {
    widget.onChanged(
      WeaveTypeModel(
        weave: selectedWeave,
        range: selectedOpenRange,
        invite: selectedInviteOption,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 위브 종류 선택
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: DropdownButton2<String>(
            alignment: Alignment.centerLeft,
            underline: const SizedBox.shrink(),
            value: selectedWeave,
            isExpanded: true,
            hint: const Text(
              "위브 종류를 선택하세요",
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Pretendard',
                color: Colors.grey,
                letterSpacing: 1,
              ),
            ),
            items: weaveTypes.map((type) {
              return DropdownMenuItem(value: type, child: Text(type));
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedWeave = value;
                selectedOpenRange = null;
                selectedInviteOption = null;
                isOpenRangeExpanded = false;
                isInviteExpanded = false;
                _notifyParent();
              });
            },
          ),
        ),

        if (selectedWeave == '내 Weave') ...[
          Divider(color: Colors.grey[850], thickness: 1),

          // 공개 범위
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () => setState(() => isOpenRangeExpanded = !isOpenRangeExpanded),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(HugeIcons.strokeRoundedGlobe02),
                      const SizedBox(width: 8),
                      Text(
                        selectedOpenRange ?? "공개 범위를 선택하세요",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Icon(isOpenRangeExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          if (isOpenRangeExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 36, bottom: 8),
              child: Column(
                children: openRanges.map((option) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedOpenRange = option;
                        isOpenRangeExpanded = false;
                        _notifyParent();
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(option),
                    ),
                  );
                }).toList(),
              ),
            ),

          Divider(color: Colors.grey[850], thickness: 1),

          // 친구 초대
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(HugeIcons.strokeRoundedUserLock02),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isInviteExpanded = !isInviteExpanded),
                    child: Text(
                      selectedInviteOption ?? "친구 초대하기",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.dialog(
                      FriendInviteDialog(
                        onFriendSelected: (friend) {
                          inviteController.addFriend(friend);
                        },
                      ),
                    );
                  },
                  child: const Icon(HugeIcons.strokeRoundedPlusSignCircle),
                ),
              ],
            ),
          ),
          if (isInviteExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 36, bottom: 8),
              child: Column(
                children: inviteOptions.map((option) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedInviteOption = option;
                        isInviteExpanded = false;
                        _notifyParent();
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(option),
                    ),
                  );
                }).toList(),
              ),
            ),

          // 초대한 친구 리스트
          Obx(() {
            final invited = inviteController.selectedFriends;
            return Padding(
              padding: const EdgeInsets.only(left: 36, top: 8, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: invited.map((friend) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundImage: friend.mediaUrl.isNotEmpty
                              ? NetworkImage(friend.mediaUrl)
                              : null,
                          child: friend.mediaUrl.isEmpty
                              ? const Icon(Icons.person, size: 14)
                              : null,
                        ),
                        Expanded(child: Text(friend.nickname)),

                        // ✅ 삭제 버튼 추가
                        TextButton(
                          onPressed: () {
                            Get.find<FriendInviteDialogController>().removeFriend(friend);
                          },
                          child: const Text(
                            "삭제하기",
                            style: TextStyle(color: Colors.redAccent, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          }),
        ],
      ],
    );
  }
}