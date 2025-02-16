import 'package:flutter/material.dart';
import 'follower_tab/follower_list.dart';
import 'follower_tab/following_list.dart';

class FollowerTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: "구독 목록"),
              Tab(text: "내 구독자"),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                FollowingList(),
                FollowerList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}