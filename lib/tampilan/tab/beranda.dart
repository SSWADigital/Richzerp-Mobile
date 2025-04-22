import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gocrane_v3/tampilan/SlideRightRoute.dart';
import 'package:gocrane_v3/tampilan/menu/izin/antrian.dart';

import 'package:gocrane_v3/tampilan/menu/dr_list/daftar_dr.dart';

import 'package:gocrane_v3/tampilan/menu/histori_order/histori_order.dart';
import 'package:gocrane_v3/tampilan/menu/hubungi_kami/hub_kami.dart';
import 'package:gocrane_v3/tampilan/menu/ifo_klinik/info_klinik.dart';
import 'package:gocrane_v3/tampilan/menu/layanan_klinik/daftarKlinik.dart';

// import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'package:gocrane_v3/UI/posisi.dart';

import 'package:gocrane_v3/main.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'YourBillingScreen.dart';

String? nameController;
String? phoneNumController;
String? emailController;
String? dateVal;
String? alamat;
String? foto;
String? nik;

String? namaCustKlinik;
String? NoRm;

class berandaPengguna extends StatefulWidget {
  @override
  _berandaPenggunaState createState() => _berandaPenggunaState();
}

class _berandaPenggunaState extends State<berandaPengguna> {
  FToast? fToast;
  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Theme.of(context).textTheme.headline1?.color),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check,
              color: Theme.of(context).textTheme.subtitle2?.color),
          SizedBox(
            width: 7.0,
          ),
          Text(
            "Tap Untuk Keluar",
            style: TextStyle(
                fontSize: 15,
                fontFamily: "medium",
                color: Theme.of(context).textTheme.subtitle2?.color),
          ),
        ],
      ),
    );

    fToast?.showToast(
      child: toast,
      gravity: ToastGravity.CENTER,
      toastDuration: Duration(seconds: 2),
    );
  }

  int backPressCounter = 1;
  int backPressTotal = 2;

  List? berita;
  List? _promo1;
  Future _berita() async {
    final Response =
        await http.post(Uri.parse("${url}/api_swamedika_app/berita.php"));
    if (Response.body == 'false') {
      print("data Null");
    } else {
      this.setState(() {
        berita = jsonDecode(Response.body);
      });
    }

    // this.setState(() {
    //   berita = jsonDecode(Response.body);
    // });
  }

  Future _promo() async {
    final Response =
        await http.post(Uri.parse("${url}/api_swamedika_app/promo.php"));

    if (Response.body == 'false') {
      print("data Null");
    } else {
      this.setState(() {
        _promo1 = jsonDecode(Response.body);
      });
    }
  }

  Future lihatprofil() async {
    final prefs = await SharedPreferences.getInstance();

    iduser = (prefs.get('pasien_id')) as String?;
    final Response = await http.post(
        Uri.parse("${url}/api_swamedika_app/lihatpasien.php"),
        body: {"pasien_id": iduser});
    this.setState(() {
      if (jsonDecode(Response.body) == false) {
        print("null");
        print(jsonDecode(Response.body));
      } else {
        var profil = jsonDecode(Response.body);
        nameController = profil[0]['pasien_nama'];
        phoneNumController = profil[0]['pasien_no_hp'];
        emailController = profil[0]['pasien_email'];
        dateVal = profil[0]['pasien_tanggal_lahir'];
        alamat = profil[0]['pasien_alamat'];
        foto = profil[0]['pasien_foto'];
        nik = profil[0]['pasien_nik'];
        print(profil);
        lihatprofilKlinik();
      }

      // gambar = datajson[0]['faskes_foto'];
    });
  }

  Future lihatprofilKlinik() async {
    final prefs = await SharedPreferences.getInstance();

    iduser = (prefs.get('pasien_id')) as String?;
    final Response = await http.post(
        Uri.parse("${url}/${urlSubAPI}/API/faskes_pilih.php"),
        body: {"nik": nik, "id_dep": idDep, "aksi": "19"});
    setState(() {
      if (jsonDecode(Response.body) == null) {
        print("null");
        print(jsonDecode(Response.body));
        namaCustKlinik = null;
        NoRm = null;
      } else {
        var profil = jsonDecode(Response.body);
        namaCustKlinik = profil[0]['cust_usr_nama'];
        NoRm = profil[0]['cust_usr_kode'];

        print(profil);
      }

      // gambar = datajson[0]['faskes_foto'];
    });
  }

  final List<String> gambar = [
    'https://images.pexels.com/photos/40568/medical-appointment-doctor-healthcare-40568.jpeg',
    'https://images.pexels.com/photos/139398/thermometer-headache-pain-pills-139398.jpeg',
    'https://images.pexels.com/photos/208512/pexels-photo-208512.jpeg'
  ];

  @override
  void initState() {
    lihatprofil();
    _berita();

    // _promo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [
            //Space
            SizedBox(
              height: 20,
            ),
            //Homitel
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //
                  Container(child: Image.asset("assets/icons/kukis.png")
                      //  RichText(
                      //   text: new TextSpan(
                      //       text: "D",
                      //       style: TextStyle(fontSize: 30, color: Colors.blue[900]

                      //           // Theme.of(context)
                      //           //     .accentTextTheme
                      //           //     .headline2
                      //           //     .color
                      //           ),
                      //       children: [
                      //         TextSpan(
                      //           text: "ua1Care",
                      //           style: TextStyle(fontSize: 27, color: Colors.blue

                      //               // Theme.of(context)
                      //               //     .accentTextTheme
                      //               //     .headline1
                      //               //     .color
                      //               ),
                      //         )
                      //       ]),
                      // ),
                      ),
                  //
                  // InkWell(
                  //   onTap: () {
                  //     locationDialogue();
                  //   },
                  //   child: Container(
                  //     child: Row(
                  //       children: [
                  //         Image.asset(
                  //           "assets/icons/ic_loc3.png",
                  //           scale: 26,
                  //         ),
                  //         SizedBox(
                  //           width: 150,
                  //           height: 25,
                  //           child: Container(
                  //             padding: EdgeInsets.symmetric(horizontal: 4),
                  //             child: Text(
                  //               loc == null ? "Cari Klinik" : loc,
                  //               style: TextStyle(
                  //                   fontSize: 15,
                  //                   fontFamily: "medium",
                  //                   color: Theme.of(context)
                  //                       .accentTextTheme
                  //                       .headline3
                  //                       .color),
                  //             ),
                  //           ),
                  //         ),
                  //         Image.asset(
                  //           "assets/icons/ic_drop_arrow.png",
                  //           scale: 9,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
            //Space
            SizedBox(
              height: 22,
            ),
            //What are you looking for?
            CarouselSlider(
              options: CarouselOptions(height: 160, autoPlay: true),
              items: gambar.map((image) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(0),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(image ?? ""))),
                    );
                  },
                );
              }).toList(),
            ),

            //Space
            SizedBox(
              height: 30,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomCard3(
                            imagePath: 'assets/icons/mi1.png',
                            title: 'Registrasi\nOnline',
                            halaman: daftar_dr(),
                          ),
                          Spacer(),
                          CustomCard3(
                            imagePath: 'assets/icons/mi2.png',
                            title: 'Informasi\nDokter',
                            halaman: daftar_dr(),
                          ),
                          Spacer(),
                          CustomCard3(
                            imagePath: 'assets/icons/mi3.png',
                            title: 'Layanan\nKlinik',
                            halaman: daftarKlinik(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomCard3(
                            imagePath: 'assets/icons/mi4.png',
                            title: 'Antrian\nPasien',
                            halaman: antrianPoli(),
                          ),
                          Spacer(),
                          CustomCard3(
                            imagePath: 'assets/icons/mi5.png',
                            title: 'Profil\nKlinik',
                            halaman: infKlinik(),
                          ),
                          Spacer(),
                          CustomCard3(
                            imagePath: 'assets/icons/mi6.png',
                            title: 'Hubungi\nKami',
                            halaman: hugbungi_kami(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //Check-up Package & more
            Visibility(
              visible: _promo1 == null ? false : true,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        "Promo Menarik",
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: "medium",
                            color: Colors.black),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                "Lihat Semua",
                                style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: "medium",
                                    color: Colors.black),
                              ),
                            ),
                            Image.asset(
                              "assets/icons/ic_forward.png",
                              scale: 50,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //Space
            SizedBox(
              height: 10,
            ),
            //Horizontal listView
            Visibility(
              visible: _promo1 == null ? false : true,
              child: Container(
                  height: 215,
                  padding: EdgeInsets.only(left: 6),
                  child: ListView(
                    // shrinkWrap: true,
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    scrollDirection: Axis.horizontal,
                    children: [
                      ListView.builder(
                          itemCount: _promo1 == null ? 0 : _promo1?.length,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: InkWell(
                                  onTap: () {
                                    // Navigator.push(
                                    //     context,
                                    //     SlidePageRoute(
                                    //         page: promo(
                                    //       list: _promo1,
                                    //       index: index,
                                    //     )));
                                  },
                                  child: Container(
                                      height: 215,
                                      width: 270,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 9),
                                      child: Column(
                                        children: [
                                          //img
                                          Container(
                                            height: 100,
                                            // width: 60,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                        _promo1?[index][
                                                                'promo_foto'] ??
                                                            ''))),
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      _promo1?[index]
                                                              ['promo_judul'] ??
                                                          '',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: "medium",
                                                          color: Colors
                                                              .black), //promo_judul
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.only(top: 3),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 5),
                                                          child: Text(
                                                            "Detail",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontFamily:
                                                                    "medium",
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                        Image.asset(
                                                          "assets/icons/ic_forward.png",
                                                          scale: 48,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                              ),
                            );
                          }),
                      //
                      SizedBox(
                        width: 2,
                      ),
                    ],
                  )),
            ),
            //News & more
            berita == null
                ? Container()
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            "Artikel",
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: "medium",
                                color: Colors.black),
                          ),
                        ),
                        // InkWell(
                        //   onTap: () {
                        //     // Navigator.push(
                        //     //     context, SlidePageRoute(page: NewsScreen()));
                        //   },
                        //   child: Container(
                        //     padding: EdgeInsets.symmetric(
                        //         horizontal: 5, vertical: 2),
                        //     decoration: BoxDecoration(
                        //         color: Theme.of(context)
                        //             .accentTextTheme
                        //             .headline5
                        //             .color
                        //             .withOpacity(0.3),
                        //         borderRadius: BorderRadius.circular(8)),
                        //     child: Row(
                        //       children: [
                        //         Container(
                        //           padding: EdgeInsets.only(left: 5),
                        //           child: Text(
                        //             "Lihat Semua",
                        //             style: TextStyle(
                        //                 fontSize: 11,
                        //                 fontFamily: "medium",
                        //                 color: Theme.of(context)
                        //                     .accentTextTheme
                        //                     .headline5
                        //                     .color),
                        //           ),
                        //         ),
                        //         Image.asset(
                        //           "assets/icons/ic_forward.png",
                        //           scale: 50,
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
            //Horizontal listView
            Container(
                height: 215,
                padding: EdgeInsets.only(left: 6),
                child: ListView(
                  // shrinkWrap: true,
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  scrollDirection: Axis.horizontal,
                  children: [
                    ListView.builder(
                        itemCount: berita == null ? 0 : berita?.length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: InkWell(
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     SlidePageRoute(
                                  //         page: NewsScreen2(
                                  //       list: berita,
                                  //       index: index,
                                  //     )));
                                },
                                child: Container(
                                    height: 215,
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Column(
                                      children: [
                                        //
                                        Expanded(
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(berita![
                                                                index]
                                                            ['berita_foto'] ??
                                                        ''))),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                top: 8, left: 4),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    berita?[index]
                                                            ['berita_judul'] ??
                                                        '',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontFamily: "medium",
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(top: 5),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 5),
                                                        child: Text(
                                                          "Detail",
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              fontFamily:
                                                                  "medium",
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      Image.asset(
                                                        "assets/icons/ic_forward.png",
                                                        scale: 50,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                            ),
                          );
                        }),
                    //
                    SizedBox(
                      width: 18,
                    ),
                  ],
                )),
            //Specialist
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            //   alignment: Alignment.centerLeft,
            //   child: Text(
            //     "Specialist",
            //     style: TextStyle(
            //         fontSize: 20,
            //         fontFamily: "medium",
            //         color: Theme.of(context).accentTextTheme.headline2.color),
            //   ),
            // ),
            //list
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 15),
            //   height: 200,
            //   width: MediaQuery.of(context).size.width * 1 + 100,
            //   child: ListView(
            //     shrinkWrap: true,
            //     physics: BouncingScrollPhysics(
            //         parent: AlwaysScrollableScrollPhysics()),
            //     scrollDirection: Axis.horizontal,
            //     children: [
            //       Container(
            //         width: 390,
            //         child: Wrap(
            //             spacing: 10,
            //             runSpacing: 10,
            //             children:
            //                 List.generate(homeScreenTestList.length, (index) {
            //               return Container(
            //                 width: 123,
            //                 child: Card(
            //                   elevation: 3,
            //                   shape: RoundedRectangleBorder(
            //                       borderRadius: BorderRadius.circular(12)),
            //                   child: InkWell(
            //                     onTap: () {
            //                       Navigator.push(
            //                           context,
            //                           SlidePageRoute(
            //                               page: CategoriesScreen(
            //                             title: "Search",
            //                           )));
            //                     },
            //                     child: Container(
            //                       height: 75,
            //                       padding: EdgeInsets.symmetric(horizontal: 10),
            //                       child: Column(
            //                         crossAxisAlignment:
            //                             CrossAxisAlignment.start,
            //                         mainAxisAlignment: MainAxisAlignment.center,
            //                         children: [
            //                           Image.asset(
            //                             homeScreenTestList[index].image,
            //                             scale: 21,
            //                           ),
            //                           Container(
            //                             padding: EdgeInsets.only(top: 5),
            //                             child: Text(
            //                               homeScreenTestList[index].title,
            //                               overflow: TextOverflow.ellipsis,
            //                               style: TextStyle(
            //                                   fontSize: 14,
            //                                   fontFamily: "medium",
            //                                   color: Theme.of(context)
            //                                       .accentTextTheme
            //                                       .headline3
            //                                       .color),
            //                             ),
            //                           )
            //                         ],
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               );
            //             })),
            //       ),
            //     ],
            //   ),
            // ),
            //
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}

