import 'PostModel.dart';

class DashboardModel {
  String? appLang;
  List<BannerData>? banner;
  int? recentNumPages;
  int? featureNumPages;
  List<PostModel>? recentPost;
  List<PostModel>? featurePost;
  SocialLink? socialLink;

  DashboardModel({
    this.appLang,
    this.banner,
    this.recentNumPages,
    this.recentPost,
    this.socialLink,
    this.featureNumPages,
    this.featurePost,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      appLang: json['app_lang'],
      banner: json['banner'] != null ? (json['banner'] as List).map((i) => BannerData.fromJson(i)).toList() : null,
      recentNumPages: json['recent_num_pages'],
      featureNumPages: json['feature_num_pages'],
      recentPost: json['recent_post'] != null ? (json['recent_post'] as List).map((i) => PostModel.fromJson(i)).toList() : null,
      featurePost: json['feature_post'] != null ? (json['feature_post'] as List).map((i) => PostModel.fromJson(i)).toList() : null,
      socialLink: json['social_link'] != null ? SocialLink.fromJson(json['social_link']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_lang'] = this.appLang;
    data['recent_num_pages'] = this.recentNumPages;
    if (this.banner != null) {
      data['banner'] = this.banner!.map((v) => v.toJson()).toList();
    }
    if (this.recentPost != null) {
      data['recent_post'] = this.recentPost!.map((v) => v.toJson()).toList();
    }
    if (this.socialLink != null) {
      data['social_link'] = this.socialLink!.toJson();
    }
    return data;
  }
}

class SocialLink {
  String? contact;
  String? copyrightText;
  String? facebook;
  String? instagram;
  String? privacyPolicy;
  String? termCondition;
  String? twitter;
  String? whatsapp;

  SocialLink({this.contact, this.copyrightText, this.facebook, this.instagram, this.privacyPolicy, this.termCondition, this.twitter, this.whatsapp});

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      contact: json['contact'],
      copyrightText: json['copyright_text'],
      facebook: json['facebook'],
      instagram: json['instagram'],
      privacyPolicy: json['privacy_policy'],
      termCondition: json['term_condition'],
      twitter: json['twitter'],
      whatsapp: json['whatsapp'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contact'] = this.contact;
    data['copyright_text'] = this.copyrightText;
    data['facebook'] = this.facebook;
    data['instagram'] = this.instagram;
    data['privacy_policy'] = this.privacyPolicy;
    data['term_condition'] = this.termCondition;
    data['twitter'] = this.twitter;
    data['whatsapp'] = this.whatsapp;
    return data;
  }
}

class BannerData {
  String? image;
  String? thumb;
  String? url;
  String? desc;

  BannerData({
    this.image,
    this.thumb,
    this.url,
    this.desc,
  });

  factory BannerData.fromJson(Map<String, dynamic> json) {
    return BannerData(
      image: json['image'],
      thumb: json['thumb'],
      url: json['url'],
      desc: json['desc'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['thumb'] = this.thumb;
    data['url'] = this.url;
    data['desc'] = this.desc;
    return data;
  }
}
