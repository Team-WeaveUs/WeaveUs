import 'package:flutter/material.dart';
import 'package:weave_us/screens/main_screen/profile_screen/profile.dart';
import 'profile_tab/post_grid.dart';
import 'profile_tab/local_weave_list.dart';
import 'profile_tab/weave_list.dart';

class ProfileTab extends StatelessWidget {
  final List<MiniPost> postList;

  const ProfileTab({super.key, required this.postList});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: "게시물"),
              Tab(text: "공유 위브"),
              Tab(text: "비밀 위브"),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                PostGrid(postList: postList),
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