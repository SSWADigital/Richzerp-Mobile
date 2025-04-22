import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

import 'dart:isolate';
import 'dart:ui';

class rincian_history extends StatefulWidget {
  const rincian_history({required this.id_reg});
  final String id_reg;
  @override
  _rincian_historyState createState() => _rincian_historyState();
}

class _rincian_historyState extends State<rincian_history>
    with SingleTickerProviderStateMixin {
  // void updateWidget() {
  //   setState(() {
  //     indikator = MyStepperWidget_3();
  //     btn = "Lanjut Cetak Bukti";
  //     tombol_riset = false;
  //     konten = pilihpekerjaan();
  //   });
  // }

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

  String? nama_drever, noOrder, merkUnit;
  String? tglstart,
      tgland,
      pic,
      bagian,
      safetyPermits,
      kodeUnit,
      kapasitas,
      DetailPekerjaan,
      transaksi_nominal,
      lokasi;

  List? TabelWaktuOrder;

  String? formatDate(String? inputDate) {
    final inputFormat = DateFormat('y-M-d');
    final outputFormat = DateFormat('d-M-y');
    final date = inputFormat.parse(inputDate!);
    return outputFormat.format(date);
  }

  Future lihatDetailOrder() async {
    final Response = await http.post(
        Uri.parse("http://101.50.2.211/api_gocrane/data_transaksi.php"),
        body: {"id": widget.id_reg, "paht": "o"});
    var data = jsonDecode(Response.body);
    print("${widget.id_reg}<///data registrasi");
    this.setState(() {
      if (Response.body == "null") {
        print("null");
      } else {
        // nama_user = data[0]['username'] ?? "";
        nama_drever = data[0]['driver_nama'];
        noOrder = data[0]['transaksi_kode'];
        lokasi = data[0]['transaksi_lokasi'];
        safetyPermits = data[0]['transaksi_safety_permit'];
        merkUnit = data[0]['alber_merk'];
        DetailPekerjaan = data[0]['transaksi_jenis_barang'];
        tglstart = data[0]['transaksi_tanggal'] ?? "";
        tgland = data[0]['transaksi_tanggal_selesai'] ?? "";
        pic = data[0]['transaksi_pic'];
        bagian = data[0]['struk_detail_nama'];
        kodeUnit = data[0]['alber_kode'];
        kapasitas = data[0]['alber_kapasitas'];
        transaksi_nominal = data[0]['transaksi_nominal'];
      }
      // gambar = data[0]json[0]['faskes_foto'];
    });

    final Respon = await http.post(
        Uri.parse("http://101.50.2.211/api_gocrane/data_transaksi.php"),
        body: {"id": widget.id_reg, "paht": "od"});

    this.setState(() {
      if (Respon.body == "false") {
        print("null");
      } else {
        TabelWaktuOrder = jsonDecode(Respon.body);
      }
      // gambar = datajson[0]['faskes_foto'];
    });
  }

  String formatDuration(int seconds) {
    final Duration duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, "0");

    final int hours = duration.inHours;
    final int minutes = duration.inMinutes.remainder(60);
    final int secs = duration.inSeconds.remainder(60);

    return "${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(secs)}";
  }

  // List<String> durasiTextList() {
  //   if (TabelWaktuOrder == null) {
  //     return <
  //         String>[]; // Mengembalikan daftar kosong jika TabelWaktuOrder null
  //   }

  //   try {
  //     return TabelWaktuOrder.map((item) {
  //       final durasiDetik = item["transaksi_detail_durasi_detik"];
  //       if (durasiDetik != null) {
  //         final durasiDetikInt = int.tryParse(durasiDetik.toString());
  //         if (durasiDetikInt != null) {
  //           final durasi = Duration(seconds: durasiDetikInt);
  //           final jam = durasi.inHours;
  //           final menit = durasi.inMinutes.remainder(60);
  //           final detik = durasi.inSeconds.remainder(60);
  //           return '($jam Jam $menit Menit $detik Detik)';
  //         }
  //       }
  //       return ''; // Tangani kasus ketika data tidak valid
  //     }).toList();
  //   } catch (e) {
  //     print(
  //         "Error: $e"); // Tangani kesalahan penguraian JSON atau konversi integer
  //     return <String>[]; // Mengembalikan daftar kosong jika terjadi kesalahan
  //   }
  // }
  String formatCurrency(String value) {
    final currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ');
    return currencyFormat.format(double.tryParse(value) ?? 0);
  }

  String accumulateDurations() {
    if (TabelWaktuOrder == null) {
      return ""; // Mengembalikan string kosong jika TabelWaktuOrder null
    }

    int totalDetik = 0;

    try {
      for (var item in TabelWaktuOrder!) {
        final durasiDetik = item["transaksi_detail_durasi_detik"];
        if (durasiDetik != null) {
          final durasiDetikInt = int.tryParse(durasiDetik.toString());
          if (durasiDetikInt != null) {
            totalDetik += durasiDetikInt;
          }
        }
      }
    } catch (e) {
      print(
          "Error: $e"); // Tangani kesalahan penguraian JSON atau konversi integer
    }

    final jam = totalDetik ~/ 3600; // 1 jam = 3600 detik
    final sisaDetik = totalDetik % 3600;
    final menit = sisaDetik ~/ 60; // 1 menit = 60 detik
    final detik = sisaDetik % 60;

    return '($jam Jam $menit Menit $detik Detik)';
  }

  final ReceivePort _port = ReceivePort();
  TabController? tb;
  int? tapIndex;
  @override
  void _handleTabSelection() {
    setState(() {});
  }

  MediaQueryData? queryData;
  @override
  void initState() {
    lihatDetailOrder();
    tb = TabController(length: 2, vsync: this);
    tb?.addListener(_handleTabSelection);

    tapIndex;
    // indikator = MyStepperWidget();
    // btn = "Lanjut Pilih Unit";
    // tombol_riset = false;
    // konten = formwaktu();
    // lihatprofil();
    // TODO: implement initState
    super.initState();
  }

  @override
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
                  height: 60,
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
                            "Order Detail",
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

                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, bottom: 14),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        shadows: [
                          BoxShadow(
                            color: Color(0x1C000000),
                            blurRadius: 4,
                            offset: Offset(0, 0),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8, top: 8),
                            child: Row(
                              children: [
                                Container(
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 0.50,
                                          color:
                                              Color.fromARGB(255, 14, 117, 18)),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 2),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Biaya',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.06,
                                        ),
                                      ),
                                      Text(
                                        accumulateDurations(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.06,
                                        ),
                                      ),
                                      // Center(
                                      //   child: Column(
                                      //     mainAxisAlignment:
                                      //         MainAxisAlignment.center,
                                      //     children: durasiTextList()
                                      //         .map((durasiText) {
                                      //       return Text(durasiText ?? "");
                                      //     }).toList(),
                                      //   ),
                                      // )
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 0.50,
                                          color: const Color.fromARGB(
                                              255, 29, 102, 32)),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 2),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        transaksi_nominal == null
                                            ? ""
                                            : formatCurrency(transaksi_nominal!)
                                                .toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.06,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 0.50,
                                    // strokeAlign: BorderSide.strokeAlignCenter,
                                    color: Color(0xFFEAE6E6),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 125,
                                      height: 115,
                                      decoration: ShapeDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              "https://images.unsplash.com/photo-1586458995526-09ce6839babe?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=873&q=80"),
                                          fit: BoxFit.cover,
                                        ),
                                        color: Color(0xFFD9D9D9),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                    // Flexible(
                                    //   child: Container(
                                    //     padding:
                                    //         const EdgeInsets.only(top: 8),
                                    //     width: 125,
                                    //     child: Text(
                                    //       "Munawir",
                                    //       textAlign: TextAlign.center,
                                    //       style: TextStyle(
                                    //         color: Colors.black,
                                    //         fontSize: 14,
                                    //         fontFamily: "Inter",
                                    //         fontWeight: FontWeight.w700,
                                    //         letterSpacing: 0.06,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Table(
                                            columnWidths: {
                                              1: FractionColumnWidth(0.1),
                                              0: FractionColumnWidth(0.5),
                                            },
                                            children: [
                                              buildRow("Nama Drever",
                                                  nama_drever ?? "", 14),
                                              buildRow("No Order",
                                                  noOrder ?? "", 14),
                                              buildRow(
                                                  "Tanggal Mulai",
                                                  tglstart == null
                                                      ? ""
                                                      : formatDate(tglstart)
                                                          .toString(),
                                                  14),
                                              buildRow(
                                                  "Tanggal Selesai",
                                                  tgland == null
                                                      ? ""
                                                      : formatDate(tgland)
                                                          .toString(),
                                                  14),
                                              buildRow("PIC", pic ?? "", 14),
                                              buildRow(
                                                  "Bagian", bagian ?? "", 14),
                                              buildRow("Safety Permits",
                                                  safetyPermits ?? "", 14),
                                              buildRow("Kode Unit",
                                                  kodeUnit ?? "", 14),
                                              buildRow("Kapasitas",
                                                  kapasitas ?? "", 14),
                                              buildRow("Detail Pekerjaan",
                                                  DetailPekerjaan ?? "", 14),
                                              buildRow(
                                                  "Lokasi", lokasi ?? "", 14),

                                              // nama_drever = data['driver_nama'] ?? "";
                                              // noOrder = data['transaksi_kode'] ?? "";
                                              // lokasi = data['transaksi_lokasi'] ?? "";
                                              // safetyPermits = data['transaksi_safety_permit'] ?? "";
                                              // merkUnit = data['alber_merk'] ?? "";
                                              // DetailPekerjaan = data['transaksi_jenis_barang'] ?? "";
                                              // tglstart = data['transaksi_tanggal'] ?? "";
                                              // tgland = data['transaksi_tanggal_selesai'] ?? "";
                                              // pic = data['transaksi_pic'] ?? "";
                                              // bagian = data['struk_detail_nama'] ?? "";
                                              // kodeUnit = data['alber_kode'] ?? "";
                                              // kapasitas = data['alber_kapasitas'] ?? "";
                                            ],
                                          ),
                                        ),
                                        // Sisanya mengikuti pola yang sama
                                        // ...
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
                  ],
                ),

                SizedBox(
                  height: 20,
                ),

