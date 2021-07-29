import 'package:auctionapp/application/app_state.dart';
import 'package:auctionapp/infrastructure/models/bidModel.dart';
import 'package:auctionapp/infrastructure/models/postModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostServices {
  CollectionReference _auctionCollection =
      FirebaseFirestore.instance.collection('auctionCollection');

  ///Create Post
  Future<void> createPost(BuildContext context, {AuctionModel model}) async {
    Provider.of<AppState>(context, listen: false)
        .stateStatus(StateStatus.IsBusy);
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('auctionCollection').doc();
    await docRef.set(model.toJson(docRef.id));
    Provider.of<AppState>(context, listen: false)
        .stateStatus(StateStatus.IsFree);
  }

  ///Get My Post
  Stream<List<AuctionModel>> streamPosts(String uid) {
    return _auctionCollection.where('uid', isEqualTo: uid).snapshots().map(
        (event) =>
            event.docs.map((e) => AuctionModel.fromJson(e.data())).toList());
  }

  ///Get Post
  Stream<List<AuctionModel>> getAllPosts() {
    return _auctionCollection.snapshots().map((event) =>
        event.docs.map((e) => AuctionModel.fromJson(e.data())).toList());
  }

  ///Get Post
  Stream<List<AuctionModel>> getActivePosts() {
    return _auctionCollection
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => AuctionModel.fromJson(e.data())).toList());
  }

  ///Get MY Biddings
  Stream<List<AuctionModel>> getMyBiddings(String uid) {
    return _auctionCollection
        .where('users', arrayContains: uid)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => AuctionModel.fromJson(e.data())).toList());
  }

  ///Accept Bid
  Future<void> acceptBid(BuildContext context, {String docID}) async {
    Provider.of<AppState>(context, listen: false)
        .stateStatus(StateStatus.IsBusy);
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('auctionCollection').doc(docID);
    await docRef.update({'isActive': false});
    Provider.of<AppState>(context, listen: false)
        .stateStatus(StateStatus.IsFree);
  }

  ///Get Comments
  Future<void> addBids(BuildContext context,
      {String eventID, BidModel comment}) async {
    Provider.of<AppState>(context, listen: false)
        .stateStatus(StateStatus.IsBusy);

    await _auctionCollection.doc(eventID).update({
      'comments': FieldValue.arrayUnion([comment.toJson()])
    });
    Provider.of<AppState>(context, listen: false)
        .stateStatus(StateStatus.IsFree);
  }

  ///Get Comments
  Future<void> addBidderID(BuildContext context,
      {String docID, String postID}) async {
    Provider.of<AppState>(context, listen: false)
        .stateStatus(StateStatus.IsBusy);

    await _auctionCollection.doc(postID).update({
      'users': FieldValue.arrayUnion([docID])
    });
    Provider.of<AppState>(context, listen: false)
        .stateStatus(StateStatus.IsFree);
  }
}
