import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gocrane_v3/Widget/Alert.dart';
import 'package:gocrane_v3/main.dart';
import 'package:gocrane_v3/tampilan/tab/cameraAbsen.dart';
import 'package:gocrane_v3/tampilan/tab/beranda.dart';
import 'package:gocrane_v3/tampilan/tab/pengajuan/informasi.dart';
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
class gajiPage extends StatefulWidget {
  @override
  _gajiPageState createState() => _gajiPageState();
}

class _gajiPageState extends State<gajiPage> {
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
    setState(() {
      
    });
}
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

  String? jenis;
  List? jadwal;

  List? jenis_alber;

  List<dynamic>? jenis_bagian;

  Future ambildata() async {
    final prefs = await SharedPreferences.getInstance();

    var id_user = (prefs.get('pegawai_id'));
    final Response = await http.get(
      Uri.parse("${url}/${urlSubAPI}/Gaji/getGaji/$id_user"),
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

  String formatDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    String formattedDate = DateFormat('MMMM', 'id_ID').format(date);
    return formattedDate;
  }

  int calculateTotalGaji(
      String gajiPokok,
      String gajiUangMakan,
      String gajiPremiHadir,
      String gajiBpjsKes,
      String gajiBpjsTk,
      String potonganll) {
    int totalGaji = 0;
    totalGaji += int.parse(gajiPokok);
    totalGaji += int.parse(gajiUangMakan);
    totalGaji += int.parse(gajiPremiHadir);
    totalGaji -= int.parse(gajiBpjsKes);
    totalGaji -= int.parse(gajiBpjsTk);
    totalGaji -= int.parse(potonganll);
    return totalGaji;
  }

  String formatRupiah(String amount) {
    return 'Rp. ${amount.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')},00';
  }
// Variabel untuk menyimpan nilai terpilih dari dropdown jam akhir

  List? startTimeList;
  List? endTimeList;

  MediaQueryData? queryData;
  @override
  void initState() {
    ambildata();
    getTheme();
    get();
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
                Container(
                  height: 50,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      //back btn
                      Positioned.directional(
                        textDirection: Directionality.of(context),
                        start: 5,
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
                              scale: 15,
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
                            "Slip Gaji",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'inter',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        child: Column(
                          children: jadwal == null
                              ? []
                              : jadwal!.map((jw) {
                                  return Card(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Material(
                                            child: ListTile(
                                              title: Text(
                                                formatDate(
                                                    jw['gaji_tgl'] ?? ""),
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: ThemeManager().themeSingle,
                                                  fontFamily: "Inter",
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.07,
                                                ),
                                              ),
                                              subtitle: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Gaji Pokok",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey,
                                                          fontFamily: "Inter",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          letterSpacing: 0.07,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        formatRupiah(
                                                            jw['gaji_pokok'] ??
                                                                ""),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: "Inter",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          letterSpacing: 0.07,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Uang Makan",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey,
                                                          fontFamily: "Inter",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          letterSpacing: 0.07,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        formatRupiah(
                                                            jw['gaji_uang_makan'] ??
                                                                "0"),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: "Inter",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          letterSpacing: 0.07,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Premi Hadir",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey,
                                                          fontFamily: "Inter",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          letterSpacing: 0.07,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        formatRupiah(
                                                            jw['gaji_premi_hadir'] ??
                                                                ""),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: "Inter",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          letterSpacing: 0.07,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "BPJS Kesehatan",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey,
                                                          fontFamily: "Inter",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          letterSpacing: 0.07,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        formatRupiah(
                                                            jw['gaji_bpjs_kes'] ??
                                                                "0"),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: "Inter",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          letterSpacing: 0.07,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "BPJS Tenaga Kerjaan",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey,
                                                          fontFamily: "Inter",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          letterSpacing: 0.07,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        formatRupiah(
                                                            jw['gaji_bpjs_tk'] ??
                                                                "0"),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: "Inter",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          letterSpacing: 0.07,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "PPh",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey,
                                                          fontFamily: "Inter",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          letterSpacing: 0.07,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        formatRupiah(
                                                            jw['pph'] ?? "0"),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: "Inter",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          letterSpacing: 0.07,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Potongan Lain-lain",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey,
                                                          fontFamily: "Inter",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          letterSpacing: 0.07,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        formatRupiah(
                                                            jw['gaji_potongan'] ??
                                                                "0"),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: "Inter",
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          letterSpacing: 0.07,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 16),
                                                    child: Container(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              209,
                                                              209,
                                                              209),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              "Total Keseluruhan",
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
                                                            Spacer(),
                                                            Text(
                                                              formatRupiah(
                                                                  jw['total_gaji'] ??
                                                                      "0"),
                                                              // formatRupiah(calculateTotalGaji(
                                                              //             jw['gaji_pokok'] ??
                                                              //                 "0",
                                                              //             jw['gaji_uang_makan'] ??
                                                              //                 "0",
                                                              //             jw['gaji_premi_hadir'] ??
                                                              //                 "0",
                                                              //             jw['gaji_bpjs_kes'] ??
                                                              //                 "0",
                                                              //             jw['gaji_bpjs_tk'] ??
                                                              //                 "0",
                                                              //             jw['gaji_potongan'] ??
                                                              //                 "0")
                                                              //         .toString() ??
                                                              //     ""),
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
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                                    ),
                                  );
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
