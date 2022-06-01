class UserModel {
  String? uid;
  String? fullname;
  String? email;
  String? profilepic;

  UserModel(
      {required this.uid,
      required this.fullname,
      required this.email,
      required this.profilepic});

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    fullname = map["fullname"];
    email = map["email"];
    profilepic = map["profilepic"];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "fullname": fullname,
      "email": email,
      "profilepic": profilepic,
    };
  }
}

class MyUserModel {
  String? uid;
  String? username;
  String? phone;
  String? status;
  String? bio;
  String? facebook;
  String? linkedIn;
  String? dribble;
  String? twitter;
  String? deviceToken;

  MyUserModel(
      {required this.uid,
      required this.username,
      required this.phone,
      required this.status,
      required this.bio,
      required this.facebook,
      required this.linkedIn,
      required this.dribble,
      required this.twitter,
      required this.deviceToken});

  MyUserModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    username = map["username"];
    phone = map["phone"];
    status = map['status'];
    bio = map['bio'];
    facebook = map['facebook'];
    linkedIn = map['linkedIn'];
    twitter = map['twitter'];
    dribble = map['dribble'];
    deviceToken = map['deviceToken'];
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "username": username,
      "phone": phone,
      'status': status,
      'bio': bio,
      'facebook': facebook,
      'linkedIn': linkedIn,
      'twitter': twitter,
      'dribble': dribble,
      'deviceToken' : deviceToken,
    };
  }
}
