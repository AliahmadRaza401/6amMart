class ParcelCategoryModel {
  int id;
  String image;
  String name;
  String description;
  String createdAt;
  String updatedAt;

  ParcelCategoryModel(
      {this.id,
        this.image,
        this.name,
        this.description,
        this.createdAt,
        this.updatedAt});

  ParcelCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
