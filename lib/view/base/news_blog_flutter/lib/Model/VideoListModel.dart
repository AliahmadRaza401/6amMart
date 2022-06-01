class VideoListModel {
  String? createdAt;
  int? id;
  String? imageUrl;
  String? title;
  String? videoType;
  String? videoUrl;

  VideoListModel({this.createdAt, this.id, this.imageUrl, this.title, this.videoType, this.videoUrl});

  factory VideoListModel.fromJson(Map<String, dynamic> json) {
    return VideoListModel(
      createdAt: json['created_at'],
      id: json['id'],
      imageUrl: json['image_url'],
      title: json['title'],
      videoType: json['video_type'],
      videoUrl: json['video_url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['image_url'] = this.imageUrl;
    data['title'] = this.title;
    data['video_type'] = this.videoType;
    data['video_url'] = this.videoUrl;
    return data;
  }
}
