import 'dart:async';
import 'dart:convert';
import 'dart:io' show File, Platform;
import 'dart:typed_data';

import 'package:baseflow_plugin_template/baseflow_plugin_template.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gocrane_v3/Widget/Alert.dart';
import 'package:gocrane_v3/main.dart';
import 'package:gocrane_v3/tampilan/SlideRightRoute.dart';
import 'package:gocrane_v3/tampilan/menu/approval/approvalCuti.dart';
import 'package:gocrane_v3/tampilan/menu/approval/approvalIzin.dart';
import 'package:gocrane_v3/tampilan/menu/approval/approvalLembur.dart';
import 'package:gocrane_v3/tampilan/menu/cuti/cuti.dart';
import 'package:gocrane_v3/tampilan/menu/gaji/gaji.dart';
import 'package:gocrane_v3/tampilan/menu/izin/antrian.dart';
import 'package:gocrane_v3/tampilan/menu/hubungi_kami/hub_kami.dart';
import 'package:gocrane_v3/tampilan/menu/ifo_klinik/info_klinik.dart';
import 'package:gocrane_v3/tampilan/menu/izin/izin.dart';
import 'package:gocrane_v3/tampilan/menu/jadwal/jadwal.dart';
import 'package:gocrane_v3/tampilan/menu/lembur/lembur.dart';
import 'package:gocrane_v3/tampilan/menu/pengumuman.dart';
import 'package:gocrane_v3/tampilan/menu/pesanHrd/pesanHrd.dart';
import 'package:gocrane_v3/tampilan/tab/cameraAbsen.dart';
import 'package:gocrane_v3/tampilan/tab/beranda.dart';
import 'package:gocrane_v3/tampilan/tab/programmer/programmer.dart';
import 'package:gocrane_v3/tampilan/tab/tiket/tiket.dart';
import 'package:gocrane_v3/theme_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

String? id_absen;
String? cek_absen;
String? masuk;
String? keluar;

/// Defines the main theme color.
final MaterialColor themeMaterialColor =
    BaseflowPluginExample.createMaterialColor(
        const Color.fromRGBO(48, 49, 60, 1));

/// Example [Widget] showing the functionalities of the geolocator plugin
class berandaMap extends StatefulWidget {
  /// Creates a new berandaMap.
  const berandaMap({Key? key}) : super(key: key);

  /// Utility method to create a page with the Baseflow templating.
  static ExamplePage createPage() {
    return ExamplePage(Icons.location_on, (context) => const berandaMap());
  }

  @override
  _GeolocatorWidgetState createState() => _GeolocatorWidgetState();
}

class _GeolocatorWidgetState extends State<berandaMap> {

 
  String? idDep;
  List<dynamic> data = [];
  List? datajson;
  String chek = "";
  List<Color> theme = [Colors.grey, Colors.black];
  Color themeSingle = Colors.grey;
  String? username;
  String? id_user;

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
    // String? idDep = prefs.get('departemen_id') as String?;

    if (idDep != null) {
      await ThemeManager().fetchColorConfiguration("1");
    }
  }


