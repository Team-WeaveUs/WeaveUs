
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
