import 'package:flutter/material.dart';
import 'profile_tab/post_grid.dart';
import 'profile_tab/local_weave_list.dart';
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
              Tab(text: "공유 위브"),
              Tab(text: "비밀 위브"),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                PostGrid(),
                WeaveList(),
                LocalWeaveList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}