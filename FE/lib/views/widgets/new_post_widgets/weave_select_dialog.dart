import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../controllers/weave_dialog_controller.dart';

class WeaveDialog extends StatelessWidget {
  final Function(String) onWeaveSelected;

  const WeaveDialog({super.key, required this.onWeaveSelected});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WeaveDialogController>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("위브를 검색하세요", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              const SizedBox(height: 25),

              // 검색 입력창
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.searchController,
                      onSubmitted: (_) => controller.fetchSearchResults(),
                      decoration: InputDecoration(
                        hintText: "검색어를 입력하세요",
                        hintStyle: const TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Color(0xFFD9D9D9),
                        contentPadding: const EdgeInsets.only(left: 20, right: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: Obx(() => controller.isLoading.value
                            ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                            : IconButton(
                          icon: const Icon(HugeIcons.strokeRoundedSearch02, size: 20),
                          onPressed: controller.fetchSearchResults,
                        )),
                      ),
                    )
                  ),
                    ],
              ),
              const SizedBox(height: 10),

              // 검색 결과
              Obx(() {
                if (!controller.hasSearched.value) {
                  return const SizedBox(); // 아무것도 안 보여줌
                }

                if (controller.searchResults.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text("근처의 join 위브 입니다.",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontFamily: 'Pretendard',
                      ),),
                  );
                }

                return Column(
                  children: List.generate(controller.searchResults.length, (index) {
                    final item = controller.searchResults[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: Text(item['title']),
                        trailing: IconButton(
                          icon: const Icon(Icons.add, color: Colors.green),
                          onPressed: () {
                            onWeaveSelected("${item['title']},${item['weave_id']}");
                            Get.back();
                          },
                        ),
                      ),
                    );
                  }),
                );
              }),

              // const SizedBox(height: 10),
              // ElevatedButton(
              //   onPressed: () => Get.back(),
              //   child: const Text("닫기"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}