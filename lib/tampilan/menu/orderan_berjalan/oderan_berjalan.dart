import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gocrane_v3/tampilan/SlideRightRoute.dart';
import 'package:gocrane_v3/tampilan/menu/orderan_berjalan/map.dart';
import 'package:gocrane_v3/tampilan/menu/orderan_berjalan/order_detail2.dart';

import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:path_provider/path_provider.dart';
import 'dart:isolate';
import 'dart:ui';

import 'package:url_launcher/url_launcher.dart';

class order_berjalan extends StatefulWidget {
  @override
  _order_berjalanState createState() => _order_berjalanState();
}

class _order_berjalanState extends State<order_berjalan> {
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

  // ignore: unused_field
  final ReceivePort _port = ReceivePort();

  void downloadFile() async {
    var fileUrl =
        'http://101.50.2.211/decpetro/document/1683944847159_230513093901_22176211.pdf';
    var fileName = 'coba';
    var response = await http.get(Uri.parse(fileUrl));
    if (response.statusCode == 200) {
      var bytes = response.bodyBytes;
      var directory = await getExternalStorageDirectory();
      var filePath = '${directory!.path}/${fileName}.pdf';
      await File(filePath).writeAsBytes(bytes);
    }
  }

  void sendWhatsAppMessage(String phoneNumber, String message) async {
    String url = 'https://wa.me/$phoneNumber?text=${Uri.encodeFull(message)}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Tidak dapat membuka WhatsApp';
    }
  }

  List card = [
    {
      "no_order": "230411142931",
      "lokasi": "coba",
      "Unit": "CRN 25",
      "PIC": "coba",
      "no_ext": "12345",
      "keterangan": "Konfirmasi Candal",
      "status": "c"
    },
    {
      "no_order": "230411142931",
      "lokasi": "coba",
      "Unit": "CRN 25",
      "PIC": "coba",
      "no_ext": "12345",
      "keterangan": "Menunggu Persetujuan Alber",
      "status": "n"
    },
    {
      "no_order": "230411142931",
      "lokasi": "coba",
      "Unit": "CRN 25",
      "PIC": "coba",
      "no_ext": "12345",
      "keterangan": "Disetujui Evaluator Alber",
      "status": "a"
    },
    {
      "no_order": "230411142931",
      "lokasi": "coba",
      "Unit": "CRN 25",
      "PIC": "coba",
      "no_ext": "12345",
      "keterangan": "Start by Driver",
      "status": "f"
    },
    // {
    //   "no_order": "230411142931",
    //   "lokasi": "coba",
    //   "Unit": "CRN 25",
    //   "PIC": "coba",
    //   "no_ext": "12345",
    //   "keterangan": "Closed by Evaluator Alber",
    //   "status": "s"
    // }
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case "a":
        return Colors.blue; // Warna untuk status 1
      case "n":
        return Colors.amber; // Warna untuk status 2
      case "c":
        return Colors.red; // Warna untuk status 3
      case "s":
        return const Color(0xFF2AB2A2); // Warna untuk status 4
      // case "s":
      //   return Colors.blue; // Warna untuk status 5
      default:
        return Colors.white; // Warna default jika status tidak cocok
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case "a":
        return "Disetujui Evaluator Alber"; // Warna untuk status 1
      case "n":
        return "Menunggu Persetujuan Alber"; // Warna untuk status 2
      case "c":
        return "Konfirmasi Candal"; // Warna untuk status 3
      case "s":
        return "Start by Driver"; // Warna untuk status 4
      // case "s":
      //   return Colors.blue; // Warna untuk status 5
      default:
        return ""; // Warna default jika status tidak cocok
    }
  }

  //////////////////////////////////////////////////////
  List? dataOrder;
  Future OrderBerjalan() async {
    final prefs = await SharedPreferences.getInstance();

    var id_user = (prefs.get('usr_id'));
    final Response = await http.post(
        Uri.parse("http://101.50.2.211/api_gocrane/user_order_berjalan.php"),
        body: {"id_usr": id_user});

    setState(() {
      if (Response.body == "false") {
        print("null");
      } else {
        dataOrder = jsonDecode(Response.body);
      }
      // gambar = datajson[0]['faskes_foto'];
    });
  }

  MediaQueryData? queryData;

  @override
  void initState() {
    OrderBerjalan();
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
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
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
                          top: 0,
                          bottom: 0,
                          start: 0,
                          end: 0,
                          child: Container(
                            alignment: Alignment.center,
                            child: const Text(
                              "Order Berjalan",
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
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        TextFormField(
                          // controller: emailController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(top: 5, left: 14),
                            hintText: "Cari berdasarkan unit",
                            prefixIcon: Icon(Icons.search),
                            labelStyle: TextStyle(
                                fontSize: 14,
                                fontFamily: "medium",
                                color: Colors.grey),
                          ),
                          style: const TextStyle(
                              fontSize: 14,
                              fontFamily: "medium",
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),

                // indikator,
                const SizedBox(
                  height: 10,
                ),

                Expanded(
                  child: ListView.builder(
                      itemCount: dataOrder == null ? 0 : dataOrder?.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              // indikator = MyStepperWidget_3();
                              // btn = "Lanjut Cetak Bukti";
                              // tombol_riset = true;
                              // konten = pilihpekerjaan();
                              // unit_list = "n";
                            });
                          },

                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: Card(
                              elevation: 5,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.white),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(16),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    top: 8),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          _getStatusText(
                                                              dataOrder![index][
                                                                  "transaksi_status"]),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: dataOrder![
                                                                            index]
                                                                        [
                                                                        "transaksi_status"] ==
                                                                    'f'
                                                                ? Colors.black
                                                                : _getStatusColor(
                                                                    dataOrder![
                                                                            index]
                                                                        [
                                                                        "transaksi_status"]),
                                                            fontSize: 14,
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            letterSpacing: 0.07,
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        Text(
                                                          dataOrder![index][
                                                              "transaksi_tanggal"],
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            letterSpacing: 0.07,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Container(
                                                child: Row(
                                                  children: [
                                                    const Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'No Orderan',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF141414),
                                                            fontSize: 12,
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            letterSpacing: 0.06,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Unit',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF141414),
                                                            fontSize: 12,
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            letterSpacing: 0.06,
                                                          ),
                                                        ),
                                                        Text(
                                                          'PIC',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF141414),
                                                            fontSize: 12,
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            letterSpacing: 0.06,
                                                          ),
                                                        ),
                                                        Text(
                                                          'No Ext',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF141414),
                                                            fontSize: 12,
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            letterSpacing: 0.06,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Lokasi',
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF141414),
                                                            fontSize: 12,
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            letterSpacing: 0.06,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8),
                                                      child: Container(
                                                        child: const Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              child: Text(
                                                                ":",
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      "Inter",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  letterSpacing:
                                                                      0.06,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              child: Text(
                                                                ":",
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      "Inter",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  letterSpacing:
                                                                      0.06,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              child: Text(
                                                                ":",
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      "Inter",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  letterSpacing:
                                                                      0.06,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              child: Text(
                                                                ":",
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      "Inter",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  letterSpacing:
                                                                      0.06,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              child: Text(
                                                                ":",
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      "Inter",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  letterSpacing:
                                                                      0.06,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8),
                                                      child: Container(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              child: Text(
                                                                dataOrder![
                                                                        index][
                                                                    "transaksi_kode"],
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      "Inter",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  letterSpacing:
                                                                      0.06,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              child: Text(
                                                                dataOrder![index]
                                                                        [
                                                                        "alber_no_plat"] ??
                                                                    "",
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      "Inter",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  letterSpacing:
                                                                      0.06,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              child: Text(
                                                                dataOrder![index]
                                                                        [
                                                                        "transaksi_pic"] ??
                                                                    "",
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      "Inter",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  letterSpacing:
                                                                      0.06,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              child: Text(
                                                                dataOrder![index]
                                                                        [
                                                                        "transaksi_no_extention"] ??
                                                                    "",
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      "Inter",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  letterSpacing:
                                                                      0.06,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              child: Text(
                                                                dataOrder![index]
                                                                        [
                                                                        "transaksi_lokasi"] ??
                                                                    "",
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      "Inter",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  letterSpacing:
                                                                      0.06,
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
                                        const SizedBox(height: 10),
                                        Container(
                                          width: 320,
                                          decoration: const ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 0.50,
                                                // strokeAlign: BorderSide.strokeAlignCenter,
                                                color: Color(0xFFEAE6E6),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    color: _getStatusColor(
                                        dataOrder![index]["transaksi_status"]),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                      child: Container(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                sendWhatsAppMessage(
                                                    '+6282224076234', '');
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 2),
                                                decoration: ShapeDecoration(
                                                  color: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    side: const BorderSide(
                                                        width: 0.50,
                                                        color: Color.fromARGB(
                                                            255, 27, 94, 32)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2),
                                                  ),
                                                ),
                                                child: const Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.call,
                                                      color: Colors.green,
                                                      size: 20,
                                                    ),
                                                    Text(
                                                      'WhatsApp',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 15,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        letterSpacing: 0.06,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            Visibility(
                                              visible: dataOrder![index][
                                                              "transaksi_status"] !=
                                                          'a' &&
                                                      dataOrder![index][
                                                              "transaksi_status"] !=
                                                          'c' &&
                                                      dataOrder![index][
                                                              "transaksi_status"] !=
                                                          'n'
                                                  ? true
                                                  : false,
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      SlidePageRoute(
                                                          page: GoogleMapScreen(
                                                              id_reg: dataOrder![
                                                                      index][
                                                                  "transaksi_id"]))); //GoogleMapScreen
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 2),
                                                  decoration: ShapeDecoration(
                                                    color: Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: const BorderSide(
                                                          width: 0.50,
                                                          color: Color(
                                                              0xFF014EE4)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2),
                                                    ),
                                                  ),
                                                  child: const Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Map',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF014EE4),
                                                          fontSize: 15,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          letterSpacing: 0.06,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            dataOrder![index][
                                                            "transaksi_status"] !=
                                                        'a' &&
                                                    dataOrder![index][
                                                            "transaksi_status"] !=
                                                        'c' &&
                                                    dataOrder![index][
                                                            "transaksi_status"] !=
                                                        'n'
                                                ? const Spacer()
                                                : Container(),
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    SlidePageRoute(
                                                        page: order_detail2(
                                                            id_reg: dataOrder![
                                                                    index][
                                                                "transaksi_id"]))); //GoogleMapScreen
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 2),
                                                decoration: ShapeDecoration(
                                                  color:
                                                      const Color(0xFF014EE4),
                                                  shape: RoundedRectangleBorder(
                                                    side: const BorderSide(
                                                        width: 0.50,
                                                        color:
                                                            Color(0xFF014EE4)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2),
                                                  ),
                                                ),
                                                child: const Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Detail',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        letterSpacing: 0.06,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // child: Padding(
                          //   padding: const EdgeInsets.all(16),
                          //   child: Card(
                          //       elevation: 4,
                          //       child: Column(
                          //         children: [
                          //           // Container(
                          //           //   color: Colors.white,
                          //           //   padding: const EdgeInsets.symmetric(
                          //           //     horizontal: 10,
                          //           //   ),
                          //           //   child: Column(
                          //           //     mainAxisSize: MainAxisSize.min,
                          //           //     mainAxisAlignment:
                          //           //         MainAxisAlignment.start,
                          //           //     crossAxisAlignment:
                          //           //         CrossAxisAlignment.start,
                          //           //     children: [
                          //           //       Row(
                          //           //         children: [
                          //           //           Container(
                          //           //             child: Column(
                          //           //               mainAxisSize:
                          //           //                   MainAxisSize.min,
                          //           //               mainAxisAlignment:
                          //           //                   MainAxisAlignment.start,
                          //           //               crossAxisAlignment:
                          //           //                   CrossAxisAlignment.start,
                          //           //               children: [
                          //           //                 // Row(
                          //           //                 //   children: [
                          //           //                 //     Text(
                          //           //                 //       card[index][
                          //           //                 //               "no_order"] ??
                          //           //                 //           "",
                          //           //                 //       textAlign:
                          //           //                 //           TextAlign.start,
                          //           //                 //       style: TextStyle(
                          //           //                 //         color: Color(
                          //           //                 //             0xff2ab2a2),
                          //           //                 //         fontSize: 14,
                          //           //                 //         fontFamily: "Inter",
                          //           //                 //         fontWeight:
                          //           //                 //             FontWeight.w600,
                          //           //                 //         letterSpacing: 0.07,
                          //           //                 //       ),
                          //           //                 //     ),
                          //           //                 //     // Spacer(),
                          //           //                 //     Text(
                          //           //                 //       "11-04-2023",
                          //           //                 //       style: TextStyle(
                          //           //                 //         color: Color(
                          //           //                 //             0xff2ab2a2),
                          //           //                 //         fontSize: 14,
                          //           //                 //         fontFamily: "Inter",
                          //           //                 //         fontWeight:
                          //           //                 //             FontWeight.w600,
                          //           //                 //         letterSpacing: 0.07,
                          //           //                 //       ),
                          //           //                 //     ),
                          //           //                 //   ],
                          //           //                 // ),
                          //           //                 SizedBox(height: 4),
                          //           //                 SizedBox(height: 8),
                          //           //                 Text(
                          //           //                   "CRN 25",
                          //           //                   style: TextStyle(
                          //           //                     color:
                          //           //                         Color(0xff141414),
                          //           //                     fontSize: 12,
                          //           //                     letterSpacing: 0.06,
                          //           //                   ),
                          //           //                 ),
                          //           //                 SizedBox(height: 4),
                          //           //                 Text(
                          //           //                   "Alat Berat",
                          //           //                   style: TextStyle(
                          //           //                     color:
                          //           //                         Color(0xff141414),
                          //           //                     fontSize: 12,
                          //           //                     letterSpacing: 0.06,
                          //           //                   ),
                          //           //                 ),
                          //           //                 SizedBox(height: 4),
                          //           //                 Text(
                          //           //                   "Bambang",
                          //           //                   style: TextStyle(
                          //           //                     color:
                          //           //                         Color(0xff141414),
                          //           //                     fontSize: 12,
                          //           //                     letterSpacing: 0.06,
                          //           //                   ),
                          //           //                 ),
                          //           //                 SizedBox(height: 4),
                          //           //                 Text(
                          //           //                   "12345",
                          //           //                   style: TextStyle(
                          //           //                     color:
                          //           //                         Color(0xff141414),
                          //           //                     fontSize: 12,
                          //           //                     letterSpacing: 0.06,
                          //           //                   ),
                          //           //                 ),
                          //           //               ],
                          //           //             ),
                          //           //           ),
                          //           //         ],
                          //           //       ),
                          //           //       // Column(
                          //           //       //   mainAxisSize: MainAxisSize.min,
                          //           //       //   mainAxisAlignment:
                          //           //       //       MainAxisAlignment.start,
                          //           //       //   crossAxisAlignment:
                          //           //       //       CrossAxisAlignment.start,
                          //           //       //   children: [],
                          //           //       // ),
                          //           //     ],
                          //           //   ),
                          //           // ),
                          //           Container(
                          //             height: 50,
                          //             color: Color(0xff2ab2a2),
                          //             child: Padding(
                          //               padding: const EdgeInsets.all(8.0),
                          //               child: Row(
                          //                 mainAxisSize: MainAxisSize.min,
                          //                 mainAxisAlignment:
                          //                     MainAxisAlignment.start,
                          //                 crossAxisAlignment:
                          //                     CrossAxisAlignment.center,
                          //                 children: [
                          //                   Expanded(
                          //                     child: Row(
                          //                       mainAxisSize: MainAxisSize.max,
                          //                       mainAxisAlignment:
                          //                           MainAxisAlignment.start,
                          //                       crossAxisAlignment:
                          //                           CrossAxisAlignment.start,
                          //                       children: [
                          //                         Text(
                          //                           "Disetujui",
                          //                           textAlign: TextAlign.center,
                          //                           style: TextStyle(
                          //                             color: Colors.white,
                          //                             fontSize: 12,
                          //                             fontFamily: "Inter",
                          //                             fontWeight:
                          //                                 FontWeight.w600,
                          //                             letterSpacing: 0.06,
                          //                           ),
                          //                         ),
                          //                       ],
                          //                     ),
                          //                   ),
                          //                   Spacer(),
                          //                   InkWell(
                          //                     onTap: () {
                          //                       Navigator.push(
                          //                           context,
                          //                           SlidePageRoute(
                          //                               page: order_detail2()));
                          //                     },
                          //                     child: Container(
                          //                       decoration: BoxDecoration(
                          //                         borderRadius:
                          //                             BorderRadius.circular(2),
                          //                         border: Border.all(
                          //                           color: Color(0xff014ee4),
                          //                           width: 1,
                          //                         ),
                          //                       ),
                          //                       padding:
                          //                           const EdgeInsets.symmetric(
                          //                         horizontal: 10,
                          //                         vertical: 2,
                          //                       ),
                          //                       child: Row(
                          //                         mainAxisSize:
                          //                             MainAxisSize.min,
                          //                         mainAxisAlignment:
                          //                             MainAxisAlignment.start,
                          //                         crossAxisAlignment:
                          //                             CrossAxisAlignment.start,
                          //                         children: [
                          //                           Text(
                          //                             "Detail",
                          //                             textAlign:
                          //                                 TextAlign.center,
                          //                             style: TextStyle(
                          //                               color:
                          //                                   Color(0xff014ee4),
                          //                               fontSize: 15,
                          //                               fontFamily: "Inter",
                          //                               fontWeight:
                          //                                   FontWeight.w600,
                          //                               letterSpacing: 0.06,
                          //                             ),
                          //                           ),
                          //                         ],
                          //                       ),
                          //                     ),
                          //                   ),
                          //                   Spacer(),
                          //                   InkWell(
                          //                     onTap: () {
                          //                       Navigator.push(
                          //                           context,
                          //                           SlidePageRoute(
                          //                               page: order_detail2()));
                          //                     },
                          //                     child: Container(
                          //                       decoration: BoxDecoration(
                          //                         color: Colors.white,
                          //                         borderRadius:
                          //                             BorderRadius.circular(2),
                          //                         border: Border.all(
                          //                           color: Colors.green,
                          //                           width: 1,
                          //                         ),
                          //                       ),
                          //                       padding:
                          //                           const EdgeInsets.symmetric(
                          //                         horizontal: 10,
                          //                         vertical: 2,
                          //                       ),
                          //                       child: Row(
                          //                         mainAxisSize:
                          //                             MainAxisSize.min,
                          //                         mainAxisAlignment:
                          //                             MainAxisAlignment.start,
                          //                         crossAxisAlignment:
                          //                             CrossAxisAlignment.start,
                          //                         children: [
                          //                           Row(
                          //                             children: [
                          //                               Icon(
                          //                                 Icons.call,
                          //                                 color: Colors.green,
                          //                               ),
                          //                               Text(
                          //                                 "Whats App",
                          //                                 textAlign:
                          //                                     TextAlign.center,
                          //                                 style: TextStyle(
                          //                                   color: Colors.green,
                          //                                   fontSize: 15,
                          //                                   fontFamily: "Inter",
                          //                                   fontWeight:
                          //                                       FontWeight.w600,
                          //                                   letterSpacing: 0.06,
                          //                                 ),
                          //                               ),
                          //                             ],
                          //                           ),
                          //                         ],
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 ],
                          //               ),
                          //             ),
                          //           ),
                          //         ],
                          //       )),
                          // ),
                        );
                      }),
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
