class CommunityPost {
  int id;
  int userId;
  int schoolId;
  List<String> images;
  String content;
  int numOfLikes;

  CommunityPost(
      {this.id,
      this.userId,
      this.schoolId,
      this.images,
      this.content,
      this.numOfLikes});

  CommunityPost.fromJson(Map<String, dynamic> json) {
    id = json['post id'];
    userId = json['user id'];
    schoolId = json['school id'];
    images = json['images'];
    content = json['content'];
    numOfLikes = json['number of likes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post id'] = this.id;
    data['user id'] = this.userId;
    data['school id'] = this.schoolId;
    data['images'] = this.images;
    data['content'] = this.content;
    data['number of likes'] = this.numOfLikes;
    return data;
  }
}

class CommentsOnPost {
  int id;
  int userId;
  int postId;
  String content;

  CommentsOnPost({this.id, this.userId, this.postId, this.content});

  CommentsOnPost.fromJson(Map<String, dynamic> json) {
    id = json['comment id'];
    userId = json['user id'];
    postId = json['post id'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment id'] = this.id;
    data['user id'] = this.userId;
    data['post id'] = this.postId;
    data['content'] = this.content;

    return data;
  }
}

class LikesOnPost {
  int id;
  int userId;
  int postId;

  LikesOnPost({this.id, this.userId, this.postId});

  LikesOnPost.fromJson(Map<String, dynamic> json) {
    id = json['like id'];
    userId = json['user id'];
    postId = json['post id'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['like id'] = this.id;
    data['user id'] = this.userId;
    data['post id'] = this.postId;

    return data;
  }
}
