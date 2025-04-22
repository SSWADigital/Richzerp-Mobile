import 'package:flutter/material.dart';

class Slide extends StatefulWidget {
  final String title;
  final String discription;
  final String img;

  Slide({required this.title, required this.discription, required this.img});

  @override
  _SlideState createState() => _SlideState();
}

class _SlideState extends State<Slide> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          //
          Container(
            child: Column(
              children: [
                //Space
                const SizedBox(
                  height: 40,
                ),
                //Home Check-Up
                Container(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                        fontSize: 25, fontFamily: "bold", color: Colors.black),
                  ),
                ),
                //Samples are taken at home.
                Container(
                  padding: EdgeInsets.only(top: 10),
                  alignment: Alignment.center,
                  child: Text(
                    widget.discription,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "medium",
                        color: Colors.black),
                  ),
                ),
                //Space
                SizedBox(
                  height: 40,
                ),
                Image.asset(
                  widget.img,
                  height: MediaQuery.of(context).size.height * 0.4,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
