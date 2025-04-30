// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../controllers/post_detail_controller.dart';
// import '../../models/post_model.dart';
//
// class PostDetailView extends StatelessWidget {
//   const PostDetailView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final post = Get.arguments['post'] as Post;
//     final controller = Get.put(PostDetailController(postId: post.id));
//
//     return Scaffold(
//       appBar: AppBar(title: Text(post.nickname)),
//       body: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Image.network(post.mediaUrl),
//                   const SizedBox(height: 10),
//                   Text(post.textContent,
//                       style: const TextStyle(fontSize: 16)),
//                   const Divider(height: 30),
//                   const Text('댓글', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 10),
//                   Obx(() => Column(
//                     children: controller.comments.map((comment) => ListTile(
//                       title: Text(comment.nickname),
//                       subtitle: Text(comment.content),
//                     )).toList(),
//                   ))
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: controller.commentController,
//                     decoration: const InputDecoration(hintText: '댓글을 입력하세요'),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: controller.submitComment,
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
