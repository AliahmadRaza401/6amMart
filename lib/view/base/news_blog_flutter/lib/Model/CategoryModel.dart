class CategoryModel {
  int? cat_ID;
  String? cat_name;
  int? category_count;
  String? category_description;
  String? category_nicename;
  int? category_parent;
  int? count;
  String? description;
  String? filter;
  String? image;
  String? name;
  int? parent;
  String? slug;
  String? taxonomy;
  int? term_group;
  int? term_id;
  int? term_taxonomy_id;

  CategoryModel(
      {this.cat_ID,
      this.cat_name,
      this.category_count,
      this.category_description,
      this.category_nicename,
      this.category_parent,
      this.count,
      this.description,
      this.filter,
      this.image,
      this.name,
      this.parent,
      this.slug,
      this.taxonomy,
      this.term_group,
      this.term_id,
      this.term_taxonomy_id});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      cat_ID: json['cat_ID'],
      cat_name: json['cat_name'],
      category_count: json['category_count'],
      category_description: json['category_description'],
      category_nicename: json['category_nicename'],
      category_parent: json['category_parent'],
      count: json['count'],
      description: json['description'],
      filter: json['filter'],
      image: json['image'],
      name: json['name'],
      parent: json['parent'],
      slug: json['slug'],
      taxonomy: json['taxonomy'],
      term_group: json['term_group'],
      term_id: json['term_id'],
      term_taxonomy_id: json['term_taxonomy_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cat_ID'] = this.cat_ID;
    data['cat_name'] = this.cat_name;
    data['category_count'] = this.category_count;
    data['category_description'] = this.category_description;
    data['category_nicename'] = this.category_nicename;
    data['category_parent'] = this.category_parent;
    data['count'] = this.count;
    data['description'] = this.description;
    data['filter'] = this.filter;
    data['image'] = this.image;
    data['name'] = this.name;
    data['parent'] = this.parent;
    data['slug'] = this.slug;
    data['taxonomy'] = this.taxonomy;
    data['term_group'] = this.term_group;
    data['term_id'] = this.term_id;
    data['term_taxonomy_id'] = this.term_taxonomy_id;
    return data;
  }
}
