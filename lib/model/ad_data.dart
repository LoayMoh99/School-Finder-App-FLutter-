class Ad {
  String adContent;
  String adImageUrl;
  int id;
  int userId;

  Ad({this.adContent, this.adImageUrl, this.id, this.userId});

  Ad.fromJson(Map<String, dynamic> json) {
    adContent = json['ad_content'];
    adImageUrl = json['ad_image_url'];
    id = json['id'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ad_content'] = this.adContent;
    data['ad_image_url'] = this.adImageUrl;
    data['id'] = this.id;
    data['user_id'] = this.userId;
    return data;
  }
}
