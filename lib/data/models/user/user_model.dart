class UserModel {
  String? sId;
  String? fullName;
  String? email;
  String? password;
  String? phoneNumber;
  String? city;
  String? state;
  String? address;
  int? profileProgress;
  String? id;
  String? updatedOn;
  String? createdOn;

  UserModel(
      {this.sId,
        this.fullName,
        this.email,
        this.password,
        this.phoneNumber,
        this.city,
        this.state,
        this.address,
        this.profileProgress,
        this.id,
        this.updatedOn,
        this.createdOn});

  UserModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['fullName'];
    email = json['email'];
    password = json['password'];
    phoneNumber = json['phoneNumber'];
    city = json['city'];
    state = json['state'];
    address = json['address'];
    profileProgress = json['profileProgress'];
    id = json['id'];
    updatedOn = json['updatedOn'];
    createdOn = json['createdOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['fullName'] = fullName;
    data['email'] = email;
    data['password'] = password;
    data['phoneNumber'] = phoneNumber;
    data['city'] = city;
    data['state'] = state;
    data['address'] = address;
    data['profileProgress'] = profileProgress;
    data['id'] = id;
    data['updatedOn'] = updatedOn;
    data['createdOn'] = createdOn;
    return data;
  }
}
