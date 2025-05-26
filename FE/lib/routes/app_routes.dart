import 'package:get/get.dart';
import 'package:weave_us/bindings/auth_binding.dart';
import 'package:weave_us/bindings/owner_profile_binding.dart';
import 'package:weave_us/bindings/post_detail_binding.dart';
import 'package:weave_us/bindings/weave_binding.dart';
import 'package:weave_us/views/owner_login_view.dart';
import 'package:weave_us/views/owner_nav/owner_home.dart';
import 'package:weave_us/views/owner_nav/owner_profile.dart';
import 'package:weave_us/views/splash_view.dart';
import 'package:weave_us/views/weave_profile.dart';
import '../bindings/home_binding.dart';
import '../bindings/new_post_binding.dart';
import '../bindings/new_weave_binding.dart';
import '../bindings/owner_home_binding.dart';
import '../bindings/owner_new_weave_binding.dart';
import '../bindings/owner_reward_binding.dart';
import '../bindings/profile_binding.dart';
import '../bindings/reward_binding.dart';
import '../bindings/search_binding.dart';

import '../middlewares/auth_middleware.dart';
import '../middlewares/owner_middleware.dart';

import '../views/auth_main_view.dart';
import '../views/common_registration_view.dart';
import '../views/home_view.dart';
import '../views/common_login_view.dart';
import '../views/new_post_view.dart';
import '../views/new_weave_view.dart';
import '../views/owner_nav/owner_new_weave_view.dart';
import '../views/owner_registration_view.dart';
import '../views/owner_nav/owner_reward_view.dart';
import '../views/post_detail_view.dart';
import '../views/profile_view.dart';
import '../views/reward_view.dart';
import '../views/search_view.dart';


class AppRoutes {
  static const SPLASH = '/';
  static const LOGIN = '/auth/login';
  static const HOME = '/home';
  static const SEARCH = '/search';
  static const NEW_WEAVE = '/new_weave';
  static const NEW_JOIN_WEAVE = '/new_join_weave';
  static const NEW_POST = '/new_post';
  static const REWARDS = '/rewards';
  static const PROFILE = '/profile/:user_id';
  static const POST_DETAIL = '/post/:post_id';
  static const AUTH = '/auth';
  static const OWNERS = '/auth/owners';
  static const NEW_USER = '/auth/login/registration';
  static const NEW_OWNER = '/auth/owners/registration';
  static const OWNER_NEW_WEAVE = '/owner/new_weave';
  static const OWNER_REWARDS = '/owner/rewards';
  static const OWNER_HOME = '/owner/home';
  static const OWNER_PROFILE = '/owner/profile/:user_id';
  static const WEAVE = '/weave/:weave_id';

  static final routes = [
    GetPage(name: SPLASH, page: () => SplashScreen(), binding: AuthBinding()),
    GetPage(
        name: LOGIN,
        page: () => LoginView(),
        binding: AuthBinding(),
        transition: Transition.noTransition),
    GetPage(
      name: HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      middlewares: [AuthMiddleware(), OwnerMiddleware()],
      transition: Transition.noTransition,
    ),
    GetPage(
      name: OWNER_HOME,
      page: () => OwnerHomeView(),
      binding: OwnerHomeBinding(),
      middlewares: [AuthMiddleware(), OwnerMiddleware()],
      transition: Transition.noTransition,
    ),
    GetPage(
      name: SEARCH,
      page: () => SearchView(),
      binding: SearchBinding(),
      middlewares: [AuthMiddleware(), OwnerMiddleware()],
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
      name: AppRoutes.POST_DETAIL,
      page: () => PostDetailView(),
      binding: PostDetailBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.noTransition,
    ),
    GetPage(
      name: OWNER_NEW_WEAVE,
      page: () => OwnerNewWeaveView(),
      binding: OwnerNewWeaveBinding(),
      middlewares: [AuthMiddleware(), OwnerMiddleware()],
      transition: Transition.noTransition,
    ),
    GetPage(
      name: NEW_WEAVE,
      page: () => NewWeaveView(),
      binding: NewWeaveBinding(),
      middlewares: [AuthMiddleware(), OwnerMiddleware()],
      transition: Transition.noTransition,
    ),
    GetPage(
      name: REWARDS,
      page: () => RewardView(),
      binding: RewardBinding(),
      middlewares: [AuthMiddleware(), OwnerMiddleware()],
      transition: Transition.noTransition,
    ),
    GetPage(
      name: OWNER_REWARDS,
      page: () => OwnerRewardView(),
      binding: OwnerRewardBinding(),
      middlewares: [AuthMiddleware(), OwnerMiddleware()],
      transition: Transition.noTransition,
    ),
    GetPage(
      name: PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware(), OwnerMiddleware()],
      transition: Transition.noTransition,
    ),
    GetPage(
      name: OWNER_PROFILE,
      page: () => OwnerProfileView(),
      binding: OwnerProfileBinding(),
      middlewares: [AuthMiddleware(), OwnerMiddleware()],
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AUTH,
      page: () => AuthMainView(),
      binding: AuthBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: OWNERS,
      page: () => OwnerLoginView(),
      binding: AuthBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
        name: NEW_USER, page: () => RegistrationView(), binding: AuthBinding(), transition: Transition.noTransition),
    GetPage(
        name: NEW_OWNER,
        page: () => OwnerRegistrationView(),
        binding: AuthBinding(),
        transition: Transition.noTransition
    ),
    GetPage(
      name: WEAVE,
      page: () => WeaveProfileView(),
      binding: WeaveBinding(),
      middlewares: [AuthMiddleware(), OwnerMiddleware()],
      transition: Transition.noTransition,
    ),
  ];
}