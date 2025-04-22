import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gocrane_v3/main.dart';
import 'package:gocrane_v3/tampilan/SlideRightRoute.dart';
import 'package:gocrane_v3/tampilan/menu/dr_list/dr_info.dart';

import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'dart:ui';

class daftar_dr extends StatefulWidget {
  @override
  _daftar_drState createState() => _daftar_drState();
}

class _daftar_drState extends State<daftar_dr>
    with SingleTickerProviderStateMixin {
  TextEditingController txttanggal = TextEditingController();

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

  Future lihatprofil() async {
    final prefs = await SharedPreferences.getInstance();

    id_user = (prefs.get('pegawai_id')) as String?;
    final Response = await http
        .get(Uri.parse("http://101.50.2.211/richzspot/user/getData/$id_user"));
    var profil = jsonDecode(Response.body);
    this.setState(() {
      if (Response.body == "false") {
        print("null");
      } else {
        // nama_user = profil[0]['username'] ?? "";
        nama_user = profil['user_nama_lengkap'] ?? "";
        nowa = profil['user_no_telp'] ?? "";
        image_profil = profil['user_foto'];
      }
      // gambar = datajson[0]['faskes_foto'];
    });
  }

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

  List? TabelWaktuOrder;
  List? jenisKendaraan;
  Future lihatDetailOrder() async {
    final Respon = await http.post(
        Uri.parse("${url}/${urlSubAPI}/API/faskes_pilih.php"),
        body: {'aksi': '13', 'id_dep': "01010317" ?? ""});
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

//    print(alber_jenis);
  }

  TabController? tb;
  @override
  void initState() {
    super.initState();

    lihatDetailOrder();
    // alber_list();
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
                            "Informasi Dokter",
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

                // Padding(
                //   padding: const EdgeInsets.only(left: 16, top: 15),
                //   child: Row(
                //     children: [
                //       Text(
                //         "Jenis Alber",
                //         textAlign: TextAlign.center,
                //         style: TextStyle(
                //           fontSize: 16,
                //           fontFamily: "Inter",
                //           fontWeight: FontWeight.w600,
                //           letterSpacing: 0.07,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 16),
                //   child: InkWell(
                //     onTap: () {},
                //     child: Stack(
                //       children: [
                //         DropdownButton(
                //           isExpanded: true,
                //           hint: Text(
                //             "Pilih Jenis Alber",
                //             style: TextStyle(
                //                 fontSize: 14,
                //                 fontFamily: "medium",
                //                 color: Theme.of(context)
                //                     .accentTextTheme
                //                     .headline4
                //                     .color),
                //             semanticsLabel: "Jenis Alber",
                //           ),
                //           value: alber_jenis,
                //           items: jenis_alber == null
                //               ? []
                //               : jenis_alber.map((item) {
                //                   return DropdownMenuItem(
                //                     child: Text(
                //                       item['jenis_nama'],
                //                       style: TextStyle(
                //                           fontSize: 14,
                //                           fontFamily: "medium",
                //                           color: Theme.of(context)
                //                               .accentTextTheme
                //                               .headline2
                //                               .color),
                //                     ),
                //                     value: item['jenis_id'],
                //                   );
                //                 }).toList(),
                //           onChanged: (value) {
                //             setState(() {
                //               alber_jenis = value;
                //               print(alber_jenis);
                //               lihatDetailOrder();
                //             });
                //           },
                //         ),
                //         Positioned.directional(
                //           textDirection: Directionality.of(context),
                //           end: 8,
                //           top: 5,
                //           child: Icon(Icons.search),
                //         )
                //       ],
                //     ),
                //   ),
                // ),

                // indikator,
                SizedBox(
                  height: 10,
                ),
                // Container(
                //   width: 328,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(6),
                //     boxShadow: [],
                //     color: Colors.white,
                //   ),
                //   child: Center(
                //     child: TabBar(
                //         labelColor: Color(0xff141414),
                //         unselectedLabelColor: Colors.grey,
                //         controller: tb,
                //         isScrollable: true,
                //         tabs: [
                //           Tab(
                //             child: Center(
                //                 child: Row(
                //               children: [
                //                 Text(
                //                   'Akan Berjalan ',
                //                   style: TextStyle(
                //                     fontSize: 14,
                //                     fontFamily: "Inter",
                //                     fontWeight: FontWeight.w500,
                //                   ),
                //                 ),
                //               ],
                //             )),
                //           ),
                //           Tab(
                //             child: Center(
                //               child: Text(
                //                 "Telah Berjalan",
                //                 style: TextStyle(
                //                   fontSize: 14,
                //                   fontFamily: "Inter",
                //                   fontWeight: FontWeight.w500,
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ]),
                //   ),
                // ),
                // SizedBox(
                //   height: 20,
                // ),

                Expanded(
                  child: Container(
                    height: 300,
                    width:
                        double.infinity, // Change width to fit available space
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                          jenisKendaraan == null ? 0 : jenisKendaraan?.length,
                      itemBuilder: (context, index) {
                        final jenis = jenisKendaraan![index];
                        List dataKendaraan = jenis['data'];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(
                                jenis['nama_klinik'] ?? "",
                                style: TextStyle(
                                  color: Color(0xff141414),
                                  fontSize: 14,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.07,
                                ),
                              ),
                            ),
                            Container(
                              height: 200,
                              width: double
                                  .infinity, // Change width to fit available space
                              child: Container(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  // ignore: unnecessary_null_comparison
                                  itemCount: dataKendaraan == null
                                      ? 0
                                      : dataKendaraan.length,
                                  itemBuilder: (context, index) {
                                    final kendaraan = dataKendaraan[index];

                                    return Card(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            Navigator.push(
                                                context,
                                                SlidePageRoute(
                                                    page: detail_dr(
                                                  list: kendaraan!,
                                                  namaKlinik:
                                                      jenis['nama_klinik'] ??
                                                          "",
                                                )));
                                            //kirim_reservasi
                                          });
                                        },
                                        child: Container(
                                            width:
                                                150, // Lebar item (sesuaikan dengan kebutuhan)
                                            height:
                                                100, // Atur tinggi sesuai kebutuhan Anda
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
                                                        : Color(0xFFA5A5A5)),
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
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
                                                      decoration:
                                                          ShapeDecoration(
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
                                                        mainAxisSize: MainAxisSize
                                                            .min, // Gunakan MainAxisSize.min agar widget tidak menumpuk
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "dr.${kendaraan["nama_dr"]}",
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF141414),
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  'Inter',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              height:
                                                                  1.0, // Gunakan nilai yang sesuai
                                                            ),
                                                            overflow: TextOverflow
                                                                .fade, // Menampilkan "..." jika teks terlalu panjang
                                                          ),

                                                          // Padding(
                                                          //   padding: const EdgeInsets
                                                          //       .only(
                                                          //       top:
                                                          //           8.0,
                                                          //       bottom:
                                                          //           8),
                                                          //   child:
                                                          //       Center(
                                                          //     child:
                                                          //         Text(
                                                          //       '${data_dok![index]["jam_mulai"]} s/d ${data_dok![index]["jam_selesai"]}',
                                                          //       style:
                                                          //           TextStyle(
                                                          //         color:
                                                          //             Color(0xFF141414),
                                                          //         fontSize:
                                                          //             12,
                                                          //         fontFamily:
                                                          //             'Inter',
                                                          //         fontWeight:
                                                          //             FontWeight.w400,
                                                          //         height:
                                                          //             1.0, // Gunakan nilai yang sesuai
                                                          //         overflow:
                                                          //             TextOverflow.fade,
                                                          //       ),
                                                          //     ),
                                                          //   ),
                                                          // ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),

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
