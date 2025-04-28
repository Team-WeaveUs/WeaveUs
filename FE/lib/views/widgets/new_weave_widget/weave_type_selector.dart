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
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Container(
            width: double.infinity,
            child: DropdownButtonFormField2<String>(
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top:10, bottom: 10), // ✨ 직접 패딩 지정
                hintStyle: TextStyle(color: Colors.grey),
                focusedBorder: InputBorder.none,
              ),
              isExpanded: true,
              // 버튼 크기, 안쪽 여백 지정
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.only(left: 0.0),
              ),
              // 펼쳐지는 메뉴 크기, 패딩 설정
              dropdownStyleData: const DropdownStyleData(
                padding: EdgeInsets.all(0.0),
              ),
              // 드롭다운 메뉴 항목 높이와 내부 여백 설정
              menuItemStyleData: const MenuItemStyleData
                (
                padding: EdgeInsets.symmetric(horizontal: 0.0),
                height: 40.0,
              ),
              style: const TextStyle(
                fontSize: 20,
                fontFamily: 'Pretendard',
                color: Colors.black,
                letterSpacing: 1,
              ),
              value: selectedWeave,
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
                return DropdownMenuItem(
                  value: type,
                  child: Text(
                    type,
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Pretendard',
                      color: Colors.black,
                      letterSpacing: 1,
                    ),
                  ),
                );
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
                  child: Text(
                    "친구 초대하기",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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

          // 초대한 친구 리스트
          Obx(() {
            final invited = inviteController.selectedFriends;
            return Padding(
              padding: const EdgeInsets.only(left: 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: invited.map((friend) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
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

                        // 삭제 버튼
                        TextButton(
                          onPressed: () {
                            inviteController.removeFriend(friend);
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