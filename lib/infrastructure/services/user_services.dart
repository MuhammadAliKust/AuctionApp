import 'package:auctionapp/application/app_state.dart';
import 'package:auctionapp/configs/back_end_configs.dart';
import 'package:auctionapp/infrastructure/models/userModel.dart';
import 'package:auctionapp/infrastructure/services/updateLocalStorageServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

class UserServices {
  ///Instantiate LocalDB
  final LocalStorage storage = new LocalStorage(BackEndConfigs.loginLocalDB);
  UserModel _bikerModel = UserModel();

  UserModel get bikerModel => _bikerModel;
  UpdateLocalStorageData _data = UpdateLocalStorageData();

  ///Collection Reference of IOC Users
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection('bidAppUsers');

  ///Add IOC Users data to Cloud Firestore
  Future<void> addBikerData(
      User user, UserModel stdModel, BuildContext context) {
    return _ref.doc(user.uid).set(stdModel.toJson(user.uid));
  }

  ///Stream a User
  Stream<UserModel> streamStudentsData(String docID) {
    print("I am $docID");
    return _ref
        .doc(docID)
        .snapshots()
        .map((snap) => UserModel.fromJson(snap.data()));
  }

  Future<void> update(UserModel userModel,
      {String firstName, String lastName, String imageUrl}) async {
    print(userModel.docID);
    return _ref.doc(userModel.docID).update({
      'profilePic': imageUrl,
      "firstName": firstName,
      'lastName': lastName,
    });
  }

  ///Add Subjects
  Future<void> addSubjects(BuildContext context,
      {UserModel userModel, List subjects}) async {
    Provider.of<AppState>(context, listen: false)
        .stateStatus(StateStatus.IsBusy);
    print(userModel.docID);
    await _ref.doc(userModel.docID).update({
      'subjects': subjects,
    });
    Provider.of<AppState>(context, listen: false)
        .stateStatus(StateStatus.IsFree);
  }

  ///Get My Advisor
  Stream<List<UserModel>> getMyAdvisor(BuildContext context, {String regNo}) {
    return _ref.where('students', arrayContains: regNo).snapshots().map(
        (snap) => snap.docs.map((e) => UserModel.fromJson(e.data())).toList());
  }

  ///Go Offline/Online
  Future<void> changeOnlineStatus({UserModel userModel, bool isOnline}) async {
    await _ref.doc(userModel.docID).update({
      'isOnline': isOnline,
    });
  }

  ///Get All Users
  Stream<List<UserModel>> streamUsers(UserModel userModel) {
    return _ref.where('docID', isNotEqualTo: userModel.docID).snapshots().map(
        (event) =>
            event.docs.map((e) => UserModel.fromJson(e.data())).toList());
  }
}
