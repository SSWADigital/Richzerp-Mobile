import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gocrane_v3/Widget/Alert.dart';
import 'package:gocrane_v3/main.dart';

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
class Pcuti extends StatefulWidget {
  @override
  _PcutiState createState() => _PcutiState();
}

class _PcutiState extends State<Pcuti> {
  DateTime currentDate = new DateTime.now();
  var dateVal;
  var now = new DateTime.now();
  Future<void> openDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != currentDate) {
      setState(() {
        dateVal = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  DateTime currentDateEnd = new DateTime.now();
  var datatglakhir;
  var tgl_akhir;

  // var now = new DateTime.now();

  //alber
  List? datajson;

  Future ambildata() async {
    final prefs = await SharedPreferences.getInstance();

    var id_user = (prefs.get('pegawai_id'));
    print("id_user: $id_user");
    print("${url}/${urlSubAPI}/Cuti/getCutiHistory/$id_user");
    final Response = await http.get(
      Uri.parse("${url}/${urlSubAPI}/Cuti/getCutiHistory/$id_user"),
    );
    var _data = jsonDecode(Response.body);

    if (this.mounted) {
      setState(() {
        if (_data == false) {
          // chek = "Belum Ada Data";

          this.setState(() {
            //    cek_absen = "0";
          });
        } else {
          this.setState(() {
            cutiData = _data;
            print(cutiData);
          });
        }
      });
    }
  }

  String? jenis;
  // List? cutiData;
  // List cutiData = [
  //   {
  //     "riwayat_cuti_tanggal": "2024-01-01",
  //     "cuti_nama": "Cuti Tahunan",
  //     "shift_kode": "SS",
  //     "cuti_status": "y",
  //     "cuti_maks": "3",
  //   },
  //   {
  //     "riwayat_cuti_tanggal": "2024-01-05",
  //     "cuti_nama": "Cuti Tahunan",
  //     "shift_kode": "SS",
  //     "cuti_maks": "3",
  //     "cuti_status": "n",
  //   },
  //   {
  //     "riwayat_cuti_tanggal": "2024-01-15",
  //     "cuti_nama": "Cuti Tahunan",
  //     "shift_kode": "SS",
  //     "cuti_maks": "3",
  //     "cuti_status": "x",
  //   },
  // ];

  List? cutiData;
  String formatDate(String dateStr) {
    if (dateStr == "") {
      return "-";
    } else {
      DateTime date = DateTime.parse(dateStr);
      String formattedDate =
          DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(date);
      return formattedDate;
    }
  }

  int _calculateTotalDays(String startDate, String endDate) {
    DateTime startDateTime = DateTime.parse(startDate);
    DateTime endDateTime = DateTime.parse(endDate);
    Duration difference = endDateTime.difference(startDateTime);
    return difference.inDays +
        1; // Menambahkan 1 karena ingin memasukkan hari terakhir
  }

  List? jenis_alber;

  List<dynamic>? jenis_bagian;

// Variabel untuk menyimpan nilai terpilih dari dropdown jam akhir

  List? startTimeList;
  List? endTimeList;

  MediaQueryData? queryData;
  @override
  void initState() {
    ambildata();

    // lihatprofil();
    // TODO: implement initState
    super.initState();
  }

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

                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        child: Column(
                          children: cutiData == null
                              ? []
                              : cutiData!.map((jw) {
                                  return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: ColoredBox(
                                            color: Colors.green,
                                            child: Material(
                                              child: ListTile(
                                                title: Text(
                                                  formatDate(
                                                      jw['cuti_tgl_mulai'] ??
                                                          ""),
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontFamily: "Inter",
                                                    fontWeight: FontWeight.w700,
                                                    letterSpacing: 0.07,
                                                  ),
                                                ),
                                                subtitle: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      jw['cuti_tgl_mulai'] !=
                                                                  null &&
                                                              jw['cuti_tgl_selesai'] !=
                                                                  null
                                                          ? ' ${_calculateTotalDays(jw['cuti_tgl_mulai'], jw['cuti_tgl_selesai'])} Hari'
                                                          : '',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.green,
                                                        fontFamily: "Inter",
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        letterSpacing: 0.07,
                                                      ),
                                                    ),
                                                    Text(
                                                      jw['jenis_cuti_nama'] ??
                                                          "",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.green,
                                                        fontFamily: "Inter",
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        letterSpacing: 0.07,
                                                      ),
                                                    ),
                                                    if (jw['cuti_keterangan_hrd'] !=
                                                        null)
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors
                                                                  .black), // Atur warna garis
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4),
                                                          child: Text(
                                                            jw['cuti_keterangan_hrd'] ??
                                                                "",
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  "Inter",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              letterSpacing:
                                                                  0.07,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                trailing: Column(
                                                  children: [
                                                    Visibility(
                                                      visible:
                                                          jw['cuti_status'] ==
                                                                  "p"
                                                              ? true
                                                              : false,
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 5,
                                                                vertical: 2),
                                                        decoration: BoxDecoration(
                                                            color: const Color
                                                                .fromARGB(255,
                                                                86, 230, 95),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8)),
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5),
                                                          child: Text(
                                                            "Disetujui",
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              fontFamily:
                                                                  "medium",
                                                              color: Colors
                                                                  .green[900],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible:
                                                          jw['cuti_status'] ==
                                                                  "n"
                                                              ? true
                                                              : false,
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 5,
                                                                vertical: 2),
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .yellow[50],
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
                                                                  .amber[900],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible:
                                                          jw['cuti_status'] ==
                                                                  "y"
                                                              ? true
                                                              : false,
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 5,
                                                                vertical: 2),
                                                        decoration: BoxDecoration(
                                                            color: const Color
                                                                .fromARGB(255,
                                                                214, 214, 214),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8)),
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5),
                                                          child: Text(
                                                            "Selesai",
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                fontFamily:
                                                                    "medium",
                                                                color: Colors
                                                                    .grey[700]),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible:
                                                          jw['cuti_status'] ==
                                                                  "x"
                                                              ? true
                                                              : false,
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 5,
                                                                vertical: 2),
                                                        decoration: BoxDecoration(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    253,
                                                                    112,
                                                                    112),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8)),
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5),
                                                          child: Text(
                                                            "Ditolak",
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              fontFamily:
                                                                  "medium",
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      110,
                                                                      4,
                                                                      4),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )),
                                      ));
                                }).toList(),
                        ),
                      ),

                      //
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //
}
