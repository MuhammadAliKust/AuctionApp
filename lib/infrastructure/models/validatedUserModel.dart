class ValidatedUserModel {
  String firstName;
  String lastName;
  String regNo;
  String departmentName;
  String role;

  ValidatedUserModel(
      {this.firstName,
      this.lastName,
      this.regNo,
      this.departmentName,
      this.role});

  ValidatedUserModel.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    regNo = json['regNo'];
    departmentName = json['departmentName'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['regNo'] = this.regNo;
    data['departmentName'] = this.departmentName;
    data['role'] = this.role;
    return data;
  }
}
