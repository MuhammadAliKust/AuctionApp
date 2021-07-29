import 'package:auctionapp/Screens/CreatePosts.dart';
import 'package:auctionapp/Screens/EditProfile.dart';
import 'package:auctionapp/Screens/Login.dart';
import 'package:auctionapp/Screens/MyBiddings.dart';
import 'package:auctionapp/Screens/MyPosts.dart';
import 'package:auctionapp/Screens/PostDetails.dart';
import 'package:auctionapp/Widgets/Card.dart';
import 'package:auctionapp/configs/back_end_configs.dart';
import 'package:auctionapp/infrastructure/models/postModel.dart';
import 'package:auctionapp/infrastructure/models/userModel.dart';
import 'package:auctionapp/infrastructure/services/auctionServices.dart';
import 'package:auctionapp/infrastructure/services/authServices.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key key}) : super(key: key);

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  PostServices _postServices = PostServices();
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final LocalStorage storage = new LocalStorage(BackEndConfigs.loginLocalDB);
  UserModel userModel = UserModel();
  bool initialized = false;
  AuthServices _authServices = AuthServices.instance();

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
                docID: items['regNo'],
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
              : _getUI(context, userModel);
        });
  }

  Widget _getUI(BuildContext context, UserModel model) {
    return model == null
        ? CircularProgressIndicator()
        : Scaffold(
            key: _drawerKey,
            drawer: Drawer(
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: ListView(
                  children: <Widget>[
                    DrawerHeader(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 18.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.grey,
                              backgroundImage:
                                  NetworkImage(userModel.profilePic ?? ""),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              userModel.firstName + " " + userModel.lastName,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () => selectedItem(context, 1),
                      hoverColor: Color(0xffE8A800),
                      leading: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Icon(
                          Icons.edit,
                          color: Color(0xff209CEE),
                        ),
                      ),
                      title: Text(
                        "My Profile",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      onTap: () => selectedItem(context, 2),
                      leading: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Icon(
                            Icons.question_answer,
                            color: Color(0xff209CEE),
                          )),
                      title: Text(
                        "My Posts",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      onTap: () => selectedItem(context, 3),
                      leading: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Icon(
                            Icons.add,
                            color: Color(0xff209CEE),
                          )),
                      title: Text(
                        "Create Posts",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      onTap: () => selectedItem(context, 4),
                      leading: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Icon(
                            Icons.bakery_dining,
                            color: Color(0xff209CEE),
                          )),
                      title: Text(
                        "My Biddings",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        return showDialog(
                            context: context,
                            builder: (ctx) => Container(
                                  height: 300,
                                  width: 230,
                                  child: AlertDialog(
                                    backgroundColor: Colors.transparent,
                                    title: Text(
                                      "Log Out?",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    content: Text(
                                      "Are You Sure Want To Sign Out?",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    actions: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 0.0),
                                        child: Container(
                                          height: 60,
                                          width: 100,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(33)),
                                            color: Color(0xff209CEE),
                                            child: FlatButton(
                                              onPressed: () {
                                                Navigator.of(ctx).pop();
                                              },
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 18.0),
                                        child: Container(
                                          height: 60,
                                          width: 100,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(33)),
                                            color: Color(0xff209CEE),
                                            child: FlatButton(
                                              onPressed: () {
                                                _authServices.signOut();
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LoginScreen()));
                                              },
                                              child: Text(
                                                "Log Out",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                      },
                      leading: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Icon(
                            Icons.logout,
                            color: Color(0xff209CEE),
                          )),
                      title: Text(
                        "Log Out",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ),
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                              onTap: () => _drawerKey.currentState.openDrawer(),
                              child: Icon(Icons.menu)),
                          SizedBox(
                            width: 130,
                          ),
                          Text(
                            "Posts",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 10,
                      width: 370,
                      child: Divider(
                        color: Colors.black,
                        height: 2,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    StreamProvider.value(
                      value: _postServices.getAllPosts(),
                      builder: (context, child) {
                        return context.watch<List<AuctionModel>>() == null
                            ? CircularProgressIndicator()
                            : ListView.builder(
                                itemCount:
                                    context.watch<List<AuctionModel>>().length,
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, i) {
                                  return GestureDetector(
                                      onTap: () {
                                        AuctionModel model = context
                                            .read<List<AuctionModel>>()[i];
                                        setState(() {});
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PostDetails(model)));
                                      },
                                      child: CardPost(context
                                          .watch<List<AuctionModel>>()[i]));
                                });
                      },
                    )
                  ],
                ),
              ),
            ),
          );
  }

  void selectedItem(BuildContext context, int index) {
    switch (index) {
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => EditProfile()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyPosts()));
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CreatePosts()));
        break;
      case 4:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyBddings()));
        break;
    }
  }
}
