import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Alert extends StatelessWidget {
  String title, subTile;
  Alert({required this.title, required this.subTile});
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: EdgeInsets.all(30),
      child: MediaQuery(
        data: queryData.copyWith(textScaleFactor: 1.0),
        child: Container(
          height: 130,
          padding: EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: EdgeInsets.only(top: 8),
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: "medium",
                      color: Theme.of(context).textTheme.headline1?.color),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  subTile,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: "medium",
                      color: Theme.of(context).textTheme.headline1?.color),
                ),
              ),

              //btn
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: MaterialButton(
                    minWidth: 120,
                    height: 38,
                    onPressed: () {
                      Navigator.pop(context);
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    elevation: 0,
                    highlightElevation: 0,
                    color: Colors.blue,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: const Text(
                      "OK",
                      style: TextStyle(
                          fontFamily: "medium",
                          color: Colors.black,
                          fontSize: 14),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
