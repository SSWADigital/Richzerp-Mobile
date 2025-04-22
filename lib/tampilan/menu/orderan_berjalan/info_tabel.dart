import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class info_tabel_order extends StatefulWidget {
  @override
  _info_tabel_orderState createState() => _info_tabel_orderState();
}

class _info_tabel_orderState extends State<info_tabel_order> {
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

  List? tagihan;

  String? honor;
  String? bulan;
  String? tahun;
  Future ambildata() async {
    final prefs = await SharedPreferences.getInstance();

    var id_user = (prefs.get('pegawai_id'));
    final Response = await http.get(
      Uri.parse(
          "http://101.50.2.211/richzspot/AbsenTunjangan/getAbsenTunjanganRiwayat/$id_user"),
    );
    var _data = jsonDecode(Response.body);
    if (_data == "[]") {
      honor = "Rp. 0";

      this.setState(() {
        honor = "Rp. 0";
      });
    } else {
      this.setState(() {
        tagihan = _data;
      });
    }
  }

  String formatDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    String formattedDate =
        DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(date);
    return formattedDate;
  }

  // List _img = [
  //   "assets/imgs/download 1.png",
  //   "assets/imgs/rs1.png",
  //   "assets/imgs/rs2.png",
  // ];
  int? tapIndex;
  @override
  void initState() {
    ambildata();
    super.initState();
    tapIndex;
  }

  bool isTap = false;
  MediaQueryData? queryData;
  @override
  Widget build(BuildContext context) {
    var formatNumber = NumberFormat("#,##0", "id_ID");
    queryData = MediaQuery.of(context);
    return MediaQuery(
      data: queryData!.copyWith(textScaleFactor: 1.0),
      child: SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Container(
              //   height: MediaQuery.of(context).size.height * 0.4,
              //   child: googleMap(context),
              // )
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16), // Padding untuk tabel
                      child: Table(
                        columnWidths: {
                          0: FlexColumnWidth(
                              0.4), // Kolom 0 memiliki lebar sebanding dengan kontennya
                          // Kolom 2 memiliki lebar tetap 100 piksel
                        },
                        border: TableBorder.all(
                            color: Colors.black,
                            width: 1.0), // Garis pemisah antara sel
                        children: [
                          TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                  color: Color(0xff2ab2a2),
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'No',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  color: Color(0xff2ab2a2),
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Start',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  color: Color(0xff2ab2a2),
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Stop',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  color: Color(0xff2ab2a2),
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Durasi',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('1'),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('08:00'),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('09:00'),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('1 jam'),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('2'),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('10:00'),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('11:30'),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('1 jam 30 menit'),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('3'),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('13:45'),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('15:15'),
                                ),
                              ),
                              TableCell(
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('1 jam 30 menit'),
                                ),
                              ),
                            ],
                          ),
                        ],
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
                              '00 jam 00 menit 00 detik',
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
                  ],
                ),
              ),

              // Container(
              //   decoration: BoxDecoration(
              //       color: Theme.of(context).textTheme.subtitle2.color,
              //       borderRadius: BorderRadius.only(
              //         topLeft: Radius.circular(20),
              //         topRight: Radius.circular(20),
              //       )),
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       //Space
              //       Container(
              //         height: 20,
              //         child: Stack(
              //           clipBehavior: Clip.none,
              //           children: [
              //             Positioned.directional(
              //                 textDirection: Directionality.of(context),
              //                 top: -10,
              //                 start: 0,
              //                 end: 0,
              //                 child: Container(
              //                   height: 40,
              //                   width: double.infinity,
              //                   decoration: BoxDecoration(
              //                       color: Theme.of(context)
              //                           .accentTextTheme
              //                           .bodyText1
              //                           .color,
              //                       borderRadius: BorderRadius.only(
              //                         topLeft: Radius.circular(20),
              //                         topRight: Radius.circular(20),
              //                       )),
              //                 )),
              //           ],
              //         ),
              //       ),
              //       //House number or Apartmant

              //       //City

              //       //District or Street
              //     ],
              //   ),
              // ),
              //Space

              //Basic health examination
              // Container(
              //   padding: EdgeInsets.symmetric(
              //     horizontal: 16,
              //   ),
              //   alignment: Alignment.centerLeft,
              //   child: Text(
              //     "Lokasi Anda",
              //     style: TextStyle(
              //         fontSize: 18,
              //         fontFamily: "medium",
              //         color: Theme.of(context).accentTextTheme.headline2.color),
              //   ),
              // ),
              //Space

              //Space
              // SizedBox(
              //   height: 12,
              // ),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Container(
              //       width: MediaQuery.of(context).size.width - 80,
              //       child: TextField(
              //         controller: _locationController,
              //         decoration: InputDecoration(
              //           hintText: "Keterangan Tempat",
              //         ),
              //       ),
              //     ),
              //     SizedBox(height: 16),
              //     ElevatedButton(
              //       onPressed: _getImage,
              //       child: Text("Pilih Gambar"),
              //     ),
              //   ],
              // ),

              //wrap////////////////////////////////////////////////////////////////////////////////////////////

              //Space
              // SizedBox(
              //   height: 20,
              // ),

              // //Space
              // SizedBox(
              //   height: 10,
              // ),
              // testItem(),
              // //Space
              // SizedBox(
              //   height: 20,
              // ),
              // //Our 4 categories check-up
              // Container(
              //   padding: EdgeInsets.symmetric(
              //     horizontal: 16,
              //   ),
              //   alignment: Alignment.centerLeft,
              //   child: Text(
              //     "Our 4 categories check-up",
              //     style: TextStyle(
              //         fontSize: 18,
              //         fontFamily: "medium",
              //         color: Theme.of(context).accentTextTheme.headline2.color),
              //   ),
              // ),
              // //Space
              // SizedBox(
              //   height: 10,
              // ),
              // checkUpItem(),
              // //Space
              // SizedBox(
              //   height: 80,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  //Appbar
  Widget appBar() {
    return //Img
        Container(
      width: double.infinity,
      height: 188,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/imgs/libartry_img.jpg"))),
      child: Container(
        height: 50,
        padding: EdgeInsets.only(left: 16, top: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //back btn
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(5.0),
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.black),
                child: Image.asset(
                  "assets/icons/ic_back.png",
                  scale: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container verticalDivider() {
    return //Divider
        Container(
      height: 30,
      padding: EdgeInsets.only(left: 25),
      child: Row(
        children: [
          VerticalDivider(
            width: 2,
            thickness: 2,
            indent: 2,
            endIndent: 2,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

// class LocationAttendancePage extends StatefulWidget {
//   @override
//   _LocationAttendancePageState createState() => _LocationAttendancePageState();
// }

// class _LocationAttendancePageState extends State<LocationAttendancePage> {
//   GoogleMapController _mapController;
//   LatLng _currentPosition;
//   Marker _currentMarker;
//   TextEditingController _locationController;
//   File _image;

//   @override
//   void initState() {
//     super.initState();

//     // Mengambil posisi saat ini dan menginisialisasi marker
//     _getCurrentLocation().then((position) {
//       setState(() {
//         _currentPosition = position;
//         _currentMarker = Marker(
//           markerId: MarkerId("current_position"),
//           position: _currentPosition,
//         );
//       });
//     });

//     // Menginisialisasi controller untuk TextField lokasi
//     _locationController = TextEditingController();
//   }

//   void _moveCameraToCurrentPosition() {
//     if (_currentPosition != null) {
//       _mapController
//           .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//         target: _currentPosition,
//         zoom: 16.0,
//       )));
//     }
//   }

//   @override
//   void dispose() {
//     _locationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Absensi Lokasi"),
//       ),
//       body: Stack(
//         children: [
//           // Widget untuk menampilkan peta
//           GoogleMap(
//             onMapCreated: _onMapCreated,
//             initialCameraPosition: CameraPosition(
//               target:
//                   _currentPosition, // Gunakan posisi saat ini sebagai posisi awal peta
//               zoom: 15,
//             ),
//             markers: _currentMarker != null
//                 ? Set<Marker>.of([_currentMarker])
//                 : null, // Ubah dari Set menjadi Set.of
//           ),
//           // Widget untuk menampilkan keterangan lokasi dan tombol untuk memilih gambar
//           Positioned(
//             left: 16,
//             bottom: 16,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: MediaQuery.of(context).size.width - 80,
//                   child: TextField(
//                     controller: _locationController,
//                     decoration: InputDecoration(
//                       hintText: "Keterangan Tempat",
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: _getImage,
//                   child: Text("Pilih Gambar"),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Callback yang dipanggil saat peta selesai dibuat
//   void _onMapCreated(GoogleMapController controller) {
//     _mapController = controller;
//   }

//   // Fungsi untuk mengambil posisi saat ini menggunakan package geolocator
//   Future<LatLng> _getCurrentLocation() async {
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//     return LatLng(position.latitude, position.longitude);
//   }

//   // Fungsi untuk memilih gambar dari galeri menggunakan package image_picker
//   Future<void> _getImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);
//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print("Gambar tidak dipilih.");
//       }
//     });
//   }
// }