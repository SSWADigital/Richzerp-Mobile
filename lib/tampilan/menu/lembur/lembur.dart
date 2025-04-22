import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gocrane_v3/Widget/Alert.dart';
import 'package:gocrane_v3/main.dart';
import 'package:gocrane_v3/tampilan/home.dart';

import 'package:gocrane_v3/tampilan/tab/cameraAbsen.dart';
import 'package:gocrane_v3/tampilan/tab/beranda.dart';
import 'package:gocrane_v3/tampilan/tab/pengajuan/informasi.dart';
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
class lembur extends StatefulWidget {
  @override
  _lemburState createState() => _lemburState();
}

class _lemburState extends State<lembur> {

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
        td_akhir();
        td_awal();
        Shift();
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

  String? nama_user;
  String? alamat_;
  String? nowa;
  String? id_user = "";
  String? image_profil;
  Widget? indikator;

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

  Future<void> td_awal() async {
    final response = await http
        .post(Uri.parse("${url}/${urlSubAPI}/Jadwal/getDataJam"), body: {
      "tanggal": tgl_awal_ymd ?? "",
    });

    setState(() {
      startTimeList = jsonDecode(response.body);

      // TODO: Lakukan sesuatu dengan datajson (misalnya, perbarui tampilan UI).
    });
  }

  ////
  Future<void> td_akhir() async {
    final response = await http
        .post(Uri.parse("${url}/${urlSubAPI}/Jadwal/getDataJam"), body: {
      "tanggal": tgl_awal_ymd ?? "",
    });

    setState(() {
      endTimeList = jsonDecode(response.body);

      // TODO: Lakukan sesuatu dengan datajson (misalnya, perbarui tampilan UI).
    });
  }

  String? selectedHour;
  String? selectedMinute;

  List<String> hours = List.generate(24, (index) => index.toString());
  List<String> minutes =
      List.generate(60, (index) => index.toString().padLeft(2, '0'));
  //alber
  List? datajson;
  Future Jenis() async {
    final prefs = await SharedPreferences.getInstance();

    var id_user = (prefs.get('pegawai_id'));
    final Response = await http.get(
      Uri.parse("${url}/${urlSubAPI}/lembur/getJenislembur/$idDep"),
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

  String? id_absen;
  String? cek_absen;
  String? masuk;
  String? keluar;
  Future dataAbsen() async {
    final prefs = await SharedPreferences.getInstance();

    id_user = (prefs.get('pegawai_id')) as String?;

    try {
      var response = await http
          .get(Uri.parse('${url}/${urlSubAPI}/absen/cekAbsen/$id_user'));
      var data = jsonDecode(response.body);

      if (data == false) {
        setState(() {
          cek_absen = '0';
        });
      } else {
        setState(() {
          masuk = data['checkin'] ?? "-";
          keluar = data['checkout'] ?? "-";
          cek_absen = data['status'] ?? "-";
          id_absen = data['absen_id'] ?? null;
        });
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  late String tgl;
  String? id_shift;
  String? shift_masuk;
  String? shift_keluar;
  Future Shift() async {
    final prefs = await SharedPreferences.getInstance();

    var id_user = (prefs.get('pegawai_id'));

    // Menggunakan DateFormat untuk memformat DateTime menjadi string 'yyyy-MM-dd'
    tgl_awal_ymd ??= DateFormat('yyyy-MM-dd').format(DateTime.now());
    print(tgl_awal_ymd);

    try {
      var response = await http.get(Uri.parse(
          '${url}/${urlSubAPI}/Jadwal/getJadwal/$id_user/$tgl_awal_ymd'));
      var data = jsonDecode(response.body);

      if (data == []) {
        setState(() {});
      } else {
        setState(() {
          shift_masuk = data[0]!['shift_jam_masuk'] ?? "";
          shift_keluar = data[0]!['shift_jam_pulang'] ?? "";
          id_shift = data[0]!['jadwal_id'] ?? "";
        });
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  TextEditingController idUser = TextEditingController();
  TextEditingController keterangan = TextEditingController();
  Future<void> _ambilid() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      idUser.text = ((prefs.get('pegawai_id')) as String?)!;
    });

    if (idUser.text != null) {
    } else {
      print(idUser.text);
    }

    print(idUser.text);
  }

  Future _insertDataIzin() async {
    final urls = Uri.parse(
        '${url}/${urlSubAPI}/Lembur/addData');

    try {
      var request = http.MultipartRequest('POST', urls);
      request.fields.addAll({
        'lembur_jam_mulai': selectedStartTime ?? "",
        'lembur_jam_selesai': selectedEndTime ?? "",
        'id_jenis_lembur': bagian_jenis ?? "",
        'id_user': idUser.text,
        'lembur_keterangan': keterangan.text ?? "-",
        'id_dep': id_dep ?? "",
        'lembur_tgl': tgl_awal_ymd,
        'id_jadwal': id_shift ?? "",
      });

      print("FIELD : ${request.fields}");

      // if (_image != null) {
      //   request.files
      //       .add(await http.MultipartFile.fromPath('bukti_izin', _image!.path));
      // }

      var response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        // Jika insert berhasil
        print(responseData); // Output response dari server
        print('Data inserted successfully!');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePagePengguna()),
          ModalRoute.withName('/'),
        );

        _showFeedbackDialog(context, " Berhasil ");
        // Tambahkan tindakan yang diinginkan setelah data berhasil diinsert
      } else {
        // Jika insert gagal
        print('Failed to insert data.');
        _showFeedbackDialog(context, " Gagal ");

        print(responseData);
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

  String? jenis;
  List<dynamic> pilihjenis = [];

  List? jenis_alber;

  List<dynamic>? jenis_bagian;

// Variabel untuk menyimpan nilai terpilih dari dropdown jam akhir

  List? startTimeList;
  List? endTimeList;
  bool isLoading = false;
  MediaQueryData? queryData;
  @override
  void initState() {
    getTheme();
    get();
    _ambilid();
    Jenis();
    Shift();
    dataAbsen();
    td_awal();
    td_akhir();
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
                            "Pengajuan Lembur",
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: id_shift == null
                                    ? Container()
                                    : Row(
                                        children: [
                                          Text(
                                            "Shift saya",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.07,
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            "${shift_masuk} - ${shift_keluar}",
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
                              if (id_absen != null)
                                SizedBox(
                                  height: 10,
                                ),
                              Container(
                                child: id_absen == null
                                    ? Container()
                                    : Row(
                                        children: [
                                          Text(
                                            "Absensi",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.07,
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            "${masuk} - ${keluar}",
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
                            ],
                          ),
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Row(
                          children: [
                            Text(
                              "Tanggal Lembur ",
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

                      const Padding(
                        padding: EdgeInsets.only(left: 16, top: 15),
                        child: Row(
                          children: [
                            Text(
                              "Jenis Lembur",
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
                                "Jenis Lembur",
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
                                          item['jenis_lembur_nama'] ?? "",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "medium",
                                              color: Colors.black),
                                        ),
                                        value: item['jenis_lembur_id'] ?? "",
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
                                border:
                                    Border.all(color: const Color(0xffbfbfbf))),
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
                                border:
                                    Border.all(color: const Color(0xffbfbfbf))),
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
                                            shift_akhir =
                                                item['shift_pesan_id'];
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

                      ////////////////////////////////////////////////////////

                      /////////////////////////////////////////////////////////
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
                              _insertDataIzin().then((_) {
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
                            color: ThemeManager().themeSingle,
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
