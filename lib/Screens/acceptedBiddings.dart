import 'package:auctionapp/Widgets/dialog.dart';
import 'package:auctionapp/Widgets/navigation_dialog.dart';
import 'package:auctionapp/configs/back_end_configs.dart';
import 'package:auctionapp/infrastructure/models/postModel.dart';
import 'package:auctionapp/infrastructure/models/userModel.dart';
import 'package:auctionapp/infrastructure/services/auctionServices.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'DashBoard.dart';
import 'PostDetails.dart';

class AcceptedBiddings extends StatefulWidget {
  const AcceptedBiddings({Key key}) : super(key: key);

  @override
  _CreatePostsState createState() => _CreatePostsState();
}

class _CreatePostsState extends State<AcceptedBiddings> {
  PostServices _postServices = PostServices();
  final LocalStorage storage = new LocalStorage(BackEndConfigs.loginLocalDB);
  UserModel userModel = UserModel();
  bool initialized = false;
  Razorpay _razorpay = Razorpay();

  @override
  initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    showNavigationDialog(context,
        message: "Thanks for purchasing", buttonText: "Okay", navigation: () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => DashBoardScreen()));
    }, secondButtonText: "secondButtonText", showSecondButton: false);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(response.message);
    showErrorDialog(context, message: response.message);
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _razorpay.clear(); // Removes all listeners
    super.dispose();
  }

  makePayment() {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': 2000,
      'name': 'Acme Corp.',
      'description': 'Fine T-Shirt',
      'prefill': {'contact': '+923419527440', 'email': 'test@mail.com'},
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

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
          "My Accepted Biddings",
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
                value: _postServices.getMyAcceptedBiddings(userModel.docID),
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
                                child: ListTile(
                                  trailing: IconButton(
                                    onPressed: () {
                                      makePayment();
                                    },
                                    icon: Icon(Icons.payment),
                                  ),
                                  title: Text(context
                                      .watch<List<AuctionModel>>()[i]
                                      .auctionTitle),
                                ));
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
