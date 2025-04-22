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

// class histori_detail extends StatefulWidget {
//   @override
//   _histori_detailState createState() => _histori_detailState();
// }

// class _histori_detailState extends State<histori_detail> {
//   // void updateWidget() {
//   //   setState(() {
//   //     indikator = MyStepperWidget_3();
//   //     btn = "Lanjut Cetak Bukti";
//   //     tombol_riset = false;
//   //     konten = pilihpekerjaan();
//   //   });
//   // }

  

//   //
//   DateTime currentDate = new DateTime.now();
//   var dateVal;
//   var now = new DateTime.now();
//   Future<void> openDatePicker(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
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

//   String? nama_user;
//   String? alamat_;
//   String? nowa;
//   String? id_user = "";
//   String? image_profil;
//   String? unit_list = "n";



//   final ReceivePort _port = ReceivePort();


  
//   }



//   MediaQueryData? queryData;
//   @override
//   void initState() {
//     // indikator = MyStepperWidget();
//     // btn = "Lanjut Pilih Unit";
//     // tombol_riset = false;
//     // konten = formwaktu();
//     // lihatprofil();
//     // TODO: implement initState



//   }

//   @override
//   void dispose() {
 
//   }



//   @override
//   Widget build(BuildContext context) {
//     queryData = MediaQuery.of(context);
//     return MediaQuery(
//       data: queryData!.copyWith(textScaleFactor: 1.0),
//       child: SafeArea(
//         child: Scaffold(
//           resizeToAvoidBottomInset: false,
//           body: Container(
//             child: Column(
//               children: [
//                 //Appbar
//                 Container(
//                   height: 50,
//                   child: Stack(
//                     fit: StackFit.expand,
//                     children: [
//                       //back btn
//                       Positioned.directional(
//                         textDirection: Directionality.of(context),
//                         start: 5,
//                         top: 10,
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
//                         top: 10,
//                         bottom: 0,
//                         start: 0,
//                         end: 0,
//                         child: Container(
//                           alignment: Alignment.center,
//                           child: const Text(
//                             "Histori Detail",
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
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   color: const Color(0xff2ab2a2),
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
//                               decoration: const BoxDecoration(
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
//                             const SizedBox(width: 16),
//                             const Row(
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

//                 // indikator,
//                 const SizedBox(
//                   height: 10,
//                 ),

