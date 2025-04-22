import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gocrane_v3/main.dart';
import 'package:gocrane_v3/tampilan/menu/gaji/gaji.dart';
import 'package:gocrane_v3/tampilan/tab/pengajuan/Pcuti.dart';
import 'package:gocrane_v3/tampilan/tab/pengajuan/Pizin.dart';
import 'package:gocrane_v3/tampilan/tab/pengajuan/Plembur.dart';
import 'package:gocrane_v3/tampilan/tab/riwayat/detailMasuk.dart';
import 'package:gocrane_v3/tampilan/tab/riwayat/detailPulang.dart';
import 'package:gocrane_v3/theme_manager.dart';

import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class detailRiwayat extends StatefulWidget {
  const detailRiwayat({required this.absensiId});
  final String absensiId;
  @override
  _detailRiwayatState createState() => _detailRiwayatState();
}

class _detailRiwayatState extends State<detailRiwayat>
    with SingleTickerProviderStateMixin {

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
  TabController? tb;
  List<Widget> _tabs = [];
  List<IconData> _icons = [
    Icons.home,
    Icons.calendar_today,
  ];
  List judul = [
    "Masuk",
    "Keluar",
  ];

  List<String> _tabText = [
    'Beranda',
    'Jadwal',
    'Notifikasi',
    'Profil',
  ];
  List<Color> _tabColor = [
    Colors.grey,
    Colors.grey,
  ];

  int _selectedTabIndex = 0;

  String chek = "";

  String? _masuk;
  String? _keluar;

  String? absensiId; // mengambil _data absensi_id
  String? idUser; // mengambil _data id_user
  String? tanggal; // mengambil _data tanggal
  String? checkIn; // mengambil _data check_in
  String? checkOut; // mengambil _data check_out
  String? locCheckIn; // mengambil _data loc_check_in
  String? locCheckOut; // mengambil _data loc_check_out
  String? fotoCheckIn; // mengambil _data foto_check_in
  String? fotoCheckOut;

  String? cek_absen;

  Future ambildata() async {
    var id = widget.absensiId;
    final Response = await http.get(
      Uri.parse("${url}/${urlSubAPI}/absen/getAbsenHistoryDetail/$id"),
    );
    var _data = jsonDecode(Response.body);
    if (_data == false) {
      chek = "Belum Ada Data";

      this.setState(() {
        cek_absen = "0";
      });
    } else {
      this.setState(() {
        absensiId = _data['absen_id'];
        idUser = _data['id_user'];
        tanggal = _data['tanggal'];
        checkIn = _data['absen_checkin'];
        checkOut = _data['absen_checkout'];
        locCheckIn = _data['absen_checkin_lokasi'];
        locCheckOut = _data['absen_checkout_lokasi'];
        fotoCheckIn = _data['absen_checkin_foto'];
        fotoCheckOut = _data['absen_checkout_foto'];
      });
    }
  }

  @override
  void initState() {
    // Menambahkan widget ke dalam list _tabs
    _tabs.add(CekAbsen_Masuk(
      absensiId: widget.absensiId,
    ));
    _tabs.add(CekAbsen_Pulang(
      absensiId: widget.absensiId,
    ));

    super.initState();
    getTheme();
    ambildata();
    tb = TabController(length: _tabs.length, vsync: this);
    tb!.addListener(() {
      setState(() {
        _selectedTabIndex = tb!.index;
        // _tabColor = List.generate(_tabs.length, (index) {
        //   return index == _selectedTabIndex
        //       ? Color(0xff020438)
        //       : Colors.grey[600];
        // }
        // );
      });
    });
  }

  String formatDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    String formattedDate =
        DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(date);
    return formattedDate;
  }

  @override
  void dispose() {
    tb!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            color: ThemeManager().themeSingle,
            padding: const EdgeInsets.only(
              top: 20,
              left: 13,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  "Detail Absensi",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 328,
            height: 137,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color(0x3f000000),
                  blurRadius: 22,
                  offset: Offset(0, 4),
                ),
              ],
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 14,
                ),
                Text(
                  tanggal == null ? tanggal ?? "" : formatDate(tanggal ?? ""),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff020438),
                    fontSize: 24,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Check In",
                          style: TextStyle(
                            color: Color(0xff020438),
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          checkIn ?? "-",
                          style: TextStyle(
                            color: Color(0xffffa800),
                            fontSize: 16,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Check Out",
                          style: TextStyle(
                            color: Color(0xff020438),
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          checkOut ?? "-",
                          style: TextStyle(
                            color: Color(0xffffa800),
                            fontSize: 16,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 20),
          Container(
            width: 328,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Color(0x1c000000),
                  blurRadius: 28,
                  offset: Offset(0, 4),
                ),
              ],
              color: Colors.white,
            ),
            child: Center(
              child: TabBar(
                labelColor: Color(0xff141414),
                unselectedLabelColor: Colors.grey,
                controller: tb,
                // isScrollable: true,
                tabs: List.generate(_tabs.length, (index) {
                  return Tab(
                    child: Center(
                        child: Text(
                      judul[index],
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                      ),
                    )),
                  );
                }),
              ),
            ),
          ),

//Anda dapat menambahkan lebih banyak widget Tab sesuai dengan kebutuhan. Pastikan juga sudah menginisialisasi controller tb sebelumnya.

          Expanded(
            child: TabBarView(
              controller: tb,
              children: _tabs,
            ),
          ),
        ],
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
