import 'package:get/get.dart';
import 'package:weave_us/bindings/auth_binding.dart';
import 'package:weave_us/views/splash_view.dart';
import '../bindings/home_binding.dart';
import '../bindings/new_post_binding.dart';
import '../bindings/profile_binding.dart';
import '../bindings/reward_binding.dart';
import '../bindings/search_binding.dart';

import '../middlewares/auth_middleware.dart';

import '../views/home_view.dart';
import '../views/login_view.dart';
import '../views/new_post_view.dart';
import '../views/profile_view.dart';
import '../views/reward_view.dart';
import '../views/search_view.dart';

class AppRoutes {
  static const SPLASH = '/';
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const SEARCH = '/search';
  static const NEW_WEAVE = '/new_weave';
  static const NEW_POST = '/new_post';
  static const REWARDS = '/rewards';
  static const PROFILE = '/profile';

  static final routes = [
    GetPage(name: SPLASH, page: () => SplashScreen(), binding: AuthBinding()),
    GetPage(name: LOGIN, page: () => LoginView(), binding: AuthBinding()),
    GetPage(
      name: HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.noTransition,
    ),
    GetPage(
      name: SEARCH,
      page: () => SearchView(),
      binding: SearchBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.noTransition,
    ),
    GetPage(
      name: NEW_POST,
      page: () => NewPostView(),
      binding: NewPostBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.noTransition,
    ),
    GetPage(
      name: REWARDS,
      page: () => RewardView(),
      binding: RewardBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.noTransition,
    ),
    GetPage(
      name: PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.noTransition,
    )
  ];
}
