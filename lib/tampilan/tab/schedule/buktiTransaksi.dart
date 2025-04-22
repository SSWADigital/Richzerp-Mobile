import 'package:flutter/material.dart';
import 'package:gocrane_v3/tampilan/SlideRightRoute.dart';
import 'package:gocrane_v3/tampilan/homeLama.dart';

import 'package:gocrane_v3/tampilan/tab/beranda.dart';

// import 'package:geolocator/geolocator.dart';

// import 'package:gocrane_v3/UI/posisi.dart';

import 'package:gocrane_v3/main.dart';
import 'package:gocrane_v3/tampilan/tab/schedule/penilaian.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class buktiTransaksi extends StatefulWidget {
  const buktiTransaksi({
    required this.list,
    required this.index,
  });
  final List list;
  final int index;

  @override
  State<buktiTransaksi> createState() => _buktiTransaksiState();
}

class _buktiTransaksiState extends State<buktiTransaksi> {
  final cardNumbController = TextEditingController();
  final nameController = TextEditingController();
  final expiryController = TextEditingController();
  final securityController = TextEditingController();

  //
  DateTime currentDate = new DateTime.now();
  var dateVal;
  var now = new DateTime.now();
  Future<void> openDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate,
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != currentDate) {
      setState(() {
        dateVal = DateFormat('MM/yyyy').format(picked);
      });
    }
  }

  //
  bool isSave = false;
  checkOnChange() {
    setState(() {
      if (cardNumbController.text.length == 16 &&
          nameController.text.length > 0 &&
          dateVal != null &&
          securityController.text.length == 4) {
        isSave = true;
      } else {
        setState(() {
          isSave = false;
        });
      }
    });
  }

  //For validateCardNumb
  String? validateCardNumb(String value) {
    if (value.isEmpty) {
      return "Invalid number";
    } else if (value.length < 16 || value.length > 16) {
      return "Invalid number";
    } else {
      return null;
    }
  }

  //For validateCardNumb
  String? validateCVC(String value) {
    if (value.isEmpty) {
      return "Invalid number";
    } else if (value.length < 4 || value.length > 4) {
      return "Invalid number";
    } else {
      return null;
    }
  }

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  void validate(name, card, month, year, cvc) {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
    } else {
      print('Form is invalid');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  MediaQueryData? queryData;
  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return MediaQuery(
      data: queryData!.copyWith(textScaleFactor: 1.0),
      child: SafeArea(
        child: Scaffold(
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
                        start: -4,
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
                              scale: 30,
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
                            "ANTRIAN POLI",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'medium',
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        width: 243,
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x0C000000),
                              blurRadius: 28,
                              offset: Offset(0, 0),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32, vertical: 16),
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Proses',
                                                  style: TextStyle(
                                                    color: Color(0xFF008E00),
                                                    fontSize: 17,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                const SizedBox(height: 16),
                                                Container(
                                                  width: double.infinity,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          height: 16,
                                                          child: const Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Tanggal Registrasi',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFFA5A5A5),
                                                                  fontSize: 14,
                                                                  fontFamily:
                                                                      'Inter',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 16),
                                                      Text(
                                                        '${widget.list[widget.index]['formatted_update_time'] ?? ""} WIB',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFFA5A5A5),
                                                          fontSize: 14,
                                                          fontFamily: 'Inter',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
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
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            child: const Text(
                                              "ID Reservasi",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'medium',
                                                  color: Colors.grey),
                                            ),
                                          ),

                                          //Space
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Container(
                                              alignment: Alignment.center,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: QrImageView(
                                                    data: widget.list[
                                                                widget.index]
                                                            ['reg_buffer_id'] ??
                                                        "",
                                                    version: QrVersions.auto,
                                                    size: 200.0,
                                                  ),
                                                ),
                                              )),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              widget.list[widget.index]
                                                      ['reg_buffer_id'] ??
                                                  "", //reg_buffer_tanggal
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'medium',
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        child: const Text(
                                          'Detail Registrasi',
                                          style: TextStyle(
                                            color: Color(0xFF141414),
                                            fontSize: 17,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w700,
                                            height: 0.08,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      Text(
                                        widget.list[widget.index]
                                                ['cust_usr_nama'] ??
                                            "",
                                        style: TextStyle(
                                          color: Color(0xFF141414),
                                          fontSize: 17,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'No. RM ${widget.list[widget.index]['cust_usr_kode'] ?? ""}',
                                        style: TextStyle(
                                          color: Color(0xFF141414),
                                          fontSize: 17,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'Layanan Poli',
                                        style: TextStyle(
                                          color: Color(0xFFA5A5A5),
                                          fontSize: 17,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        widget.list[widget.index]
                                                ['poli_nama'] ??
                                            "",
                                        style: const TextStyle(
                                          color: Color(0xFF141414),
                                          fontSize: 17,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'Dokter',
                                        style: TextStyle(
                                          color: Color(0xFFA5A5A5),
                                          fontSize: 17,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        widget.list[widget.index]['usr_name'] ??
                                            "",
                                        style: const TextStyle(
                                          color: Color(0xFF141414),
                                          fontSize: 17,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'Jenis Pasien',
                                        style: TextStyle(
                                          color: Color(0xFFA5A5A5),
                                          fontSize: 17,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        widget.list[widget.index]
                                                ['jenis_nama'] ??
                                            "",
                                        style: TextStyle(
                                          color: Color(0xFF141414),
                                          fontSize: 17,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            elevation: 5,
            height: 152,
            child: Container(
              height: 150,
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
                                Navigator.push(
                                    context, SlidePageRoute(page: penilaian()));
                                // Fungsi yang akan dijalankan saat tombol ditekan
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 10),
                              color: const Color(0xFF007100),
                              minWidth: 312,
                              height: 48,
                              child: const Text(
                                'Beri Penilaian',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                                child: MaterialButton(
                              onPressed: () {
                                // Fungsi yang akan dijalankan saat tombol ditekan
                                print('Tapped on "Batalkan Registrasi"');
                              },
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 1, color: Color(0xFFF24E1E)),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 10),
                              minWidth: 312,
                              height: 48,
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Batalkan Registrasi',
                                    style: TextStyle(
                                      color: Color(0xFFF24E1E),
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ],
                        ),
                      )
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String text;

  InfoCard({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Colors.blue),
        const SizedBox(height: 10),
        Text(text, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
