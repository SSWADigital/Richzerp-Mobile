import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gocrane_v3/tampilan/SlideRightRoute.dart';
import 'package:gocrane_v3/tampilan/menu/histori_order/feedback.dart';
import 'package:gocrane_v3/tampilan/menu/histori_order/rincian_history.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:isolate';
import 'dart:ui';

class histori_order extends StatefulWidget {
  @override
  _histori_orderState createState() => _histori_orderState();
}

class _histori_orderState extends State<histori_order> {
  // void updateWidget() {
  //   setState(() {
  //     indikator = MyStepperWidget_3();
  //     btn = "Lanjut Cetak Bukti";
  //     tombol_riset = false;
  //     konten = pilihpekerjaan();
  //   });
  // }

  List<dynamic> pilihjenis = [
    {
      "jenis_nama": "Departemen Riset",
      "nilai": "L",
    },
    {
      "jenis_nama": "Departemen Riset 1",
      "nilai": "L",
    },
  ];

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
    final Response = await http
        .get(Uri.parse("http://101.50.2.211/richzspot/user/getData/$id_user"));
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

  bool isSave = false;

  final ReceivePort _port = ReceivePort();

  String? dp_id;
  String? bagian_jenis;

  List<dynamic>? jenis_bagian;

  Future<void> bagian_pilih() async {
    final response = await http.get(
      Uri.parse(
          "http://101.50.2.211/gocraneapp_v2/production/buat_order/bagian.php?id=$dp_id"),
    );

    setState(() {
      jenis_bagian = jsonDecode(response.body);
      print(jenis_bagian);

      // TODO: Lakukan sesuatu dengan datajson (misalnya, perbarui tampilan UI).
    });
  }

  List? dataOrder;
  Future Orderhistory() async {
    final prefs = await SharedPreferences.getInstance();

    var id_user = (prefs.get('usr_id'));
    final Response = await http.post(
        Uri.parse("http://101.50.2.211/api_gocrane/history_usr.php"),
        body: {
          "userId": id_user ?? "",
          "tgl_awal": tgl_awal_ymd ?? "",
          "tgl_selesai": tgl_akhir_ymd ?? ""
        });

    this.setState(() {
      if (Response.body == null) {
        print(Response.body);
      } else {
        dataOrder = jsonDecode(Response.body);
      }
      // gambar = datajson[0]['faskes_foto'];
    });
  }

  DateTime currentDateStart = new DateTime.now();
  var datatglawal;
  var tgl_awal;

