import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'dart:ui';

class editprofil_user extends StatefulWidget {
  @override
  _editprofil_userState createState() => _editprofil_userState();
}

class _editprofil_userState extends State<editprofil_user> {
  // void updateWidget() {
  //   setState(() {
  //     indikator = MyStepperWidget_3();
  //     btn = "Lanjut Cetak Bukti";
  //     tombol_riset = false;
  //     konten = pilihpekerjaan();
  //   });
  // }

  final picker = ImagePicker();

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
    setState(() {
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
      "jenis_nama": "Departemen Riseti",
      "nilai": "L",
    },
    {
      "jenis_nama": "Departemen Riset 1",
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
                            "Edit Profil",
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
                      Container(
                        height: 50,
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xffbfbfbf)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: DropdownButton(
                            isExpanded: true,
                            hint: Text(
                              "Pilih Bagian",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: "medium",
                              ),
                              semanticsLabel: "Jenis Kelamin",
                            ),
                            value: jenis,
                            items: pilihjenis.map((item) {
                              return DropdownMenuItem(
                                child: Text(
                                  item['jenis_nama'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "medium",
                                    color: const Color.fromARGB(55, 0, 0, 0),
                                  ),
                                ),
                                value: item['nilai'],
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                jenis = value as String?;
                                print(jenis);
                              });
                            },
                            underline: Container(), // Menghilangkan underline
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xffbfbfbf)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: DropdownButton(
                            isExpanded: true,
                            hint: Text(
                              "Pilih Bagian",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: "medium",
                              ),
                              semanticsLabel: "Jenis Kelamin",
                            ),
                            value: jenis,
                            items: pilihjenis.map((item) {
                              return DropdownMenuItem(
                                child: Text(
                                  item['jenis_nama'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "medium",
                                    color: const Color.fromARGB(85, 0, 0, 0),
                                  ),
                                ),
                                value: item['nilai'],
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                jenis = value as String?;
                                print(jenis);
                              });
                            },
                            underline: Container(), // Menghilangkan underline
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xffbfbfbf)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: DropdownButton(
                            isExpanded: true,
                            hint: const Text(
                              "Pilih Bagian",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: "medium",
                              ),
                              semanticsLabel: "Jenis Kelamin",
                            ),
                            value: jenis,
                            items: pilihjenis.map((item) {
                              return DropdownMenuItem(
                                child: Text(
                                  item['jenis_nama'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: "medium",
                                    color: Color.fromARGB(85, 0, 0, 0),
                                  ),
                                ),
                                value: item['nilai'],
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                jenis = value as String?;
                                print(jenis);
                              });
                            },
                            underline: Container(), // Menghilangkan underline
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Stack(
                          children: [
                            TextFormField(
                              controller: tgllahirController,
                              onChanged: (_) {},
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 14),
                                hintText: "Masukan No. SAP",
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
  List genderList = [
    "Laki-laki",
    "perempuan",
  ];
  String? genderVal;
  void genderDialogue() {
    showDialog<void>(
      context: context,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            insetPadding: EdgeInsets.all(20),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(genderList.length, (index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          genderVal = genderList[index]["kode"];
                          Navigator.pop(context);
                        });
                      },
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          genderList[index]["jenis_kelamin"],
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "medium",
                              color: Color.fromARGB(0, 0, 0, 0)),
                        ),
                      ),
                    );
                  })),
            ),
          );
        });
      },
    );
  }
}
