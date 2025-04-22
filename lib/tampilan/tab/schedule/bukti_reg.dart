import 'package:flutter/material.dart';
import 'package:gocrane_v3/tampilan/homeLama.dart';

import 'package:gocrane_v3/tampilan/tab/beranda.dart';

// import 'package:geolocator/geolocator.dart';

// import 'package:gocrane_v3/UI/posisi.dart';

import 'package:gocrane_v3/main.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class qr extends StatefulWidget {
  const qr({
    required this.list,
    required this.index,
  });
  final List list;
  final int index;

  @override
  State<qr> createState() => _qrState();
}

class _qrState extends State<qr> {
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        return false;
      },
      child: MediaQuery(
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
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()),
                                  (route) => false);
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
                            child: Text(
                              "Bukti Registrasi",
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
                        //Space
                        SizedBox(
                          height: 12,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            "ID Reservasi",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'medium',
                                color: Colors.grey),
                          ),
                        ),

                        //Space
                        SizedBox(
                          height: 12,
                        ),

                        //card img
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Container(
                              alignment: Alignment.center,
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: QrImageView(
                                        data: 'Halo, ini adalah kode QR',
                                        version: QrVersions.auto,
                                        size: 200.0,
                                      ),
                                    ),
                                  )),
                              //widget.list[widget.index]['reservasi_id']),
                              // width: double.infinity,
                              // height: 200,
                              // margin: EdgeInsets.symmetric(horizontal: 14.5),
                              // decoration: BoxDecoration(
                              //     image: DecorationImage(
                              //         fit: BoxFit.contain,
                              //         image: AssetImage("assets/imgs/qr.png"))),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            "65765765565",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'medium',
                                color: Colors.black),
                          ),
                        ),
                        //Space
                        SizedBox(
                          height: 5,
                        ),

                        Container(
                          height: 300,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                                // headingRowColor: MaterialStateColor.resolveWith(
                                //     (states) => Colors.blue),
                                columnSpacing: 38.0,
                                columns: [
                                  // DataColumn(label: Text('Pilih')),
                                  DataColumn(label: Text('')),
                                  DataColumn(label: Text('')),
                                  // DataColumn(label: Text('Tanggal')),
                                ],
                                rows: <DataRow>[
                                  // DataRow(
                                  //   cells: <DataCell>[
                                  //     DataCell(Text("Tanggal Reservasi")),
                                  //     DataCell(Text(DateFormat("dd-MM-yyyy")
                                  //         .format(DateTime.parse(
                                  //             tglbooking ?? "")))),
                                  //     // DataCell(Text("6.0")),
                                  //     // DataCell(Text("4.0")),
                                  //   ],
                                  // ),
                                  // DataRow(
                                  //   cells: <DataCell>[
                                  //     DataCell(Text("Dokter")),
                                  //     DataCell(Text(nama_dokter ?? "")),
                                  //   ],
                                  // ),
                                  // DataRow(
                                  //   cells: <DataCell>[
                                  //     DataCell(Text("Faskes")),
                                  //     DataCell(Text(namapoli!)),
                                  //     // DataCell(Text("6.0")),
                                  //     // DataCell(Text("4.0")),
                                  //   ],
                                  // ),
                                ]
                                //  List.generate(1, (index) {
                                //   // final p =
                                //   // Checkbox(
                                //   //     value: tappilih == index ? true : false,
                                //   //     activeColor: Colors.blue,
                                //   //     onChanged: (e) {
                                //   //       setState(() {
                                //   //         tappilih = index;
                                //   //         txtjadwal.text =
                                //   //             jadwal[index]['faskes_jadwal_id'];
                                //   //         print(txtjadwal);
                                //   //       });
                                //   //     });
                                //   // final y = jadwal[index]['faskes_jadwal_hari'];

                                //   // final x = jadwal[index]['faskes_jadwal_jam_awal'];
                                //   // final z = jadwal[index]['faskes_jadwal_jam_akhir'];
                                //   // final w = jadwal[index]['faskes_jadwal_hari_number'];

                                //   return DataRow(cells: [
                                //     // DataCell(Container(child: p)),
                                //     DataCell(Container(
                                //         child: Text(widget.list[widget.index]
                                //                 ['faskes_nama'] ??
                                //             ""))),
                                //     DataCell(Container(
                                //         child: Text(widget.list[widget.index]
                                //                 ['pegawai_nama'] ??
                                //             ""))),
                                //     DataCell(Container(
                                //         child: Text(widget.list[widget.index]
                                //                 ['reservasi_tanggal'] ??
                                //             "")))
                                //   ]);
                                // }
                                // ),
                                ),
                          ),
                        ),

                        //
                      ],
                    ),
                  )
                ],
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              elevation: 5,
              child: Container(
                height: 70,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: MaterialButton(
                          height: 44,
                          onPressed: () {
                            // FocusScope.of(context).requestFocus(FocusNode());
                            // check();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                              (route) => false,
                            );
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                            side: BorderSide(
                                color:
                                    Color(0xFF007100)), // Tambahkan baris ini
                          ),
                          color: Colors
                              .white, // Ubah warna latar belakang menjadi putih
                          elevation: 0,
                          highlightElevation: 0,
                          child: Container(
                              child: Text(
                            'Kembali ke Beranda',
                            style: TextStyle(
                              color: Color(0xFF007100),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              height: 0,
                            ),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
