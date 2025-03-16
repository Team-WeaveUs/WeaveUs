import 'package:get/get.dart';
import 'package:weave_us/screens/main_screen.dart';
import 'package:weave_us/screens/main_screen/home_screen.dart';
import 'package:weave_us/screens/main_screen/profile_screen.dart';
import 'package:weave_us/screens/main_screen/reward_screen.dart';
import 'package:weave_us/screens/main_screen/weave_upload_screen.dart';
import 'package:weave_us/screens/search_screen.dart';
import 'package:weave_us/screens/signin_screen.dart';
import 'package:weave_us/screens/signpassword_screen.dart';
import 'package:weave_us/screens/signup_screen.dart';

class Routes {
  static List<GetPage> pages = [
    GetPage(
      name: '/main',
      page: () => MainScreen(),
    ),
    GetPage(
      name: '/home',
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: '/search',
      page: () => const SearchScreen(),
    ),
    GetPage(
      name: '/reward',
      page: () => const RewardScreen(),
    ),
    GetPage(
      name: '/weaveupload',
      page: () => const WeaveUploadScreen(),
    ),
    GetPage(
      name: '/signin',
      page: () => const SigninScreen(),
    ),
    GetPage(
      name: '/signup',
      page: () => const SignupScreen(),
    ),
    GetPage(
      name: '/password',
      page: () => const SignpasswordScreen(),
    ),
    // 추가할 예정
  ];
}