import 'package:auctionapp/Widgets/Card.dart';
import 'package:auctionapp/configs/back_end_configs.dart';
import 'package:auctionapp/infrastructure/models/postModel.dart';
import 'package:auctionapp/infrastructure/models/userModel.dart';
import 'package:auctionapp/infrastructure/services/auctionServices.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import 'DashBoard.dart';
import 'PostDetails.dart';

class MyPosts extends StatefulWidget {
  const MyPosts({Key key}) : super(key: key);

  @override
  _CreatePostsState createState() => _CreatePostsState();
}

class _CreatePostsState extends State<MyPosts> {
  PostServices _postServices = PostServices();
  final LocalStorage storage = new LocalStorage(BackEndConfigs.loginLocalDB);
  UserModel userModel = UserModel();
  bool initialized = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: storage.ready,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!initialized) {
            var items = storage.getItem(BackEndConfigs.userDetailsLocalStorage);

            if (items != null) {
              print(items);
              userModel = UserModel(
                docID: items['docID'],
                email: items['email'],
                firstName: items['firstName'],
                lastName: items['lastName'],
                profilePic: items['profilePic'],
              );
            }

            initialized = true;
          }
          return snapshot.data == null
              ? CircularProgressIndicator()
              : _getUI(context);
        });
  }

  Widget _getUI(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => DashBoardScreen()));
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "My Posts",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
                color: Colors.black, fontSize: 22, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              StreamProvider.value(
                value: _postServices.streamPosts(userModel.docID),
                builder: (context, child) {
                  return context.watch<List<AuctionModel>>() == null
                      ? CircularProgressIndicator()
                      : ListView.builder(
                          itemCount: context.watch<List<AuctionModel>>().length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, i) {
                            return GestureDetector(
                                onTap: () {
                                  AuctionModel model =
                                      context.read<List<AuctionModel>>()[i];
                                  setState(() {});
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PostDetails(model)));
                                },
                                child: CardPost(
                                    context.watch<List<AuctionModel>>()[i]));
                          });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
