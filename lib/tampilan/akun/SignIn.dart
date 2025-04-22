import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:gocrane_v3/Widget/Alert.dart';
import 'package:gocrane_v3/main.dart';
import 'package:gocrane_v3/tampilan/SlideRightRoute.dart';
import 'package:gocrane_v3/tampilan/akun/otp.dart';
import 'package:gocrane_v3/tampilan/home.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gocrane_v3/tampilan/homeLama.dart';

String? login_id;
String? login_username;
String? login_password;
String? login_status;
String? pegawaiid;
String? pegawainama;
String? pegawai_alamat;
String? pegawai_no_hp;
String? pegawai_foto;
String? pegawai_tanggal_lahir;
String? pegawai_email;

String? username;
String? dep_nama;
String? usr_foto;
String? nowa;
String? usr_when_create;
String? usr_id;
String? usr_loginname;
String? usr_email;

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  List<Color> theme = [Colors.grey, Colors.black];
  Color themeSingle = Colors.grey;

      final Map<String, List<Color>> departmentColors = {
  "1": [const Color(0xFF0000FF), const Color(0xFF87CEFA)], // Biru
  "2": [const Color(0xFF00FF00), const Color(0xFF32CD32)], // Hijau
  "03": [const Color(0xFFFFFF00), const Color(0xFFFFD700)], // Kuning
  "04": [const Color(0xFFFF0000), const Color(0xFFFFA07A)], // Merah
  
};

