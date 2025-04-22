import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gocrane_v3/tampilan/SlideRightRoute.dart';

import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'dart:ui';

class schedule extends StatefulWidget {
  @override
  _scheduleState createState() => _scheduleState();
}

class _scheduleState extends State<schedule>
    with SingleTickerProviderStateMixin {
  TextEditingController txttanggal = TextEditingController();
  List<Map<String?, dynamic>> list = [
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

  List<Map<String?, dynamic>> absen = [
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
  List<Map<String?, dynamic>> jenisKendaraan2 = [
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
          Uri.parse("http://101.50.2.211/api_gocrane/data_unit.php"),
          body: {"paht": "AU"});
      if (mounted) {
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
          Uri.parse("http://101.50.2.211/api_gocrane/data_unit.php"),
          body: {"id": alber_jenis, "paht": "UJ"});
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
      Uri.parse("http://101.50.2.211/api_gocrane/alber.php"),
    );
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
    tb = TabController(length: 2, vsync: this);
    tb?.addListener(_handleTabSelection);
    lihatDetailOrder();
    alber_list();
    tapIndex;
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
                            "Schedule",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'inter',
                            ),
                          ),
                        ),
                      ),
                      Positioned.directional(
                        textDirection: Directionality.of(context),
                        start: 0,
                        end: -350,
                        top: 0,
                        bottom: 0,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: InkWell(
                            onTap: () {},
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(
                                  Icons.info_outline,
                                  color: Colors.amber,
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 15),
                  child: Row(
                    children: [
                      Text(
                        "Jenis Alber",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.07,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: InkWell(
                    onTap: () {},
                    child: Stack(
                      children: [
                        DropdownButton(
                          isExpanded: true,
                          hint: Text(
                            "Pilih Jenis Alber",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "medium",
                                color: const Color.fromARGB(255, 34, 34, 34)),
                            semanticsLabel: "Jenis Alber",
                          ),
                          value: alber_jenis,
                          items: jenis_alber == null
                              ? []
                              : jenis_alber!.map((item) {
                                  return DropdownMenuItem(
                                    child: Text(
                                      item['jenis_nama'],
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "medium",
                                          color: const Color.fromARGB(
                                              255, 34, 34, 34)),
                                    ),
                                    value: item['jenis_id'],
                                  );
                                }).toList(),
                          onChanged: (value) {
                            setState(() {
                              alber_jenis = value as String?;
                              print(alber_jenis);
                              lihatDetailOrder();
                            });
                          },
                        ),
                        Positioned.directional(
                          textDirection: Directionality.of(context),
                          end: 8,
                          top: 5,
                          child: Icon(Icons.search),
                        )
                      ],
                    ),
                  ),
                ),

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
                          jenisKendaraan == null ? 0 : jenisKendaraan!.length,
                      itemBuilder: (context, index) {
                        final jenis = jenisKendaraan?[index];
                        List dataKendaraan = jenis['data'];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(
                                jenis['alber_kode'] ?? "",
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
                              height: 250,
                              width: double
                                  .infinity, // Change width to fit available space
                              child: Container(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: dataKendaraan == []
                                      ? 0
                                      : dataKendaraan.length,
                                  itemBuilder: (context, index) {
                                    final kendaraan = dataKendaraan[index];

                                    return Card(
                                      child: InkWell(
                                        onTap: () {
                                          // Navigator.push(
                                          //   context,
                                          //   SlidePageRoute(
                                          //       page: CalendarScreen2(
                                          //           id: kendaraan['alber_id'] ??
                                          //               "",
                                          //           alber: kendaraan[
                                          //                   'alber_kode'] ??
                                          //               "")), //CalendarScreen KalenderSchedule
                                          // );
                                        },
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 200,
                                              height: 120,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    "https://media.istockphoto.com/id/862598472/photo/truck-crane.jpg?s=170667a&w=0&k=20&c=b5YBmqSurVWi9m71V-J3YyyZQH_zOM8Gw2FNqFGemrs=",
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    kendaraan[
                                                            'alber_no_plat'] ??
                                                        "",
                                                    style: TextStyle(
                                                      color: Color(0xff141414),
                                                      fontSize: 10,
                                                      letterSpacing: 0.05,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    kendaraan['nama'] ?? "",
                                                    style: TextStyle(
                                                      color: Color(0xff141414),
                                                      fontSize: 14,
                                                      fontFamily: "Inter",
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      letterSpacing: 0.07,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    kendaraan['alber_kode'] ??
                                                        "",
                                                    style: TextStyle(
                                                      color: Color(0xff141414),
                                                      fontSize: 10,
                                                      letterSpacing: 0.05,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    kendaraan[
                                                            'alber_kapasitas'] ??
                                                        "",
                                                    style: TextStyle(
                                                      color: Color(0xff141414),
                                                      fontSize: 10,
                                                      letterSpacing: 0.05,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
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
