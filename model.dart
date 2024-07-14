class UserProfile {
  String? userName;
  String? dateOfBirth;
  String? phoneNo;
  String email;
  String? profileUrl;
  String? address;
  String uid;
  UserProfile(
      {required this.email,
        required this.uid,
        this.userName,
        this.dateOfBirth,
        this.phoneNo,
        this.profileUrl,
        this.address});
  Map<String, dynamic> mapedInfo() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'username': userName ?? "",
      'dob': dateOfBirth ?? "",
      'phoneNo': phoneNo ?? "",
      'profile': profileUrl,
      'address': address ?? "",
    };
  }
}