class Menu {
  final IconData icon;
  final String label;
  final String route;

  Menu({required this.icon, required this.label, required this.route});
}

class MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;

  MenuTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 48,
          color: Colors.blue,
        ),
        SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class MenuRow extends StatelessWidget {
  final IconData icon;
  final String label;

  MenuRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 57,
          height: 57,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color(0xFFE3FFE3),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 30,
            color: Colors.black,
          ),
        ),
        SizedBox(width: 16),
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
        ),
      ],
    );
  }
}

class CustomCard extends StatelessWidget {
  final String imagePath;
  final String title;

  const CustomCard({required this.imagePath, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.002) // Menambahkan efek perspektif
              ..rotateX(-0.2), // Menambahkan rotasi ke sumbu X
            child: Container(
              width: 60,
              height: 60,
              padding: const EdgeInsets.only(
                top: 13,
                left: 14,
                right: 14,
                bottom: 12,
              ),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                shadows: [
                  BoxShadow(
                    color: const Color.fromARGB(
                        255, 189, 189, 189), // Warna bayangan
                    blurRadius: 0.5, // Jarak penyebaran bayangan
                    spreadRadius: 1.0, // Seberapa luas bayangan diperluas
                    offset: Offset(0, 2), // Posisi bayangan (x, y)
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      width: 37,
                      height: 25,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(imagePath),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomCard3 extends StatelessWidget {
  final String imagePath;
  final String title;
  final Widget halaman;

  const CustomCard3(
      {required this.imagePath, required this.title, required this.halaman});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, SlidePageRoute(page: halaman));
              // Fungsi yang akan dipanggil saat tombol ditekan
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              elevation: 0, // Atur sesuai keinginan Anda
              primary: Colors.transparent, // Warna latar belakang
              onPrimary: Colors.green[700], // Warna teks pada keadaan normal
            ),
            child: Container(
              height: 40,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      width: 40,
                      height:
                          40, // Sesuaikan dengan perbandingan aspek yang diinginkan
                      child: FittedBox(
                        fit: BoxFit
                            .contain, // Sesuaikan gambar ke dalam Container
                        alignment:
                            Alignment.center, // Letakkan gambar di tengah
                        child: Image.asset(imagePath),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ],
      ),
    );
  }
}
