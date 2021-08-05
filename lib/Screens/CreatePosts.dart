import 'dart:io';

import 'package:auctionapp/Widgets/navigation_dialog.dart';
import 'package:auctionapp/application/app_state.dart';
import 'package:auctionapp/configs/back_end_configs.dart';
import 'package:auctionapp/infrastructure/models/postModel.dart';
import 'package:auctionapp/infrastructure/models/userModel.dart';
import 'package:auctionapp/infrastructure/services/auctionServices.dart';
import 'package:auctionapp/infrastructure/services/uploadFileServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'DashBoard.dart';

class CreatePosts extends StatefulWidget {
  const CreatePosts({Key key}) : super(key: key);

  @override
  _CreatePostsState createState() => _CreatePostsState();
}

class _CreatePostsState extends State<CreatePosts> {
  var _formKey = GlobalKey<FormState>();
  PostServices _postServices = PostServices();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

  void _submit() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
  }

  ProgressDialog pr;

  File _file;

  UploadFileServices _uploadFileServices = UploadFileServices();
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
    print(TimeOfDay.now());
    pr = ProgressDialog(context, isDismissible: true);
    var status = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        leading: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => DashBoardScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            )),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
            "Create Post",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Text(
              "Choose Image",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(19),
                          image: DecorationImage(
                              image: _file == null
                                  ? AssetImage("Assets/Images/download.jpg")
                                  : FileImage(_file),
                              fit: BoxFit.cover)),
                    ),
                    Positioned.fill(
                      top: -40,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          height: 40,
                          width: 40,
                          child: IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 19,
                            ),
                            onPressed: getFile,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff209CEE),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 28.0, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Post Title",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 28.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 50,
                            width: 340,
                            child: TextFormField(
                              onFieldSubmitted: (value) {},
                              controller: _titleController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "*Please Enter Post Title";
                                } else
                                  return null;
                              },
                              //  controller: _firstnamecontroller,
                              decoration: InputDecoration(
                                  hintText: "Enter Your Post Title",
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 28.0, top: 10, bottom: 10),
                      child: Row(
                        children: [
                          Text(
                            "Post Discription",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 28.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 50,
                            width: 340,
                            child: TextFormField(
                              onFieldSubmitted: (value) {},
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "*Enter Your Post Discription";
                                } else
                                  return null;
                              },
                              controller: _descController,
                              decoration: InputDecoration(
                                  hintText: "Enter Your Post Discription",
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 28.0, top: 10, bottom: 10),
                      child: Row(
                        children: [
                          Text(
                            "Product Price",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 28.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 50,
                            width: 340,
                            child: TextFormField(
                              onFieldSubmitted: (value) {},
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "*Enter Your Product Price";
                                } else
                                  return null;
                              },
                              controller: _priceController,
                              decoration: InputDecoration(
                                  hintText: "Enter Your Product price",
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 28.0, top: 10, bottom: 10),
                      child: Row(
                        children: [
                          Text(
                            "Product Location",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 28.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 50,
                            width: 340,
                            child: TextFormField(
                              onFieldSubmitted: (value) {},
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "*Enter Your Product Location";
                                } else
                                  return null;
                              },
                              controller: _locationController,
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.location_city),
                                  hintText: "Enter Your Product Location",
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(_selectedTime == null ? "" : _selectedTime.minute.toString()),
            RaisedButton(
              onPressed: () {
                _show();
              },
              child: Text("Select Timer for Bid"),
            ),
            SizedBox(
              height: 20,
            ),
            //  TextButton(
            //                 onPressed: () {
            //                   DatePicker.showDatePicker(context,
            //                       showTitleActions: true,
            //                       minTime: DateTime(2018, 3, 5),
            //                       maxTime: DateTime(2019, 6, 7),
            //                       theme: DatePickerTheme(
            //                           headerColor: Colors.orange,
            //                           backgroundColor: Colors.blue,
            //                           itemStyle: TextStyle(
            //                               color: Colors.white,
            //                               fontWeight: FontWeight.bold,
            //                               fontSize: 18),
            //                           doneStyle:
            //                               TextStyle(color: Colors.white, fontSize: 16)),
            //                       onChanged: (date) {
            //                     print('change $date in time zone ' +
            //                         date.timeZoneOffset.inHours.toString());
            //                   }, onConfirm: (date) {
            //                     print('confirm $date');
            //                   }, currentTime: DateTime.now(), locale: LocaleType.en);
            //                 },
            //                 child: Text(
            //                   'show date picker(custom theme &date time range)',
            //                   style: TextStyle(color: Colors.blue),
            //                 )),

            GestureDetector(
              onTap: () async {
                await pr.show();
                if (!_formKey.currentState.validate()) {
                  return;
                }
                _createPost(status, context);
              },
              child: Container(
                height: 60,
                width: 220,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13)),
                  color: Color(0xff209CEE),
                  child: Center(
                    child: Text(
                      "Upload Post",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DateTime _selectedTime;

  // We don't need to pass a context to the _show() function
  // You can safety use context as below
  Future<void> _show() async {
    final TimeOfDay result =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (result != null) {
      setState(() {
        _selectedTime = DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, result.hour, result.minute);
      });
    }
  }

  Future getFile() async {
    _file = await FilePicker.getFile();
    setState(() {
      if (_file != null) {
        _file = File(_file.path);
      } else {
        print('No image selected.');
      }
    });
  }

  _createPost(AppState status, BuildContext context) async {
    var user = Provider.of<User>(context, listen: false);
    await _uploadFileServices
        .getUrl(context, file: _file)
        .then((fileUrl) async {
      await _postServices.createPost(
        context,
        model: AuctionModel(
            uid: userModel.docID,
            auctionTitle: _titleController.text,
            auctionDescription: _descController.text,
            price: _priceController.text,
            location: _locationController.text,
            date: "${DateTime.now().month} ${DateTime.now().day}",
            time: "${DateTime.now().hour} ${DateTime.now().minute}",
            users: [],
            image: fileUrl,
            isActive: true,
            bidTimer: Timestamp.fromDate(_selectedTime),
            comments: []),
      );
    }).then((value) async {
      if (status.getStateStatus() == StateStatus.IsFree) {
        await pr.hide();
        showNavigationDialog(context,
            message: "Auction created successfully.",
            buttonText: "Okay", navigation: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => DashBoardScreen()));
        }, secondButtonText: "", showSecondButton: false);
      }
    });
  }
}

class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime currentTime, LocaleType locale})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.hour);
    this.setMiddleIndex(this.currentTime.minute);
    this.setRightIndex(this.currentTime.second);
  }

  @override
  String leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "|";
  }

  @override
  String rightDivider() {
    return "|";
  }

  @override
  List<int> layoutProportions() {
    return [1, 2, 1];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex())
        : DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex());
  }
}
