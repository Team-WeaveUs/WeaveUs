import 'package:flutter/material.dart';
import 'package:weave_us/screens/main_screen/home_screen/post.dart';

class SearchResults extends StatelessWidget {
  final List<Post> filteredPosts;
  final String content; // 추가: 동적으로 content 값을 받음

  const SearchResults({Key? key, required this.filteredPosts, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        // 🔹 방문 인증 카드 (content 값을 전달)
        VisitCard(content: content),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: filteredPosts.length,
            itemBuilder: (context, index) {
              final post = filteredPosts[index];

              return Container(
                margin: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.black))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.weaveTitle,
                                  style: const TextStyle(
                                      fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                                Text("weaveType"), // Weave 타입 정보 추가 가능
                              ]
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.black)
                              ),
                              child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.add, color: Colors.black,)
                              )
                          ),
                        ],
                      ),
                    ),

                    // 🔹 이미지 크기 조정 및 스크롤 가능하도록 설정
                    if (post.urls.isNotEmpty)
                      SizedBox(
                        height: size.height * 0.6, // 이미지 최대 높이 제한
                        child: PageView(
                          children: post.urls.map((url) => ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                            child: Image.network(
                              url,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )).toList(),
                        ),
                      ),

                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          border: Border(top: BorderSide(color: Colors.black))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 35/2,
                                backgroundImage: post.userProfile == '0'
                                    ? null
                                    : NetworkImage(post.userProfile),
                                backgroundColor: Colors.grey,
                                child: post.userProfile == '0'
                                    ? const Icon(size: 35/2, Icons.person, color: Colors.white)
                                    : null,
                              ),
                              const SizedBox(width: 10,),
                              Text(post.name, style: const TextStyle(fontSize: 20),),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextButton(
                              onPressed: () {},
                              child: Text("구독", style: TextStyle(fontSize: 18, color: Colors.black)),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      width: size.width,
                      child: Text(post.content, style: const TextStyle(fontSize: 18),),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// 🔹 방문 인증 카드 UI (content 값을 전달받도록 변경)
class VisitCard extends StatelessWidget {
  final String content;

  const VisitCard({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🔹 프로필 아이콘 (Person 아이콘 사용)
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person, color: Colors.black),
          ),
          SizedBox(width: 10), // 간격

          // 🔹 텍스트 (content 값 표시)
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Text(
              content, // 동적으로 변경되는 텍스트
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1, // 한 줄로 제한
              overflow: TextOverflow.ellipsis, // 길 경우 "..." 표시
            ),
          ),

          Spacer(), // 오른쪽 아이콘을 오른쪽으로 밀기

          // 🔹 플러스 버튼
          IconButton(
            onPressed: () {
              print("방문 플러스");
            },
            icon: const Icon(Icons.add_circle_outline),
            padding: EdgeInsets.zero, // 아이콘 패딩 조절
            constraints: BoxConstraints(), // 크기 조절
          ),
        ],
      ),
    );
  }
}