//Anda dapat menambahkan lebih banyak widget Tab sesuai dengan kebutuhan. Pastikan juga sudah menginisialisasi controller tb sebelumnya.

                Expanded(
                    child: Container(
                  child: ListView(
                    children: [
                      Container(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: TabelWaktuOrder == null
                              ? Center(
                                  child: Container(),
                                )
                              : Table(
                                  columnWidths: {
                                    0: FlexColumnWidth(
                                        0.4), // Kolom 0 memiliki lebar sebanding dengan kontennya
                                    // Kolom 2 memiliki lebar tetap 100 piksel
                                  },
                                  border: TableBorder.all(
                                    color: Colors.black,
                                    width: 1.0,
                                    style: BorderStyle.solid,
                                  ),
                                  children: [
                                    TableRow(
                                      decoration: BoxDecoration(
                                        color: Colors.amber,
                                      ),
                                      children: [
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              'No',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'Start',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'Stop',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              '	Durasi',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ...TabelWaktuOrder!
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      final int index = entry.key;
                                      final Map<String, dynamic> item =
                                          entry.value;
                                      return TableRow(
                                        children: [
                                          TableCell(
                                            child: Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Text(
                                                  (index + 1).toString(),
                                                ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                item['transaksi_detail_mulai'] ??
                                                    "",
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(item[
                                                      'transaksi_detail_selesai'] ??
                                                  "-"),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                item['transaksi_detail_durasi_detik'] !=
                                                        null
                                                    ? formatDuration(int.tryParse(
                                                            item['transaksi_detail_durasi_detik']
                                                                .toString()) ??
                                                        0)
                                                    : "",
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ],
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Total Durasi :',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.06,
                                ),
                              ),
                              Spacer(),
                              Text(
                                accumulateDurations(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.06,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Container(
                      //   padding: EdgeInsets.symmetric(
                      //       horizontal: 16), // Padding untuk tabel
                      //   child: Table(
                      //     columnWidths: {
                      //       0: FlexColumnWidth(
                      //           0.4), // Kolom 0 memiliki lebar sebanding dengan kontennya
                      //       // Kolom 2 memiliki lebar tetap 100 piksel
                      //     },
                      //     border: TableBorder.all(
                      //         color: Colors.black,
                      //         width: 1.0), // Garis pemisah antara sel
                      //     children: [
                      //       TableRow(
                      //         children: [
                      //           TableCell(
                      //             child: Container(
                      //               color: Color(0xff2ab2a2),
                      //               padding: EdgeInsets.all(8.0),
                      //               child: Text(
                      //                 'No',
                      //                 style: TextStyle(
                      //                     fontWeight: FontWeight.bold),
                      //               ),
                      //             ),
                      //           ),
                      //           TableCell(
                      //             child: Container(
                      //               color: Color(0xff2ab2a2),
                      //               padding: EdgeInsets.all(8.0),
                      //               child: Text(
                      //                 'Start',
                      //                 style: TextStyle(
                      //                     fontWeight: FontWeight.bold),
                      //               ),
                      //             ),
                      //           ),
                      //           TableCell(
                      //             child: Container(
                      //               color: Color(0xff2ab2a2),
                      //               padding: EdgeInsets.all(8.0),
                      //               child: Text(
                      //                 'Stop',
                      //                 style: TextStyle(
                      //                     fontWeight: FontWeight.bold),
                      //               ),
                      //             ),
                      //           ),
                      //           TableCell(
                      //             child: Container(
                      //               color: Color(0xff2ab2a2),
                      //               padding: EdgeInsets.all(8.0),
                      //               child: Text(
                      //                 'Durasi',
                      //                 style: TextStyle(
                      //                     fontWeight: FontWeight.bold),
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       TableRow(
                      //         children: [
                      //           TableCell(
                      //             child: Container(
                      //               padding: EdgeInsets.all(8.0),
                      //               child: Text('1'),
                      //             ),
                      //           ),
                      //           TableCell(
                      //             child: Container(
                      //               padding: EdgeInsets.all(8.0),
                      //               child: Text('08:00'),
                      //             ),
                      //           ),
                      //           TableCell(
                      //             child: Container(
                      //               padding: EdgeInsets.all(8.0),
                      //               child: Text('09:00'),
                      //             ),
                      //           ),
                      //           TableCell(
                      //             child: Container(
                      //               padding: EdgeInsets.all(8.0),
                      //               child: Text('1 jam'),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 16),
                      //   child: Container(
                      //     decoration: ShapeDecoration(
                      //       color: Colors.white,
                      //       shape: RoundedRectangleBorder(
                      //         side: BorderSide(width: 1, color: Colors.black),
                      //         borderRadius: BorderRadius.circular(2),
                      //       ),
                      //     ),
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 10, vertical: 2),
                      //     child: Row(
                      //       mainAxisSize: MainAxisSize.min,
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       crossAxisAlignment: CrossAxisAlignment.center,
                      //       children: [
                      //         Text(
                      //           'Total Durasi :',
                      //           textAlign: TextAlign.center,
                      //           style: TextStyle(
                      //             color: Colors.black,
                      //             fontSize: 15,
                      //             fontWeight: FontWeight.w700,
                      //             letterSpacing: 0.06,
                      //           ),
                      //         ),
                      //         Spacer(),
                      //         Text(
                      //           '00 jam 00 menit 00 detik',
                      //           textAlign: TextAlign.center,
                      //           style: TextStyle(
                      //             color: Colors.black,
                      //             fontSize: 15,
                      //             fontWeight: FontWeight.w700,
                      //             letterSpacing: 0.06,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                )),

                ////////////////////////////////////////

                ////////////////////////////////////////

                // indikator,
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
              fontSize: 12,
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
              fontSize: 12,
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
                  fontSize: 12,
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
