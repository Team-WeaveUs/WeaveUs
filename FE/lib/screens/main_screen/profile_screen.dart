import 'package:flutter/material.dart';
import 'package:weave_us/screens/elements/toggle_button.dart';
import 'package:weave_us/screens/main_screen/profile_screen/follower_tab.dart';
import 'package:weave_us/screens/main_screen/profile_screen/profile_tab.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                CircleAvatar(
                  radius: 55.5,
                  backgroundImage: null,
                  //widget.postData.userProfile == '0'
                  // ? null
                  // : NetworkImage(widget.postData.userProfile),
                  child: Icon(size: 60, Icons.person, color: Colors.white),
                  //widget.postData.userProfile == '0'
                  // ? Icon(Icons.person, color: Colors.white)
                  // : null,
                  backgroundColor: Colors.grey, // 기본 배경색 설정 (선택 사항)
                ),
                SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "이름",
                      style: TextStyle(fontSize: 30),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                        SizedBox(width: 10,),
                        Text("like",
                        style: TextStyle(fontSize: 20),),
                      ],
                    ),
                    Row(children: [
                      Icon(
                        Icons.person_outlined,
                      ),
                      SizedBox(width: 10,),
                      Text("followers",
                      style: TextStyle(fontSize: 20),)
                    ]),
                  ],
                ),
              ]),
              ToggleButton(
                  selectedIndex: selectedIndex,
                  onToggle: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  })
            ],
          ),
          const SizedBox(height: 20,),
          Expanded(
            child: selectedIndex == 0 ? FollowerTab() : ProfileTab(),
          )
        ],
      ),
    );
  }
}
