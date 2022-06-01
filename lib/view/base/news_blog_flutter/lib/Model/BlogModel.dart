import 'PostModel.dart';

class BlogModel {
  int? numPages;
  List<PostModel>? posts;

  BlogModel({this.numPages, this.posts});

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      numPages: json['num_pages'],
      posts: json['posts'] != null ? (json['posts'] as List).map((i) => PostModel.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['num_pages'] = this.numPages;
    if (this.posts != null) {
      data['posts'] = this.posts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
