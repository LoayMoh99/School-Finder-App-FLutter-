class Review {
  int id;
  int userId;
  int schoolId;
  String description;
  int rating;

  Review({this.id, this.userId, this.schoolId, this.description, this.rating});

  Review.fromJson(Map<String, dynamic> json) {
    id = json['review id'];
    userId = json['user id'];
    schoolId = json['school id'];
    description = json['description'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['review id'] = this.id;
    data['user id'] = this.userId;
    data['school id'] = this.schoolId;
    data['description'] = this.description;
    data['rating'] = this.rating;
    return data;
  }
}

class LikesOfReview {
  int id;
  int userId;
  int reviewId;

  LikesOfReview({this.id, this.userId, this.reviewId});

  LikesOfReview.fromJson(Map<String, dynamic> json) {
    id = json['like id'];
    userId = json['user id'];
    reviewId = json['review id'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['like id'] = this.id;
    data['user id'] = this.userId;
    data['review id'] = this.reviewId;
    return data;
  }
}

class DislikesOfReview {
  int id;
  int userId;
  int reviewId;

  DislikesOfReview({this.id, this.userId, this.reviewId});

  DislikesOfReview.fromJson(Map<String, dynamic> json) {
    id = json['dislike id'];
    userId = json['user id'];
    reviewId = json['review id'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dislike id'] = this.id;
    data['user id'] = this.userId;
    data['review id'] = this.reviewId;
    return data;
  }
}
