import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:gocrane_v3/tampilan/tab/beranda.dart';

// import 'package:geolocator/geolocator.dart';

// import 'package:gocrane_v3/UI/posisi.dart';

import 'package:gocrane_v3/main.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class antrian extends StatefulWidget {
  const antrian({
    required this.list,
    required this.index,
  });
  final List list;
  final int index;

  @override
  State<antrian> createState() => _antrianState();
}

class _antrianState extends State<antrian> {
  final cardNumbController = TextEditingController();
  final nameController = TextEditingController();
  final expiryController = TextEditingController();
  final securityController = TextEditingController();

  //
  DateTime currentDate = new DateTime.now();
  var dateVal;
  var now = new DateTime.now();
  Future<void> openDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate,
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != currentDate) {
      setState(() {
        dateVal = DateFormat('MM/yyyy').format(picked);
      });
    }
  }

  //

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  void validate(name, card, month, year, cvc) {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
    } else {
      print('Form is invalid');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  String? NoSekarang;
  String? NoBerikutnya;
  String? NoSudah;

  Future S() async {
    final Response = await http.post(
        Uri.parse("http://103.157.97.200/nusamedis/API/antrian.php"),
        body: {
          "aksi": "S",
          'id_poli': widget.list[widget.index]['id_poli'],
          'id_dokter': widget.list[widget.index]['usr_id']
        });

    if (this.mounted) {
      this.setState(() {
        var datajson = jsonDecode(Response.body);
        if (datajson == null) {
          NoSudah = "-";
        } else {
          NoSudah = datajson[0]['no_antrian_pasien'];
        }
      });
    }
  }

  Future A() async {
    final Response = await http.post(
        Uri.parse("http://103.157.97.200/nusamedis/API/antrian.php"),
        body: {
          "aksi": "A",
          'id_poli': widget.list[widget.index]['id_poli'] ?? "",
          'id_dokter': widget.list[widget.index]['usr_id'] ?? ""
        });

    if (this.mounted) {
      this.setState(() {
        var datajson = jsonDecode(Response.body);
        if (datajson != false) {
          NoBerikutnya = datajson[0]['no_antrian_pasien'] ?? "";
        } else {
          NoBerikutnya = "-";
        }
      });
    }
  }

  Future L() async {
    final Response = await http.post(
        Uri.parse("http://103.157.97.200/nusamedis/API/antrian.php"),
        body: {
          "aksi": "L",
          'id_poli': widget.list[widget.index]['id_poli'] ?? "",
          'id_dokter': widget.list[widget.index]['usr_id'] ?? ""
        });
    var datajson = jsonDecode(Response.body);
    if (this.mounted) {
      this.setState(() {
        var datajson = jsonDecode(Response.body);
        if (datajson != false) {
          NoSekarang = datajson[0]['no_antrian_pasien'];
        } else {
          NoSekarang = "-";
        }
      });
    }
  }

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 2), (Timer timer) {
      A();
      L();
      S();
    });

    super.initState();
  }

  // A  = sedang antri
  // P  = Panggil Pasien
  // L  = Layani
  // S  = Sudah di Layani
  int _waktuRating = 0;
  int _pelayananRating = 0;
  int _performaAlatRating = 0;
  int _performaOperatorRating = 0;

  MediaQueryData? queryData;
  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return MediaQuery(
      data: queryData!.copyWith(textScaleFactor: 1.0),
      child: SafeArea(
        child: Scaffold(
          body: Container(
            child: Column(
              children: [
                //Appbar
                Container(
                  height: 50,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      //back btn
                      Positioned.directional(
                        textDirection: Directionality.of(context),
                        start: -4,
                        top: 0,
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
                        top: 0,
                        bottom: 0,
                        start: 0,
                        end: 0,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "ANTRIAN POLI",
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
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        width: 243,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x0C000000),
                              blurRadius: 28,
                              offset: Offset(0, 0),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                                decoration: ShapeDecoration(
                                  color: Color(0xFF00AA00),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'NOMOR ANTRIAN SAAT INI',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'A003',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'PASIEN',
                                            style: TextStyle(
                                              color: Color(0xFFA5A5A5),
                                              fontSize: 12,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Suharso',
                                                  style: TextStyle(
                                                    color: Color(0xFF141414),
                                                    fontSize: 16,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'No. RM 4455670099',
                                                  style: TextStyle(
                                                    color: Color(0xFF141414),
                                                    fontSize: 12,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            '${widget.list[widget.index]['reg_buffer_tanggal']}',
                                            style: TextStyle(
                                              color: Color(0xFF141414),
                                              fontSize: 14,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Container(
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Klinik',
                                                  style: TextStyle(
                                                    color: Color(0xFFA5A5A5),
                                                    fontSize: 12,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${widget.list[widget.index]['poli_nama']}',
                                                  style: TextStyle(
                                                    color: Color(0xFF141414),
                                                    fontSize: 12,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 46),
                                          Container(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Jenis Pasien',
                                                  style: TextStyle(
                                                    color: Color(0xFFA5A5A5),
                                                    fontSize: 12,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Asuransi',
                                                  style: TextStyle(
                                                    color: Color(0xFF141414),
                                                    fontSize: 12,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'NOMOR ANTRIAN',
                                            style: TextStyle(
                                              color: Color(0xFFA5A5A5),
                                              fontSize: 12,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            ' ${widget.list[widget.index]['reg_antri_nomer']}',
                                            style: TextStyle(
                                              color: Color(0xFF007100),
                                              fontSize: 48,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      //Space
                      // Container(
                      //   padding: EdgeInsets.all(20),
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: <Widget>[
                      //       CircleAvatar(
                      //         radius: 60,
                      //         backgroundImage: AssetImage(
                      //             'assets/icons/ic_hospital.png'), // Ganti dengan foto dokter
                      //       ),
                      //       SizedBox(height: 20),
                      //       Text(
                      //         'Nomor Antrian: ${widget.list[widget.index]['reg_antri_nomer']}',
                      //         style: TextStyle(
                      //             fontSize: 24, fontWeight: FontWeight.bold),
                      //       ),
                      //       SizedBox(height: 20),
                      //       Container(
                      //         padding: EdgeInsets.all(10),
                      //         decoration: BoxDecoration(
                      //           color: Colors.blue,
                      //           borderRadius: BorderRadius.circular(10),
                      //         ),
                      //         child: Column(
                      //           children: [
                      //             Text(
                      //               'Sedang Dilayani',
                      //               style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontSize: 18,
                      //                 fontWeight: FontWeight.bold,
                      //               ),
                      //             ),
                      //             Text(
                      //               NoSekarang ?? "",
                      //               style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontSize: 24,
                      //                 fontWeight: FontWeight.bold,
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //       SizedBox(height: 20),
                      //       Container(
                      //         padding: EdgeInsets.all(10),
                      //         decoration: BoxDecoration(
                      //           color: Colors.blue,
                      //           borderRadius: BorderRadius.circular(10),
                      //         ),
                      //         child: Column(
                      //           children: [
                      //             Text(
                      //               'Antrian Selanjutnya',
                      //               style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontSize: 18,
                      //                 fontWeight: FontWeight.bold,
                      //               ),
                      //             ),
                      //             Text(
                      //               NoBerikutnya ?? "",
                      //               style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontSize: 24,
                      //                 fontWeight: FontWeight.bold,
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //       SizedBox(height: 30),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //         children: [
                      //           InfoCard(
                      //               icon: Icons.person,
                      //               text: widget.list[widget.index]
                      //                   ["usr_name"]),
                      //           InfoCard(
                      //               icon: Icons.location_on,
                      //               text: widget.list[widget.index]
                      //                   ['poli_nama']),
                      //         ],
                      //       ),
                      //       SizedBox(height: 30),
                      //       ElevatedButton(
                      //         onPressed: () {
                      //           Navigator.push(
                      //               context,
                      //               SlidePageRoute(
                      //                   page: bukti_reg(
                      //                 list: widget.list,
                      //                 index: widget.index,
                      //               )));
                      //           // Tambahkan aksi tombol di sini
                      //         },
                      //         style: ElevatedButton.styleFrom(
                      //             primary: Colors.blue),
                      //         child: Text('KARTU REGISTRASI',
                      //             style: TextStyle(fontSize: 16)),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                )
              ],
            ),
          ),
          // bottomNavigationBar: BottomAppBar(
          //   elevation: 5,
          //   child: Container(
          //     height: 70,
          //     child: Container(
          //       padding: EdgeInsets.symmetric(horizontal: 16),
          //       child: Row(
          //         children: [
          //           Expanded(
          //             child: MaterialButton(
          //               height: 44,
          //               onPressed: () {
          //                 FocusScope.of(context).requestFocus(FocusNode());
          //                 check();
          //               },
          //               shape: RoundedRectangleBorder(
          //                   borderRadius: BorderRadius.circular(6)),
          //               color: Colors.blue,

          //               //  isSave
          //               //     ? Theme.of(context).accentTextTheme.headline1.color
          //               //     : Theme.of(context)
          //               //         .primaryTextTheme
          //               //         .headline3
          //               //         .color,
          //               elevation: 0,
          //               highlightElevation: 0,
          //               child: Container(
          //                 child: Text(
          //                   "Simpan",
          //                   style: TextStyle(
          //                       color:
          //                           Theme.of(context).textTheme.subtitle2.color,
          //                       fontSize: 15,
          //                       fontFamily: 'medium'),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String? text;

  InfoCard({required this.icon, this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Colors.blue),
        SizedBox(height: 10),
        Text(text!, style: TextStyle(fontSize: 16)),
      ],
    );
  }
}

Widget buildRatingForm(String label, int rating, ValueChanged<int> onChanged) {
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