//                 Expanded(
//                   child: ListView(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: Container(
//                           color: Colors.white,
//                           padding: const EdgeInsets.only(
//                             bottom: 10,
//                           ),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               const Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Column(
//                                             mainAxisSize: MainAxisSize.min,
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.start,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Column(
//                                                 mainAxisSize: MainAxisSize.min,
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.start,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Row(
//                                                     mainAxisSize:
//                                                         MainAxisSize.min,
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.start,
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Text(
//                                                         "No. Order",
//                                                         style: TextStyle(
//                                                           color:
//                                                               Color(0xff2ab2a2),
//                                                           fontSize: 14,
//                                                           letterSpacing: 0.07,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   SizedBox(height: 4),
//                                                   Text(
//                                                     "202220232024",
//                                                     textAlign: TextAlign.center,
//                                                     style: TextStyle(
//                                                       color: Color(0xff2ab2a2),
//                                                       fontSize: 14,
//                                                       fontFamily: "Inter",
//                                                       fontWeight:
//                                                           FontWeight.w600,
//                                                       letterSpacing: 0.07,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               SizedBox(height: 16),
//                                               Column(
//                                                 mainAxisSize: MainAxisSize.min,
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.start,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Row(
//                                                     mainAxisSize:
//                                                         MainAxisSize.min,
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.start,
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Text(
//                                                         "Periode",
//                                                         style: TextStyle(
//                                                           color:
//                                                               Color(0xff2ab2a2),
//                                                           fontSize: 14,
//                                                           letterSpacing: 0.07,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   SizedBox(height: 4),
//                                                   Text(
//                                                     "14/04/2023 - 24/04/2023",
//                                                     textAlign: TextAlign.center,
//                                                     style: TextStyle(
//                                                       color: Color(0xff2ab2a2),
//                                                       fontSize: 14,
//                                                       fontFamily: "Inter",
//                                                       fontWeight:
//                                                           FontWeight.w600,
//                                                       letterSpacing: 0.07,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               SizedBox(height: 16),
//                                               Column(
//                                                 mainAxisSize: MainAxisSize.min,
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.start,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Row(
//                                                     mainAxisSize:
//                                                         MainAxisSize.min,
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.start,
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Text(
//                                                         "Waktu",
//                                                         style: TextStyle(
//                                                           color:
//                                                               Color(0xff2ab2a2),
//                                                           fontSize: 14,
//                                                           letterSpacing: 0.07,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   SizedBox(height: 4),
//                                                   Text(
//                                                     "11.30 - 12.30",
//                                                     textAlign: TextAlign.center,
//                                                     style: TextStyle(
//                                                       color: Color(0xff2ab2a2),
//                                                       fontSize: 14,
//                                                       fontFamily: "Inter",
//                                                       fontWeight:
//                                                           FontWeight.w600,
//                                                       letterSpacing: 0.07,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(height: 16),
//                                   Text(
//                                     "Menunggu  Persetujuan",
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                       color: Color(0xffe00000),
//                                       fontSize: 16,
//                                       fontFamily: "Inter",
//                                       fontWeight: FontWeight.w600,
//                                       letterSpacing: 0.08,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 24),
//                               Container(
//                                 width: 320,
//                                 color: Colors.grey,
//                                 height: 1,
//                               ),
//                               const SizedBox(height: 24),
//                               Container(
//                                 width: 320,
//                                 child: Column(
//                                   mainAxisSize: MainAxisSize.min,
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                       width: double.infinity,
//                                       child: Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Container(
//                                             width: double.infinity,
//                                             child: const Row(
//                                               mainAxisSize: MainAxisSize.min,
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Expanded(
//                                                   child: Row(
//                                                     mainAxisSize:
//                                                         MainAxisSize.max,
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.start,
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Text(
//                                                         "Unit",
//                                                         style: TextStyle(
//                                                           color:
//                                                               Color(0xff141414),
//                                                           fontSize: 12,
//                                                           letterSpacing: 0.06,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 SizedBox(width: 4),
//                                                 Text(
//                                                   "Komatsu",
//                                                   textAlign: TextAlign.center,
//                                                   style: TextStyle(
//                                                     color: Color(0xff141414),
//                                                     fontSize: 12,
//                                                     fontFamily: "Inter",
//                                                     fontWeight: FontWeight.w600,
//                                                     letterSpacing: 0.06,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           const SizedBox(height: 8),
//                                           Container(
//                                             width: double.infinity,
//                                             child: const Row(
//                                               mainAxisSize: MainAxisSize.min,
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Expanded(
//                                                   child: Row(
//                                                     mainAxisSize:
//                                                         MainAxisSize.max,
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.start,
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Expanded(
//                                                         child: SizedBox(
//                                                           child: Text(
//                                                             "Bagian",
//                                                             style: TextStyle(
//                                                               color: Color(
//                                                                   0xff141414),
//                                                               fontSize: 12,
//                                                               letterSpacing:
//                                                                   0.06,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 SizedBox(width: 4),
//                                                 Text(
//                                                   "Bagian Ops Logistik Wilayah I",
//                                                   textAlign: TextAlign.center,
//                                                   style: TextStyle(
//                                                     color: Color(0xff141414),
//                                                     fontSize: 12,
//                                                     fontFamily: "Inter",
//                                                     fontWeight: FontWeight.w600,
//                                                     letterSpacing: 0.06,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           const SizedBox(height: 8),
//                                           Container(
//                                             width: double.infinity,
//                                             child: const Row(
//                                               mainAxisSize: MainAxisSize.min,
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Expanded(
//                                                   child: Row(
//                                                     mainAxisSize:
//                                                         MainAxisSize.max,
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.start,
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Expanded(
//                                                         child: SizedBox(
//                                                           child: Text(
//                                                             "PIC",
//                                                             style: TextStyle(
//                                                               color: Color(
//                                                                   0xff141414),
//                                                               fontSize: 12,
//                                                               letterSpacing:
//                                                                   0.06,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 SizedBox(width: 4),
//                                                 Text(
//                                                   "Bambang",
//                                                   textAlign: TextAlign.center,
//                                                   style: TextStyle(
//                                                     color: Color(0xff141414),
//                                                     fontSize: 12,
//                                                     fontFamily: "Inter",
//                                                     fontWeight: FontWeight.w600,
//                                                     letterSpacing: 0.06,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           const SizedBox(height: 8),
//                                           Container(
//                                             width: double.infinity,
//                                             child: const Row(
//                                               mainAxisSize: MainAxisSize.min,
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Expanded(
//                                                   child: Row(
//                                                     mainAxisSize:
//                                                         MainAxisSize.max,
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.start,
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Expanded(
//                                                         child: SizedBox(
//                                                           child: Text(
//                                                             "Safety Permits",
//                                                             style: TextStyle(
//                                                               color: Color(
//                                                                   0xff141414),
//                                                               fontSize: 12,
//                                                               letterSpacing:
//                                                                   0.06,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 SizedBox(width: 4),
//                                                 Text(
//                                                   "-",
//                                                   textAlign: TextAlign.center,
//                                                   style: TextStyle(
//                                                     color: Color(0xff141414),
//                                                     fontSize: 12,
//                                                     fontFamily: "Inter",
//                                                     fontWeight: FontWeight.w600,
//                                                     letterSpacing: 0.06,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           const SizedBox(height: 8),
//                                           Container(
//                                             width: double.infinity,
//                                             child: const Row(
//                                               mainAxisSize: MainAxisSize.min,
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Expanded(
//                                                   child: Row(
//                                                     mainAxisSize:
//                                                         MainAxisSize.max,
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.start,
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Expanded(
//                                                         child: SizedBox(
//                                                           child: Text(
//                                                             "Kode Unit",
//                                                             style: TextStyle(
//                                                               color: Color(
//                                                                   0xff141414),
//                                                               fontSize: 12,
//                                                               letterSpacing:
//                                                                   0.06,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 SizedBox(width: 4),
//                                                 Text(
//                                                   "DZR 16",
//                                                   textAlign: TextAlign.center,
//                                                   style: TextStyle(
//                                                     color: Color(0xff141414),
//                                                     fontSize: 12,
//                                                     fontFamily: "Inter",
//                                                     fontWeight: FontWeight.w600,
//                                                     letterSpacing: 0.06,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           const SizedBox(height: 8),
//                                           Container(
//                                             width: double.infinity,
//                                             child: Row(
//                                               mainAxisSize: MainAxisSize.min,
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 const Expanded(
//                                                   child: Row(
//                                                     mainAxisSize:
//                                                         MainAxisSize.max,
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.start,
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Expanded(
//                                                         child: SizedBox(
//                                                           child: Text(
//                                                             "Kapasitas",
//                                                             style: TextStyle(
//                                                               color: Color(
//                                                                   0xff141414),
//                                                               fontSize: 12,
//                                                               letterSpacing:
//                                                                   0.06,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 const SizedBox(width: 4),
//                                                 Container(
//                                                   width: 37,
//                                                   height: 16,
//                                                   child: const Row(
//                                                     mainAxisSize:
//                                                         MainAxisSize.min,
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.end,
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Text(
//                                                         "5.6 M",
//                                                         style: TextStyle(
//                                                           color:
//                                                               Color(0xff141414),
//                                                           fontSize: 12,
//                                                           fontFamily: "Inter",
//                                                           fontWeight:
//                                                               FontWeight.w600,
//                                                           letterSpacing: 0.06,
//                                                         ),
//                                                       ),
//                                                       Text(
//                                                         "3",
//                                                         textAlign:
//                                                             TextAlign.center,
//                                                         style: TextStyle(
//                                                           color:
//                                                               Color(0xff141414),
//                                                           fontSize: 6,
//                                                           fontFamily: "Inter",
//                                                           fontWeight:
//                                                               FontWeight.w600,
//                                                           letterSpacing: 0.03,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           const SizedBox(height: 8),
//                                           Container(
//                                             width: double.infinity,
//                                             child: const Row(
//                                               mainAxisSize: MainAxisSize.min,
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Expanded(
//                                                   child: Row(
//                                                     mainAxisSize:
//                                                         MainAxisSize.max,
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.start,
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Expanded(
//                                                         child: SizedBox(
//                                                           child: Text(
//                                                             "Detail Pekerjaan",
//                                                             style: TextStyle(
//                                                               color: Color(
//                                                                   0xff141414),
//                                                               fontSize: 12,
//                                                               letterSpacing:
//                                                                   0.06,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 SizedBox(width: 4),
//                                                 Text(
//                                                   "Maintenance",
//                                                   textAlign: TextAlign.center,
//                                                   style: TextStyle(
//                                                     color: Color(0xff141414),
//                                                     fontSize: 12,
//                                                     fontFamily: "Inter",
//                                                     fontWeight: FontWeight.w600,
//                                                     letterSpacing: 0.06,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           const SizedBox(height: 8),
//                                           Container(
//                                             width: double.infinity,
//                                             child: const Row(
//                                               mainAxisSize: MainAxisSize.min,
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Expanded(
//                                                   child: Row(
//                                                     mainAxisSize:
//                                                         MainAxisSize.max,
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.start,
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Expanded(
//                                                         child: SizedBox(
//                                                           child: Text(
//                                                             "Lokasi",
//                                                             style: TextStyle(
//                                                               color: Color(
//                                                                   0xff141414),
//                                                               fontSize: 12,
//                                                               letterSpacing:
//                                                                   0.06,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 SizedBox(width: 4),
//                                                 Text(
//                                                   "ALBER",
//                                                   textAlign: TextAlign.center,
//                                                   style: TextStyle(
//                                                     color: Color(0xff141414),
//                                                     fontSize: 12,
//                                                     fontFamily: "Inter",
//                                                     fontWeight: FontWeight.w600,
//                                                     letterSpacing: 0.06,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(height: 24),
//                               Container(
//                                 color: Colors.grey,
//                                 width: 320,
//                                 height: 1,
//                               ),
//                               const SizedBox(height: 24),
//                               Container(
//                                 child: const Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Expanded(
//                                       child: Row(
//                                         mainAxisSize: MainAxisSize.max,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             "Start",
//                                             style: TextStyle(
//                                               color: Color(0xff141414),
//                                               fontSize: 14,
//                                               fontFamily: "Inter",
//                                               fontWeight: FontWeight.w500,
//                                               letterSpacing: 0.07,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(width: 4),
//                                     Text(
//                                       "11.30",
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                         color: Color(0xff2ab2a2),
//                                         fontSize: 14,
//                                         fontFamily: "Inter",
//                                         fontWeight: FontWeight.w600,
//                                         letterSpacing: 0.07,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Container(
//                                 child: const Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Expanded(
//                                       child: Row(
//                                         mainAxisSize: MainAxisSize.max,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             "Stop",
//                                             style: TextStyle(
//                                               color: Color(0xff141414),
//                                               fontSize: 14,
//                                               fontFamily: "Inter",
//                                               fontWeight: FontWeight.w500,
//                                               letterSpacing: 0.07,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(width: 4),
//                                     Text(
//                                       "10.30",
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                         color: Color(0xffe00000),
//                                         fontSize: 14,
//                                         fontFamily: "Inter",
//                                         fontWeight: FontWeight.w600,
//                                         letterSpacing: 0.07,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Container(
//                                 child: const Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Expanded(
//                                       child: Row(
//                                         mainAxisSize: MainAxisSize.max,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             "Durasi",
//                                             style: TextStyle(
//                                               color: Color(0xff141414),
//                                               fontSize: 14,
//                                               fontFamily: "Inter",
//                                               fontWeight: FontWeight.w500,
//                                               letterSpacing: 0.07,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(width: 4),
//                                     Text(
//                                       "23 Jam",
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                         color: Color(0xff141414),
//                                         fontSize: 14,
//                                         fontFamily: "Inter",
//                                         fontWeight: FontWeight.w600,
//                                         letterSpacing: 0.07,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(height: 24),
//                               Container(
//                                 child: const Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Expanded(
//                                       child: Row(
//                                         mainAxisSize: MainAxisSize.max,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             "Biaya",
//                                             style: TextStyle(
//                                               color: Color(0xff141414),
//                                               fontSize: 16,
//                                               fontFamily: "Inter",
//                                               fontWeight: FontWeight.w500,
//                                               letterSpacing: 0.08,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Text(
//                                       "420.000.000",
//                                       textAlign: TextAlign.center,
//                                       style: TextStyle(
//                                         color: Color(0xff141414),
//                                         fontSize: 16,
//                                         fontFamily: "Inter",
//                                         fontWeight: FontWeight.w600,
//                                         letterSpacing: 0.08,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
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
//             insetPadding: const EdgeInsets.all(20),
//             child: Container(
//               padding: const EdgeInsets.symmetric(vertical: 10),
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
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
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