List<Color> getColorsByDepartment(String idDepartemen) {
  return departmentColors["1"] ?? [Colors.blue, Colors.lightBlueAccent]; // Default warna
}
Color getColorsByDepartmentSingle(String idDepartemen) {
  return singleColors["1"] ?? Colors.blueAccent; // Default warna
}


  Future ambildata() async {
    final prefs = await SharedPreferences.getInstance();

    // idDep = (prefs.get('departemen_id')) as String;
    // print("idDep: $idDep");
    username = prefs.getString('username'); // Replace 'username' with the correct key if it's different
  id_user = prefs.getString('idUser');
    theme = getColorsByDepartment("1");
    id_user = (prefs.get('idUser')) as String?;

    // _berita();

    // try {
    //   var response = await http
    //       .get(Uri.parse('${url}/${urlSubAPI}/absen/cekAbsen/$id_user'));
    //   var data = jsonDecode(response.body);

    //   if (data == false) {
    //     setState(() {
    //       chek = 'Belum Ada Data';
    //       cek_absen = '0';
    //     });
    //   } else {
        setState(() {
          // masuk = data['checkin'];
          // keluar = data['checkout'];
          // cek_absen = data['status'];
          // id_absen = data['absen_id'];
        });
    //   }
    // } catch (error) {
    //   print('Error: $error');
    // }
  }



  // Future ambildata() async {
  //   final prefs = await SharedPreferences.getInstance();

  //   id_user = (prefs.get('pegawai_id'));
  //   final Response = await http.post(
  //       Uri.parse("${url}/swa_absen/API/riwayat_absen.php"),
  //       body: {"pegawai_id": id_user == "" ? pegawaiid : id_user, "aksi": "1"});
  //   var _data = jsonDecode(Response.body);
  //   if (_data == false) {
  //     chek = "Belum Ada Data";

  //     this.setState(() {
  //       cek_absen = "0";
  //     });
  //   } else {
  //     this.setState(() {
  //       masuk = _data[0]['check_in'] == null ? "-" : _data[0]['check_in'];
  //       keluar = _data[0]['check_out'] == null ? "-" : _data[0]['check_out'];
  //       if (_data[0]['check_out'] != null) {
  //         cek_absen = "1";
  //       }
  //     });
  //   }
  // }

  //////////////////////////////////////////////////////////
  String? nama_user;
  String? alamat;
  String? nowa;
  // String? id_user = "";
  String? image_profil;
  String? masaKerja;
  String? idRole;
  Future lihatprofil() async {
    final prefs = await SharedPreferences.getInstance();

    id_user = (prefs.get('pegawai_id')) as String?;
    final Response = await http
        //.get(Uri.parse("${url}/${urlSubAPI}/user/getDataApk/$id_user"));
        .get(Uri.parse("${url}/${urlSubAPI}/user/getData/$id_user"));
    var profil = jsonDecode(Response.body);
    this.setState(() {
      if (Response.body == "false") {
        print("null");
      } else {
        // nama_user = profil[0]['username'] ?? "";
        // nama_user = profil['pgw_nama'] ?? "";
        // nowa = profil['pgw_nip'] ?? "";
        // image_profil = profil['pgw_foto'];

        nama_user = profil['user_nama_lengkap'] ?? "";
        // nowa = profil['pgw_nip'] ?? "";
        image_profil = profil['user_foto'];
        idRole = profil['id_role'];

        DateTime tgl_kerja =
            DateFormat('yyyy-MM-dd').parse(profil['user_tgl_awal_kerja'] ?? "");
        DateTime satuTahunDariSekarang =
            DateTime.now().subtract(Duration(days: 365));

        if (tgl_kerja.isAfter(satuTahunDariSekarang)) {
          masaKerja = "x";
        } else {
          masaKerja = "";
        }
      }
      // gambar = datajson[0]['faskes_foto'];
    });
  }

  List? berita;
  List? _promo1;
  Future _berita() async {
    final Response = await http
        .post(Uri.parse("${url}/${urlSubAPI}/Pengumuman/getDataTabel/$idDep"));
    if (Response.body == 'false') {
      print("data Null");
    } else {
      setState(() {
        berita = jsonDecode(Response.body);
      });
    }

    // this.setState(() {
    //   berita = jsonDecode(Response.body);
    // });
  }



  // Future lihatprofil() async {
  //   final prefs = await SharedPreferences.getInstance();

  //   id_user = (prefs.get('pegawai_id'));

  //   final Response = await http.post(
  //       Uri.parse("${url}/swa_absen/API/user_profil.php"),
  //       body: {"user_id": id_user == "" ? pegawaiid : id_user});
  //   var profil = jsonDecode(Response.body);
  //   this.setState(() {
  //     if (Response.body == "false") {
  //       print("null");
  //     } else {
  //       // nama_user = profil[0]['username'] ?? "";
  //       nama_user = profil[0]['user_nama_lengkap'] ?? "";
  //       nowa = profil[0]['id_dep'] ?? "";
  //     }

  //     // gambar = datajson[0]['faskes_foto'];
  //   });
  // }
  var totalDalamAntrian;
  var totalSedangDikerjakan;
  var totalKonfirmasi;
  var totalDikembalikan;
  var totalBelumMemulai;

  Future getTiket() async {
    // final prefs = await SharedPreferences.getInstance();

    // idDep = (prefs.get('departemen_id')) as String;
    // print("idDep: $idDep");
    // theme = getColorsByDepartment("1");
    // id_user = (prefs.get('idUser')) as String?;

    // _berita();

    try {
      var dalamAntrian = await http
          .get(Uri.parse('http://103.157.97.152/mycrm/api.php?action=getTotalDalamAntrian&id_dep=1'));
      var dalamAntrianData = jsonDecode(dalamAntrian.body);
      var sedangDikerjakan = await http
          .get(Uri.parse('http://103.157.97.152/mycrm/api.php?action=getTotalSedangDikerjakan&id_dep=1'));
      var sedangDikerjakanData = jsonDecode(sedangDikerjakan.body);
      var konfirmasi = await http
          .get(Uri.parse('http://103.157.97.152/mycrm/api.php?action=getTotalKonfirmasi&id_dep=1'));
      var konfirmasiData = jsonDecode(konfirmasi.body);
      var dikembalikan = await http
          .get(Uri.parse('http://103.157.97.152/mycrm/api.php?action=getTotalDikembalikan&id_dep=1'));
      var dikembalikanData = jsonDecode(dikembalikan.body);
      var belumMemulai = await http
          .get(Uri.parse('http://103.157.97.152/mycrm/api.php?action=getTotalBelumMemulai&id_dep=1'));
      var belumMemulaiData = jsonDecode(belumMemulai.body);
      // var dalamAntrian = await http
      //     .get(Uri.parse('http://103.157.97.152/mycrm/api.php?action=getTotalDalamAntrian&id_dep=1'));
      // var dalamAntrianData = jsonDecode(dalamAntrian.body);
      // var dalamAntrian = await http
      //     .get(Uri.parse('http://103.157.97.152/mycrm/api.php?action=getTotalDalamAntrian&id_dep=1'));
      // var dalamAntrianData = jsonDecode(dalamAntrian.body);

      if (data == false) {
        setState(() {
          chek = 'Belum Ada Data';
          cek_absen = '0';
        });
      } else {
        setState(() {
          totalDalamAntrian = dalamAntrianData;
          totalSedangDikerjakan = sedangDikerjakanData;
          totalKonfirmasi = konfirmasiData;
          totalDikembalikan = dikembalikanData;
          totalBelumMemulai = belumMemulaiData;
          // keluar = data['checkout'];
          // cek_absen = data['status'];
          // id_absen = data['absen_id'];
        });
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  String getDateFormatted() {
    initializeDateFormatting('id_ID', null);
    String formattedDate =
        DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.now());
    return formattedDate;
  }

  @override
  void initState() {
    lihatprofil();
    getTheme();
    // get();
    getTiket();
    ambildata();

    //  if (this.mounted) {
    //   _getLocationPermission();
    //   _getCurrentLocation();
    //   _getpeta();
    //   _berita();
    //   _initializeCamera();
    // }

    super.initState();

    
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
    // addMarkers();
    // _locationController.text = lat + lng;

    // lihatprofil();
    ambildata();
    // ambildata();
    //  _pageController = PageController();
  }

  // String getDateFormatted() {
  //   initializeDateFormatting('id_ID', null);
  //   String formattedDate =
  //       DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.now());
  //   return formattedDate;
  // }

  String formatDate() {
    initializeDateFormatting('id_ID', null);
    String formattedDate =
        DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.now());
    return formattedDate;
  }


  final houseNumbController = new TextEditingController();
  final cityController = new TextEditingController();
  final districtController = new TextEditingController();
  String? _timeString;
  String? jam;
  String _formatDatejam(DateTime datejam) {
    return DateFormat('HH:mm:ss').format(datejam);
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    if (this.mounted) {
      setState(() {
        _timeString = formattedDateTime;
      });
    }
  }

  void _getjam() {
    final DateTime now = DateTime.now();
    final String formattedDatejam = _formatDateTime(now);
    if (this.mounted) {
      setState(() {
        jam = formattedDatejam;
      });
    }
  }

  //
  bool isSave = false;
  checkChanged() {
    if (houseNumbController.text.isNotEmpty &&
        cityController.text.isNotEmpty &&
        districtController.text.isNotEmpty) {
      setState(() {
        isSave = true;
      });
    } else {
      setState(() {
        isSave = false;
      });
    }
  }

  // var kpi = [
  //     {'target': '1000', 'actual': '950', 'persen': '95'},
  //     {'target': '2000', 'actual': '1800', 'persen': '90'},
  //     {'target': '500', 'actual': '450', 'persen': '90'},
  //     {'target': '3000', 'actual': '2800', 'persen': '93.33'},
  //   ];

  MediaQueryData? queryData;
  @override
Widget build(BuildContext context) {
  queryData = MediaQuery.of(context);
  return MediaQuery(
    data: queryData!.copyWith(textScaleFactor: 1.0),
    child: SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 248,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0),
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment(0.82, -0.57),
                                end: Alignment(-0.82, 0.57),
                                colors: ThemeManager().theme ?? [Colors.blue, Colors.lightBlue],
                              ),
                            ),
                            padding: const EdgeInsets.only(
                              left: 16,
                              top: 40,
                              bottom: 138,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: image_profil == null
                                                  ? NetworkImage("")
                                                  : NetworkImage(image_profil ?? "")
                                          )),
                                    ),
                                    SizedBox(width: 17),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              username ?? "-",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontFamily: "Inter",
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          id_user ?? "-",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontFamily: "Inter",
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _timeString ?? "",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                getDateFormatted(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Main content
            Expanded(
              child: totalBelumMemulai == null
                  ? Center(child: CircularProgressIndicator()) // Show loading spinner
                  : ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "Menu Utama",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Container(
                            child: Wrap(
                              spacing: 16,
                              runSpacing: 16, 
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                CustomCard3(
                                  iconData: Icons.check_circle,
                                  title: 'Approval Izin',
                                  halaman: approvalIzinPage(),
                                  color: ThemeManager().themeSingle,
                                ),
                                CustomCard3(
                                  iconData: Icons.timer,
                                  title: 'Aproval Lembur',
                                  halaman: approvallemburPage(),
                                  color: ThemeManager().themeSingle,
                                ),
                                CustomCard3(
                                  iconData: Icons.beach_access,
                                  title: 'Aproval Cuti',
                                  halaman: approvalcutiPage(),
                                  color: ThemeManager().themeSingle,
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: ThemeManager().themeSingle,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Daftar Tiket Support',
                                  style: TextStyle(
                                    fontSize: 16, // Increased font size
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  height: 130,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      AchievementCard(
                                        title: 'Dalam Antrian',
                                        total: "$totalDalamAntrian",
                                        page: TiketPage(action: 'n'),
                                      ),
                                      AchievementCard(
                                        title: 'Sedang Dikerjakan',
                                        total: "$totalSedangDikerjakan",
                                        page: TiketPage(action: 'd'),
                                      ),
                                      AchievementCard(
                                        title: 'Konfirmasi',
                                        total: "$totalKonfirmasi",
                                        page: TiketPage(action: 'c'),
                                      ),
                                      AchievementCard(
                                        title: 'Dikembalikan',
                                        total: "$totalDikembalikan",
                                        page: TiketPage(action: 'k'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: ThemeManager().themeSingle,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Programmer',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  height: 130,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      AchievementCard(
                                        title: 'Belum Memulai',
                                        total: "${totalBelumMemulai['total']}",
                                        page: TiketPage(action: 'd'),
                                      ),
                                      AchievementCard(
                                        title: 'Sedang Mengerjakan',
                                        total: "$totalSedangDikerjakan",
                                        page: TiketPage(action: 'd'),
                                      ),
                                      AchievementCard(
                                        title: 'Konfirmasi',
                                        total: "$totalKonfirmasi",
                                        page: TiketPage(action: 'c'),
                                      ),
                                      AchievementCard(
                                        title: 'Dikembalikan',
                                        total: "$totalDikembalikan",
                                        page: TiketPage(action: 'k'),
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
            ),
          ],
        ),
      ),
    ),
  );
}



Widget _buildTicketCard({
  required int no,
  required String noTicket,
  required String waktu,
  required String client,
  required String kategori,
  required String subject,
  required String person,
  required String lamaDiAntrian,
  required String status,
}) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 8.0),
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris pertama: No dan No Tiket
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "No: $no",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Text(
                    "No Tiket: ",
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    noTicket,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Waktu
          Text(
            "Waktu: $waktu",
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          // Lama di Antrian
          Text(
            "Lama di Antrian: $lamaDiAntrian",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget appBar() {
    return //Img
        Container(
      width: double.infinity,
      height: 188,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/imgs/libartry_img.jpg"))),
      child: Container(
        height: 50,
        padding: EdgeInsets.only(left: 16, top: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //back btn
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .color!
                        .withOpacity(0.9)),
                child: Image.asset(
                  "assets/icons/ic_back.png",
                  scale: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  

  Container verticalDivider() {
    return //Divider
        Container(
      height: 30,
      padding: EdgeInsets.only(left: 25),
      child: Row(
        children: [
          VerticalDivider(
            width: 2,
            thickness: 2,
            indent: 2,
            endIndent: 2,
            color: Colors.black,
          ),
        ],
      ),
    );
  }

}

class AchievementCard extends StatelessWidget {
  final String title;
  final String total;
  final Widget page;
  // final String actual;
  // final String percentage;

  const AchievementCard({
    key,
    required this.title,
    required this.total,
    required this.page,
    // required this.actual,
    // required this.percentage
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
    GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child:  Container(
      width: 120, // Increased width for larger cards
      margin: const EdgeInsets.only(right: 20), // Increased margin for spacing
      padding: const EdgeInsets.all(10), // Increased padding inside the card
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8), // Increased corner radius
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16, // Increased font size
              fontWeight: FontWeight.w700,
              color: Color(0xFF030817),
            ),
          ),
          const SizedBox(height: 15),
          _buildMetricRow('Total', '$total'),
          // _buildMetricRow('Actual', '$actual'),
          // _buildMetricRow('Persen', '$percentage'),
        ],
      ),
    ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF030817),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF2B4EE8),
            ),
          ),
        ],
      ),
    );
  }
  }
  
