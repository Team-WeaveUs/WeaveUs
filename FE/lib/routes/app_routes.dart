import 'package:get/get.dart';
import 'package:weave_us/bindings/auth_binding.dart';
import 'package:weave_us/bindings/post_detail_binding.dart';
import 'package:weave_us/bindings/weave_binding.dart';
import 'package:weave_us/views/new_reward_condition_view.dart';
import 'package:weave_us/views/other_profile_view.dart';
import 'package:weave_us/views/owner_login_view.dart';
import 'package:weave_us/views/splash_view.dart';
import 'package:weave_us/views/weave_profile_view.dart';

import '../bindings/home_binding.dart';
import '../bindings/new_post_binding.dart';
import '../bindings/new_reward_condition_binding.dart';
import '../bindings/new_weave_binding.dart';
import '../bindings/owner_new_weave_binding.dart';
import '../bindings/new_reward_binding.dart';
import '../bindings/profile_binding.dart';
import '../bindings/reward_binding.dart';
import '../bindings/reward_detail_binding.dart';
import '../bindings/search_binding.dart';
import '../bindings/reward_condition_detail_binding.dart';

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
import '../views/owner_nav/new_reward_view.dart';
import '../views/owner_reward_view.dart';
import '../views/post_detail_view.dart';
import '../views/profile_view.dart';
import '../views/reward_condition_detail_view.dart';
import '../views/reward_detail_view.dart';
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
  static const MY_PROFILE = '/my_profile';
  static const PROFILE = '/profile/:user_id';
  static const POST_DETAIL = '/post/:post_id';
  static const AUTH = '/auth';
  static const OWNERS = '/auth/owners';
  static const NEW_USER = '/auth/login/registration';
  static const NEW_OWNER = '/auth/owners/registration';
  static const OWNER_NEW_WEAVE = '/owner/new_weave';
  static const NEW_REWARDS = '/new_rewards';
  static const WEAVE = '/weave/:weave_id';
  static const REWARD_DETAIL = '/reward/detail';
  static const REWARD_CONDITION = '/reward/condition';
  static const OWNER_REWARDS = '/owner/rewards';
  static const OWNER_REWARD_DETAIL = '/reward/condition/detail';

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
      name: NEW_REWARDS,
      page: () => NewRewardView(),
      binding: OwnerRewardBinding(),
      middlewares: [AuthMiddleware(), OwnerMiddleware()],
      transition: Transition.noTransition,
    ),
    GetPage(
      name: MY_PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware ()],
      transition: Transition.noTransition,
    ),
    GetPage(
      name: PROFILE,
      page: () => OtherProfileView(),
      binding: ProfileBinding(),
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
        name: NEW_USER,
        page: () => RegistrationView(),
        binding: AuthBinding(),
        transition: Transition.noTransition),
    GetPage(
        name: NEW_OWNER,
        page: () => OwnerRegistrationView(),
        binding: AuthBinding(),
        transition: Transition.noTransition),
    GetPage(
      name: WEAVE,
      page: () => WeaveProfileView(),
      binding: WeaveBinding(),
      middlewares: [AuthMiddleware()],
      transition: Transition.noTransition,
    ),
    GetPage(
      name: REWARD_DETAIL,
      page: () => RewardDetailView(),
      binding: RewardDetailBinding(),
      transition: Transition.noTransition,
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: REWARD_CONDITION,
      page: () => NewRewardConditionView(),
      binding: NewRewardConditionBinding(),
      transition: Transition.noTransition,
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: OWNER_REWARDS,
      page: () => OwnerRewardView(),
      binding: RewardBinding(),
      transition: Transition.noTransition,
      middlewares: [AuthMiddleware(), OwnerMiddleware()],
    ),
    GetPage(
      name: OWNER_REWARD_DETAIL,
      page: () => RewardConditionDetailView(),
      binding: RewardConditionDetailBinding(),

      transition: Transition.noTransition,
      middlewares: [AuthMiddleware()],
    ),
  ];
}
