import 'package:news_flutter/Model/PostModel.dart';

class SearchModel {
  int? num_pages;
  List<PostModel>? posts;

  SearchModel({this.num_pages, this.posts});

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
      num_pages: json['num_pages'],
      posts: json['posts'] != null ? (json['posts'] as List).map((e) => PostModel.fromJson(e)).toList() : [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['num_pages'] = this.num_pages;
    data['posts'] = this.posts!.map((e) => e).toList();

    return data;
  }
}
