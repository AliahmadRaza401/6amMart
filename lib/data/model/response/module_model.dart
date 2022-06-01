class ModuleModel {
  int id;
  String moduleName;
  String moduleType;
  String thumbnail;
  String icon;
  int themeId;
  String description;
  int storesCount;
  String createdAt;
  String updatedAt;

  ModuleModel(
      {this.id,
        this.moduleName,
        this.moduleType,
        this.thumbnail,
        this.storesCount,
        this.icon,
        this.themeId,
        this.description,
        this.createdAt,
        this.updatedAt,
      });

  ModuleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    moduleName = json['module_name'];
    moduleType = json['module_type'];
    thumbnail = json['thumbnail'];
    icon = json['icon'];
    themeId = json['theme_id'];
    description = json['description'];
    storesCount = json['stores_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['module_name'] = this.moduleName;
    data['module_type'] = this.moduleType;
    data['thumbnail'] = this.thumbnail;
    data['icon'] = this.icon;
    data['theme_id'] = this.themeId;
    data['description'] = this.description;
    data['stores_count'] = this.storesCount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}