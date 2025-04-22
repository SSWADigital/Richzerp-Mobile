// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:math';
// import 'package:path_provider/path_provider.dart';
// import 'dart:isolate';
// import 'dart:ui';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class order_detail extends StatefulWidget {
//   @override
//   _order_detailState createState() => _order_detailState();
// }

// class _order_detailState extends State<order_detail>
//     with SingleTickerProviderStateMixin {
//   // void updateWidget() {
//   //   setState(() {
//   //     indikator = MyStepperWidget_3();
//   //     btn = "Lanjut Cetak Bukti";
//   //     tombol_riset = false;
//   //     konten = pilihpekerjaan();
//   //   });
//   // }

//   File _image;
//   final picker = ImagePicker();

//   Future getImage() async {
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);

//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//   //
//   DateTime currentDate = new DateTime.now();
//   var dateVal;
//   var now = new DateTime.now();
//   Future<void> openDatePicker(BuildContext context) async {
//     final DateTime picked = await showDatePicker(
//       context: context,
//       initialDate: currentDate,
//       firstDate: DateTime(1950),
//       lastDate: DateTime(2101),
//     );
//     if (picked != null && picked != currentDate) {
//       setState(() {
//         dateVal = DateFormat('dd-MM-yyyy').format(picked);
//       });
//     }
//   }

//   TextEditingController nameController = TextEditingController();
//   TextEditingController phoneNumController = TextEditingController();
//   TextEditingController alamat = TextEditingController();
//   TextEditingController tgllahirController = TextEditingController();

//   String nama_user;
//   String alamat_;
//   String nowa;
//   String id_user = "";
//   String image_profil;
//   String unit_list = "n";

//   Future lihatprofil() async {
//     final prefs = await SharedPreferences.getInstance();

//     id_user = (prefs.get('pegawai_id'));
//     final Response = await http.get(
//         Uri.parse("http://103.157.97.200/richzspot/user/getData/$id_user"));
//     var profil = jsonDecode(Response.body);
//     this.setState(() {
//       if (Response.body == "false") {
//         print("null");
//       } else {
//         // nama_user = profil[0]['username'] ?? "";
//         nameController.text = profil['user_nama_lengkap'] ?? "";
//         phoneNumController.text = profil['user_no_telp'] ?? "";
//         image_profil = profil['user_foto'];
//         dateVal = profil['user_tgl_lahir'] ?? "";
//         alamat.text = profil['user_alamat'] ?? "";
//       }
//       // gambar = datajson[0]['faskes_foto'];
//     });
//   }

//   Future _edit() async {
//     final prefs = await SharedPreferences.getInstance();

//     id_user = (prefs.get('pegawai_id'));
//     if (_image != null) {
//       var request = http.MultipartRequest(
//           'POST',
//           Uri.parse(
//               'http://103.157.97.200/richzspot/user/updateData/$id_user'));
//       request.fields.addAll({
//         'user_nama_lengkap': nameController.text,
//         'user_no_telp': phoneNumController.text,
//         'pasien_alamat': alamat.text,
//         "user_tgl_lahir": dateVal,
//       });
//       request.files
//           .add(await http.MultipartFile.fromPath('user_foto', _image.path));

//       http.StreamedResponse response = await request.send();

//       showDialog<void>(
//           context: context,
//           builder: (BuildContext dialogContext) {
//             return Alert(
//               title: "Pembritahuan !!!",
//               subTile: "Berhasil Edit Profil",
//             );
//           });
//       // Navigator.pop(context);
//     } else {
//       var request = http.MultipartRequest(
//           'POST',
//           Uri.parse(
//               'http://103.157.97.200/richzspot/user/updateData/$id_user'));
//       request.fields.addAll({
//         'user_nama_lengkap': nameController.text,
//         'user_no_telp': phoneNumController.text,
//         'pasien_alamat': alamat.text,
//         "user_tgl_lahir": dateVal,
//       });

//       http.StreamedResponse response = await request.send();

