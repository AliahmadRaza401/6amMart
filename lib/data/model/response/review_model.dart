class ReviewModel {
  int id;
  String comment;
  int rating;
  String itemName;
  String itemImage;
  String customerName;
  String createdAt;
  String updatedAt;

  ReviewModel(
      {this.id,
        this.comment,
        this.rating,
        this.itemName,
        this.itemImage,
        this.customerName,
        this.createdAt,
        this.updatedAt});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    rating = json['rating'];
    itemName = json['item_name'];
    itemImage = json['item_image'];
    customerName = json['customer_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comment'] = this.comment;
    data['rating'] = this.rating;
    data['item_name'] = this.itemName;
    data['item_image'] = this.itemImage;
    data['customer_name'] = this.customerName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
