class AuthorAvatarUrls {
  String? url;

  AuthorAvatarUrls({this.url});

  factory AuthorAvatarUrls.fromJson(Map<String, dynamic> json) {
    return AuthorAvatarUrls(
      url: json['96'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['96'] = this.url;
    return data;
  }
}