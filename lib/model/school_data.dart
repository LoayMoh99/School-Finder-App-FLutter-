class School {
  int id;
  String name;
  List<String> stages;
  List<String> certificates;
  String gender;
  String mainLanguage;
  String addresss;
  String phoneNumber;
  int annualFees;
  String description;
  int estiblashingYear;
  List<String> gallery;
  List<Facilities> facilities;
  List<String> externalUrls;
  int rating;
  int ratedBy;

  School(
      {this.id,
      this.name,
      this.stages,
      this.certificates,
      this.gender,
      this.mainLanguage,
      this.addresss,
      this.phoneNumber,
      this.annualFees,
      this.description,
      this.estiblashingYear,
      this.gallery,
      this.facilities,
      this.externalUrls,
      this.rating,
      this.ratedBy});

  School.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    stages =
        json['stages'] != null ? json['stages'].cast<String>() : <String>[];
    certificates = json['certificates'] != null
        ? json['certificates'].cast<String>()
        : <String>[];
    gender = json['gender'];
    mainLanguage = json['main language'];
    addresss = json['addresss'];
    phoneNumber = json['phone number'];
    annualFees = json['Annual fees'];
    description = json['description'];
    estiblashingYear = json['estiblashing year'];
    gallery =
        json['gallery'] != null ? json['gallery'].cast<String>() : <String>[];
    if (json['facilities'] != null) {
      facilities = new List<Facilities>();
      json['facilities'].forEach((v) {
        facilities.add(new Facilities.fromJson(v));
      });
    }
    externalUrls = json['external_urls'] != null
        ? json['external_urls'].cast<String>()
        : <String>[];
    rating = json['rating'];
    ratedBy = json['rated by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['stages'] = this.stages;
    data['certificates'] = this.certificates;
    data['gender'] = this.gender;
    data['main language'] = this.mainLanguage;
    data['addresss'] = this.addresss;
    data['phone number'] = this.phoneNumber;
    data['Annual fees'] = this.annualFees;
    data['description'] = this.description;
    data['estiblashing year'] = this.estiblashingYear;
    data['gallery'] = this.gallery;
    if (this.facilities != null) {
      data['facilities'] = this.facilities.map((v) => v.toJson()).toList();
    }
    data['external_urls'] = this.externalUrls;
    data['rating'] = this.rating;
    data['rated by'] = this.ratedBy;
    return data;
  }
}

class Facilities {
  String type;
  int number;
  String description;

  Facilities({this.type, this.number, this.description});

  Facilities.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    number = json['number'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['number'] = this.number;
    data['description'] = this.description;
    return data;
  }
}
