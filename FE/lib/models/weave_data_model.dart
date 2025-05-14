class WeaveData {
  final String message;
  final List<WeaveDataList> data;

  WeaveData({required this.message, required this.data});

  factory WeaveData.fromJson(Map<String, dynamic> json) {
    return WeaveData(
        message: json['message'],
        data: List<WeaveDataList>.from(
            json['weaves'].map((x) => WeaveDataList.fromJson(x))));
  }
}

class MyWeaveData {
  final String message;
  final List<WeaveDataList> data;

  MyWeaveData({required this.message, required this.data});

  factory MyWeaveData.fromJson(Map<String, dynamic> json) {
    return MyWeaveData(
        message: json['message'],
        data: List<WeaveDataList>.from(
            json['result'].map((x) => WeaveDataList.fromJson(x))));
  }
}

class WeaveDataList {
  final int weaveId;
  final String title;
  final String description;
  final int typeId;
  final int privacyId;
  final String createdAt;

  WeaveDataList(
      {required this.weaveId,
      required this.title,
      required this.description,
      required this.typeId,
      required this.privacyId,
      required this.createdAt});

  factory WeaveDataList.fromJson(Map<String, dynamic> json) {
    return WeaveDataList(
      weaveId: json['weave_id'] ?? json['id'],
      title: json['title'],
      description: json['description'],
      typeId: json['type_id'],
      privacyId: json['privacy_id'],
      createdAt: json['created_at'],
    );
  }
}

class JoinWeaveData {
  final String message;
  final List<JoinWeaveList> data;

  JoinWeaveData({required this.message, required this.data});

  factory JoinWeaveData.fromJson(Map<String, dynamic> json) {
    return JoinWeaveData(
        message: json['message'],
        data: List<JoinWeaveList>.from(
            json['weaves'].map((x) => JoinWeaveList.fromJson(x))));
  }
}

class JoinWeaveList {
  final int weaveId;
  final String title;
  final String description;
  final int typeId;
  final int privacyId;
  final String createdAt;
  final double lat;
  final double lng;

  JoinWeaveList(
      {required this.weaveId,
      required this.title,
      required this.description,
      required this.typeId,
      required this.privacyId,
      required this.createdAt,
      required this.lat,
      required this.lng});

  factory JoinWeaveList.fromJson(Map<String, dynamic> json) {
    return JoinWeaveList(
      weaveId: json['weave_id'],
      title: json['title'],
      description: json['description'],
      typeId: json['type_id'],
      privacyId: json['privacy_id'],
      createdAt: json['created_at'],
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}
