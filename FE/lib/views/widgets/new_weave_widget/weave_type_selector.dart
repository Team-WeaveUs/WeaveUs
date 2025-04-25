import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:weave_us/views/widgets/new_weave_widget/friend_invite.dialog.dart';
import '../../../models/weave_type_model.dart';

class WeaveTypeSelector extends StatefulWidget {
  final Function(WeaveTypeModel model) onChanged;

  const WeaveTypeSelector({
    super.key,
    required this.onChanged,
  });

  @override
  State<WeaveTypeSelector> createState() => _WeaveTypeSelectorState();
}

class _WeaveTypeSelectorState extends State<WeaveTypeSelector> {
  final List<String> weaveTypes = ['Weave', '내 Weave', 'Global', 'Private'];
  final List<String> openRanges = ['모두 공개', '초대한 사용자', '나만 보기'];
  final List<String> inviteOptions = ['인원', '로직', '필요'];

  String? selectedWeave;
  String? selectedOpenRange;
  String? selectedInviteOption;

  bool isOpenRangeExpanded = false;
  bool isInviteExpanded = false;

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
        Padding(
          padding: const EdgeInsets.only(right: 20, left: 5),
          child: DropdownButton2<String>(
            alignment: Alignment.centerLeft,

            underline: const SizedBox.shrink(),
            value: selectedWeave,
            isExpanded: true,
            hint: const Text(
              "위브 종류를 선택하세요",
              textAlign: TextAlign.left,
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
            selectedItemBuilder: (context) => weaveTypes.map((type) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  type,
                  textAlign: TextAlign.left,
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

        // 공개 범위, 초대 인원 옵션은 '내 Weave'일 때만 표시
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
                  Row(children: [
                    const Icon(HugeIcons.strokeRoundedGlobe02),
                    const SizedBox(width: 8),
                    Text(
                      selectedOpenRange ?? "공개 범위를 선택하세요",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ]),
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

          // 초대 인원
          GestureDetector(
            onTap: () => setState(() => isInviteExpanded = !isInviteExpanded),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(children: [
                    const Icon(HugeIcons.strokeRoundedUserLock02),
                    const SizedBox(width: 8),
                    Text(
                      selectedInviteOption ?? "친구 초대하기",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50.0),
                    child: GestureDetector(
                      onTap: () {
                        Get.dialog(const FriendInviteDialog());
                      },
                      child: const Icon(HugeIcons.strokeRoundedPlusSignCircle),
                    ),
                  ),
                  ]),
                ),

                const Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Icon(Icons.arrow_drop_down),
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
        ],
      ],
    );
  }
}