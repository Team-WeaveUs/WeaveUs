import 'package:flutter/material.dart';
import 'profile_tab/post_grid.dart';
import 'profile_tab/reward_list.dart';
import 'profile_tab/weave_list.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(text: "게시물"),
              Tab(text: "Weave"),
              Tab(text: "리워드"),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                PostGrid(),
                WeaveList(),
                RewardList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}