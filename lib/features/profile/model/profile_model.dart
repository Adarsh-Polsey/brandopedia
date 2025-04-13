class ProfileModel {
  String? name;
  String? email;
  String? phone;
  String? dob;
  String? profileImagePath;

  ProfileModel({
    this.name,
    this.email,
    this.phone,
    this.dob,
    this.profileImagePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'dob': dob,
      'profileImagePath': profileImagePath,
    };
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      dob: json['dob'],
      profileImagePath: json['profileImagePath'],
    );
  }
}