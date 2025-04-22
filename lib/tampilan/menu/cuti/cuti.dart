import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gocrane_v3/Widget/Alert.dart';
import 'package:gocrane_v3/main.dart';
import 'package:gocrane_v3/tampilan/akun/SignIn.dart';
import 'package:gocrane_v3/tampilan/home.dart';
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
class cutipage extends StatefulWidget {
  @override
  _cutipageState createState() => _cutipageState();
}

class _cutipageState extends State<cutipage> {

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
    final DateTime? pilihTglAwal = await showDatePicker(
      context: context,
      initialDate: currentDateStart,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pilihTglAwal != null && pilihTglAwal != currentDateStart) {
      setState(() {
        datatglawal = DateFormat('dd-MM-yyyy').format(pilihTglAwal);
        tgl_awal_ymd = DateFormat('yyyy-MM-dd').format(pilihTglAwal);
      });
    }
  }

  String? bagian_jenis;
  var tgl_awal_ymd;
  var tgl_akhir_ymd;

  String? sisa_cuti;
  DateTime currentDateEnd = new DateTime.now();
  var datatglakhir;
  var tgl_akhir;
  TextEditingController keteranan = TextEditingController();
  // var now = new DateTime.now();
  Future<void> buka_tgl_akhir(BuildContext context) async {
    final DateTime? pilihTglAkhir = await showDatePicker(
      context: context,
      initialDate: currentDateEnd,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pilihTglAkhir != null && pilihTglAkhir != currentDateEnd) {
      setState(() {
        datatglakhir = DateFormat('dd-MM-yyyy').format(pilihTglAkhir);
        tgl_akhir_ymd = DateFormat('yyyy-MM-dd').format(pilihTglAkhir);

        DateTime awal = DateFormat('yyyy-MM-dd').parse(tgl_awal_ymd);
        DateTime akhir = pilihTglAkhir;
        Duration difference = akhir.difference(awal);
        int jumlahHari = difference.inDays + 1;
        print('Jumlah hari: $jumlahHari');
        print('Jumlah cuti: $TotalHari');
        int totalHari = int.tryParse(TotalHari ?? "0") ?? 0;

        if (jumlahHari > totalHari) {
          setState(() {
            sisa_cuti = "x";
          });
          // Lakukan sesuatu jika jumlah hari lebih besar dari TotalHari
        } else {
          setState(() {
            sisa_cuti = "y";
          });
        }
      });
    }
  }

  String? nama_user;
  String? alamat_;
  String? nowa;
  String? id_user = "";
  String? image_profil;
  Widget? indikator;
  String? TotalHari;

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

  ////

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

  Future JenisCuti_lama() async {
    final Response = await http
        .post(Uri.parse("${url}/${urlSubAPI}/API/get_data.php"), body: {
      'aksi': '2',
    });

    if (Response.body == 'false') {
      print("data Null");
    } else {
      this.setState(() {
        pilihjenis = jsonDecode(Response.body);
      });
    }
  }

  Future JenisCuti() async {
    final Response = await http.post(
        Uri.parse("${url}/${urlSubAPI}/cuti/hitungDurasiCutiTersisa/$usr_id/$idDep"),
        body: {
          'aksi': '2',
        });

    if (Response.body == 'false') {
      print("data Null");
    } else {
      this.setState(() {
        pilihjenis = jsonDecode(Response.body);
      });
    }
  }

  Future lihatprofil() async {
    final prefs = await SharedPreferences.getInstance();

    id_user = (prefs.get('pegawai_id')) as String?;
    final Response = await http
        .get(Uri.parse("${url}/${urlSubAPI}/user/getDataApk/$id_user"));
    var profil = jsonDecode(Response.body);
    this.setState(() {
      if (Response.body == "false") {
        print("null");
      } else {
        // nama_user = profil[0]['username'] ?? "";
        nama_user = profil['pgw_nama'] ?? "";
        nowa = profil['pgw_nip'] ?? "";
        image_profil = profil['pgw_foto'];
      }
      // gambar = datajson[0]['faskes_foto'];
    });
  }

  bool isDataComplete() {
    // Gantilah dengan logika sesuai dengan data yang Anda periksa
    return keteranan.text.isNotEmpty &&
        tgl_awal_ymd != null &&
        tgl_akhir_ymd != null &&
        bagian_jenis != null &&
        sisa_cuti != "x";
  }

  ///
  Future _insertDatacuti() async {
    final prefs = await SharedPreferences.getInstance();

    var idUsr = (prefs.get('pegawai_id'));
    final urls = Uri.parse(
        '${url}/${urlSubAPI}/cuti/addData'); // Ganti dengan URL endpoint API Anda
    try {
      final response = await http.post(urls, body: {
        // 'id_shift': "1",
        'cuti_tgl_mulai': tgl_awal_ymd ?? "",
        'cuti_tgl_selesai': tgl_akhir_ymd ?? "",
        'id_jenis_cuti': bagian_jenis ?? "",
        'id_user': idUsr ?? "",
        'cuti_keterangan': keteranan.text ?? "-",
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

  Future Jenis() async {
    final prefs = await SharedPreferences.getInstance();

    var idUser = (prefs.get('usr_id'));
    final Response = await http.get(
      Uri.parse(
          "$url/$urlSubAPI/cuti/hitungDurasiCutiTersisa/$idUser/$idDep"),
    );
    var _data = jsonDecode(Response.body);
            print("URL: $url/$urlSubAPI/cuti/hitungDurasiCutiTersisa/$idUser/$idDep");

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
            print("Pilih Jenis : $pilihjenis");
          });
        }
      });
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
                        "Terkirim Cuti",
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

  List? pilihjenis;

  String? jenis;
  // List<dynamic> pilihjenis = [
  //   {
  //     "jenis_nama": "Sakit",
  //     "nilai": "L",
  //   },
  //   {
  //     "jenis_nama": "Keperluan Keluarga",
  //     "nilai": "P",
  //   },
  // ];

  List? jenis_alber;

  List<dynamic>? jenis_bagian;