//       showDialog<void>(
//           context: context,
//           builder: (BuildContext dialogContext) {
//             return Alert(
//               title: "Pembritahuan !!!",
//               subTile: " Berhasil Edit Profil",
//             );
//           });
//       // Navigator.pop(context);
//     }
//   }

//   check() {
//     if (nameController.text.isEmpty) {
//       return showDialog<void>(
//           context: context,
//           builder: (BuildContext dialogContext) {
//             return Alert(
//               title: "Alert !!!",
//               subTile: "First name is required !",
//             );
//           });
//     } else if (genderVal == null) {
//       return showDialog<void>(
//           context: context,
//           builder: (BuildContext dialogContext) {
//             return Alert(
//               title: "Alert !!!",
//               subTile: "Gender is required !",
//             );
//           });
//     } else if (dateVal == null) {
//       return showDialog<void>(
//           context: context,
//           builder: (BuildContext dialogContext) {
//             return Alert(
//               title: "Alert !!!",
//               subTile: "Date of birth is required !",
//             );
//           });
//     } else if (phoneNumController.text.isEmpty) {
//       return showDialog<void>(
//           context: context,
//           builder: (BuildContext dialogContext) {
//             return Alert(
//               title: "Alert !!!",
//               subTile: "Phone number is required !",
//             );
//           });
//     } else if (alamat.text.isEmpty) {
//       return showDialog<void>(
//           context: context,
//           builder: (BuildContext dialogContext) {
//             return Alert(
//               title: "Alert !!!",
//               subTile: "Email is required !",
//             );
//           });
//     } else {
//       Navigator.pop(context);
//     }
//   }

//   bool isSave = false;
//   checkChanged() {
//     if (nameController.text.isNotEmpty &&
//         genderVal != null &&
//         dateVal != null &&
//         phoneNumController.text.isNotEmpty &&
//         alamat.text.isNotEmpty) {
//       setState(() {
//         isSave = true;
//       });
//     } else {
//       isSave = false;
//     }
//   }

//   final ReceivePort _port = ReceivePort();
//   TabController tb;
//   int tapIndex;
//   @override
//   void _handleTabSelection() {
//     setState(() {});
//   }

//   MediaQueryData queryData;
//   @override
//   void initState() {
//     tb = TabController(length: 2, vsync: this);
//     tb.addListener(_handleTabSelection);
//     tapIndex;
//     // indikator = MyStepperWidget();
//     // btn = "Lanjut Pilih Unit";
//     // tombol_riset = false;
//     // konten = formwaktu();
//     // lihatprofil();
//     // TODO: implement initState
//     super.initState();

//     IsolateNameServer.registerPortWithName(
//         _port.sendPort, 'downloader_send_port');
//     _port.listen((dynamic data) {
//       String id = data[0];
//       DownloadTaskStatus status = data[1];
//       int progress = data[2];
//       setState(() {
//         // Update UI state based on download progress/status
//       });
//     });

//     FlutterDownloader.registerCallback(downloadCallback);
//   }

//   @override
//   void dispose() {
//     IsolateNameServer.removePortNameMapping('downloader_send_port');
//     super.dispose();
//   }

//   static void downloadCallback(
//       String id, DownloadTaskStatus status, int progress) {
//     final SendPort send =
//         IsolateNameServer.lookupPortByName('downloader_send_port');
//     send.send([id, status, progress]);
//   }

