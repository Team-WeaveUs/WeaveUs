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



class JoinWeave {
  final int weaveId;
  final String title;
  final String description;
  final String? location;
  final int areaId;
  final int rewardId;
  final int rewardConditionId;
  late double lat;
  late double lng;

  JoinWeave(
      {required this.weaveId,
      required this.title,
      required this.description,
      required this.location,
      required this.areaId,
      required this.rewardId,
      required this.rewardConditionId,
      this.lat = 0.0,
      this.lng = 0.0});

  factory JoinWeave.fromJson(Map<String, dynamic> json) {
    JoinWeave data = JoinWeave(
      weaveId: json['weave_id'],
      title: json['title'],
      description: json['description'],
      location: json['location'],
      areaId: json['area_id'],
      rewardId: json['reward_id'],
      rewardConditionId: json['reward_condition_id'],
    );
    data.lat = data.location!.contains(' ') ? double.parse(data.location!.split(' ')[0]) : 0.0;
    data.lng = data.location!.contains(' ') ? double.parse(data.location!.split(' ')[1]) : 0.0;
    return data;
  }
}
