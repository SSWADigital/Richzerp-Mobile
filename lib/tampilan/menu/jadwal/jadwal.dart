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
class jadwalPage extends StatefulWidget {
  @override
  _jadwalPageState createState() => _jadwalPageState();
}

class _jadwalPageState extends State<jadwalPage> {

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
  var tgl_awal_ymd;
  var tgl_akhir_ymd;
  String?
      selectedStartTime; // Variabel untuk menyimpan nilai terpilih dari dropdown jam awal
  String? selectedEndTime;
  String? dp_id;
  String? bagian_jenis;
  String? alber_jenis;
  String? user_nama;
  String? shift_awal;
  String? shift_akhir;
  TextEditingController tanggalawal = TextEditingController();
  TextEditingController tanggalakhir = TextEditingController();
  TextEditingController jamawal = TextEditingController();
  TextEditingController jamakhir = TextEditingController();
  TextEditingController jenisalber = TextEditingController();
  TextEditingController departemen = TextEditingController();
  TextEditingController bagian = TextEditingController();
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

  Future<void> bagian_pilih() async {
    final response = await http.get(
      Uri.parse(
          "http://101.50.2.211/gocraneapp_v2/production/buat_order/bagian.php?id=$dp_id"),
    );

    this.setState(() {
      jenis_bagian = jsonDecode(response.body);
      print(jenis_bagian);

      // TODO: Lakukan sesuatu dengan datajson (misalnya, perbarui tampilan UI).
    });
  }

  Future profil() async {
    final prefs = await SharedPreferences.getInstance();

    var id_user = (prefs.get('usr_id'));

    final Response = await http.post(
        Uri.parse("http://101.50.2.211/api_gocrane/profil.php"),
        body: {"id_usr": "1"});

    this.setState(() {
      var datajson = jsonDecode(Response.body);

      departemen.text = datajson['profile'][0]["struk_nama"];
      dp_id = datajson['profile'][0]["struk_id"];
    });
  }

  String? jenis;
  List? jadwal;
  Future ambildata() async {
    final prefs = await SharedPreferences.getInstance();

    var id_user = (prefs.get('pegawai_id'));
    final Response = await http.get(
      Uri.parse("${url}/${urlSubAPI}/Jadwal/getJadwal/$id_user"),
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

  List? jenis_alber;

  List<dynamic>? jenis_bagian;

// Variabel untuk menyimpan nilai terpilih dari dropdown jam akhir

  List? startTimeList;
  List? endTimeList;

  String formatDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    String formattedDate =
        DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(date);
    return formattedDate;
  }

  int _calculateTotalDays(String startDate, String endDate) {
    DateTime startDateTime = DateTime.parse(startDate);
    DateTime endDateTime = DateTime.parse(endDate);
    Duration difference = endDateTime.difference(startDateTime);
    return difference.inDays +
        1; // Menambahkan 1 karena ingin memasukkan hari terakhir
  }

  MediaQueryData? queryData;
  @override
  void initState() {
    ambildata();
    getTheme();
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
                            "Jadwal Karyawan",
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
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Row(
                          children: [
                            Text(
                              "Jadwal Minggu ini",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.07,
                              ),
                            ),
                          ],
                        ),
                      ),

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
                                          color: ThemeManager().themeSingle,
                                          child: Material(
                                            child: ListTile(
                                              title: Text(
                                                formatDate(
                                                    jw['jadwal_tgl'] ?? ""),
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
                                                    jw['shift_tipe'] == "s"
                                                        ? "Shift Siang"
                                                        : "Shit Pagi",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: jw['shift_tipe'] ==
                                                              "s"
                                                          ? Color.fromARGB(
                                                              255, 219, 95, 38)
                                                          : ThemeManager().themeSingle,
                                                      fontFamily: "Inter",
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      letterSpacing: 0.07,
                                                    ),
                                                  ),
                                                  if (jw['jadwal_keterangan'] !=
                                                      null)
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors
                                                                .black), // Atur warna garis
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4),
                                                        child: Text(
                                                          jw['jadwal_keterangan'] ??
                                                              "",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                            fontFamily: "Inter",
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            letterSpacing: 0.07,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              trailing: Text(
                                                "${jw['shift_jam_masuk']}-${jw['shift_jam_pulang']}",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: "Inter",
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.07,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )),
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
