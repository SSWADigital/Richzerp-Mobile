import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gocrane_v3/main.dart';
import 'package:gocrane_v3/tampilan/SlideRightRoute.dart';

import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'dart:ui';

class info_klinik extends StatefulWidget {
  const info_klinik({
    required this.list,
    required this.index,
  });
  final List list;
  final int index;
  @override
  _info_klinikState createState() => _info_klinikState();
}

class _info_klinikState extends State<info_klinik>
    with SingleTickerProviderStateMixin {
  TextEditingController txttanggal = TextEditingController();
  List<Map<String, dynamic>> list = [
    {
      "img": "assets/imgs/download 1.png",
      "name": "Rumah Sakit Indriati",
      "jarak": "200 m",
      "msgStatus": "New message",
      "timing": "21 minutes ago",
      "color": 0xFF4CAF50,
    },
    {
      "img": "assets/imgs/rs1.png",
      "name": "Rumah Sakit Moewardi",
      "jarak": "3 km",
      "msgStatus": "Ongoing",
      "timing": "32 minutes ago",
      "color": 0xFF4285f4,
    },
    {
      "img": "assets/imgs/rs2.png",
      "name": "Rumah Sakit JIH Surakarta",
      "jarak": "2 km",
      "msgStatus": "Ended 13:02",
      "timing": "2 days ago",
      "color": 0xAA5c5c8a,
    },
  ];

  List<Map<String, dynamic>> absen = [
    {
      "tanggal": "08 Maret 2023",
      "masuk": "07:30",
      "keluar": "-",
      "keterangan": "-",
    },
    {
      "tanggal": "07 Maret 2023",
      "masuk": "07:30",
      "keluar": "13:30",
      "keterangan": "-",
    },
    {
      "tanggal": "06 Maret 2023",
      "masuk": "07:30",
      "keluar": "13:30",
      "keterangan": "-",
    },
  ];
  ///////////////////////////////////////////////////////////////////////
  List<Map<String, dynamic>> jenisKendaraan2 = [
    {
      'judul': 'CRANE',
      'data': [
        {
          'nama': 'CRN 21',
          'harga': 'Rp 200.000.000',
          'gambar':
              'https://media.istockphoto.com/id/862598472/photo/truck-crane.jpg?s=170667a&w=0&k=20&c=b5YBmqSurVWi9m71V-J3YyyZQH_zOM8Gw2FNqFGemrs=',
        },
        {
          'nama': 'CRN 21',
          'harga': 'Rp 200.000.000',
          'gambar':
              'https://media.istockphoto.com/id/862598472/photo/truck-crane.jpg?s=170667a&w=0&k=20&c=b5YBmqSurVWi9m71V-J3YyyZQH_zOM8Gw2FNqFGemrs=',
        },
        {
          'nama': 'CRN 21',
          'harga': 'Rp 200.000.000',
          'gambar':
              'https://media.istockphoto.com/id/862598472/photo/truck-crane.jpg?s=170667a&w=0&k=20&c=b5YBmqSurVWi9m71V-J3YyyZQH_zOM8Gw2FNqFGemrs=',
        },
        {
          'nama': 'CRN 21',
          'harga': 'Rp 200.000.000',
          'gambar':
              'https://media.istockphoto.com/id/862598472/photo/truck-crane.jpg?s=170667a&w=0&k=20&c=b5YBmqSurVWi9m71V-J3YyyZQH_zOM8Gw2FNqFGemrs=',
        },
        // ...
      ],
    },
    {
      'judul': 'HT - TR',
      'data': [
        {
          'nama': 'HT-TR04',
          'harga': 'Rp 17.000.000',
          'gambar':
              'https://media.istockphoto.com/id/862598472/photo/truck-crane.jpg?s=170667a&w=0&k=20&c=b5YBmqSurVWi9m71V-J3YyyZQH_zOM8Gw2FNqFGemrs=',
        },
        {
          'nama': 'HT-TR05',
          'harga': 'Rp 17.000.000',
          'gambar':
              'https://media.istockphoto.com/id/862598472/photo/truck-crane.jpg?s=170667a&w=0&k=20&c=b5YBmqSurVWi9m71V-J3YyyZQH_zOM8Gw2FNqFGemrs=',
        },
        {
          'nama': 'HT-TR05',
          'harga': 'Rp 17.000.000',
          'gambar':
              'https://media.istockphoto.com/id/862598472/photo/truck-crane.jpg?s=170667a&w=0&k=20&c=b5YBmqSurVWi9m71V-J3YyyZQH_zOM8Gw2FNqFGemrs=',
        },
        // ...
      ],
    },
  ];

  ///////////////////////////////////////////////////////////////////////
  String? nama_user;
  String? alamat;
  String? nowa;
  String? id_user = "";
  String? image_profil;

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

  //////////////////////////////////////////////////////////////////////
  String? honor;
  String? bulan;
  String? tahun;
  Future ambildata() async {
    if (this.mounted) {
      final prefs = await SharedPreferences.getInstance();

      var id_user = (prefs.get('pegawai_id'));
      final Response = await http.get(
        Uri.parse(
            "http://101.50.2.211/richzspot/AbsenTunjangan/getAbsenTunjangan/$id_user"),
      );
      var _data = jsonDecode(Response.body);
      if (_data == false) {
        honor = "Rp. 0";

        this.setState(() {
          honor = "Rp. 0";
        });
      } else {
        this.setState(() {
          var jumlah = _data["total"];
          var formatNumber = NumberFormat("#,##0", "id_ID");
          var formattedNumber = formatNumber.format(int.parse(jumlah));
          honor = formattedNumber;
          bulan = _data["bulan"];
          tahun = _data["bulan"];
        });
      }
    }
  }

  List? data_dok;
  Future dokter_klinik_() async {
    final Response = await http
        .post(Uri.parse("${url}/${urlSubAPI}/API/faskes_pilih.php"), body: {
      "aksi": "12",
      "id_dep": "01010317",
      "poli_id": widget.list[widget.index]['id_poli'] ?? ""
    });

    if (Response.body == null) {
      if (this.mounted) {
        this.setState(() {
          print(widget.list[widget.index]['id_poli'] ?? "");
          print("data Null");
          setState(() {
            data_dok = null;
          });
        });
      }
    } else {
      if (this.mounted) {
        this.setState(() {
          data_dok = jsonDecode(Response.body);
          print(widget.list[widget.index]['id_poli'] ?? "");
        });
      }
    }
  }

  List? TabelWaktuOrder;
  List? jenisKendaraan;
  Future lihatDetailOrder() async {
    // final Respon = await http.post(
    //     Uri.parse("http://101.50.2.211/api_gocrane/data_unit.php"),
    //     body: {"paht": "AU"});

    // this.setState(() {
    //   if (Respon.body == null) {
    //     print("null");
    //   } else {
    //     jenisKendaraan = jsonDecode(Respon.body);
    //     print(Respon.body);
    //   }
    //   // gambar = datajson[0]['faskes_foto'];
    // });

    if (alber_jenis == null) {
      final Respon = await http.post(
          Uri.parse("${url}/${urlSubAPI}/API/faskes_pilih.php"),
          body: {'aksi': '11', 'id_dep': "01010317" ?? ""});
      if (this.mounted) {
        setState(() {
          // ignore: unnecessary_null_comparison
          if (Respon.body == null) {
            print("null");
          } else {
            jenisKendaraan = jsonDecode(Respon.body);
            print(Respon.body);
          }
          // gambar = datajson[0]['faskes_foto'];
        });
      }
    } else {
      final Respon = await http.post(
          Uri.parse("${url}/${urlSubAPI}/API/faskes_pilih.php"),
          body: {'aksi': '11', 'id_dep': "01010317" ?? ""});
      if (this.mounted) {
        setState(() {
          // ignore: unnecessary_null_comparison
          if (Respon.body == null) {
            print("null");
          } else {
            jenisKendaraan = jsonDecode(Respon.body);
            print(Respon.body);
          }
          // gambar = datajson[0]['faskes_foto'];
        });
      }
    }
    print(alber_jenis);
  }

  List? jenis_alber;
  String? alber_jenis;
  Future alber_list() async {
    final Response = await http.post(
        Uri.parse("${url}/${urlSubAPI}/API/faskes_pilih.php"),
        body: {'aksi': '11', 'id_dep': "01010317" ?? ""});
    if (this.mounted) {
      this.setState(() {
        jenis_alber = jsonDecode(Response.body);
      });
    }
  }

  TabController? tb;
  @override
  void initState() {
    super.initState();
    dokter_klinik_();
  }

  void _handleTabSelection() {
    setState(() {});
  }

  // List _tanggal = [
  //   "assets/imgs/download 1.png",
  //   "assets/imgs/rs1.png",
  //   "assets/imgs/rs2.png",
  //  ];
  int? tapIndex;

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
                            "Galeri Unit",
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
                      Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Judul
                            ListTile(
                              title: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.list[widget.index]['nama_klinik'] ??
                                        "",
                                    style: TextStyle(
                                      color: Color(0xFF141414),
                                      fontSize: 20,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700,
                                      height: 0,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    decoration: ShapeDecoration(
                                      color: Color(0xFF007100),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(2)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // Text(
                                        //   widget.list[widget.index]['data'] ??
                                        //       "",
                                        //   style: TextStyle(
                                        //     color: Colors.white,
                                        //     fontSize: 14,
                                        //     fontFamily: 'Inter',
                                        //     fontWeight: FontWeight.w600,
                                        //     height: 0,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 10, left: 16),
                              child: Text(
                                'Jadwal Praktek',
                                style: TextStyle(
                                  color: Color(0xFFA5A5A5),
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),

                            // Daftar Komponen
                            Container(
                              child: Column(
                                children: (widget.list[widget.index]['data']
                                        as List<dynamic>)
                                    .map((kendaraan) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 16),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            kendaraan['nama_hari'] ?? "",
                                            style: TextStyle(
                                              color: Color(0xFF141414),
                                              fontSize: 14,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            kendaraan['jam_buka'] ?? "",
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 2, 129, 33),
                                              fontSize: 14,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                              // letterSpacing: 0.05,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Dokter yang Praktek',
                          style: TextStyle(
                            color: Color(0xFFA5A5A5),
                            fontSize: 15,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ),

                      ////////////////////////////////////////////////////////
                      data_dok == null
                          ? Container()
                          : Card(
                              child: Column(
                                children: [
                                  // ... (Widget lainnya)
                                  // GridView.builder di dalam Card
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 0.5 / 0.75,
                                    ),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            tapIndex = index;
                                          });
                                        },
                                        child: Container(
                                          // Konten item di sini
                                          width: 200,
                                          height: 100,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          decoration: ShapeDecoration(
                                            color: tapIndex == index
                                                ? Colors.green[600]
                                                : Colors.white,
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 1,
                                                color: tapIndex == index
                                                    ? const Color.fromARGB(
                                                        255, 67, 160, 71)
                                                    : Color(0xFFA5A5A5),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Center(
                                            child: Container(
                                              width: 100,
                                              decoration: ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 16,
                                                    ),
                                                    width: 110,
                                                    height: 95,
                                                    decoration: ShapeDecoration(
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            "https://via.placeholder.com/80x64"),
                                                        fit: BoxFit.fill,
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 15,
                                                    ),
                                                    child: Column(
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
                                                          data_dok![index][
                                                                  "usr_name"] ??
                                                              "",
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFF141414),
                                                            fontSize: 12,
                                                            fontFamily: 'Inter',
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            height: 1.0,
                                                          ),
                                                          overflow:
                                                              TextOverflow.fade,
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount:
                                        data_dok == null ? 0 : data_dok!.length,
                                  ),
                                ],
                              ),
                            )
                    ],
                  ),
                ),

                // Expanded(
                //   child: ListView.builder(
                //     itemCount: jenisKendaraan?.length ?? 0,
                //     itemBuilder: (context, index) {
                //       final jenis = jenisKendaraan![index];
                //       List dataKendaraan = jenis['data'];

                //       return InkWell(
                //         onTap: () {},
                //         child: Card(
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               // Judul
                //               ListTile(
                //                 title: Row(
                //                   mainAxisSize: MainAxisSize.min,
                //                   mainAxisAlignment: MainAxisAlignment.start,
                //                   crossAxisAlignment: CrossAxisAlignment.center,
                //                   children: [
                //                     Text(
                //                       jenis['nama_klinik'] ?? "",
                //                       style: TextStyle(
                //                         color: Color(0xFF141414),
                //                         fontSize: 20,
                //                         fontFamily: 'Inter',
                //                         fontWeight: FontWeight.w700,
                //                         height: 0,
                //                       ),
                //                     ),
                //                     const SizedBox(width: 4),
                //                     Container(
                //                       padding: const EdgeInsets.symmetric(
                //                           horizontal: 4),
                //                       decoration: ShapeDecoration(
                //                         color: Color(0xFF007100),
                //                         shape: RoundedRectangleBorder(
                //                             borderRadius:
                //                                 BorderRadius.circular(2)),
                //                       ),
                //                       child: Row(
                //                         mainAxisSize: MainAxisSize.min,
                //                         mainAxisAlignment:
                //                             MainAxisAlignment.start,
                //                         crossAxisAlignment:
                //                             CrossAxisAlignment.center,
                //                         children: [
                //                           Text(
                //                             jenis['kode_klinik'] ?? "",
                //                             style: TextStyle(
                //                               color: Colors.white,
                //                               fontSize: 14,
                //                               fontFamily: 'Inter',
                //                               fontWeight: FontWeight.w600,
                //                               height: 0,
                //                             ),
                //                           ),
                //                         ],
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //               Padding(
                //                 padding:
                //                     const EdgeInsets.only(bottom: 10, left: 16),
                //                 child: Text(
                //                   'Jadwal Praktek',
                //                   style: TextStyle(
                //                     color: Color(0xFFA5A5A5),
                //                     fontSize: 14,
                //                     fontFamily: 'Inter',
                //                     fontWeight: FontWeight.w400,
                //                     height: 0,
                //                   ),
                //                 ),
                //               ),

                //               // Daftar Komponen
                //               Container(
                //                 child: Column(
                //                   children: dataKendaraan.map((kendaraan) {
                //                     return Padding(
                //                       padding: const EdgeInsets.symmetric(
                //                           vertical: 8, horizontal: 16),
                //                       child: Padding(
                //                         padding: const EdgeInsets.symmetric(
                //                             horizontal: 10),
                //                         child: Row(
                //                           mainAxisSize: MainAxisSize.min,
                //                           mainAxisAlignment:
                //                               MainAxisAlignment.start,
                //                           crossAxisAlignment:
                //                               CrossAxisAlignment.start,
                //                           children: [
                //                             Text(
                //                               kendaraan['nama_hari'] ?? "",
                //                               style: TextStyle(
                //                                 color: Color(0xFF141414),
                //                                 fontSize: 14,
                //                                 fontFamily: 'Inter',
                //                                 fontWeight: FontWeight.w400,
                //                               ),
                //                             ),
                //                             Spacer(),
                //                             Text(
                //                               kendaraan['jam_buka'] ?? "",
                //                               style: TextStyle(
                //                                 color: Color.fromARGB(
                //                                     255, 2, 129, 33),
                //                                 fontSize: 14,
                //                                 fontFamily: 'Inter',
                //                                 fontWeight: FontWeight.w400,
                //                                 // letterSpacing: 0.05,
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                       ),
                //                     );
                //                   }).toList(),
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // ),

//Anda dapat menambahkan lebih banyak widget Tab sesuai dengan kebutuhan. Pastikan juga sudah menginisialisasi controller tb sebelumnya.

                // Expanded(
                //   child: TabBarView(controller: tb, children: [
                //     tagihandetail(),
                //     pembayaranlunas(),

                //     // Endocrine(),
                //     // Dentist(),
                //     // Orthopodist(),
                //     // Surgeon(),
                //   ]),
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
