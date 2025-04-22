import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'dart:isolate';
import 'dart:ui';

class feedback_menu extends StatefulWidget {
  const feedback_menu({required this.id_reg});
  final String id_reg;
  @override
  _feedback_menuState createState() => _feedback_menuState();
}

class _feedback_menuState extends State<feedback_menu> {
  int _waktuRating = 0;
  int _pelayananRating = 0;
  int _performaAlatRating = 0;
  int _performaOperatorRating = 0;
  void _insertDatafeedback() async {
    final prefs = await SharedPreferences.getInstance();

    var id_usr = (prefs.get('usr_id'));
    final url = Uri.parse(
        'http://101.50.2.211/gocraneapp_v2/production/api_gocraneapp/feedback_user.php'); // Ganti dengan URL endpoint API Anda
    try {
      final response = await http.post(url, body: {
        // 'id_shift': "1",
        'feedback_ketepatan_waktu': _waktuRating.toString() ?? "0",
        'feedback_performance_alat': _performaAlatRating.toString() ?? "0",
        'feedback_performance_operator':
            _performaOperatorRating.toString() ?? "0",
        'feedback_pelayanan_kerja': _pelayananRating.toString() ?? "0",
        'feedback_komentar': komentar.text ?? "-",
        'transaksi_id': widget.id_reg,
      });
      print(response.body);

      if (response.body == "1") {
        // Jika insert berhasil

        // Output response dari server
        print('Data inserted successfully!');
        setState(() {});

        // Tambahkan tindakan yang diinginkan setelah data berhasil diinsert
      } else {
        // Jika insert gagal
        print('Failed to insert data.');
        // Tambahkan tindakan yang diinginkan jika gagal melakukan insert
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _showFeedbackDialog(BuildContext context) {
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
                  Container(
                    width: 63,
                    height: 63,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.send,
                      size: 80,
                      color: Color(0xff2ab2a2),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Terimakasih!",
                        style: TextStyle(
                          color: Color(0xff2ab2a2),
                          fontSize: 36,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.18,
                        ),
                      ),
                      Text(
                        "Feedback anda telah terkirim",
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
                onTap: () {
                  Navigator.pop(dialogContext); // Tutup dialog
                },
                child: Container(
                  width: 229,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: const Color(0xff2ab2a2),
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
  TextEditingController komentar = TextEditingController();

  String? nama_user;
  String? alamat_;
  String? nowa;
  String? id_user = "";
  String? image_profil;
  String? unit_list = "n";

  Future Feedbac_cek() async {
    final Response = await http.post(
        Uri.parse(
            "http://101.50.2.211/gocraneapp_v2/production/api_gocraneapp/feedback_cek.php"),
        body: {
          "transaksi_id": widget.id_reg,
        });
    var feedback = jsonDecode(Response.body);
    setState(() {
      if (Response.body == "false") {
        print("null");
      } else {
        // nama_user = feedback[0]['username'] ?? "";
        komentar.text = feedback?[0]['feedback_komentar'] ?? "";

        _waktuRating =
            int.tryParse(feedback?[0]['feedback_ketepatan_waktu'] ?? "") ?? 0;
        _pelayananRating =
            int.tryParse(feedback?[0]['feedback_pelayanan_kerja'] ?? "") ?? 0;
        _performaAlatRating =
            int.tryParse(feedback?[0]['feedback_performance_alat'] ?? "") ?? 0;
        _performaOperatorRating =
            int.tryParse(feedback?[0]['feedback_performance_operator'] ?? "") ??
                0;
      }
      // gambar = datajson[0]['faskes_foto'];
    });
  }

  final ReceivePort _port = ReceivePort();

  MediaQueryData? queryData;
  @override
  void initState() {
    Feedbac_cek();
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
                          child: const Text(
                            "Feedback",
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
                const Padding(
                  padding: EdgeInsets.only(left: 16, top: 16),
                  child: Row(
                    children: [
                      Text(
                        "Bagikan Pengalaman Anda",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff141414),
                          fontSize: 18,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.09,
                        ),
                      )
                    ],
                  ),
                ),

                // indikator,

                Expanded(
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildRatingForm('Ketepatan Waktu :', _waktuRating,
                                (value) {
                              setState(() {
                                _waktuRating = value;
                              });
                            }),
                            buildRatingForm(
                                'Pelayanan Kerja :', _pelayananRating, (value) {
                              setState(() {
                                _pelayananRating = value;
                              });
                            }),
                            buildRatingForm(
                                'Performa Alat :', _performaAlatRating,
                                (value) {
                              setState(() {
                                _performaAlatRating = value;
                              });
                            }),
                            buildRatingForm(
                                'Performa Operator', _performaOperatorRating,
                                (value) {
                              setState(() {
                                _performaOperatorRating = value;
                              });
                            }),
                            const Text(
                              "Tinggalkan Komentar :",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
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
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x14000000),
                                blurRadius: 4,
                                offset: Offset(0, 0),
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: TextField(
                            maxLines: 4,
                            controller: komentar,
                            // Jumlah baris yang ingin ditampilkan
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: MaterialButton(
                      height: 44,
                      onPressed: () {
                        setState(() {
                          _insertDatafeedback();
                          Navigator.pop(context);
                          _showFeedbackDialog(context);
                        });

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
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x21000000),
                                  blurRadius: 26,
                                  offset: Offset(0, 4),
                                ),
                              ],
                              color: const Color(0xff2ab2a2),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Kirim Feedback",
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
}

Widget buildRatingForm(String label, int rating, ValueChanged<int> onChanged) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildStar(1, rating, onChanged),
          buildStar(2, rating, onChanged),
          buildStar(3, rating, onChanged),
          buildStar(4, rating, onChanged),
          buildStar(5, rating, onChanged),
        ],
      ),
      const SizedBox(height: 10),
    ],
  );
}

Widget buildStar(int value, int rating, ValueChanged<int> onChanged) {
  IconData iconData = value <= rating ? Icons.star : Icons.star_border;

  return GestureDetector(
    onTap: () {
      onChanged(value);
    },
    child: Icon(
      iconData,
      color: const Color(0xff2ab2a2),
      size: 40,
    ),
  );
}
