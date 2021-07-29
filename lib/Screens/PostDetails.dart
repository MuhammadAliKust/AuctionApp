import 'package:auctionapp/Screens/DashBoard.dart';
import 'package:auctionapp/Widgets/BiddingCard.dart';
import 'package:auctionapp/Widgets/navigation_dialog.dart';
import 'package:auctionapp/configs/back_end_configs.dart';
import 'package:auctionapp/infrastructure/models/bidModel.dart';
import 'package:auctionapp/infrastructure/models/postModel.dart';
import 'package:auctionapp/infrastructure/models/userModel.dart';
import 'package:auctionapp/infrastructure/services/auctionServices.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class PostDetails extends StatefulWidget {
  final AuctionModel model;

  const PostDetails(this.model);

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  final LocalStorage storage = new LocalStorage(BackEndConfigs.loginLocalDB);
  UserModel userModel = UserModel();
  bool initialized = false;
  PostServices _postServices = PostServices();
  int _value = 1;
  var items = [
    'Apple',
    'Banana',
    'Grapes',
    'Orange',
    'watermelon',
    'Pineapple'
  ];

  TextEditingController _controller = TextEditingController();

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
        leadingWidth: 20,
        elevation: 0,
        backgroundColor: Colors.white,
        bottomOpacity: 0,
        shadowColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Posts Details",
          style: TextStyle(
              color: Colors.black, fontSize: 19, fontWeight: FontWeight.bold),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => DashBoardScreen()));
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Container(
                height: 200,
                width: 400,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.model.image ?? ""))),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Description",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.model.auctionDescription,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Product Details",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 60,
                    width: 120,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            widget.model.date,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      elevation: 4,
                    ),
                  ),
                  Container(
                    height: 60,
                    width: 120,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_city,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            widget.model.location,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      elevation: 4,
                    ),
                  ),
                  Container(
                    height: 60,
                    width: 120,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock_clock,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            widget.model.price,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      elevation: 4,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Biddings",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              height: 400,
              width: 400,
              child: ListView.builder(
                  itemCount: widget.model.comments.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, i) {
                    print(widget.model.comments.length);
                    return Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15),
                      child: BiddingCard(widget.model.comments[i], () {
                        if (userModel.docID == widget.model.uid)
                          showNavigationDialog(context,
                              message:
                                  "Do you really want to accept this offer?",
                              buttonText: "Yes", navigation: () {
                            _postServices.acceptBid(context,
                                docID: widget.model.docID);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DashBoardScreen()));
                          }, secondButtonText: "No", showSecondButton: true);
                      }),
                    );
                  }),
            ),
            SizedBox(
              height: 10,
            ),
            if (widget.model.isActive)
              if (userModel.docID != widget.model.uid)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 60,
                      width: 310,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13)),
                        color: Colors.white54,
                        elevation: 4,
                        child: TextFormField(
                          controller: _controller,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 10, top: 13),
                            hintText: "Place Your Bid Here",
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 60,
                      width: 60,
                      child: Card(
                        color: Color(0xff209CEE),
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: InkWell(
                          onTap: () {
                            _postServices.addBidderID(context,
                                postID: widget.model.docID,
                                docID: userModel.docID);
                            _postServices
                                .addBids(context,
                                    eventID: widget.model.docID,
                                    comment: BidModel(
                                        name: userModel.firstName +
                                            " " +
                                            userModel.lastName,
                                        commentText: _controller.text,
                                        time:
                                            "${DateTime.now().hour}:${DateTime.now().minute}",
                                        image: userModel.profilePic))
                                .then((value) => showNavigationDialog(context,
                                        message: "Bid Done Successfully",
                                        buttonText: "Okay", navigation: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DashBoardScreen()));
                                    },
                                        secondButtonText: "",
                                        showSecondButton: false));
                          },
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                )
          ],
        ),
      ),
    );
  }
}
