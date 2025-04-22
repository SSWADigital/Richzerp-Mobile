import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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

class formwaktu extends StatefulWidget {
  @override
  _formwaktuState createState() => _formwaktuState();
}

class _formwaktuState extends State<formwaktu> {
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

  DateTime currentDateStart = new DateTime.now();
  var datatglawal;
  var tgl_awal;

  // var now = new DateTime.now();
  Future<void> buka_tgl_awal(BuildContext context) async {
    final DateTime? pilih_tgl_awal = await showDatePicker(
      context: context,
      initialDate: currentDateStart,
      firstDate: DateTime(1950),
      lastDate: DateTime(2101),
    );
    if (pilih_tgl_awal != null && pilih_tgl_awal != currentDateStart) {
      setState(() {
        datatglawal = DateFormat('dd-MM-yyyy').format(pilih_tgl_awal);
        tgl_awal_ymd = DateFormat('yyyy-MM-dd').format(pilih_tgl_awal);
        td_awal();
      });
    }
  }

  DateTime currentDateEnd = new DateTime.now();
  var datatglakhir;
  var tgl_akhir;

  // var now = new DateTime.now();
  Future<void> buka_tgl_akhir(BuildContext context) async {
    final DateTime? pilih_tgl_akhir = await showDatePicker(
      context: context,
      initialDate: currentDateEnd,
      firstDate: DateTime(1950),
      lastDate: DateTime(2101),
    );
    if (pilih_tgl_akhir != null && pilih_tgl_akhir != currentDateEnd) {
      setState(() {
        datatglakhir = DateFormat('dd-MM-yyyy').format(pilih_tgl_akhir);
        tgl_akhir_ymd = DateFormat('yyyy-MM-dd').format(pilih_tgl_akhir);
        td_akhir();
      });
    }
  }
  // TextEditingController nameController = TextEditingController();
  // TextEditingController phoneNumController = TextEditingController();
  // TextEditingController alamat = TextEditingController();
  // TextEditingController tgllahirController = TextEditingController();
  // TextEditingController dep_nama = TextEditingController();

  // TextEditingController tanggalawal = TextEditingController();
  // TextEditingController tanggalakhir = TextEditingController();
  // TextEditingController jamawal = TextEditingController();
  // TextEditingController jamakhir = TextEditingController();
  // TextEditingController jenisalber = TextEditingController();
  // TextEditingController departemen = TextEditingController();
  // TextEditingController bagian = TextEditingController();

  String? nama_user;
  String? alamat_;
  String? nowa;
  String? id_user = "";
  String? image_profil;
  Widget? indikator;

  // Future lihatprofil() async {
  //   final prefs = await SharedPreferences.getInstance();

  //   id_user = (prefs.get('pegawai_id'));
  //   final Response = await http.get(
  //       Uri.parse("http://101.50.2.211/richzspot/user/getData/$id_user"));
  //   var profil = jsonDecode(Response.body);
  //   this.setState(() {
  //     if (Response.body == "false") {
  //       print("null");
  //     } else {
  //       // nama_user = profil[0]['username'] ?? "";
  //       nameController.text = profil['user_nama_lengkap'] ?? "";
  //       phoneNumController.text = profil['user_no_telp'] ?? "";
  //       image_profil = profil['user_foto'];
  //       dateVal = profil['user_tgl_lahir'] ?? "";
  //       alamat.text = profil['user_alamat'] ?? "";
  //       jenis = profil['user_jenis_kelamin'] ?? "";
  //     }
  //     // gambar = datajson[0]['faskes_foto'];
  //   });
  // }

  // Future _edit() async {
  //   final prefs = await SharedPreferences.getInstance();

  //   id_user = (prefs.get('pegawai_id'));
  //   if (_image != null) {
  //     var request = http.MultipartRequest(
  //         'POST',
  //         Uri.parse(
  //             'http://101.50.2.211/richzspot/user/updateData/$id_user'));
  //     request.fields.addAll({
  //       'user_nama_lengkap': nameController.text,
  //       'user_no_telp': phoneNumController.text,
  //       'pasien_alamat': alamat.text,
  //       "user_tgl_lahir": dateVal,
  //     });
  //     request.files
  //         .add(await http.MultipartFile.fromPath('user_foto', _image.path));

  //     http.StreamedResponse response = await request.send();

  //     showDialog<void>(
  //         context: context,
  //         builder: (BuildContext dialogContext) {
  //           return Alert(
  //             title: "Pembritahuan !!!",
  //             subTile: "Berhasil Edit Profil",
  //           );
  //         });
  //     // Navigator.pop(context);
  //   } else {
  //     var request = http.MultipartRequest(
  //         'POST',
  //         Uri.parse(
  //             'http://101.50.2.211/richzspot/user/updateData/$id_user'));
  //     request.fields.addAll({
  //       'user_nama_lengkap': nameController.text,
  //       'user_no_telp': phoneNumController.text,
  //       'pasien_alamat': alamat.text,
  //       "user_tgl_lahir": dateVal,
  //     });