class CustomCard3 extends StatelessWidget {
  final IconData iconData; // Tambahkan IconData
  final String title;
  final Widget halaman;
  final Color color;

  const CustomCard3({
    Key? key,
    required this.iconData, // Ubah dari imagePath ke iconData
    required this.title,
    required this.halaman,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => halaman),
        );
      },
      child: Column(
        children: [
          Icon(
            iconData, // Gunakan Material Icon
            size: 40,
            color: color, // Warna sesuai kebutuhan
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

// class LocationAttendancePage extends StatefulWidget {
//   @override
//   _LocationAttendancePageState createState() => _LocationAttendancePageState();
// }

// class _LocationAttendancePageState extends State<LocationAttendancePage> {
//   GoogleMapController _mapController;
//   LatLng _currentPosition;
//   Marker _currentMarker;
//   TextEditingController _locationController;
//   File _image;

//   @override
//   void initState() {
//     super.initState();

//     // Mengambil posisi saat ini dan menginisialisasi marker
//     _getCurrentLocation().then((position) {
//       setState(() {
//         _currentPosition = position;
//         _currentMarker = Marker(
//           markerId: MarkerId("current_position"),
//           position: _currentPosition,
//         );
//       });
//     });

//     // Menginisialisasi controller untuk TextField lokasi
//     _locationController = TextEditingController();
//   }

//   void _moveCameraToCurrentPosition() {
//     if (_currentPosition != null) {
//       _mapController
//           .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//         target: _currentPosition,
//         zoom: 16.0,
//       )));
//     }
//   }

//   @override
//   void dispose() {
//     _locationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Absensi Lokasi"),
//       ),
//       body: Stack(
//         children: [
//           // Widget untuk menampilkan peta
//           GoogleMap(
//             onMapCreated: _onMapCreated,
//             initialCameraPosition: CameraPosition(
//               target:
//                   _currentPosition, // Gunakan posisi saat ini sebagai posisi awal peta
//               zoom: 15,
//             ),
//             markers: _currentMarker != null
//                 ? Set<Marker>.of([_currentMarker])
//                 : null, // Ubah dari Set menjadi Set.of
//           ),
//           // Widget untuk menampilkan keterangan lokasi dan tombol untuk memilih gambar
//           Positioned(
//             left: 16,
//             bottom: 16,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: MediaQuery.of(context).size.width - 80,
//                   child: TextField(
//                     controller: _locationController,
//                     decoration: InputDecoration(
//                       hintText: "Keterangan Tempat",
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: _getImage,
//                   child: Text("Pilih Gambar"),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Callback yang dipanggil saat peta selesai dibuat
//   void _onMapCreated(GoogleMapController controller) {
//     _mapController = controller;
//   }

//   // Fungsi untuk mengambil posisi saat ini menggunakan package geolocator
//   Future<LatLng> _getCurrentLocation() async {
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//     return LatLng(position.latitude, position.longitude);
//   }

//   // Fungsi untuk memilih gambar dari galeri menggunakan package image_picker
//   Future<void> _getImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);
//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print("Gambar tidak dipilih.");
//       }
//     });
//   }
// }
