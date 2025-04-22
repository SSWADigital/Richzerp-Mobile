import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gocrane_v3/tampilan/tab/geolocator.dart';
import 'package:gocrane_v3/main.dart';
import 'package:gocrane_v3/tampilan/SlideRightRoute.dart';
import 'package:gocrane_v3/tampilan/akun/SignIn.dart';
import 'package:gocrane_v3/tampilan/tab/beranda.dart';
import 'package:gocrane_v3/tampilan/tab/pengajuan/informasi.dart';
import 'package:gocrane_v3/tampilan/tab/profil/profil_cek.dart';
import 'package:gocrane_v3/theme_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class biodatapengguna extends StatefulWidget {
  @override
  _biodatapenggunaState createState() => _biodatapenggunaState();
}

class _biodatapenggunaState extends State<biodatapengguna> {

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
  Future<String?> _ambildata() async {
    final prefs = await SharedPreferences.getInstance();

    iduser = (prefs.get('login_id')) as String?;
    print(iduser);
    return iduser;
  }

  String? nama_user;
  String? alamat;
  String? nowa;
  String? id_user = "";
  String? image_profil;
  String? bagian;

  Future profil() async {
    final prefs = await SharedPreferences.getInstance();

    iduser = (prefs.get('pasien_id')) as String?;
    final Response = await http.post(
        Uri.parse("${url}/api_swamedika_app/lihatpasien.php"),
        body: {"pasien_id": iduser});

    this.setState(() {
      var datajson = jsonDecode(Response.body);

      nama_user = datajson[0]['pasien_nama'];
      dep_nama = datajson[0]["pasien_tanggal_lahir"];
      bagian = datajson[0]['pasien_no_hp'];
      //nowa = datajson['profile'][0]["struk_nama"];
      print(datajson);
    });
  }

  String login_id = '';
  String login_username = '';
  String login_password = '';
  String login_status = '';
  String pasien_nama = '';
  String pasien_alamat = '';
  String pasien_no_hp = "";
  String pasien_foto = '';
  String pasien_tanggal_lahir = '';
  String pasien_email = "";
  String? foto;

  Future lihatprofil() async {
    final prefs = await SharedPreferences.getInstance();

    id_user = (prefs.get('pegawai_id')) as String?;
    final Response = await http
        //.get(Uri.parse("${url}/${urlSubAPI}/user/getDataApk/$id_user"));
        .get(Uri.parse("${url}/${urlSubAPI}/user/getData/$id_user"));
    var profil = jsonDecode(Response.body);
    setState(() {
      if (Response.body == "false") {
        print("null");
      } else {
        // nama_user = profil[0]['username'] ?? "";
        // nama_user = profil['pgw_nama'] ?? "";
        nowa = profil['user_no_telp'] ?? "";
        // image_profil = profil['pgw_foto'];

        nama_user = profil['user_nama_lengkap'] ?? "";
        // nowa = profil['pgw_nip'] ?? "";
        image_profil = profil['user_foto'];
      }
      // gambar = datajson[0]['faskes_foto'];
    });
  }

  @override
  void initState() {
    lihatprofil();
    // profil();
    // _ambildata();
    // lihatprofil();
    // TODO: implement initState
    super.initState();
    getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 281,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: ThemeManager().theme,
              ),
            ),
            padding: const EdgeInsets.only(
              // left: 128,
              // right: 127,
              top: 20,
              bottom: 34,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Profil",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 43),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
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

                              // image_profil== null?AssetImage("assets/icons/ic_profile_1.png")
                              //     : NetworkImage(image_profil)

                              )),
                    ),
                    SizedBox(height: 17),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: Text(
                            nama_user ?? "-",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          nowa ?? "-",
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
          Expanded(
            child: ListView(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context, SlidePageRoute(page: edit_profil()));
                    //  Navigator.push(context, SlidePageRoute(page: AboutUs()));
                  },
                  child: Container(
                    height: 45,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/icons/ic_about.png",
                          scale: 22,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            "Edit Profil",
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: "medium",
                                color: Colors.black),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, SlidePageRoute(page: informasi()));
                  },
                  child: Container(
                    height: 45,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/icons/ic_about.png",
                          scale: 22,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            "Informasi",
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: "medium",
                                color: Colors.black),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          MaterialButton(
            onPressed: () async {
              logoutDialogue();
            },
            child: Container(
              width: 328,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Color(0xff020438),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x44000000),
                    blurRadius: 24,
                    offset: Offset(8, 8),
                  ),
                ],
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 16,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Keluar",
                    style: TextStyle(
                      color: Color(0xff020438),
                      fontSize: 20,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

 void logoutDialogue() {
  showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(builder: (context, setState) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          insetPadding: EdgeInsets.all(30),
          child: Container(
            height: 164,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Message content
                Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 4,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Keluar",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "medium",
                              color: Colors.black),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 9),
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                            text: "Anda Yakin ?",
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: "medium",
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Action buttons
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Tidak",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "medium",
                                color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        onTap: () async {
                          // Call the API to log out
                          await _logout();
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Keluar",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "medium",
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
    },
  );
}
Future<void> _logout() async {
  try {
    // Make the HTTP POST request to the logout API
    final response = await http.post(
      Uri.parse('http://103.157.97.152/mycrm/keluar_api.php'),
    );

    if (response.statusCode == 200) {
      // Check the response for success
      final data = json.decode(response.body);
      
      if (data['status'] == 'success') {
        // Successfully logged out
        SharedPreferences prefs = await SharedPreferences.getInstance();
        // iduser = (prefs.get('idUser')) as String?;
        prefs.setBool("isUser", false);  // Set isUser to true to indicate logged in

        // prefs.remove('usr_id');
        // prefs.remove('pegawai_nama');
        // prefs.remove('pasien_id');
        
        // Navigate to the SignIn screen and remove previous routes
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SignIn()),
          (route) => false,
        );
      } else {
        // Handle any error message from the API
        print('Logout failed: ${data['message']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to log out, try again.')),
        );
      }
    } else {
      // Handle the case where the response status is not 200 (successful)
      print('Error: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred while logging out.')),
      );
    }
  } catch (e) {
    // Handle any exception that occurred during the API call
    print('Error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('An error occurred while logging out.')),
    );
  }
}
}
