import 'package:auctionapp/Screens/adminLogin.dart';
import 'package:auctionapp/Widgets/Card.dart';
import 'package:auctionapp/configs/back_end_configs.dart';
import 'package:auctionapp/infrastructure/models/postModel.dart';
import 'package:auctionapp/infrastructure/models/userModel.dart';
import 'package:auctionapp/infrastructure/services/auctionServices.dart';
import 'package:auctionapp/infrastructure/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import 'PostDetails.dart';

class DeletePostView extends StatefulWidget {
  const DeletePostView({Key key}) : super(key: key);

  @override
  _DeletePostViewState createState() => _DeletePostViewState();
}

class _DeletePostViewState extends State<DeletePostView> {
  PostServices _postServices = PostServices();
  final LocalStorage storage = new LocalStorage(BackEndConfigs.loginLocalDB);
  UserModel userModel = UserModel();
  bool initialized = false;
  UserServices _userServices = UserServices();

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
        leading: Container(
          height: 1,
          width: 1,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => AdminLoginScreen()),
                    (route) => false);
              })
        ],
        title: Text(
          "All Posts",
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
                value: _postServices.getAllPosts(),
                builder: (context, child) {
                  return context.watch<List<AuctionModel>>() == null
                      ? CircularProgressIndicator()
                      : ListView.builder(
                          itemCount: context.watch<List<AuctionModel>>().length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, i) {
                            return ListTile(
                              title: Text(context
                                  .watch<List<AuctionModel>>()[i]
                                  .auctionTitle),
                              subtitle: Text(
                                  context.watch<List<AuctionModel>>()[i].price),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  AuctionModel model =
                                      context.read<List<AuctionModel>>()[i];
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Message"),
                                          content: Text(
                                              "Do you really want to delete this post?"),
                                          actions: [
                                            FlatButton(
                                              onPressed: () {
                                                _postServices
                                                    .deletePost(model.docID);
                                                Navigator.pop(context);
                                              },
                                              child: Text("Yes"),
                                            ),
                                            FlatButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("No"),
                                            ),
                                          ],
                                        );
                                      });
                                },
                              ),
                            );
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
