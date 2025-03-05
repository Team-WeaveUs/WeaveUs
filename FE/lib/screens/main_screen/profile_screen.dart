import 'package:flutter/material.dart';
import 'package:weave_us/screens/elements/toggle_button.dart';
import 'package:weave_us/screens/main_screen/profile_screen/follower_tab.dart';
import 'package:weave_us/screens/main_screen/profile_screen/profile.dart';
import 'package:weave_us/screens/main_screen/profile_screen/profile_service.dart';
import 'package:weave_us/screens/main_screen/profile_screen/profile_tab.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int selectedIndex = 1;
  late Future<Profile?> _profileFuture;

  @override
  void initState() {
    super.initState();
    // Fetch the profile data from the API
    _profileFuture = ProfileService.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FutureBuilder<Profile?>(
                future: _profileFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircleAvatar(
                      radius: 55.5,
                      backgroundColor: Colors.grey,
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError || !snapshot.hasData) {
                    return const CircleAvatar(
                      radius: 55.5,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.error, color: Colors.white),
                    );
                  }

                  final profile = snapshot.data!;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 55.5,
                        backgroundImage: profile.img != null
                            ? NetworkImage(profile.img!)
                            : null,
                        child: profile.img == null
                            ? const Icon(size: 60, Icons.person, color: Colors.white)
                            : null,
                        backgroundColor: Colors.grey,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.nickname ?? "이름",
                            style: const TextStyle(fontSize: 30),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.favorite, color: Colors.red),
                              const SizedBox(width: 10),
                              Text(
                                "${profile.likes}",
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.person_outlined),
                              const SizedBox(width: 10),
                              Text(
                                "${profile.subscribes}",
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              ToggleButton(
                selectedIndex: selectedIndex,
                onToggle: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<Profile?>(
              future: _profileFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  return const Center(child: Text('Error loading profile'));
                }

                final profile = snapshot.data!;
                return selectedIndex == 0
                    ? FollowerTab()
                    : ProfileTab(postList: profile.postList); // Pass postList to ProfileTab
              },
            ),
          ),
        ],
      ),
    );
  }
}