final Map<String, Color> singleColors = {
  "1": const Color(0xFF0000FF), // Biru
  "2": const Color(0xFF00FF00), // Hijau
  "03": const Color(0xFFFFFF00), // Kuning
  "04": const Color(0xFFFF0000), // Merah

};

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

  bool _showClearButton = false;

  void initState() {
    super.initState();
    get();
    emailController.addListener(() {
      setState(() {
        _showClearButton = emailController.text.length > 0;
      });
    });
  }

  Widget _getClearButton() {
    if (!_showClearButton) {
      return Text("");
    }
    return InkWell(
      onTap: () {
        emailController.clear();
      },
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "assets/icons/ic_clear.png",
            scale: 4.3,
          )),
    );
  }

  //
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> kirim() async {
    if (pasien_telepon.text.isEmpty) {
      showDialog<void>(
          context: context,
          builder: (BuildContext dialogContext) {
            return Alert(
              title: "Peringatan !!!",
              subTile: "Lengkapi no Wa Anda !",
            );
          });
    } else {}
    var request = http.MultipartRequest(
        'POST', Uri.parse('${url}/swamedika/login/send_otp'));
    request.fields.addAll({
      'pasien_no_hp': pasien_telepon.text,
      'kode_negara': "+62",
    });
    nowa = pasien_telepon.text;
    Navigator.push(context, SlidePageRoute(page: OTPScreen()));
    http.StreamedResponse response = await request.send();
  }

  TextEditingController pasien_telepon = TextEditingController();
  bool showNotification = false;
  bool checkBoxValue = false;
  _onChange(bool val) {
    setState(() {
      checkBoxValue = val;
    });
  }

  //============================================================================
  List? datauser;

  Future _login() async {
  // Periksa jika email dan password kosong
  if (emailController.text.isEmpty || passwordController.text.isEmpty) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Pemberitahuan !!!"),
          content: Text("Akun data tidak benar!"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  try {
    // Lakukan request POST ke server
    final response = await http.post(
      Uri.parse("http://103.157.97.152/mycrm/masuk_api.php"),
      body: {
        "txtUser": emailController.text,
        "txtPass": passwordController.text,
      },
    );

    // Periksa status code, pastikan 200 OK
    if (response.statusCode == 200) {
      var datauser = jsonDecode(response.body);

      // Menampilkan dialog dengan respons dari server
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Server Response"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Response:"),
                Text("Loginname: ${datauser['data']['loginname'] ?? 'N/A'}"),  // Sesuaikan dengan respons server
                Text("Name: ${datauser['data']['name'] ?? 'N/A'}"),  // Sesuaikan dengan respons server
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      // Periksa status login dari server (response body) 
      if (datauser['status'] == 1) {
        // Menyimpan data ke SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("isUser", true);  // Set isUser to true to indicate logged in
        prefs.setString("idUser", datauser['data']['id']);  // Set isUser to true to indicate logged in
        prefs.setString("loginname", datauser['data']['loginname']);
        prefs.setString("user_name", datauser['data']['name']);
        prefs.setString("user_tipe", datauser['data']['tipe']);
        prefs.setString("user_role", datauser['data']['rol']);
        prefs.setString("user_idpgw", datauser['data']['id_pgw']);
        // prefs.setString("usr_email", datauser['data']['email'] ?? '');  // Adjust based on response from server
        // prefs.setString("login_id", datauser['data']['id']); // Assuming `id` is returned from API

        // Navigasi ke halaman utama setelah login sukses
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePagePengguna()),  // Change to your home page widget
          (route) => false,
        );
      } else {
        // Jika status login gagal, tampilkan pesan
        showDialog<void>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text("Pemberitahuan !!!"),
              content: Text("Login gagal, username atau password salah."),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      // Jika status code bukan 200, tampilkan pesan error
      showDialog<void>(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text("Pemberitahuan !!!"),
            content: Text("Gagal Terhubung ke Server"),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          );
        },
      );
    }
  } catch (e) {
    // Menangani error jika terjadi kesalahan dalam request HTTP atau parsing JSON
    print("Terjadi kesalahan: $e");  // Cetak error lengkap ke konsol

    // Menampilkan dialog error dengan detail
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Error"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Terjadi kesalahan: $e"),  // Menampilkan error lengkap di dialog
              Text("Tipe error: ${e.runtimeType}"),  // Menampilkan tipe error
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
  //============================================================================
  MediaQueryData? queryData;
  FocusNode usernameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return MediaQuery(
      data: queryData!.copyWith(textScaleFactor: 1.0),
      child: SafeArea(
        child: Scaffold(
          body: Form(
            // key: _formKey,
            child: Container(
              child: Column(
                children: [
                  //Appbar

                  // Container(
                  //   height: 50,
                  //   child: Stack(
                  //     fit: StackFit.expand,
                  //     children: [
                  //       //back btn
                  //       Positioned.directional(
                  //         textDirection: Directionality.of(context),
                  //         start: -4,
                  //         top: 0,
                  //         bottom: 0,
                  //         child: InkWell(
                  //           onTap: () {
                  //             // Navigator.pop(context);
                  //           },
                  //           child: Padding(
                  //             padding: const EdgeInsets.symmetric(horizontal: 30),
                  //             child: Image.asset("assets/icons/swa1.png"),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  //
                  Expanded(
                    child: Container(
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 200,
                          ),
                          // InkWell(
                          //     child: new Padding(
                          //         padding: EdgeInsets.only(top: 50),
                          //         child: Row(
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           mainAxisSize: MainAxisSize.max,
                          //           children: <Widget>[
                          //             Align(
                          //               alignment: Alignment.bottomCenter,
                          //               child: Image.asset(
                          //                 "assets/icons/kukis_hd.png",
                          //                 height: 100,
                          //                 width: 300,
                          //               ),
                          //             ),
                          //           ],
                          //         )),
                          //     onTap: () async {}),
                          //Space

                          //Sign In
                          Container(
                            padding: EdgeInsets.only(top: 60),
                            alignment: Alignment.center,
                            child: Text(
                              "Masuk",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "medium",
                                  color: Colors.black),
                            ),
                          ),
                          //Space
                          SizedBox(
                            height: 12,
                          ),
                          //Don't have an account?...
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: () {
                                // FocusScope.of(context)
                                //     .requestFocus(FocusNode());
                                // Navigator.push(
                                //     context, SlidePageRoute(page: daftar()));
                              },
                              child: RichText(
                                text: new TextSpan(
                                  text: "Aplikasi Manajemen",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 230, 92, 0),
                                    fontSize: 15,
                                    fontFamily: "medium",
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //Space
                          SizedBox(
                            height: 50,
                          ),
                          //Email or Phone Number
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey, // Warna garis kotak
                                  width: 1.0,
                                ),
                                borderRadius:
                                    BorderRadius.circular(8.0), // Sudut kotak
                              ),
                              child: Stack(
                                children: [
                                  TextFormField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.only(top: 5, left: 14),
                                      labelText: "Masukan Username Anda ",
                                      labelStyle: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "medium",
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "medium",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //Space
                          SizedBox(
                            height: 17,
                          ),
                          //Password Text Field
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey, // Warna garis kotak
                                  width: 1.0,
                                ),
                                borderRadius:
                                    BorderRadius.circular(8.0), // Sudut kotak
                              ),
                              child: Stack(
                                children: [
                                  TextFormField(
                                    obscureText: _obscureText,
                                    controller: passwordController,
                                    keyboardType: TextInputType.visiblePassword,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 14),
                                      labelText: "Password",
                                      labelStyle: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "medium",
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "medium",
                                    ),
                                  ),
                                  Positioned.directional(
                                    textDirection: Directionality.of(context),
                                    end: 8,
                                    top: 4,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _toggle();
                                        });
                                      },
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: _obscureText
                                              ? Image.asset(
                                                  "assets/icons/ic_hide.png",
                                                  scale: 3.7,
                                                )
                                              : Image.asset(
                                                  "assets/icons/ic_seen.png",
                                                  scale: 3.7,
                                                )),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: MaterialButton(
                                    height: 44,
                                    onPressed: () {
                                      setState(() {
                                        _login();
                                      });

                                      // FocusScope.of(context)
                                      //     .requestFocus(FocusNode());
                                      // checkVal(context);
                                      // _login();
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4)),
                                    color: Colors.red[700],
                                    elevation: 0,
                                    highlightElevation: 0,
                                    child: Container(
                                      child: Text(
                                        "Masuk",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontFamily: 'medium'),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
