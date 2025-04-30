class Weave {
  final String title;
  final int id;

  Weave({required this.title, required this.id});

  factory Weave.fromJson(Map<String, dynamic> json) {
    return Weave(
      title: json['title'],
      id: json['weave_id'],
    );
  }
}