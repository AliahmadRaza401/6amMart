import 'package:news_flutter/Model/PostModel.dart';

class BookmarkNewsResponse {
  // ignore: non_constant_identifier_names
  int? num_pages;
  List<PostModel>? posts;

  // ignore: non_constant_identifier_names
  BookmarkNewsResponse({this.num_pages, this.posts});

  factory BookmarkNewsResponse.fromJson(Map<String, dynamic> json) {
    return BookmarkNewsResponse(
      num_pages: json['num_pages'],
      posts: json['posts'] != null ? (json['posts'] as List).map((i) => PostModel.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['num_pages'] = this.num_pages;
    if (this.posts != null) {
      data['posts'] = this.posts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
