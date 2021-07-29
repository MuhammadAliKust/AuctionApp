import 'package:auctionapp/infrastructure/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateLocalStorageData {
  ///Update Local Storage Data
  Future<UserModel> updateLocalStorageData(String docID, UserModel userModel) {
    return FirebaseFirestore.instance
        .collection("iocUsers")
        .doc(docID)
        .get()
        .then((value) {
      return UserModel.fromJson(value.data());
    });
  }
}
