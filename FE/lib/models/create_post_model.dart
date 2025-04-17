class CreatePostRequest {
  final String userId;
  final int privacyId;
  final String weaveId;
  final String content;
  final List<CreatePostFile> files;

  CreatePostRequest({
    required this.userId,
    this.privacyId = 3,
    required this.weaveId,
    required this.content,
    required this.files,
  });

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "privacy_id": privacyId,
    "weave_id": weaveId,
    "content": content,
    "files": files.map((file) => file.toJson()).toList(),
  };
}

class CreatePostFile {
  final String type;
  final String name;

  CreatePostFile({this.type = "image/jpeg", required this.name});

  Map<String, dynamic> toJson() => {
    "Type": type,
    "name": name,
  };
}