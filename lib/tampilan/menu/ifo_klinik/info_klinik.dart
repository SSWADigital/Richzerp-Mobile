import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gocrane_v3/main.dart';
import 'package:gocrane_v3/tampilan/SlideRightRoute.dart';

import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'dart:ui';

class infKlinik extends StatefulWidget {
  const infKlinik({
    super.key,
  });

  @override
  _infKlinikState createState() => _infKlinikState();
}

class _infKlinikState extends State<infKlinik>
    with SingleTickerProviderStateMixin {
  List? jadwal_dokter;
  String? alber_jenis;

  Future jadwalDR() async {
    final Respon = await http.post(
        Uri.parse("${url}/${urlSubAPI}/API/faskes_pilih.php"),
        body: {'aksi': '14', 'id_dep': "01010317" ?? "", 'id_dr': ""});
    if (this.mounted) {
      this.setState(() {
        jadwal_dokter = jsonDecode(Respon.body);
      });
    }
  }

  TabController? tb;
  @override
  void initState() {
    super.initState();
    // jadwalDR();
    // dokter_klinik_();
  }

  void _handleTabSelection() {
    setState(() {});
  }

  // List _tanggal = [
  //   "assets/imgs/download 1.png",
  //   "assets/imgs/rs1.png",
  //   "assets/imgs/rs2.pn g",
  //  ];
  int? taplist;

  bool isTap = false;
  MediaQueryData? queryData;

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
                            "Profil Klinik",
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
                      Container(
                        padding: const EdgeInsets.only(
                          top: 16,
                        ),
                        width: double.infinity,
                        height: 220,
                        decoration: ShapeDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                "https://lh3.googleusercontent.com/p/AF1QipPnrxL1AxltUfPViFQuSurQsConPWD3fk9iQH9C=s680-w680-h510"),
                            fit: BoxFit.fill,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(
                          16,
                        ),
                        child: Text(
                          'Klinik Utama Kasih Ibu Sehati',
                          style: TextStyle(
                            color: Color(0xFF007100),
                            fontSize: 20,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: Text(
                            'Alamat',
                            style: TextStyle(
                              color: Color(0xFFA5A5A5),
                              fontSize: 15,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: 320,
                          child: Text(
                            "Jalan Slamet Riyadi No.489 Pajang, Kecamatan an, Kota Surakarta, Jawa Tengah, 57146 Indonesia",
                            style: TextStyle(
                              color: Color(0xff141414),
                              fontSize: 16,
                              letterSpacing: 0.07,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: Text(
                            'Jam Buka',
                            style: TextStyle(
                              color: Color(0xFFA5A5A5),
                              fontSize: 15,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          )),
                      Container(
                        padding: const EdgeInsets.all(
                          16,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Senin - Sabtu',
                                        style: TextStyle(
                                          color: Color(0xFF141414),
                                          fontSize: 16,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 153),
                                Text(
                                  '08:00 - 20:00',
                                  style: TextStyle(
                                    color: Color(0xFF007100),
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Minggu',
                                        style: TextStyle(
                                          color: Color(0xFF141414),
                                          fontSize: 16,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 153),
                                Text(
                                  '08:00 - 16:00',
                                  style: TextStyle(
                                    color: Color(0xFF007100),
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: Text(
                            'Kontak',
                            style: TextStyle(
                              color: Color(0xFFA5A5A5),
                              fontSize: 15,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Telepon',
                                    style: TextStyle(
                                      color: Color(0xFF141414),
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 153),
                            Text(
                              '(0271) 7466173',
                              style: TextStyle(
                                color: Color(0xFF007100),
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
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
