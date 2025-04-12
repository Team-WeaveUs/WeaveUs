import 'package:flutter/material.dart';

class WeaveTypeSelector extends StatefulWidget {
  final String selectedWeave;
  final String selectedOpenRange;
  final String selectedInviteOption;
  final Function(String weave, String range, String invite) onChanged;

  const WeaveTypeSelector({
    super.key,
    required this.selectedWeave,
    required this.selectedOpenRange,
    required this.selectedInviteOption,
    required this.onChanged,
  });

  @override
  State<WeaveTypeSelector> createState() => _WeaveTypeSelectorState();
}

class _WeaveTypeSelectorState extends State<WeaveTypeSelector> {
  final weaveTypes = ['Weave', '내 Weave', 'Global', 'Private'];
  final openRanges = ['모두 공개', '초대한 사용자', '나만 보기'];
  final inviteOptions = ['1명 업로드 가능', '3명 업로드 가능', '5명 업로드 가능'];

  late String selectedWeave;
  late String selectedOpenRange;
  late String selectedInviteOption;

  bool isOpenRangeExpanded = false;
  bool isInviteExpanded = false;

  @override
  void initState() {
    super.initState();
    selectedWeave = widget.selectedWeave;
    selectedOpenRange = widget.selectedOpenRange;
    selectedInviteOption = widget.selectedInviteOption;
  }

  void _updateParent() {
    widget.onChanged(selectedWeave, selectedOpenRange, selectedInviteOption);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('위브 종류', style: TextStyle(fontSize: 15, color: Colors.black)),
        DropdownButton<String>(
          value: selectedWeave,
          isExpanded: true,
          items: weaveTypes.map((type) {
            return DropdownMenuItem(value: type, child: Text(type));
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedWeave = value!;
              _updateParent();
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
                    selectedOpenRange,
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
                    onTap: () {
                      setState(() {
                        selectedOpenRange = option;
                        isOpenRangeExpanded = false;
                        _updateParent();
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
                    selectedInviteOption,
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
                    onTap: () {
                      setState(() {
                        selectedInviteOption = option;
                        isInviteExpanded = false;
                        _updateParent();
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
