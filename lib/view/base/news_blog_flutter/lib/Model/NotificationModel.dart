class NotificationModel {
  List<Data>? data;
  String? message;

  NotificationModel({this.data, this.message});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      data: json['data'] != null ? (json['data'] as List).map((i) => Data.fromJson(i)).toList() : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['`data`'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? datetime;
  String? id;
  String? image;
  String? post_id;
  String? title;

  Data({this.datetime, this.id, this.image, this.post_id, this.title});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      datetime: json['datetime'],
      id: json['id'],
      image: json['image'],
      post_id: json['post_id'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['datetime'] = this.datetime;
    data['id'] = this.id;
    data['image'] = this.image;
    data['post_id'] = this.post_id;
    data['title'] = this.title;
    return data;
  }
}
