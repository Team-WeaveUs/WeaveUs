import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../controllers/search_controller.dart';

class SearchResultList extends StatelessWidget {
  const SearchResultList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WeaveSearchController>();

    return Obx(() {
      final results = controller.searchResults;
      final recent = controller.joinWeaveData.value;

      if (controller.isNoResults.value) {
        return const Center(
          child: Text(
            "검색 결과가 없습니다.",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
              fontFamily: 'Pretendard',
            ),
          ),
        );
      }

      return ListView(
        padding: const EdgeInsets.all(12),
        children: [
          if (results.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "검색 결과",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                    fontFamily: 'Pretendard',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...results.map((result) {
              final isSubscribed =
                  result['subscribe_status'] == 1 ? true : false;

              return controller.isWeaveResult.value
                  ? ListTile(
                      title: GestureDetector(
                        onTap: () {
                          Get.toNamed('/weave/${result['weave_id']}',
                              arguments: {
                                'weaveId': result['weave_id'],
                                'weaveTitle': result['title'],
                              });
                        },
                        child: Text(result['title'] ?? '제목 없음'),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          Get.toNamed('/new_post', arguments: {
                            'weaveId': result['weave_id'],
                            'weaveTitle': result['title'],
                          });
                        },
                      ))
                  : ListTile(
                      leading: result['media_url'] == null
                          ? const CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                              ))
                          : CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                result['mediaUrl'],
                              )),
                      title: GestureDetector(
                        onTap: () {
                          final isOwner = result['is_owner'] == 1;
                          final userId = result['user_id'];
                          final nickname = result['nickname'] ?? '닉네임';
                          final weaveTitle = result['title'] ?? '';

                          if (isOwner) {
                            Get.toNamed('/profile/$userId', arguments: {
                              'userId': userId,
                              'nickname': nickname,
                              'title': weaveTitle,
                            });
                          } else {
                            Get.toNamed('/profile/$userId', arguments: {
                              'userId': userId,
                              'nickname': nickname,
                              'title': weaveTitle,
                            });
                          }
                        },
                        child: Text(
                            result['title'] ?? result['nickname'] ?? '제목 없음'),
                      ),
                      trailing: GestureDetector(
                        onTap: () {
                          controller.toggleSubscribe(result['user_id']);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSubscribed
                                ? Colors.grey
                                : const Color(0xFFFF8000),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isSubscribed ? "구독 중" : "구독",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
            }).toList(),
            const SizedBox(height: 80),
          ] else ...[
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "근처 Join Weave",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                    fontFamily: 'Pretendard',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...recent.map((result) {
              return ListTile(
                title: Text(result.title),
                subtitle: Text('${result.distance.toStringAsFixed(1)}km 거리'),
                onTap: () {
                  Get.toNamed('/weave/${result.weaveId}', arguments: {
                    'weaveId': result.weaveId,
                    'weaveTitle': result.title,
                  });
                },
                trailing: IconButton(
                  icon: const Icon(HugeIcons.strokeRoundedGift),
                  onPressed: () {
                    Get.toNamed('/new_post', arguments: {
                      'weaveId': result.weaveId,
                      'weaveTitle': result.title,
                    });
                  },
                ),
              );
            }).toList(),
            const SizedBox(height: 80),
          ],
        ],
      );
    });
  }
}
