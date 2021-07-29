class AuctionModel {
  String uid;
  String docID;
  String auctionTitle;
  String auctionDescription;
  String price;
  String location;
  String time;
  String date;
  String image;
  List users;
  bool isActive;
  List comments;

  AuctionModel({
    this.docID,
    this.auctionTitle,
    this.auctionDescription,
    this.price,
    this.location,
    this.time,
    this.date,
    this.uid,
    this.users,
    this.isActive,
    this.comments,
    this.image,
  });

  AuctionModel.fromJson(Map<String, dynamic> json) {
    docID = json['docID'];
    auctionTitle = json['auctionTitle'];
    auctionDescription = json['auctionDescription'];
    price = json['price'];
    location = json['location'];
    time = json['time'];
    date = json['date'];
    uid = json['uid'];
    users = json['users'];
    isActive = json['isActive'];
    comments = json['comments'];
    image = json['image'];
  }

  Map<String, dynamic> toJson(String docID) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['docID'] = docID;
    data['uid'] = this.uid;
    data['auctionTitle'] = this.auctionTitle;
    data['auctionDescription'] = this.auctionDescription;
    data['price'] = this.price;
    data['location'] = this.location;
    data['time'] = this.time;
    data['date'] = this.date;
    data['users'] = this.users;
    data['isActive'] = this.isActive;
    data['comments'] = this.comments;
    data['image'] = this.image;
    return data;
  }
}
