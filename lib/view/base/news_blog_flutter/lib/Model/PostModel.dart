import 'package:news_flutter/Model/CategoryModel.dart';

class PostModel {
  List<CategoryModel>? category;
  String? commentCount;
  String? commentStatus;
  String? filter;
  String? guid;
  String? humanTimeDiff;
  int? iD;
  bool? isFav;
  int? menuOrder;
  String? noOfComments;
  String? pingStatus;
  String? pinged;
  String? postAuthor;
  String? postAuthorName;
  String? postContent;
  String? postContentFiltered;
  String? postDate;
  String? postDateGmt;
  String? postExcerpt;
  String? postMimeType;
  String? postModified;
  String? postModifiedGmt;
  String? postName;
  int? postParent;
  String? postPassword;
  String? postStatus;
  String? postTitle;
  String? postType;
  String? readableDate;
  String? readableDates;
  String? shareUrl;
  String? toPing;
  String? image;

  PostModel({
    this.category,
    this.commentCount,
    this.commentStatus,
    this.filter,
    this.guid,
    this.humanTimeDiff,
    this.iD,
    this.isFav,
    this.menuOrder,
    this.noOfComments,
    this.pingStatus,
    this.pinged,
    this.postAuthor,
    this.postAuthorName,
    this.postContent,
    this.postContentFiltered,
    this.postDate,
    this.postDateGmt,
    this.postExcerpt,
    this.postMimeType,
    this.postModified,
    this.postModifiedGmt,
    this.postName,
    this.postParent,
    this.postPassword,
    this.postStatus,
    this.postTitle,
    this.postType,
    this.readableDate,
    this.readableDates,
    this.shareUrl,
    this.toPing,
    this.image,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      category: json['category'] != null ? (json['category'] as List).map((i) => CategoryModel.fromJson(i)).toList() : null,
      commentCount: json['comment_count'],
      commentStatus: json['comment_status'],
      filter: json['filter'],
      guid: json['guid'],
      humanTimeDiff: json['human_time_diff'],
      iD: json['ID'],
      isFav: json['is_fav'],
      menuOrder: json['menu_order'],
      noOfComments: json['no_of_comments'],
      pingStatus: json['ping_status'],
      pinged: json['pinged'],
      postAuthor: json['post_author'],
      postAuthorName: json['post_author_name'],
      postContent: json['post_content'],
      postContentFiltered: json['post_content_filtered'],
      postDate: json['post_date'],
      postDateGmt: json['post_date_gmt'],
      postExcerpt: json['post_excerpt'],
      postMimeType: json['post_mime_type'],
      postModified: json['post_modified'],
      postModifiedGmt: json['post_modified_gmt'],
      postName: json['post_name'],
      postParent: json['post_parent'],
      postPassword: json['post_password'],
      postStatus: json['post_status'],
      postTitle: json['post_title'],
      postType: json['post_type'],
      readableDate: json['readable_date'],
      readableDates: json['readable_dates'],
      shareUrl: json['share_url'],
      toPing: json['to_ping'],
      image: json['image'] == null ? '' : json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.category != null) {
      data['category'] = this.category!.map((v) => v.toJson()).toList();
    }
    data['comment_count'] = this.commentCount;
    data['comment_status'] = this.commentStatus;
    data['filter'] = this.filter;
    data['guid'] = this.guid;
    data['human_time_diff'] = this.humanTimeDiff;
    data['iD'] = this.iD;
    data['is_fav'] = this.isFav;
    data['menu_order'] = this.menuOrder;
    data['no_of_comments'] = this.noOfComments;
    data['ping_status'] = this.pingStatus;
    data['pinged'] = this.pinged;
    data['post_author'] = this.postAuthor;
    data['post_author_name'] = this.postAuthorName;
    data['post_content'] = this.postContent;
    data['post_content_filtered'] = this.postContentFiltered;
    data['post_date'] = this.postDate;
    data['post_date_gmt'] = this.postDateGmt;
    data['post_excerpt'] = this.postExcerpt;
    data['post_mime_type'] = this.postMimeType;
    data['post_modified'] = this.postModified;
    data['post_modified_gmt'] = this.postModifiedGmt;
    data['post_name'] = this.postName;
    data['post_parent'] = this.postParent;
    data['post_password'] = this.postPassword;
    data['post_status'] = this.postStatus;
    data['post_title'] = this.postTitle;
    data['post_type'] = this.postType;
    data['readable_date'] = this.readableDate;
    data['readable_dates'] = this.readableDates;
    data['share_url'] = this.shareUrl;
    data['to_ping'] = this.toPing;
    data['image'] = this.image;

    return data;
  }
}
