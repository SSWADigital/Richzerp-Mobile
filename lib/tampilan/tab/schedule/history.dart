import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gocrane_v3/tampilan/SlideRightRoute.dart';

import 'package:gocrane_v3/tampilan/tab/beranda.dart';

// import 'package:geolocator/geolocator.dart';

// import 'package:gocrane_v3/UI/posisi.dart';

import 'package:gocrane_v3/main.dart';
import 'package:gocrane_v3/tampilan/tab/schedule/antrian.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  List<Map<String, dynamic>> list = [
    {
      "img": "assets/imgs/checkup.jpg",
      "name": "Dr. Dimitri Petrenko",
      "activeStatus": "Active now",
      "msgStatus": "New message",
      "timing": "21 minutes ago",
      "color": 0xFF4CAF50,
    },
    {
      "img": "assets/imgs/checkup.jpg",
      "name": "Dr. Dimitri Petrenko",
      "activeStatus": "Active now",
      "msgStatus": "Ongoing",
      "timing": "32 menit",
      "color": 0xFF4285f4,
    },
  ];
  List? datajson;
  Future ambildata() async {
    final Response = await http.post(
        Uri.parse("${url}/${urlSubAPI}/API/faskes_pilih.php"),
        body: {"aksi": "8", 'nik': "123123123", 'id_dep': idDep});
    if (this.mounted) {
      this.setState(() {
        datajson = jsonDecode(Response.body);
      });
    }
  }

  bool _isValidImageURL(String url) {
    if (url == null || !url.startsWith('http')) {
      return false;
    }
    return true;
  }

  @override
  void initState() {
    if (this.mounted) {
      ambildata();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            //Schedule
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: Text(
                "Riwayat",
                style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w700,
                    fontFamily: "medium",
                    color: Colors.black),
              ),
            ),
            Container(
              // height: 300,
              child: Expanded(
                  child: datajson == null
                      ? Center(
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("assets/imgs/slide_img3.png"),
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                              // 3, //
                              datajson == null ? 0 : datajson?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: InkWell(
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     SlidePageRoute(
                                  //         page: buktiTransaksi(
                                  //       list: datajson!,
                                  //       index: index,
                                  //     )));
                                },
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                  margin: EdgeInsets.zero,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                            left: 10,
                                            right: 2,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  padding:
                                                      EdgeInsets.only(left: 8),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        child: Text(
                                                          datajson![index][
                                                                  'reg_buffer_tanggal'] ??
                                                              "",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  "medium",
                                                              color:
                                                                  Colors.green),
                                                        ),
                                                      ),
                                                      //Space
                                                      SizedBox(
                                                        height: 3,
                                                      ),
                                                      Container(
                                                        child: Text(
                                                          datajson![index][
                                                                  'usr_name'] ??
                                                              "",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  "medium",
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 3,
                                                      ),
                                                      Container(
                                                        child: Text(
                                                          datajson![index][
                                                                  'poli_nama'] ??
                                                              "",
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  "medium",
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Visibility(
                                                        visible: datajson![
                                                                        index][
                                                                    'reg_buffer_status'] ==
                                                                "y"
                                                            ? true
                                                            : false,
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal: 5,
                                                                  vertical: 2),
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .amber[100],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 5),
                                                            child: Text(
                                                              "Menunggu",
                                                              style: TextStyle(
                                                                  fontSize: 11,
                                                                  fontFamily:
                                                                      "medium",
                                                                  color: Colors
                                                                          .amber[
                                                                      900]),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Visibility(
                                                    visible: datajson![index][
                                                                'status_antrian'] ==
                                                            "S"
                                                        ? false
                                                        : true,
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            SlidePageRoute(
                                                                page: antrian(
                                                              list: datajson!,
                                                              index: index,
                                                            )));
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Visibility(
                                                          visible: datajson![
                                                                          index]
                                                                      [
                                                                      'reg_antri_nomer'] ==
                                                                  null
                                                              ? false
                                                              : true,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(5),
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                          .green[
                                                                      100],
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8)),
                                                              child: Container(
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      "No Antrian",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontFamily:
                                                                              "medium",
                                                                          color:
                                                                              Colors.green[900]),
                                                                    ),
                                                                    Text(
                                                                      datajson![index]
                                                                              [
                                                                              'reg_antri_nomer'] ??
                                                                          "",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontFamily:
                                                                              "medium",
                                                                          color:
                                                                              Colors.green[900]),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        //
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          })),
            ),
          ],
        ),
      ),
    );
  }

  Container item(String img, String title, String subTitle, String msgInd,
      int clr, String time) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        margin: EdgeInsets.zero,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(
                  left: 10,
                  right: 2,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover, image: AssetImage(img))),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned.directional(
                            textDirection: Directionality.of(context),
                            top: -1,
                            end: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                title,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "medium",
                                    color: Colors.black),
                              ),
                            ),
                            //Space
                            SizedBox(
                              height: 3,
                            ),
                            Container(
                              child: Text(
                                subTitle,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "medium",
                                    color: Colors.black),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    //
                    InkWell(
                      onTap: () {
                        // conservationDialogue();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Image.asset(
                          "assets/icons/ic_menu.png",
                          scale: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //
              Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //
                    Container(
                      child: Text(
                        msgInd,
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: "medium",
                            color: Color(clr)),
                      ),
                    ),
                    //
                    Container(
                      child: Text(
                        time,
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: "medium",
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
