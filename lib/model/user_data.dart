class User {
  int id;
  String role;
  String name;
  String email;
  String avatar;
  String phoneNo;
  String address;
  List<int> favorites;

  User({
    this.id,
    this.role,
    this.name,
    this.email,
    this.avatar,
    this.phoneNo,
    this.address,
    this.favorites,
  });

  User.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.role = json['role'];
    this.name = json['name'];
    this.email = json['email'];
    this.avatar = json['avatar'];
    this.phoneNo = json['phone_no'];
    this.address = json['address'];
    this.favorites =
        json['favorites'] != null ? json['favorites'].cast<int>() : <int>[];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['role'] = this.role;
    data['name'] = this.name;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    data['phone_no'] = this.phoneNo;
    data['address'] = this.address;
    data['favorites'] = this.favorites;
    return data;
  }
}
