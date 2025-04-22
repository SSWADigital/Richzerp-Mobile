import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gocrane_v3/Widget/Alert.dart';
import 'package:gocrane_v3/main.dart';

import 'package:gocrane_v3/tampilan/tab/cameraAbsen.dart';
import 'package:gocrane_v3/tampilan/tab/beranda.dart';
import 'package:gocrane_v3/tampilan/tab/pengajuan/informasi.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
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
class Plembur extends StatefulWidget {
  @override
  _PlemburState createState() => _PlemburState();
}

class _PlemburState extends State<Plembur> {
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
  Future alber_list() async {
    final Response = await http.post(
      Uri.parse("http://101.50.2.211/api_gocrane/alber.php"),
    );
    if (this.mounted) {
      this.setState(() {
        jenis_alber = jsonDecode(Response.body);
      });
    }
  }

  Future ambildata() async {
    final prefs = await SharedPreferences.getInstance();

    var id_user = (prefs.get('pegawai_id'));
    final Response = await http.get(
      Uri.parse("${url}/${urlSubAPI}/Lembur/getlemburHistory/$id_user"),
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
            jadwal = _data;
            print(jadwal);
          });
        }
      });
    }
  }

  String? jenis;
  List? jadwal;
  // List jadwal = [
  //   {
  //     "tgl": "8 Agustus 2023",
  //     "lembur_tipe": "Normal Lembur",
  //     "shift_kode": "SS",
  //     "status": "y",
  //     "durasi": "3",
  //     "waktu": "17:00-14:00",
  //     "keterangan": "Mengganti teman",
  //   },
  //   {
  //     "tgl": "8 September 2023",
  //     "lembur_tipe": "Normal Lembur",
  //     "shift_kode": "SS",
  //     "durasi": "3",
  //     "status": "n",
  //     "waktu": "17:00-14:00",
  //     "keterangan": "Ada pekerjaan yang harus di selesaikan",
  //   },
  //   {
  //     "tgl": "8 Desember 2023",
  //     "lembur_tipe": "Normal Lembur",
  //     "shift_kode": "SS",
  //     "durasi": "3",
  //     "status": "x",
  //     "waktu": "17:00-14:00",
  //     "keterangan": "Ada pekerjaan yang harus di selesaikan",
  //   },
  // ];

  List? jenis_alber;

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

  List<dynamic>? jenis_bagian;
  int _calculateTotalHours(String startTime, String endTime) {
    // Parsing string waktu ke dalam objek DateTime dengan tanggal sembarang (untuk memudahkan perhitungan)
    DateTime startDateTime = DateTime.parse('2000-01-01 $startTime');
    DateTime endDateTime = DateTime.parse('2000-01-01 $endTime');

    // Menghitung selisih waktu dalam jam
    Duration difference = endDateTime.difference(startDateTime);
    return difference.inHours;
  }
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
                          children: jadwal == null
                              ? []
                              : jadwal!.map((jw) {
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
                                                      jw['lembur_tgl'] ?? ""),
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
                                                      "${jw['jenis_lembur_nama']}",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: "Inter",
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        letterSpacing: 0.07,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          jw['lembur_jam_mulai'] !=
                                                                      null &&
                                                                  jw['lembur_jam_selesai'] !=
                                                                      null
                                                              ? '${_calculateTotalHours(jw['lembur_jam_mulai'], jw['lembur_jam_selesai'])} Jam'
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
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 10),
                                                          child: Text(
                                                            "${jw['lembur_jam_mulai']}-${jw['lembur_jam_selesai']}",
                                                            style: TextStyle(
                                                              fontSize: 14,
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
                                                      ],
                                                    ),
                                                    Text(
                                                      jw['lembur_keterangan'] ??
                                                          "",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey,
                                                        fontFamily: "Inter",
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        letterSpacing: 0.07,
                                                      ),
                                                    ),
                                                    if (jw['lembur_keterangan_hrd'] !=
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
                                                            jw['lembur_keterangan_hrd'] ??
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
                                                          jw['lembur_status'] ==
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
                                                          jw['lembur_status'] ==
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
                                                          jw['lembur_status'] ==
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
                                                          jw['lembur_status'] ==
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