// Variabel untuk menyimpan nilai terpilih dari dropdown jam akhir

  List? startTimeList;
  List? endTimeList;
  bool isLoading = false;
  MediaQueryData? queryData;
  @override
  void initState() {
    // JenisCuti();
    getTheme();
    get();
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
          resizeToAvoidBottomInset: true,
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
                            "Pengajuan Cuti",
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
                              "Jenis Cuti",
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
                        onTap: () {},
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
                                "Pilih Jenis Cuti",
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
                                        child: Row(
                                          children: [
                                            Text(
                                              item['nama_cuti'] ?? "",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: "medium",
                                                  color: Colors.black),
                                            ),
                                            Spacer(),
                                            Text(
                                              " Sisa Cuti ${item['sisa_cuti']}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: "medium",
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                        value: item['id_cuti'] ?? "",
                                        onTap: () {
                                          setState(() {
                                            TotalHari = item['sisa_cuti'] ?? "";
                                            print(item['sisa_cuti'] ?? "");
                                          });
                                        },
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
                        padding: EdgeInsets.only(left: 16),
                        child: Row(
                          children: [
                            Text(
                              "Mulai Cuti ",
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
                                  contentPadding:
                                      const EdgeInsets.only(left: 14),
                                  labelText: datatglawal == null
                                      ? "Tanggal Awal"
                                      : datatglawal?.toString(),
                                  labelStyle: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "medium",
                                      color: datatglawal == null
                                          ? const Color.fromARGB(
                                              255, 85, 85, 85)
                                          : Colors.black),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: const BorderSide(
                                          width: 1, color: Colors.black)),
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
                      ///////////////////////////////////////////////////////////
                      const Padding(
                        padding: EdgeInsets.only(left: 16, top: 16),
                        child: Row(
                          children: [
                            Text(
                              "Selesai Cuti ",
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
                                onChanged: (_) {
                                  print(tgl_akhir);
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(left: 14),
                                  labelText: datatglakhir == null
                                      ? "Tanggal Akhir"
                                      : datatglakhir?.toString(),
                                  labelStyle: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "medium",
                                      color: datatglakhir == null
                                          ? const Color.fromARGB(
                                              255, 85, 85, 85)
                                          : Colors.black),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: const BorderSide(
                                          width: 1, color: Colors.black)),
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
                      if (sisa_cuti == "x")
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "*Tanggal selesai cuti melebihi ketentuan",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "medium",
                                color: Colors.red),
                          ),
                        ),

                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Row(
                          children: [
                            Text(
                              "Alasan Cuti",
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
                            controller: keteranan,

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
                            onPressed: isDataComplete()
                                ? () {
                                    // Ubah status loading menjadi true saat tombol ditekan
                                    setState(() {
                                      isLoading = true;
                                    });

                                    // Panggil fungsi _insertDataIzin (asumsi ini adalah fungsi yang membuat koneksi jaringan)
                                    _insertDatacuti().then((_) {
                                      // Setelah proses selesai, ubah status loading kembali menjadi false
                                      setState(() {
                                        isLoading = false;
                                      });

                                      // Tambahkan navigasi atau tindakan lain di sini setelah proses selesai
                                    });
                                  }
                                : null,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 10,
                            ),
                            color: isDataComplete()
                                ? ThemeManager().themeSingle
                                : Colors.grey,
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
