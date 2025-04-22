import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gocrane_v3/main.dart';
import 'package:gocrane_v3/tampilan/SlideRightRoute.dart';
import 'package:gocrane_v3/tampilan/menu/orderan_berjalan/map.dart';
import 'package:gocrane_v3/tampilan/tab/beranda.dart';
import 'package:gocrane_v3/tampilan/tab/geolocator.dart';
import 'package:gocrane_v3/tampilan/tab/pengajuan/informasi.dart';
import 'package:gocrane_v3/tampilan/tab/profil/profil.dart';
import 'package:gocrane_v3/tampilan/tab/riwayat/riwayat.dart';
import 'package:gocrane_v3/tampilan/tab/schedule.dart';
import 'package:gocrane_v3/tampilan/tab/schedule/history.dart';
import 'package:gocrane_v3/theme_manager.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

String? exp_str;

class HomePagePengguna extends StatefulWidget {
  @override
  _HomePagePenggunaState createState() => _HomePagePenggunaState();
}

class _HomePagePenggunaState extends State<HomePagePengguna>
    with SingleTickerProviderStateMixin {
  
  List<Color> theme = [Colors.blue, Colors.lightBlueAccent];
  Color themeSingle = Colors.lightBlueAccent;

final Map<String, List<Color>> departmentColors = {
  // "1": [const Color(0xFF0000FF), const Color(0xFF87CEFA)], 
  // "01": [const Color(0xFF11A211), const Color(0xFF32CD32)],
  // "03": [const Color(0xFFFFD700), const Color(0xFFFFC125)],
  // "04": [const Color(0xFFFF0000), const Color(0xFFFFA07A)],
};

final Map<String, Color> singleColors = {
  // "1": const Color(0xFF0000FF), 
  // "01": const Color(0xFF0D7F0D),
  // "03": const Color(0xFFFFD700),
  // "04": const Color(0xFFFF0000),
};


var idDep = "0";

List<Color> getColorsByDepartment(String idDepartemen) {
  return departmentColors[idDepartemen] ?? [Colors.blue, Colors.lightBlueAccent]; // Default warna
}
Color getColorsByDepartmentSingle(String idDepartemen) {
  return singleColors[idDepartemen] ?? Colors.lightBlueAccent; // Default warna
}

// get() async {
//   final prefs = await SharedPreferences.getInstance();

//     idDep = (prefs.get('departemen_id')) as String;
//     print("idDep: $idDep");

// }
Future<void> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    String? idDep = prefs.get('departemen_id') as String?;

    if (idDep != null) {
      await ThemeManager().fetchColorConfiguration(idDep);
    }
  }
  TabController? tb;
  List<Widget> _tabs = [
    berandaMap(),
    riwayatAbsen(),
    informasi(),
    biodatapengguna(),
  ];
  List<IconData> _icons = [
    Icons.home,
    Icons.calendar_today,
    Icons.book_sharp,
    Icons.person,
  ];
  List judul = [
    "Beranda",
    "Absensi",
    "Pengajuan",
    "Profil",
  ];

  List<String> _tabText = ['Beranda', 'Jadwal', 'Notifikasi', 'Profil'];
  List<Color> _tabColor = [
    Colors.blue,
    Colors.blue,
    Colors.blue,
    Colors.blue,
  ];

  int _selectedTabIndex = 0;

  Future lihatprofil() async {
    final prefs = await SharedPreferences.getInstance();

    var id_user = (prefs.get('pegawai_id')) as String?;
    final Response =
        await http.get(Uri.parse("${url}/${urlSubAPI}/user/getData/$id_user"));
    var profil = jsonDecode(Response.body);

    setState(() {
      if (Response.body == "false") {
        print("null");
      } else {
        // String exptgl = profil['user_exp_str'] ?? "";
        // if (exptgl.isNotEmpty) {
        //   DateTime expDate = DateFormat('yyyy-MM-dd').parse(exptgl);
        //   DateTime sixMonthsFromNow = DateTime.now().add(Duration(days: 180));
        //   DateTime now = DateTime.now();
        //   int daysLeft = expDate.difference(now).inDays;

        //   if (expDate.isBefore(sixMonthsFromNow)) {
        //     exp_str = "x";
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       SnackBar(
        //         content: RichText(
        //           text: TextSpan(
        //             style: TextStyle(
        //                 color: Colors.red), // Ganti warna teks sesuai kebutuhan
        //             children: [
        //               TextSpan(
        //                 text:
        //                     'Masa berlaku nomor STR Anda akan berakhir dalam ',
        //               ),
        //               TextSpan(
        //                 text: '$daysLeft hari',
        //                 style: TextStyle(
        //                     fontWeight: FontWeight.bold), // Format cetak tebal
        //               ),
        //               TextSpan(
        //                 text: ' (${DateFormat('dd-MM-yyyy').format(expDate)})',
        //                 style: TextStyle(fontWeight: FontWeight.bold),
        //               ),
        //             ],
        //           ),
        //         ),
        //         duration: Duration(seconds: 60), // Durasi snackbar
        //         backgroundColor: Color.fromARGB(
        //             255, 255, 205, 130), // Warna latar belakang kuning muda
        //         action: SnackBarAction(
        //           label: 'Tutup',
        //           onPressed: () {
        //             // Tanggapan saat tombol ditutup
        //           },
        //           textColor: Colors.red, // Warna teks tombol merah tua
        //         ),
        //       ),
        //     );
        //     // Jika tanggal kadaluarsa kurang dari 6 bulan dari hari ini
        //     // Lakukan sesuatu
        //   } else {
        //     exp_str = "";
        //     // Jika tanggal kadaluarsa lebih dari 6 bulan dari hari ini
        //     // Lakukan sesuatu
        //   }
        // } else {
        //   // Tidak ada tanggal kadaluarsa yang tersedia
        // }

        //////////////////////////////////////////////////////////////////////////
        String exptgl = profil['user_exp_str'] ?? "";
        if(idDep == '01') {
        if (exptgl.isNotEmpty) {
          DateTime expDate = DateFormat('yyyy-MM-dd').parse(exptgl);
          DateTime sixMonthsFromNow = DateTime.now().add(Duration(days: 180));
          DateTime now = DateTime.now();
          int daysLeft = expDate.difference(now).inDays;

          String daysLeftText = '';

          if (daysLeft >= 30) {
            int monthsLeft = (daysLeft / 30).floor();
            int remainingDays = daysLeft % 30;
            daysLeftText = '$monthsLeft bulan';
            if (remainingDays > 0) {
              daysLeftText += ' $remainingDays hari';
            }
          } else if (daysLeft >= 7) {
            int weeksLeft = (daysLeft / 7).floor();
            int remainingDays = daysLeft % 7;
            daysLeftText = '$weeksLeft minggu';
            if (remainingDays > 0) {
              daysLeftText += ' $remainingDays hari';
            }
          } else {
            daysLeftText = '$daysLeft hari';
          }

          if (expDate.isBefore(sixMonthsFromNow)) {
            exp_str = "x";
            if (daysLeft <= 0) {
              // Tampilkan notifikasi bahwa STR sudah tidak berlaku lagi
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: RichText(
                    text: TextSpan(
                      style: TextStyle(
                          color:
                              Colors.red), // Ganti warna teks sesuai kebutuhan
                      children: [
                        TextSpan(
                          text: 'Nomor STR Anda sudah tidak berlaku lagi.',
                          style: TextStyle(
                              fontWeight:
                                  FontWeight.bold), // Format cetak tebal
                        ),
                        TextSpan(
                          text:
                              ' (${DateFormat('dd-MM-yyyy').format(expDate)})',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  duration: Duration(seconds: 60), // Durasi snackbar
                  backgroundColor: Color.fromARGB(
                      255, 255, 205, 130), // Warna latar belakang kuning muda
                  action: SnackBarAction(
                    label: 'Tutup',
                    onPressed: () {
                      // Tanggapan saat tombol ditutup
                    },
                    textColor: Colors.red, // Warna teks tombol merah tua
                  ),
                ),
              );
            } else {
              // Tampilkan snackbar untuk memberi tahu bahwa STR akan segera berakhir
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: RichText(
                    text: TextSpan(
                      style: TextStyle(
                          color:
                              Colors.red), // Ganti warna teks sesuai kebutuhan
                      children: [
                        TextSpan(
                          text:
                              'Masa berlaku nomor STR Anda akan berakhir dalam ',
                        ),
                        TextSpan(
                          text: '$daysLeftText',
                          style: TextStyle(
                              fontWeight: FontWeight
                                  .bold), // Format cetak tebal DateFormat('MMMM', 'id_ID').format(expDate);
                        ),
                        TextSpan(
                          text:
                              ' (${DateFormat('dd').format(expDate)} ${DateFormat('MMMM', 'id_ID').format(expDate)} ${DateFormat('yyyy').format(expDate)})',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  duration: Duration(seconds: 60), // Durasi snackbar
                  backgroundColor: Color.fromARGB(
                      255, 255, 205, 130), // Warna latar belakang kuning muda
                  action: SnackBarAction(
                    label: 'Tutup',
                    onPressed: () {
                      // Tanggapan saat tombol ditutup
                    },
                    textColor: Colors.red, // Warna teks tombol merah tua
                  ),
                ),
              );
            }
          } else {
            exp_str = "";
            // Jika tanggal kadaluarsa lebih dari 6 bulan dari hari ini
            // Lakukan sesuatu
          }
        } else {
          // Tidak ada tanggal kadaluarsa yang tersedia
        }
///////////////////////////////////////////////////////////////////////////////////
        String exptglsip = profil['user_exp_str'] ?? "";
        if (exptglsip.isNotEmpty) {
          DateTime expDatesip = DateFormat('yyyy-MM-dd').parse(exptglsip);
          DateTime sixMonthsFromNow = DateTime.now().add(Duration(days: 180));
          DateTime now = DateTime.now();
          int daysLeft = expDatesip.difference(now).inDays;

          String daysLeftText = '';

          if (daysLeft >= 30) {
            int monthsLeft = (daysLeft / 30).floor();
            int remainingDays = daysLeft % 30;
            daysLeftText = '$monthsLeft bulan';
            if (remainingDays > 0) {
              daysLeftText += ' $remainingDays hari';
            }
          } else if (daysLeft >= 7) {
            int weeksLeft = (daysLeft / 7).floor();
            int remainingDays = daysLeft % 7;
            daysLeftText = '$weeksLeft minggu';
            if (remainingDays > 0) {
              daysLeftText += ' $remainingDays hari';
            }
          } else {
            daysLeftText = '$daysLeft hari';
          }

          if (expDatesip.isBefore(sixMonthsFromNow)) {
            exp_str = "x";
            if (daysLeft <= 0) {
              // Tampilkan notifikasi bahwa STR sudah tidak berlaku lagi
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: RichText(
                    text: TextSpan(
                      style: TextStyle(
                          color:
                              Colors.red), // Ganti warna teks sesuai kebutuhan
                      children: [
                        TextSpan(
                          text: 'Nomor SIP Anda sudah tidak berlaku lagi.',
                          style: TextStyle(
                              fontWeight:
                                  FontWeight.bold), // Format cetak tebal
                        ),
                        TextSpan(
                          text:
                              ' (${DateFormat('dd-MM-yyyy').format(expDatesip)})',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  duration: Duration(seconds: 60), // Durasi snackbar
                  backgroundColor: Color.fromARGB(
                      255, 255, 205, 130), // Warna latar belakang kuning muda
                  action: SnackBarAction(
                    label: 'Tutup',
                    onPressed: () {
                      // Tanggapan saat tombol ditutup
                    },
                    textColor: Colors.red, // Warna teks tombol merah tua
                  ),
                ),
              );
            } else {
              // Tampilkan snackbar untuk memberi tahu bahwa STR akan segera berakhir
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: RichText(
                    text: TextSpan(
                      style: TextStyle(
                          color:
                              Colors.red), // Ganti warna teks sesuai kebutuhan
                      children: [
                        TextSpan(
                          text: 'Masa berlaku SIP Anda akan berakhir dalam ',
                        ),
                        TextSpan(
                          text: '$daysLeftText',
                          style: TextStyle(
                              fontWeight: FontWeight
                                  .bold), // Format cetak tebal DateFormat('MMMM', 'id_ID').format(expDate);
                        ),
                        TextSpan(
                          text:
                              ' (${DateFormat('dd').format(expDatesip)} ${DateFormat('MMMM', 'id_ID').format(expDatesip)} ${DateFormat('yyyy').format(expDatesip)})',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  duration: Duration(seconds: 60), // Durasi snackbar
                  backgroundColor: Color.fromARGB(
                      255, 255, 205, 130), // Warna latar belakang kuning muda
                  action: SnackBarAction(
                    label: 'Tutup',
                    onPressed: () {
                      // Tanggapan saat tombol ditutup
                    },
                    textColor: Colors.red, // Warna teks tombol merah tua
                  ),
                ),
              );
            }
          } else {
            exp_str = "";
            // Jika tanggal kadaluarsa lebih dari 6 bulan dari hari ini
            // Lakukan sesuatu
          }
        } else {
          // Tidak ada tanggal kadaluarsa yang tersedia
        }
        }
///////////////////////////////////////////////////////////////////////////////////
      }
    });
  }

  @override
  void initState() {
    super.initState();
    tb = TabController(length: _tabs.length, vsync: this);
    getTheme();
    tb!.addListener(() {
      setState(() {
        _selectedTabIndex = tb!.index;
        _tabColor = List.generate(_tabs.length, (index) {
          return index == _selectedTabIndex ? ThemeManager().themeSingle : Colors.grey;
        });
      });
    });
    lihatprofil();
  }

  @override
  void dispose() {
    tb!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: tb,
        children: _tabs,
      ),
      bottomNavigationBar: Material(
        elevation: 4,
        child: Container(
          height: 67,
          child: TabBar(
            controller: tb,
            indicatorColor: Colors.transparent,
            tabs: List.generate(_tabs.length, (index) {
              return Tab(
                  child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _icons[index],
                      size: 26,
                      color: _tabColor[index],
                    ),
                    Text(
                      judul[index],
                      style: TextStyle(
                        fontSize: 12,
                        color: _tabColor[index],
                      ),
                    ),
                  ],
                ),
              ));
            }),
          ),
        ),
      ),
    );
  }
}

//1
Container tabItem(int index, String img, double sc) {
  return Container(
    child: Image.asset(
      img,
      scale: sc,
    ),
  );
}

Container tabItem4(context, int index, String img, double sc, String title) {
  return Container(
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.directional(
          top: 0,
          start: 0,
          end: 0,
          textDirection: Directionality.of(context),
          child: Container(
            child: Column(
              children: [
                Image.asset(
                  img,
                  scale: sc,
                ),
                Container(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: "medium",
                      color: Colors.black,
                      // Theme.of(context).accentTextTheme.headline1.color
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
