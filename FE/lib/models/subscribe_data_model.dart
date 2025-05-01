  class SubscribeData {
  final String message;
  final List<SubscribeDataList> data;

  SubscribeData({
    required this.message,
    required this.data,
  });

  factory SubscribeData.fromJson(Map<String, dynamic> json) {
    return SubscribeData(
        message: json['message'],
        data: List<SubscribeDataList>.from(
            json['data'].map((x) => SubscribeDataList.fromJson(x))));
  }
}

class SubscribeDataList {
  final int id;
  final String nickname;
  final String mediaUrl;

  SubscribeDataList({
    required this.id,
    required this.nickname,
    required this.mediaUrl,
  });

  factory SubscribeDataList.fromJson(Map<String, dynamic> json) {
    return SubscribeDataList(
      id: json['id'],
      nickname: json['nickname'],
      mediaUrl: json['media_url'] ?? "",
    );
  }
}