  //     http.StreamedResponse response = await request.send();

  //     showDialog<void>(
  //         context: context,
  //         builder: (BuildContext dialogContext) {
  //           return Alert(
  //             title: "Pembritahuan !!!",
  //             subTile: " Berhasil Edit Profil",
  //           );
  //         });
  //     // Navigator.pop(context);
  //   }
  // }

  Future<void> td_awal() async {
    final response = await http.get(
      Uri.parse(
          "http://101.50.2.211/gocraneapp_v2/production/buat_order/waktu-order.php?awal=1&tanggal=$datatglawal"),
    );

    setState(() {
      startTimeList = jsonDecode(response.body);

      // TODO: Lakukan sesuatu dengan datajson (misalnya, perbarui tampilan UI).
    });
  }

  ////
  Future<void> td_akhir() async {
    final response = await http.get(
      Uri.parse(
          "http://101.50.2.211/gocraneapp_v2/production/buat_order/waktu-order.php?akhir=1&tanggal=$datatglakhir"),
    );

    setState(() {
      endTimeList = jsonDecode(response.body);

      // TODO: Lakukan sesuatu dengan datajson (misalnya, perbarui tampilan UI).
    });
  }

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

  // Future bagian_pilih() async {
  //   final Response = await http.post(
  //     Uri.parse("http://101.50.2.211/api_gocrane/alber.php"),
  //   );
  //   if (this.mounted) {
  //     this.setState(() {
  //       var dp_nama = jsonDecode(Response.body);
  //       departemen.text = dp_nama[0]['username'] ?? "";
  //     });
  //   }
  // }

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
        body: {"id_usr": id_user});

    this.setState(() {
      var datajson = jsonDecode(Response.body);

      departemen.text = datajson['profile'][0]["struk_nama"];
      dp_id = datajson['profile'][0]["struk_id"];
    });
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

  List? jenis_alber;

  List<dynamic>? jenis_bagian;