//   @override
//   Widget build(BuildContext context) {
//     queryData = MediaQuery.of(context);
//     return MediaQuery(
//       data: queryData.copyWith(textScaleFactor: 1.0),
//       child: SafeArea(
//         child: Scaffold(
//           resizeToAvoidBottomInset: false,
//           body: Container(
//             child: Column(
//               children: [
//                 //Appbar
//                 Container(
//                   height: 60,
//                   child: Stack(
//                     fit: StackFit.expand,
//                     children: [
//                       //back btn
//                       Positioned.directional(
//                         textDirection: Directionality.of(context),
//                         start: 3,
//                         top: 0,
//                         bottom: 0,
//                         child: InkWell(
//                           onTap: () {
//                             Navigator.pop(context);
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.all(10.0),
//                             child: Image.asset(
//                               "assets/icons/ic_back.png",
//                               scale: 15,
//                             ),
//                           ),
//                         ),
//                       ),
//                       //title
//                       Positioned.directional(
//                         textDirection: Directionality.of(context),
//                         top: 0,
//                         bottom: 0,
//                         start: 0,
//                         end: 0,
//                         child: Container(
//                           alignment: Alignment.center,
//                           child: Text(
//                             "Order Detail",
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.w700,
//                               fontFamily: 'inter',
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   color: Color(0xff2ab2a2),
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 24,
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         width: double.infinity,
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Container(
//                               width: 80,
//                               height: 80,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Color(0xffd9d9d9),
//                               ),
//                               child: ClipOval(
//                                 child: Image.network(
//                                   'https://as1.ftcdn.net/v2/jpg/01/92/07/76/1000_F_192077668_hLewzaqBcb2RVB0iiHmjYjnbZAUGJgOq.jpg',
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 16),
//                             Row(
//                               mainAxisSize: MainAxisSize.min,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "Hadi Ismanto",
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 16,
//                                         fontFamily: "Inter",
//                                         fontWeight: FontWeight.w600,
//                                         letterSpacing: 0.08,
//                                       ),
//                                     ),
//                                     SizedBox(height: 4),
//                                     Text(
//                                       "OP. Crane Kelas 1",
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 14,
//                                         letterSpacing: 0.07,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),

//                 Container(
//                   width: 328,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(6),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Color(0x1c000000),
//                         blurRadius: 28,
//                         offset: Offset(0, 4),
//                       ),
//                     ],
//                     color: Colors.white,
//                   ),
//                   child: Center(
//                     child: TabBar(
//                         labelColor: Color(0xff141414),
//                         unselectedLabelColor: Colors.grey,
//                         controller: tb,
//                         isScrollable: true,
//                         tabs: [
//                           Tab(
//                             child: Center(
//                                 child: Row(
//                               children: [
//                                 Text(
//                                   'Informasi',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontFamily: "Inter",
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             )),
//                           ),
//                           Tab(
//                             child: Center(
//                                 child: Text(
//                               'Tabel',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontFamily: "Inter",
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             )),
//                           ),
//                         ]),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
// //Anda dapat menambahkan lebih banyak widget Tab sesuai dengan kebutuhan. Pastikan juga sudah menginisialisasi controller tb sebelumnya.

//                 Expanded(
//                   child: TabBarView(controller: tb, children: [
//                     info_orderan(),
//                     info_tabel_order(),

//                     // Endocrine(),
//                     // Dentist(),
//                     // Orthopodist(),
//                     // Surgeon(),
//                   ]),
//                 ),

//                 // indikator,
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   //
//   List genderList = [
//     "Laki-laki",
//     "perempuan",
//   ];
//   String genderVal;
//   void genderDialogue() {
//     showDialog<void>(
//       context: context,
//       // false = user must tap button, true = tap outside dialog
//       builder: (BuildContext dialogContext) {
//         return StatefulBuilder(builder: (context, setState) {
//           return Dialog(
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             insetPadding: EdgeInsets.all(20),
//             child: Container(
//               padding: EdgeInsets.symmetric(vertical: 10),
//               child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: List.generate(genderList.length, (index) {
//                     return InkWell(
//                       onTap: () {
//                         setState(() {
//                           genderVal = genderList[index]["kode"];
//                           Navigator.pop(context);
//                         });
//                       },
//                       child: Container(
//                         height: 50,
//                         padding: EdgeInsets.symmetric(horizontal: 20),
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           genderList[index]["jenis_kelamin"],
//                           style: TextStyle(
//                               fontSize: 18,
//                               fontFamily: "medium",
//                               color: Theme.of(context)
//                                   .accentTextTheme
//                                   .headline2
//                                   .color),
//                         ),
//                       ),
//                     );
//                   })),
//             ),
//           );
//         });
//       },
//     );
//   }
// }
