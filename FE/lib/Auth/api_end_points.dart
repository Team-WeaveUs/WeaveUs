class ApiEndpoints {

  static Map<String, dynamic> profileInfoBody(int userId, int targetUserId, int postCount) {
    return {
      "user_id": userId, "target_user_id": targetUserId, "post_count": postCount
    };
  }

  static Map<String, dynamic> updateUserProfileBody(String name, String email) {
    return {
      "body": {"name": name, "email": email}
    };
  }

  static Map<String, dynamic> createPostBody(String title, String content) {
    return {
      "body": {"title": title, "content": content}
    };
  }
}