// Variabel untuk menyimpan nilai terpilih dari dropdown jam akhir

  List? startTimeList;
  List? endTimeList;

  MediaQueryData? queryData;
  @override
  void initState() {
    alber_list();
    profil();
    bagian_pilih();
    // lihatprofil();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Space
        const SizedBox(
          height: 20,
        ),
        const Row(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Order Transaksi",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xff141414),
                  fontSize: 18,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.09,
                ),
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Row(
            children: [
              Text(
                "Tanggal Awal ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.07,
                ),
              ),
              Text(
                "*",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.07,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: InkWell(
            onTap: () {
              buka_tgl_awal(context);
            },
            child: Stack(
              children: [
                TextFormField(
                  enabled: false,
                  onChanged: (_) {
                    print(tgl_awal);
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 14),
                    labelText: datatglawal == null
                        ? "Tanggal Awal"
                        : datatglawal?.toString(),
                    labelStyle: TextStyle(
                        fontSize: 14,
                        fontFamily: "medium",
                        color: datatglawal == null
                            ? const Color.fromARGB(255, 85, 85, 85)
                            : Colors.black),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide:
                            const BorderSide(width: 1, color: Colors.black)),
                  ),
                ),
                Positioned.directional(
                  textDirection: Directionality.of(context),
                  end: 8,
                  top: 5,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "assets/icons/ic_calendar.png",
                        scale: 25,
                      )),
                )
              ],
            ),
          ),
        ),

        const Padding(
          padding: EdgeInsets.only(left: 16, top: 15),
          child: Row(
            children: [
              Text(
                "Tanggal Akhir",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.07,
                ),
              ),
              Text(
                "*",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.07,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: InkWell(
            onTap: () {
              buka_tgl_akhir(context);
            },
            child: Stack(
              children: [
                TextFormField(
                  enabled: false,
                  onChanged: (value) {
                    print(tgl_akhir);
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 14),
                    labelText: datatglakhir == null
                        ? "Tanggal Akhir"
                        : datatglakhir?.toString(),
                    labelStyle: TextStyle(
                        fontSize: 14,
                        fontFamily: "medium",
                        color:
                            datatglakhir == null ? Colors.black : Colors.black),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide:
                            const BorderSide(width: 1, color: Colors.black)),
                  ),
                ),
                Positioned.directional(
                  textDirection: Directionality.of(context),
                  end: 8,
                  top: 5,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "assets/icons/ic_calendar.png",
                        scale: 25,
                      )),
                )
              ],
            ),
          ),
        ),

        //
        const Padding(
          padding: EdgeInsets.only(left: 16, top: 15),
          child: Row(
            children: [
              Text(
                "Pilih Jam",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.07,
                ),
              ),
              Text(
                "*",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.07,
                ),
              ),
            ],
          ),
        ),

        Row(
          children: [
            Container(
              height: 50,
              width: 150,
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffbfbfbf))),
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: DropdownButton(
                  isExpanded: true,
                  hint: const Text(
                    "Jam Awal",
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "medium",
                        color: Colors.black),
                    //semanticsLabel: "Jenis Kelamin",
                  ),
                  value: selectedStartTime,
                  items: startTimeList == null
                      ? []
                      : startTimeList?.map((item) {
                          return DropdownMenuItem(
                            child: Text(
                              item['shift_pesan_nama'],
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: "medium",
                                  color: Colors.black),
                            ),
                            value: item['shift_pesan_nama'],
                            onTap: () {
                              shift_awal = item['shift_pesan_id'];
                              print(shift_awal);
                            },
                          );
                        }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStartTime = value as String?;
                      print(selectedStartTime);
                    });
                  },
                ),
              ),
            ),
            const Spacer(),
            Container(
              height: 50,
              width: 150,
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffbfbfbf))),
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: DropdownButton(
                  isExpanded: true,
                  hint: const Text(
                    "Jam Akhir",
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "medium",
                        color: Colors.black),
                    semanticsLabel: "Jenis Kelamin",
                  ),
                  value: selectedEndTime,
                  items: endTimeList == null
                      ? []
                      : endTimeList?.map((item) {
                          return DropdownMenuItem(
                            child: Text(
                              item['shift_pesan_nama'],
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: "medium",
                                  color: Colors.black),
                            ),
                            value: item['shift_pesan_nama'],
                            onTap: () {
                              shift_akhir = item['shift_pesan_id'];
                              print(shift_akhir);
                            },
                          );
                        }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedEndTime = value as String?;
                      print(selectedEndTime);
                    });
                  },
                ),
              ),
            ),
          ],
        ),

        const Padding(
          padding: EdgeInsets.only(
            left: 16,
          ),
          child: Row(
            children: [
              Text(
                "Jenis Alber",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.07,
                ),
              ),
              Text(
                "*",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.07,
                ),
              ),
            ],
          ),
        ),
        //Gender
        Container(
          height: 50,
          margin: const EdgeInsets.all(15.0),
          padding: const EdgeInsets.all(3.0),
          decoration:
              BoxDecoration(border: Border.all(color: const Color(0xffbfbfbf))),
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: DropdownButton(
              isExpanded: true,
              hint: const Text(
                "Pilih Jenis Alber",
                style: TextStyle(
                    fontSize: 14, fontFamily: "medium", color: Colors.black),
                semanticsLabel: "Jenis Alber",
              ),
              value: alber_jenis,
              items: jenis_alber == null
                  ? []
                  : jenis_alber?.map((item) {
                      return DropdownMenuItem(
                        child: Text(
                          item['jenis_nama'],
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: "medium",
                              color: Colors.black),
                        ),
                        value: item['jenis_id'],
                      );
                    }).toList(),
              onChanged: (value) {
                setState(() {
                  alber_jenis = value as String?;
                  print(alber_jenis);
                });
              },
            ),
          ),
        ),

        //Space
        const Padding(
          padding: EdgeInsets.only(left: 16, bottom: 15),
          child: Row(
            children: [
              Text(
                "Departemen",
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
        //Phone number
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            children: [
              TextFormField(
                cursorColor: Color.fromARGB(255, 48, 47, 47),
                readOnly: true,
                controller: departemen,
                keyboardType: TextInputType.number,
                onChanged: (_) {},
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 48, 47,
                            47)), // Ubah warna border saat terfokus
                  ),
                  contentPadding: EdgeInsets.only(left: 14),
                  labelStyle: TextStyle(
                      fontSize: 14, fontFamily: "medium", color: Colors.black),
                  border: OutlineInputBorder(
                    // Tambahkan border di sini
                    // Atur radius sesuai keinginan
                    borderSide: BorderSide(
                      // Tentukan warna dan ketebalan garis
                      color: Colors.grey, // Warna garis
                      width: 1.0, // Ketebalan garis
                    ),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
                style: TextStyle(
                    fontSize: 14, fontFamily: "medium", color: Colors.black),
              ),
            ],
          ),
        ),
        //Space

        //Email
        const Padding(
          padding: EdgeInsets.only(left: 16, top: 15),
          child: Row(
            children: [
              Text(
                "Bagian",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.07,
                ),
              ),
              Text(
                "*",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.07,
                ),
              ),
            ],
          ),
        ),
        //Gender
        InkWell(
          onTap: () {
            bagian_pilih();
          },
          child: Container(
            height: 50,
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffbfbfbf))),
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: DropdownButton(
                isExpanded: true,
                hint: const Text(
                  "Pilih Bagian",
                  style: TextStyle(
                      fontSize: 14, fontFamily: "medium", color: Colors.black),
                  semanticsLabel: "Jenis Kelamin",
                ),
                value: bagian_jenis,
                items: jenis_bagian == null
                    ? []
                    : jenis_bagian?.map((item) {
                        return DropdownMenuItem(
                          child: Text(
                            item['struk_detail_nama'],
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "medium",
                                color: Colors.black),
                          ),
                          value: item['struk_detail_id'],
                        );
                      }).toList(),
                onChanged: (value) {
                  setState(() {
                    bagian_jenis = value as String?;
                    print(bagian_jenis);
                  });
                },
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
