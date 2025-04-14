import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class WeaveTypeSelector extends StatefulWidget {
  final Function({
  required String? weave,
  required String? range,
  required String? invite,
  }) onChanged;

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
  final List<String> inviteOptions = ['1명 업로드 가능', '3명 업로드 가능', '5명 업로드 가능'];

  String? selectedWeave;
  String? selectedOpenRange;
  String? selectedInviteOption;

  bool isOpenRangeExpanded = false;
  bool isInviteExpanded = false;

  void _notifyParent() {
    widget.onChanged(
      weave: selectedWeave,
      range: selectedOpenRange,
      invite: selectedInviteOption,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButton2<String>(
          value: selectedWeave,
          isExpanded: true,
          hint: const Text("위브 종류를 선택하세요",
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Pretendard',
            color: Colors.grey,
            letterSpacing: 1
          )
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
        if (selectedWeave == '내 Weave') ...[
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => setState(() => isOpenRangeExpanded = !isOpenRangeExpanded),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const Icon(Icons.public, size: 18),
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
          if (isOpenRangeExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 36, bottom: 8),
              child: Column(
                children: openRanges.map((option) {
                  return GestureDetector(
                    onTap: () => setState(() {
                      selectedOpenRange = option;
                      isOpenRangeExpanded = false;
                      _notifyParent();
                    }),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(option),
                    ),
                  );
                }).toList(),
              ),
            ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => setState(() => isInviteExpanded = !isInviteExpanded),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const Icon(Icons.group, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    selectedInviteOption ?? "초대 인원 설정",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ]),
                Icon(isInviteExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
              ],
            ),
          ),
          if (isInviteExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 36, bottom: 8),
              child: Column(
                children: inviteOptions.map((option) {
                  return GestureDetector(
                    onTap: () => setState(() {
                      selectedInviteOption = option;
                      isInviteExpanded = false;
                      _notifyParent();
                    }),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(option),
                    ),
                  );
                }).toList(),
              ),
            ),
        ]
      ],
    );
  }
}
