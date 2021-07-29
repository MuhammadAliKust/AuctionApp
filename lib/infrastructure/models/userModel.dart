class UserModel {
  String docID;
  String firstName;
  String lastName;
  String profilePic;
  String email;

  UserModel({
    this.docID,
    this.firstName,
    this.lastName,
    this.profilePic,
    this.email,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    docID = json['docID'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    profilePic = json['profilePic'];
    email = json['email'];
  }

  Map<String, dynamic> toJson(String docID) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['docID'] = docID;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['profilePic'] = this.profilePic;
    data['email'] = this.email;
    return data;
  }
}
