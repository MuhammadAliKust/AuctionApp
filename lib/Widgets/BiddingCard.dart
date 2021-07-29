import 'package:auctionapp/infrastructure/services/auctionServices.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BiddingCard extends StatefulWidget {
  final model;

  final VoidCallback onTap;

  const BiddingCard(this.model, this.onTap);

  @override
  _BiddingCardState createState() => _BiddingCardState();
}

class _BiddingCardState extends State<BiddingCard> {
  PostServices _postServices = PostServices();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: ListTile(
        onTap: () => widget.onTap(),
        tileColor: Colors.black12,
        selectedTileColor: Colors.green,
        //isThreeLine: true,
        trailing: Text(widget.model['time']),
        leading: Container(
          height: 70,
          width: 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("Assets/Images/download.jpg"))),
        ),
        isThreeLine: true,
        title: Text(
          widget.model['name'],
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600),
          ),
        ),
        subtitle: Text(widget.model['commentText'],
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500))),
      ),
    );
  }
}
