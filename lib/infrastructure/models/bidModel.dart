class BidModel {
  String image;
  String name;
  String commentText;
  String time;
  String uid;

  BidModel({this.image, this.name, this.commentText, this.time, this.uid});

  BidModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    name = json['name'];
    commentText = json['commentText'];
    time = json['time'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['name'] = this.name;
    data['commentText'] = this.commentText;
    data['time'] = this.time;
    data['uid'] = this.uid;
    return data;
  }
}
