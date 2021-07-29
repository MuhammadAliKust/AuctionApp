import 'dart:io';

import 'package:auctionapp/Widgets/navigation_dialog.dart';
import 'package:auctionapp/configs/back_end_configs.dart';
import 'package:auctionapp/infrastructure/models/userModel.dart';
import 'package:auctionapp/infrastructure/services/uploadFileServices.dart';
import 'package:auctionapp/infrastructure/services/user_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'DashBoard.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key key}) : super(key: key);

  @override
  _CreatePostsState createState() => _CreatePostsState();
}

class _CreatePostsState extends State<EditProfile> {
  ProgressDialog pr;
  File _file;
  final LocalStorage storage = new LocalStorage(BackEndConfigs.loginLocalDB);
  UserModel userModel = UserModel();
  bool initialized = false;
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  UserServices _userServices = UserServices();
  UploadFileServices _uploadFileServices = UploadFileServices();

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context, isDismissible: false);
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
            _firstNameController =
                TextEditingController(text: userModel.firstName);
            _lastNameController =
                TextEditingController(text: userModel.lastName);

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
            "My Profile",
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
              height: 50,
            ),
            Stack(
              children: [
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(19),
                      image: DecorationImage(
                          image: _file == null
                              ? userModel.profilePic == ""
                                  ? AssetImage("Assets/Images/download.jpg")
                                  : NetworkImage(userModel.profilePic ?? "")
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
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  userModel.firstName + " " + userModel.lastName,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  width: 340,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13)),
                    elevation: 4,
                    child: TextFormField(
                      onFieldSubmitted: (value) {},
                      validator: (value) {
                        if (value.isEmpty) {
                          return "*First Name is  Required";
                        } else
                          return null;
                      },
                      controller: _firstNameController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10, top: 10),
                          border: InputBorder.none,
                          hintText: "Update First Name",
                          hintStyle: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  width: 340,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13)),
                    elevation: 4,
                    child: TextFormField(
                      onFieldSubmitted: (value) {},
                      validator: (value) {
                        if (value.isEmpty) {
                          return "*Last Name is  Required";
                        } else
                          return null;
                      },
                      controller: _lastNameController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10, top: 10),
                          border: InputBorder.none,
                          hintText: "Update Last Name",
                          hintStyle: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () async {
                await pr.show();
                if (_file != null) {
                  _uploadFileServices
                      .getUrl(context, file: _file)
                      .then((value) => _userServices.update(userModel,
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          imageUrl: value))
                      .then((value) async {
                    await pr.hide();
                    showNavigationDialog(context,
                        message: "Updates Successfully",
                        buttonText: "Okay", navigation: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DashBoardScreen()));
                    },
                        secondButtonText: "secondButtonText",
                        showSecondButton: false);
                  });
                } else {
                  _userServices
                      .update(userModel,
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          imageUrl: userModel.profilePic)
                      .then((value) async {
                    await pr.hide();
                    showNavigationDialog(context,
                        message: "Updates Successfully",
                        buttonText: "Okay", navigation: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DashBoardScreen()));
                    },
                        secondButtonText: "secondButtonText",
                        showSecondButton: false);
                  });
                }
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
                      "Update",
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
}
