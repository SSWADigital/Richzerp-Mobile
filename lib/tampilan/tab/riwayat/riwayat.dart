import 'dart:convert';
import 'dart:io';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:gocrane_v3/Widget/Alert.dart';
import 'package:gocrane_v3/main.dart';
import 'package:gocrane_v3/tampilan/SlideRightRoute.dart';

import 'package:gocrane_v3/tampilan/tab/cameraAbsen.dart';
import 'package:gocrane_v3/tampilan/tab/beranda.dart';
import 'package:gocrane_v3/tampilan/tab/pengajuan/informasi.dart';
import 'package:gocrane_v3/tampilan/tab/riwayat/detailRiwayat.dart';
import 'package:gocrane_v3/theme_manager.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

String? poliid;
String? id_dep;
String? kode_reservasi;
String? namapoli;
String? tglbooking;
String? nama_dokter;
String? id_dokter;
String? id_jam;

// ignore: must_be_immutable
class riwayatAbsen extends StatefulWidget {
  @override
  _riwayatAbsenState createState() => _riwayatAbsenState();
}

class _riwayatAbsenState extends State<riwayatAbsen> {

  List<Color> theme = [Colors.grey, Colors.black];
  Color themeSingle = Colors.grey;

final Map<String, List<Color>> departmentColors = {
  "1": [const Color(0xFF0000FF), const Color(0xFF87CEFA)], 
  "01": [const Color(0xFF11A211), const Color(0xFF32CD32)],
  "03": [const Color(0xFFFFD700), const Color(0xFFFFC125)],
  "04": [const Color(0xFFFF0000), const Color(0xFFFFA07A)],
};

final Map<String, Color> singleColors = {
  "1": const Color(0xFF0000FF), 
  "01": const Color(0xFF0D7F0D),
  "03": const Color(0xFFFFD700),
  "04": const Color(0xFFFF0000),
};

Future<void> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    String? idDep = prefs.get('departemen_id') as String?;

    if (idDep != null) {
      await ThemeManager().fetchColorConfiguration(idDep);
    }
  }

var idDep = "0";

List<Color> getColorsByDepartment(String idDepartemen) {
  return departmentColors[idDepartemen] ?? [Colors.grey, Colors.black]; // Default warna
}
Color getColorsByDepartmentSingle(String idDepartemen) {
  return singleColors[idDepartemen] ?? Colors.grey; // Default warna
}

