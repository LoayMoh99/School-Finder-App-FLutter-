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
    id = json['id'];
    role = json['role'];
    name = json['name'];
    email = json['email'];
    avatar = json['avatar'];
    phoneNo = json['phone_no'];
    address = json['address'];
    favorites = json['favorites'].cast<int>();
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
