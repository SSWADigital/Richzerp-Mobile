import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({required this.id_reg});
  final String id_reg;
  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  GoogleMapController? _mapController;

  void sendWhatsAppMessage(String phoneNumber, String message) async {
    String url = 'https://wa.me/$phoneNumber?text=${Uri.encodeFull(message)}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Tidak dapat membuka WhatsApp';
    }
  }

  BitmapDescriptor? customIcon;
  // Future<void> _createCustomMarker() async {
  //   final Uint8List markerIcon = await getBytesFromUrl(
  //       'http://101.50.2.211/gocraneapp_v2/production/order_berjalan/assets/icon/CRN25_OFF.png'); // Ganti URL_GAMBAR_ICON dengan URL gambar ikon Anda
  //   customIcon = BitmapDescriptor.fromBytes(markerIcon);
  // }

  // Future<Uint8List> getBytesFromUrl(String url) async {
  //   final response = await http.get(Uri.parse(url));
  //   return response.bodyBytes;
  // }
  bool isLoading = true;
  Future<img.Image> resizeImage(img.Image image, int width, int height) async {
    return img.copyResize(image, width: width, height: height);
  }

  Future<void> _createCustomMarker() async {
    // customIcon = await BitmapDescriptor.fromAssetImage(
    //   ImageConfiguration(size: Size(100, 100)),
    //   'assets/icons/CRN25_OFF.png',
    // );
    // final ByteData data = await rootBundle.load('assets/icons/CRN25_OFF.png');
    // final List<int> bytes = data.buffer.asUint8List();

    // img.Image image = img.decodeImage(Uint8List.fromList(bytes));
    // img.Image resizedImage = await resizeImage(image, 10, 10);

    // customIcon =
    //     BitmapDescriptor.fromBytes(Uint8List.fromList(resizedImage.getBytes()));

    setState(() {
      isLoading = false;
    });
  }

  String? nama_drever, noOrder, merkUnit;
  String? tglstart,
      tgland,
      pic,
      bagian,
      safetyPermits,
      kodeUnit,
      kapasitas,
      DetailPekerjaan,
      lokasi;

  List? TabelWaktuOrder;
  Future lihatDetailOrder() async {
    final Response = await http.post(
        Uri.parse("http://101.50.2.211/api_gocrane/data_transaksi.php"),
        body: {"id": widget.id_reg, "paht": "op"});
    var data = jsonDecode(Response.body);
    print("${widget.id_reg}<///data registrasi");
    setState(() {
      if (Response.body == "null") {
        print("null");
      } else {
        // nama_user = data[0]['username'] ?? "";
        nama_drever = data[0]['driver_nama'];
        noOrder = data[0]['transaksi_kode'];
        lokasi = data[0]['transaksi_lokasi'];
        safetyPermits = data[0]['transaksi_safety_permit'];
        merkUnit = data[0]['alber_merk'];
        DetailPekerjaan = data[0]['transaksi_jenis_barang'];
        tglstart = data[0]['transaksi_tanggal'];
        tgland = data[0]['transaksi_tanggal_selesai'];
        pic = data[0]['transaksi_pic'];
        bagian = data[0]['struk_detail_nama'];
        kodeUnit = data[0]['alber_kode'];
        kapasitas = data[0]['alber_kapasitas'];
      }
      // gambar = data[0]json[0]['faskes_foto'];
    });

    final Respon = await http.post(
        Uri.parse("http://101.50.2.211/api_gocrane/data_transaksi.php"),
        body: {"id": widget.id_reg, "paht": "o"});

    setState(() {
      if (Respon.body == "false") {
        print("null");
      } else {
        TabelWaktuOrder = jsonDecode(Respon.body);
      }
      // gambar = datajson[0]['faskes_foto'];
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();

    super.dispose();
  }

  bool isVisible = true;

  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  void initState() {
    _createCustomMarker();
    lihatDetailOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(-7.5561101, 110.7648007),
                    zoom: 15.0,
                  ),
                  markers: Set<Marker>.from([
                    Marker(
                      markerId: MarkerId('marker_id'),
                      position: LatLng(-7.5561101, 110.7648007),
                      // icon: customIcon,
                      infoWindow: InfoWindow(
                        title: 'Lokasi',
                        snippet: 'Deskripsi lokasi',
                      ),
                    ),
                  ]),
                ),
                Positioned(
                  top: 23,
                  left: 1,
                  right: 1,
                  child: Container(
                    color: Colors.white,
                    height: 50,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        //back btn
                        Positioned.directional(
                          textDirection: Directionality.of(context),
                          start: 3,
                          top: 0,
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
                          top: 0,
                          bottom: 0,
                          start: 0,
                          end: 0,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              "Map",
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
                ),
                Positioned(
                    bottom: 16.0,
                    left: 16.0,
                    right: 16.0,
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          child: Visibility(
                            visible: isVisible,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, bottom: 14),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                shadows: [
                                  BoxShadow(
                                    color: Color(0x1C000000),
                                    blurRadius: 4,
                                    offset: Offset(0, 0),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 8, top: 8),
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: ShapeDecoration(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  width: 0.50,
                                                  color: Color.fromARGB(
                                                      255, 28, 99, 31)),
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 2),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Biaya (0 : 0 : 0)',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                  letterSpacing: 0.06,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          decoration: ShapeDecoration(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  width: 0.50,
                                                  color: Color.fromARGB(
                                                      255, 28, 99, 31)),
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 2),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Rp. ',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                  letterSpacing: 0.06,
                                                ),
                                              ),
                                              Text(
                                                '421,250,000.00',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                  letterSpacing: 0.06,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: const ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            width: 0.50,
                                            // strokeAlign: BorderSide.strokeAlignCenter,
                                            color: Color(0xFFEAE6E6),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 125,
                                              height: 115,
                                              decoration: ShapeDecoration(
                                                image: const DecorationImage(
                                                  image: NetworkImage(
                                                      "https://images.unsplash.com/photo-1586458995526-09ce6839babe?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=873&q=80"),
                                                  fit: BoxFit.cover,
                                                ),
                                                color: Color(0xFFD9D9D9),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                              ),
                                            ),
                                            // Flexible(
                                            //   child: Container(
                                            //     padding:
                                            //         const EdgeInsets.only(top: 8),
                                            //     width: 125,
                                            //     child: Text(
                                            //       "Munawir",
                                            //       textAlign: TextAlign.center,
                                            //       style: TextStyle(
                                            //         color: Colors.black,
                                            //         fontSize: 14,
                                            //         fontFamily: "Inter",
                                            //         fontWeight: FontWeight.w700,
                                            //         letterSpacing: 0.06,
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16),
                                                child: Table(
                                                  columnWidths: {
                                                    1: FractionColumnWidth(0.1),
                                                    0: FractionColumnWidth(0.4),
                                                  },
                                                  children: [
                                                    buildRow("Nama Drever",
                                                        nama_drever ?? "", 14),
                                                    buildRow("No Order",
                                                        noOrder ?? "", 14),
                                                    buildRow("Lokasi",
                                                        lokasi ?? "", 14),
                                                    buildRow(
                                                        "Safety Permits",
                                                        safetyPermits ?? "",
                                                        14),
                                                    buildRow("Merk Unit",
                                                        merkUnit ?? "", 14),
                                                    buildRow("Code Unit",
                                                        kodeUnit ?? "", 14),
                                                  ],
                                                ),
                                              ),
                                              // Sisanya mengikuti pola yang sama
                                              // ...
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.amber,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: Container(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                      onTap: toggleVisibility,
                                      child: Icon(
                                        isVisible
                                            ? Icons.arrow_circle_down
                                            : Icons.arrow_circle_up,
                                        color: Colors.white,
                                        size: 30,
                                      )),
                                  Spacer(),
                                  InkWell(
                                    onTap: () {
                                      sendWhatsAppMessage('+6282224076234', '');
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 2),
                                      decoration: ShapeDecoration(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              width: 0.50,
                                              color: Color.fromARGB(
                                                  255, 28, 99, 31)),
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.call,
                                            color: Colors.green,
                                          ),
                                          Text(
                                            'WhatsApp',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 15,
                                              fontFamily: 'Inter',
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
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
    );
  }
}

TableRow buildRow(String title, String value, double shiz) {
  return TableRow(
    children: [
      TableCell(
        child: SizedBox(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 10,
              fontWeight: FontWeight.w400,
              // letterSpacing: 0.06,
            ),
          ),
        ),
      ),
      TableCell(
        child: FractionallySizedBox(
          widthFactor:
              0.0, // Ubah nilai widthFactor sesuai kebutuhan (0.0 - 1.0)
          child: Text(
            ":",
            textAlign: TextAlign.center, // Perataan teks ke tengah
            style: TextStyle(
              color: Colors.black,
              fontSize: 10,
              fontWeight: FontWeight.w400,
              // letterSpacing: 0.06,
            ),
          ),
        ),
      ),
      TableCell(
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  // letterSpacing: 0.06,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
