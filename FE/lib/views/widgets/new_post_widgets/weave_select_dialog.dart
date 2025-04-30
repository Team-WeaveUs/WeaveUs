import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
              const Text("위브를 검색하세요", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              // 검색 입력창
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.searchController,
                      decoration: InputDecoration(
                        hintText: "검색어를 입력하세요",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Obx(() => controller.isLoading.value
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator())
                      : IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: controller.fetchSearchResults,
                  )),
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
                    child: Text("검색 결과가 없습니다."),
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

              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text("닫기"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}