get() async {
  final prefs = await SharedPreferences.getInstance();

    idDep = (prefs.get('departemen_id')) as String;
    print("idDep: $idDep");
    theme = getColorsByDepartment(idDep);
    themeSingle = getColorsByDepartmentSingle(idDep);
}

  TextEditingController txttanggal = TextEditingController();
  List<Map<String, dynamic>> list = [
    {
      "img": "assets/imgs/download 1.png",
      "name": "Rumah Sakit Indriati",
      "jarak": "200 m",
      "msgStatus": "New message",
      "timing": "21 minutes ago",
      "color": 0xFF4CAF50,
    },
    {
      "img": "assets/imgs/rs1.png",
      "name": "Rumah Sakit Moewardi",
      "jarak": "3 km",
      "msgStatus": "Ongoing",
      "timing": "32 minutes ago",
      "color": 0xFF4285f4,
    },
    {
      "img": "assets/imgs/rs2.png",
      "name": "Rumah Sakit JIH Surakarta",
      "jarak": "2 km",
      "msgStatus": "Ended 13:02",
      "timing": "2 days ago",
      "color": 0xAA5c5c8a,
    },
  ];

  /////////////////////////////////////////////////////////////////////////////
  String formatDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    String formattedDate =
        DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(date);
    return formattedDate;
  }

  String chek = "";

  String? _masuk;
  String? _keluar;

  String? absensiId; // mengambil absen absensi_id
  String? idUser; // mengambil absen id_user
  String? tanggal; // mengambil absen tanggal
  String? checkIn; // mengambil absen check_in
  String? checkOut; // mengambil absen check_out
  String? locCheckIn; // mengambil absen loc_check_in
  String? locCheckOut; // mengambil absen loc_check_out
  String? fotoCheckIn; // mengambil absen foto_check_in
  String? fotoCheckOut;

  String? cek_absen;
  Future ambildata() async {
    final prefs = await SharedPreferences.getInstance();

    var id_user = (prefs.get('pegawai_id'));
    final Response = await http.get(
      Uri.parse("${url}/${urlSubAPI}/absen/getAbsenHistory/$id_user"),
    );

    var _data = jsonDecode(Response.body);
    if (_data == false) {
      chek = "Belum Ada Data";

      this.setState(() {
        cek_absen = "0";
      });
    } else {
      this.setState(() {
        absen = _data;
      });
    }
  }

  Future ambilfilter() async {
    final prefs = await SharedPreferences.getInstance();

    var id_user = (prefs.get('pegawai_id'));
    var tanggal_filter = txttanggal.text;
    final Response = await http.get(
      Uri.parse(
          "${url}/${urlSubAPI}/absen/getAbsenHistory/$id_user/$tanggal_filter"),
    );
    var _data = jsonDecode(Response.body);
    if (_data == false) {
      chek = "Belum Ada Data";

      this.setState(() {
        cek_absen = "0";
      });
    } else {
      this.setState(() {
        absen = _data;
      });
    }
  }

  List? absen;
  /////////////////////////////////////////////////////////////////////////////
  // List absen = [
  //   {
  //     "tanggal": "2024-01-04",
  //     "check_in": "07:00",
  //     "check_out": "15:00",
  //     "absensi_id": "2",
  //     "gaji_makan": "300.000",
  //     "gaji_transpot": "400.000",
  //   },
  //   {
  //     "tanggal": "2024-01-03",
  //     "check_in": "07:00",
  //     "check_out": "15:00",
  //     "absensi_id": "2",
  //     "gaji_makan": "300.000",
  //     "gaji_transpot": "400.000",
  //   },
  //   {
  //     "tanggal": "2024-01-02",
  //     "check_in": "07:00",
  //     "check_out": "",
  //     "absensi_id": "2",
  //     "gaji_makan": "300.000",
  //     "gaji_transpot": "400.000",
  //   },
  // ];
  // List _tanggal = [
  //   "assets/imgs/download 1.png",
  //   "assets/imgs/rs1.png",
  //   "assets/imgs/rs2.png",
  // ];

  String? idAbsen;
  int? tapIndex;
  @override
  void initState() {
    super.initState();
    ambildata();
    getTheme();
    tapIndex;
  }

  MediaQueryData? queryData;
  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return MediaQuery(
      data: queryData!.copyWith(textScaleFactor: 1.0),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            child: Column(
              children: [
                //Appbar
                Container(
                  decoration: BoxDecoration(color: ThemeManager().themeSingle),
                  height: 75,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      //back btn

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
                              "Laporan Absensi",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 360,
                  child: Text(
                    "Riwayat",
                    style: TextStyle(
                      color: Color(0xff141414),
                      fontSize: 16,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 360,
                  height: 155,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 30,
                        offset: Offset(0, 13),
                      ),
                    ],
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 14,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DateTimePicker(
                        initialValue: '',

                        dateMask: 'd - MM - yyyy',
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.calendar_today,
                              color: Colors.black54,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black54,
                              ),
                              // borderRadius: BorderRadius.circular(20),
                            ),

                            //icon: Icon(Icons.perm_identity),
                            hintText: "Pilih Tanggal",
                            hintStyle: TextStyle(
                              color: Colors.black54,
                            ),
                            // contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 5,),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                        dateLabelText: 'Date',
                        onChanged: (value) => txttanggal.text = (value),

                        onSaved: (value) => txttanggal.text = (value)!,

                        // onChanged: (val) => txtSampai,

                        // onSaved: (val) => txtSampai,
                        // onChanged: (val) => print(val),
                        // validator: (val) {
                        //   print(val);
                        //   return null;
                        // },
                        // onSaved: (val) => print(val),
                      ),
                      SizedBox(height: 15),
                      MaterialButton(
                        onPressed: () {
                          ambilfilter();
                          print("nulllllllllllllll");
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: ThemeManager().themeSingle,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Cari",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 360,
                  child: Text(
                    "Absensi Terbaru",
                    style: TextStyle(
                      color: Color(0xff141414),
                      fontSize: 16,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // Container(
                //   height: MediaQuery.of(context).size.height * 0.4,
                //   child: googleMap(context),
                // )
                Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: absen == null ? 0 : absen!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: BorderSide(
                                      width: 1,
                                      color: tapIndex == index
                                          ? Colors.black
                                          : Colors.transparent)),
                              margin: EdgeInsets.zero,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    tapIndex = index;
                                    //isTap = true;
                                    Navigator.push(
                                        context,
                                        SlidePageRoute(
                                            page: detailRiwayat(
                                          absensiId:
                                              absen![index]["absen_id"] ?? "",
                                        )));
                                  });
                                },
                                child: Container(
                                  width: 328,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x07000000),
                                        blurRadius: 16,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                    color: Colors.white,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 14,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        formatDate(
                                            absen![index]["tanggal"] ?? ""),
                                        style: TextStyle(
                                          color: Color(0xff284184),
                                          fontSize: 14,
                                          fontFamily: "Inter",
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Container(
                                        width: double.infinity,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Check In",
                                                  style: TextStyle(
                                                    color: Color(0xff141414),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  "Check Out",
                                                  style: TextStyle(
                                                    color: Color(0xff141414),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                              ],
                                            ),
                                            SizedBox(width: 190),
                                            Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    absen![index]["checkin"] ??
                                                        "-",
                                                    style: TextStyle(
                                                      color: Color(0xff141414),
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    absen![index]["checkout"] ??
                                                        "-",
                                                    style: TextStyle(
                                                      color: Color(0xff141414),
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        })),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //
}
