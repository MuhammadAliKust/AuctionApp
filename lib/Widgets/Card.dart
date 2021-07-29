import 'package:auctionapp/infrastructure/models/postModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardPost extends StatefulWidget {
  final AuctionModel model;

  const CardPost(this.model);

  @override
  _CardState createState() => _CardState();
}

class _CardState extends State<CardPost> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        height: 290,
        width: 400,
        child: Column(children: [
          Container(
            height: 150,
            width: 400,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.model.image ?? ""))),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    radius: 25,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  widget.model.auctionDescription,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 65.0, bottom: 0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 25.0),
                  child: Text(
                    widget.model.time,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25.0),
                  child: Text(
                    widget.model.price,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 10,
            width: 390,
            child: Divider(
              color: Colors.black,
              height: 2,
            ),
          ),
          SizedBox(
            height: 10,
          )
        ]));
  }
}
