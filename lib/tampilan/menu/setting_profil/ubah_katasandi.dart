import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';

class ubah_katasandi extends StatefulWidget {
  @override
  _ubah_katasandiState createState() => _ubah_katasandiState();
}

class _ubah_katasandiState extends State<ubah_katasandi> {
  // void updateWidget() {
  //   setState(() {
  //     indikator = MyStepperWidget_3();
  //     btn = "Lanjut Cetak Bukti";
  //     tombol_riset = false;
  //     konten = pilihpekerjaan();
  //   });
  // }

  final picker = ImagePicker();

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
      } else {
        print('No image selected.');
      }
    });
  }

  //
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

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController tgllahirController = TextEditingController();

  String? nama_user;
  String? alamat_;
  String? nowa;
  String? id_user = "";
  String? image_profil;
  String? unit_list = "n";

  Future lihatprofil() async {
    final prefs = await SharedPreferences.getInstance();

    id_user = (prefs.get('pegawai_id')) as String?;
    final Response = await http.get(
        Uri.parse("http://103.157.97.200/richzspot/user/getData/$id_user"));
    var profil = jsonDecode(Response.body);
    this.setState(() {
      if (Response.body == "false") {
        print("null");
      } else {
        // nama_user = profil[0]['username'] ?? "";
        nameController.text = profil['user_nama_lengkap'] ?? "";
        phoneNumController.text = profil['user_no_telp'] ?? "";
        image_profil = profil['user_foto'];
        dateVal = profil['user_tgl_lahir'] ?? "";
        alamat.text = profil['user_alamat'] ?? "";
      }
      // gambar = datajson[0]['faskes_foto'];
    });
  }

  MediaQueryData? queryData;
  @override
  void initState() {
    // indikator = MyStepperWidget();
    // btn = "Lanjut Pilih Unit";
    // tombol_riset = false;
    // konten = formwaktu();
    // lihatprofil();
    // TODO: implement initState
    super.initState();
  }

  String? jenis;
  List<dynamic> pilihjenis = [
    {
      "jenis_nama": "Laki-laki",
      "nilai": "L",
    },
    {
      "jenis_nama": "Perempuan",
      "nilai": "P",
    },
  ];

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
                        start: 3,
                        top: 0,
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
                        top: 0,
                        bottom: 0,
                        start: 0,
                        end: 0,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Ubah Password",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'inter',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // indikator,
                SizedBox(
                  height: 10,
                ),

                Expanded(
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, top: 10, bottom: 10),
                        child: Row(
                          children: [
                            Text(
                              "Username",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.07,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Stack(
                          children: [
                            TextFormField(
                              controller: tgllahirController,
                              onChanged: (_) {},
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 14),
                                hintText: "Input Username",
                                labelStyle: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "medium",
                                    color: Color.fromARGB(0, 0, 0, 0)),
                              ),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "medium",
                                  color: Color.fromARGB(0, 0, 0, 0)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, top: 10, bottom: 10),
                        child: Row(
                          children: [
                            Text(
                              "Password",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.07,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Stack(
                          children: [
                            TextFormField(
                              obscureText: _obscureText,
                              // controller: passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 14),
                                hintText: "Input Password",
                              ),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "medium",
                                  color: Color.fromARGB(0, 0, 0, 0)),
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
                                          ? Icon(
                                              Icons.visibility_off,
                                              color: Colors.grey,
                                            )
                                          : Icon(
                                              Icons.visibility_outlined,
                                              color: Colors.grey,
                                            ))),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, top: 10, bottom: 10),
                        child: Row(
                          children: [
                            Text(
                              "Ulangi Username",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.07,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Stack(
                          children: [
                            TextFormField(
                              obscureText: _obscureText,
                              // controller: passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 14),
                                hintText: "Ulangi Password",
                              ),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "medium",
                                  color: Color.fromARGB(0, 0, 0, 0)),
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
                                          ? Icon(
                                              Icons.visibility_off,
                                              color: Colors.grey,
                                            )
                                          : Icon(
                                              Icons.visibility_outlined,
                                              color: Colors.grey,
                                            ))),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: MaterialButton(
                      height: 44,
                      onPressed: () {
                        setState(() {});

                        // FocusScope.of(context).requestFocus(FocusNode());
                        // _edit();
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 320,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x21000000),
                                  blurRadius: 26,
                                  offset: Offset(0, 4),
                                ),
                              ],
                              color: Color(0xff2ab2a2),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Simpan",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.08,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
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
