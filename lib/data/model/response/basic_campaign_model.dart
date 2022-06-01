import 'package:sixam_mart/data/model/response/store_model.dart';

class BasicCampaignModel {
  int id;
  String title;
  String image;
  String description;
  String availableDateStarts;
  String availableDateEnds;
  String startTime;
  String endTime;
  List<Store> store;

  BasicCampaignModel(
      {this.id,
        this.title,
        this.image,
        this.description,
        this.availableDateStarts,
        this.availableDateEnds,
        this.startTime,
        this.endTime,
        this.store});

  BasicCampaignModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    description = json['description'];
    availableDateStarts = json['available_date_starts'];
    availableDateEnds = json['available_date_ends'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    if (json['stores'] != null) {
      store = [];
      json['stores'].forEach((v) {
        store.add(new Store.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image'] = this.image;
    data['description'] = this.description;
    data['available_date_starts'] = this.availableDateStarts;
    data['available_date_ends'] = this.availableDateEnds;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    if (this.store != null) {
      data['stores'] = this.store.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
