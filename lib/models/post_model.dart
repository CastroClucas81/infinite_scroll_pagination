class PostModel {
  final int id;
  final String title;
  final String body;

  PostModel({
    required this.id,
    required this.title,
    required this.body,
  });

  factory PostModel.fromJson(dynamic json) {
    var postModel = PostModel(
      id: int.parse(json['id'].toString()),
      title: json['title'],
      body: json['body'],
    );

    return postModel;
  }
}
