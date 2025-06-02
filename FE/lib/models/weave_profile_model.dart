import './profile_post_list_model.dart';

class WeaveProfile {
  final String message;
  final int weaveId;
  final String weaveTitle;
  final String weaveDescription;
  final int isJoinWeave;
  final int privacyId;
  final int rewardId;
  final int rewardConditionId;
  final int weaveLikes;
  final int weaveContributers;
  final List<ProfilePostList> posts;
  final String createUserNickname;
  final int weaveUserId;

  WeaveProfile({
    required this.message,
    required this.weaveId,
    required this.weaveTitle,
    required this.weaveDescription,
    required this.isJoinWeave,
    required this.privacyId,
    required this.rewardId,
    required this.rewardConditionId,
    required this.weaveLikes,
    required this.weaveContributers,
    required this.posts,
    required this.createUserNickname,
    required this.weaveUserId,
  });
  factory WeaveProfile.fromJson(Map<String, dynamic> json) {
    return WeaveProfile(
      message: json['message'],
      weaveId: json['weave_id'],
      weaveTitle: json['weave_title'],
      weaveDescription: json['weave_description'],
      isJoinWeave: json['is_joinweave'],
      privacyId: json['privacy_id'],
      rewardId: json['reward_id'] ?? 0,
      rewardConditionId: json['reward_condition_id'] ?? 0,
      weaveLikes: json['weave_likes'],
      weaveContributers: json['weave_contributors'],
      posts: List<ProfilePostList>.from(
        json['posts'].map((x) => ProfilePostList.fromJson(x)),
      ),
      createUserNickname: json['create_user_nickname'] ?? "",
      weaveUserId: json['weave_user_id'],
    );
  }
}