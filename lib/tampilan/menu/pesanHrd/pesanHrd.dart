import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gocrane_v3/Widget/Alert.dart';
import 'package:gocrane_v3/main.dart';
import 'package:gocrane_v3/tampilan/home.dart';

import 'package:gocrane_v3/tampilan/tab/cameraAbsen.dart';
import 'package:gocrane_v3/tampilan/tab/beranda.dart';
import 'package:gocrane_v3/tampilan/tab/pengajuan/informasi.dart';
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
class pesanHrd extends StatefulWidget {
  @override
  _pesanHrdState createState() => _pesanHrdState();
}

class _pesanHrdState extends State<pesanHrd> {
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

  DateTime currentDateStart = new DateTime.now();
  var datatglawal;
  var tgl_awal;

  TextEditingController keterangan = TextEditingController();
  Future _insertDataHrd() async {
    final prefs = await SharedPreferences.getInstance();

    var idUsr = (prefs.get('pegawai_id'));
    final urls = Uri.parse(
        '${url}/${urlSubAPI}/masukan/addData/'); // Ganti dengan URL endpoint API Anda
    try {
      final response = await http.post(urls, body: {
        // 'id_shift': "1",

        'id_hrd': bagian_jenis ?? "",
        'id_user': idUsr ?? "",
        'masukan_keterangan': keterangan.text ?? "-",
        'id_dep': idDep,
      });
      print(response.body);

      if (response.statusCode == 200) {
        // Jika insert berhasil
        final responseData = jsonDecode(response.body);
        print(responseData); // Output response dari server
        print('Data inserted successfully!');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePagePengguna()), //qr()),
          ModalRoute.withName('/'),
        );

        _showFeedbackDialog(context, " Berhasil ");
        // Tambahkan tindakan yang diinginkan setelah data berhasil diinsert
      } else {
        // Jika insert gagal
        print('Failed to insert data.');
        _showFeedbackDialog(context, " Gagal ");

        print(jsonDecode(response.body));
        // Tambahkan tindakan yang diinginkan jika gagal melakukan insert
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _showFeedbackDialog(BuildContext context, String ket) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Container(
                  //   width: 63,
                  //   height: 63,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(8),
                  //   ),
                  //   child: const Icon(
                  //     Icons.send,
                  //     size: 80,
                  //     color: Color.fromARGB(255, 0, 131, 0),
                  //   ),
                  // ),
                  // const SizedBox(height: 32),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        ket,
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 131, 0),
                          fontSize: 36,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.18,
                        ),
                      ),
                      Text(
                        "Terkirim Izin",
                        style: TextStyle(
                          color: Color(0xff141414),
                          fontSize: 12,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.06,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  Navigator.pop(dialogContext);

                  // Tutup dialog
                },
                child: Container(
                  width: 229,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Color.fromARGB(255, 0, 138, 11),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Keluar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.06,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
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
  bool isLoading = false;
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

  File? _image;
  final picker = ImagePicker();

  Future getImage_c(String g) async {
    if (g == 'g') {
      //buka galeri
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path); // Simpan gambar sesuai indeks
        } else {
          print('No image selected.');
        }
      });
    } else if (g == 'c') {
      //buka kamera
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path); // Simpan gambar sesuai indeks
        } else {
          print('No image selected.');
        }
      });
    } else {}
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
  Future Jenis() async {
    final prefs = await SharedPreferences.getInstance();

    var id_user = (prefs.get('pegawai_id'));
    final Response = await http.get(
      Uri.parse("${url}/${urlSubAPI}/User/getDataHrd/$idDep"),
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
            pilihjenis = _data;
            print(pilihjenis);
          });
        }
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
  List? pilihjenis;

  List? jenis_alber;

  List<dynamic>? jenis_bagian;

// Variabel untuk menyimpan nilai terpilih dari dropdown jam akhir

  List? startTimeList;
  List? endTimeList;

  MediaQueryData? queryData;
  @override
  void initState() {
    Jenis();
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
                            "Pesan HRD",
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
                        padding: EdgeInsets.only(left: 16, top: 15),
                        child: Row(
                          children: [
                            Text(
                              "HRD",
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
                              border:
                                  Border.all(color: const Color(0xffbfbfbf))),
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: DropdownButton(
                              isExpanded: true,
                              hint: const Text(
                                "Pilih HRD",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "medium",
                                    color: Colors.black),
                              ),
                              value: bagian_jenis,
                              items: pilihjenis == null
                                  ? []
                                  : pilihjenis?.map((item) {
                                      return DropdownMenuItem(
                                        child: Text(
                                          item['user_nama_lengkap'] ?? "",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "medium",
                                              color: Colors.black),
                                        ),
                                        value: item['user_id'] ?? "",
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

                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Row(
                          children: [
                            Text(
                              "Keterangan",
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

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          width: 318,
                          height: 104,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Color(0xff020438),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            maxLines: 4,
                            controller: keterangan,
                            // Jumlah baris yang ingin ditampilkan
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(8),
                            ),
                          ),
                        ),
                      ),

                      //
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            elevation: 5,
            height: 97,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: MaterialButton(
                            onPressed: () {
                              // Ubah status loading menjadi true saat tombol ditekan
                              setState(() {
                                isLoading = true;
                              });

                              // Panggil fungsi _insertDataIzin (asumsi ini adalah fungsi yang membuat koneksi jaringan)
                              _insertDataHrd().then((_) {
                                // Setelah proses selesai, ubah status loading kembali menjadi false
                                setState(() {
                                  isLoading = false;
                                });

                                // Tambahkan navigasi atau tindakan lain di sini setelah proses selesai
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 10,
                            ),
                            color: const Color(0xFF007100),
                            minWidth: 312,
                            height: 50,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Indikator loading
                                Visibility(
                                  visible: isLoading,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                                // Teks tombol
                                Visibility(
                                  visible: !isLoading,
                                  child: const Text(
                                    'Kirim',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                    ),
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
        ),
      ),
    );
  }

  //
}
