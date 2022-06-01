class SocialLogInBody {
  String email;
  String token;
  String uniqueId;
  String medium;
  String phone;

  SocialLogInBody(
      {this.email, this.token, this.uniqueId, this.medium, this.phone});

  SocialLogInBody.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    token = json['token'];
    uniqueId = json['unique_id'];
    medium = json['medium'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['token'] = this.token;
    data['unique_id'] = this.uniqueId;
    data['medium'] = this.medium;
    data['phone'] = this.phone;
    return data;
  }
}
