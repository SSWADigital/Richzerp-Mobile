import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gocrane_v3/tampilan/SlideRightRoute.dart';

import 'package:gocrane_v3/tampilan/tab/beranda.dart';

// import 'package:geolocator/geolocator.dart';

// import 'package:gocrane_v3/UI/posisi.dart';

import 'package:gocrane_v3/main.dart';
import 'package:gocrane_v3/tampilan/tab/schedule/antrian.dart';
import 'package:gocrane_v3/tampilan/tab/schedule/buktiTransaksi.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

class penilaian extends StatefulWidget {
  @override
  _penilaianState createState() => _penilaianState();
}

class _penilaianState extends State<penilaian> {
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
        body: {"aksi": "8", 'nik': nik});
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

  int dataReting = 0;
  TextEditingController isikomentar = TextEditingController();

  @override
  void initState() {
    ambildata();

    ambildata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              height: 80,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  //back btn
                  Positioned.directional(
                    textDirection: Directionality.of(context),
                    start: -4,
                    top: 10,
                    bottom: 0,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          "assets/icons/ic_back.png",
                          scale: 30,
                        ),
                      ),
                    ),
                  ),
                  //title
                  Positioned.directional(
                    textDirection: Directionality.of(context),
                    top: 10,
                    bottom: 0,
                    start: 0,
                    end: 0,
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Beri Penilaian",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'medium',
                            color: Colors.black),
                      ),
                    ),
                  ),
                ],
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
                                  Navigator.push(
                                      context,
                                      SlidePageRoute(
                                          page: buktiTransaksi(
                                        list: datajson!,
                                        index: index,
                                      )));
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
                                                      //Space
                                                      SizedBox(
                                                        height: 3,
                                                      ),
                                                      buildRatingForm(
                                                          'Ketepatan Waktu :',
                                                          dataReting, (value) {
                                                        setState(() {
                                                          dataReting = value;
                                                        });
                                                      }, isikomentar),

                                                      SizedBox(
                                                        height: 3,
                                                      ),
                                                    ],
                                                  ),
                                                ),
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

                              //  Card(
                              //   elevation: 3,
                              //   shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(9)),
                              //   child: Stack(
                              //     clipBehavior: Clip.none,
                              //     children: [
                              //       Container(
                              //         padding: EdgeInsets.symmetric(
                              //             horizontal: 8, vertical: 12),
                              //         child: Column(
                              //           crossAxisAlignment: CrossAxisAlignment.start,
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.spaceBetween,
                              //           children: [
                              //             //img
                              //             Card(
                              //               elevation: 1,
                              //               shape: RoundedRectangleBorder(
                              //                   borderRadius:
                              //                       BorderRadius.circular(6)),
                              //               child: Container(
                              //                 width: 100,
                              //                 height: 120,
                              //                 margin: EdgeInsets.symmetric(
                              //                     horizontal: 2, vertical: 2),
                              //                 decoration: BoxDecoration(
                              //                     borderRadius:
                              //                         BorderRadius.circular(6),
                              //                     image: DecorationImage(
                              //                         fit: BoxFit.cover,
                              //                         image: NetworkImage(
                              //                             datajson[index]
                              //                                 ['lokasi_foto']))),
                              //               ),
                              //             ),
                              //             //Dr. Dimitri
                              //             Container(
                              //               padding: EdgeInsets.only(top: 5),
                              //               child: Text(
                              //                 datajson[index]['pegawai_nama'],
                              //                 style: TextStyle(
                              //                     fontSize: 15,
                              //                     fontWeight: FontWeight.w600,
                              //                     fontFamily: "medium",
                              //                     color: Colors.black),
                              //               ),
                              //             ),
                              //             //Dentist
                              //             Container(
                              //               padding: EdgeInsets.only(bottom: 5),
                              //               child: Text(
                              //                 "Dokter Umum",
                              //                 style: TextStyle(
                              //                     fontSize: 12,
                              //                     fontFamily: "medium",
                              //                     color: Colors.black),
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //       Positioned.directional(
                              //           textDirection: Directionality.of(context),
                              //           end: -1,
                              //           top: -21,
                              //           child: Container(
                              //             width: 65,
                              //             height: 70,
                              //             decoration: BoxDecoration(
                              //                 image: DecorationImage(
                              //                     fit: BoxFit.cover,
                              //                     image: AssetImage(
                              //                         "assets/icons/ic_bg.png"))),
                              //             child: Row(
                              //               mainAxisAlignment:
                              //                   MainAxisAlignment.center,
                              //               children: [
                              //                 Image.asset(
                              //                   "assets/icons/ic_star.png",
                              //                   scale: 38,
                              //                   color: Colors.black,
                              //                 ),
                              //                 Container(
                              //                   padding: EdgeInsets.only(
                              //                       left: 3, right: 7),
                              //                   child: Text(
                              //                     "4.5",
                              //                     style: TextStyle(
                              //                         fontSize: 12.0,
                              //                         fontFamily: "medium",
                              //                         color: Colors.black),
                              //                   ),
                              //                 )
                              //               ],
                              //             ),
                              //           ))
                              //     ],
                              //   ),
                              // ),
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

Widget buildRatingForm(String label, int rating, ValueChanged<int> onChanged,
    TextEditingController komentar) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildStar(1, rating, onChanged),
          buildStar(2, rating, onChanged),
          buildStar(3, rating, onChanged),
          buildStar(4, rating, onChanged),
          buildStar(5, rating, onChanged),
        ],
      ),
      SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          width: 318,
          height: 104,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 4,
                offset: Offset(0, 0),
              ),
            ],
            color: Colors.white,
          ),
          child: TextField(
            maxLines: 4,
            controller: komentar,
            // Jumlah baris yang ingin ditampilkan
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(8),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget buildStar(int value, int rating, ValueChanged<int> onChanged) {
  IconData iconData = value <= rating ? Icons.star : Icons.star_border;

  return GestureDetector(
    onTap: () {
      onChanged(value);
    },
    child: Icon(
      iconData,
      color: Color(0xff2ab2a2),
      size: 40,
    ),
  );
}