  var tgl_awal_ymd;
  var tgl_akhir_ymd;
  String?
      selectedStartTime; // Variabel untuk menyimpan nilai terpilih dari dropdown jam awal
  String? selectedEndTime;
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
        Orderhistory();
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
        Orderhistory();
      });
    }
  }

  MediaQueryData? queryData;
  @override
  void initState() {
    Orderhistory();

    // indikator = MyStepperWidget();
    // btn = "Lanjut Pilih Unit";
    // tombol_riset = false;
    // konten = formwaktu();
    // lihatprofil();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
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
                            "Histori Berjalan",
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
                Padding(
                  padding: const EdgeInsets.only(left: 16),
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
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: InkWell(
                    onTap: () {
                      buka_tgl_awal(context);
                      Orderhistory();
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
                            contentPadding: EdgeInsets.only(left: 14),
                            labelText: datatglawal == null
                                ? DateFormat('dd/MM/yyyy')
                                    .format(DateTime.now())
                                : datatglawal.toString(),
                            labelStyle: TextStyle(
                                fontSize: 14,
                                fontFamily: "medium",
                                color: datatglawal == null
                                    ? Colors.grey
                                    : const Color.fromARGB(255, 32, 32, 32)),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey)),
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

                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 15),
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
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: InkWell(
                    onTap: () {
                      buka_tgl_akhir(context);
                      Orderhistory();
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
                            contentPadding: EdgeInsets.only(left: 14),
                            labelText: datatglakhir == null
                                ? DateFormat('dd/MM/yyyy')
                                    .format(DateTime.now())
                                : datatglakhir.toString(),
                            labelStyle: TextStyle(
                                fontSize: 14,
                                fontFamily: "medium",
                                color: datatglakhir == null
                                    ? Colors.grey
                                    : Colors.black),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.grey)),
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
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 15),
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
                    ],
                  ),
                ),
                //Gender
                Container(
                  height: 50,
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffbfbfbf))),
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: DropdownButton(
                      isExpanded: true,
                      hint: const Text(
                        "Pilih Bagian",
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "medium",
                            color: Colors.black),
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

                // indikator,
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: dataOrder == null ? 0 : dataOrder?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 320,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x1c000000),
                                  blurRadius: 2,
                                  offset: Offset(0, 0),
                                ),
                              ],
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 10,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Order Selesai",
                                        style: TextStyle(
                                          color: Color(0xff141414),
                                          fontSize: 16,
                                          fontFamily: "Inter",
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Table(
                                              columnWidths: {
                                                1: FractionColumnWidth(0.1),
                                                0: FractionColumnWidth(0.3),
                                              },
                                              children: [
                                                buildRow(
                                                    "No Order",
                                                    dataOrder?[index][
                                                            "transaksi_kode"] ??
                                                        "",
                                                    14),
                                                buildRow(
                                                    "Lokasi",
                                                    dataOrder?[index][
                                                            "transaksi_lokasi"] ??
                                                        "", //transaksi_lokasi
                                                    14),
                                                buildRow(
                                                    "Unit",
                                                    dataOrder?[index]
                                                            ["alber_kode"] ??
                                                        "" +
                                                            "(${dataOrder?[index]["alber_kapasitas"]})",
                                                    14),
                                                buildRow(
                                                    "Jam / Biaya",
                                                    "4 Jam 30 Mnt 0 Dtk / ${dataOrder?[index]["transaksi_nominal_realisasi"]}",
                                                    14),
                                                buildRow(
                                                    "Tanggal",
                                                    dataOrder?[index][
                                                            "transaksi_tanggal"] ??
                                                        "",
                                                    14),
                                              ],
                                            ),
                                          ),
                                          // Sisanya mengikuti pola yang sama
                                          // ...
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16),
                                Container(
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              SlidePageRoute(
                                                  page: rincian_history(
                                                      id_reg: dataOrder![index]
                                                          ["transaksi_id"])));
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                              color: Color(0xff2ab2a2),
                                              width: 1,
                                            ),
                                            color: Colors.white,
                                          ),
                                          padding: const EdgeInsets.all(8),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Detail",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Color(0xff2ab2a2),
                                                  fontSize: 16,
                                                  fontFamily: "Inter",
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.05,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              SlidePageRoute(
                                                  page: feedback_menu(
                                                      id_reg: dataOrder?[index]
                                                          ["transaksi_id"])));
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: Color(0xff2ab2a2),
                                          ),
                                          padding: const EdgeInsets.all(8),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Feedback",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontFamily: "Inter",
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.05,
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
                          ));
                    },
                  ),
                ),

                // Expanded(
                //   child: ListView(
                //     children: [
                //       SizedBox(
                //         height: 20,
                //       ),

                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //
}

TableRow buildRow(String title, String value, double shiz) {
  return TableRow(
    children: [
      TableCell(
        child: SizedBox(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: shiz,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.06,
            ),
          ),
        ),
      ),
      TableCell(
        child: FractionallySizedBox(
          widthFactor:
              0.1, // Ubah nilai widthFactor sesuai kebutuhan (0.0 - 1.0)
          child: Text(
            ":",
            textAlign: TextAlign.center, // Perataan teks ke tengah
            style: TextStyle(
              color: Colors.black,
              fontSize: shiz,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.06,
            ),
          ),
        ),
      ),
      TableCell(
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: shiz,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.06,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
