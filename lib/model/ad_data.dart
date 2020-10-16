class Ad {
  String adContent;
  String adImageUrl;
  int id;
  int userId;
  String createdAt;
  String updatedAt;

  Ad(
      {this.adContent,
      this.createdAt,
      this.updatedAt,
      this.adImageUrl,
      this.id,
      this.userId});

  Ad.fromJson(Map<String, dynamic> json) {
    adContent = json['ad_content'];
    adImageUrl = json['ad_image_url'];
    id = json['id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ad_content'] = this.adContent;
    data['ad_image_url'] = this.adImageUrl;
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
