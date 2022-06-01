class PredictionModel {
  String description;
  String id;
  int distanceMeters;
  String placeId;
  String reference;

  PredictionModel(
      {this.description,
        this.id,
        this.distanceMeters,
        this.placeId,
        this.reference});

  PredictionModel.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    id = json['id'];
    distanceMeters = json['distance_meters'];
    placeId = json['place_id'];
    reference = json['reference'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['id'] = this.id;
    data['distance_meters'] = this.distanceMeters;
    data['place_id'] = this.placeId;
    data['reference'] = this.reference;
    return data;
  }
}