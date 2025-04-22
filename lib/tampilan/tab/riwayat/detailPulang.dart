import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gocrane_v3/Widget/Alert.dart';
import 'package:gocrane_v3/main.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

String? poliid;
String? id_dep;
String? kode_reservasi;
String? namapoli;
String? tglbooking;
String? nama_dokter;
String? id_dokter;
String? id_jam;

// ignore: must_be_immutable
class CekAbsen_Pulang extends StatefulWidget {
  const CekAbsen_Pulang({required this.absensiId});
  final String absensiId;
  @override
  _CekAbsen_PulangState createState() => _CekAbsen_PulangState();
}

class _CekAbsen_PulangState extends State<CekAbsen_Pulang> {
  //Tests Items

  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  Marker? _currentMarker;
  TextEditingController? _locationController;
  File? _image;

  //Tests Items

  /////////////////////////////////////////////////////////////////////////////

  String chek = "";

  String? _masuk;
  String? _keluar;

  String? absensiId; // mengambil _data absensi_id
  String? idUser; // mengambil _data id_user
  String? tanggal; // mengambil _data tanggal

  String? checkOut; // mengambil _data check_out

  String? locCheckOut; // mengambil _data loc_check_out

  String? fotoCheckOut;

  LatLng? lokkasinya;

  String? cek_absen;
  Future ambildata() async {
    var id = widget.absensiId;
    final Response = await http.get(
      Uri.parse("${url}/${urlSubAPI}/absen/getAbsenHistoryDetail/$id"),
    );
    var _data = jsonDecode(Response.body);
    if (_data == false) {
      chek = "Belum Ada Data";

      this.setState(() {
        cek_absen = "0";
      });
    } else {
      this.setState(() {
        absensiId = _data['absen_id'];
        idUser = _data['id_user'];
        tanggal = _data['tanggal'];

        checkOut = _data['absen_checkout'];

        locCheckOut = _data['absen_checkout_lokasi'];

        fotoCheckOut = _data['absen_checkout_foto'];
        if (locCheckOut != null) {
          String _locCheckOut = locCheckOut!;
          List<String> locCheckInSplit = _locCheckOut.split(',');
          double latitude = double.parse(locCheckInSplit[0]);
          double longitude = double.parse(locCheckInSplit[1]);
          lokkasinya = LatLng(latitude, longitude);
        } else {}
      });
    }
  }
  ////////////////////////////////////////////////////////////////////////////

  ScrollController? _scrollController;
  bool isTitle = false;
  Color _text = Colors.transparent;
  myfung() {
    _scrollController = ScrollController()
      ..addListener(
        () => _isAppBarExpanded
            ? _text != Theme.of(context).textTheme.caption!.color
                ? setState(
                    () {
                      _text = Theme.of(context).textTheme.caption!.color!;
                      isTitle = true;
                      // _icon = Theme.of(context).textTheme.caption.color;
                      // theme= true;
                      print('setState is called');
                    },
                  )
                : {}
            : _text != Colors.transparent
                ? setState(() {
                    print('setState is called');
                    _text = Colors.transparent;
                    isTitle = false;
                    //_icon = Theme.of(context).textTheme.bodyText1.color;
                  })
                : {},
      );
  }

  bool locStatus = false;

  LatLng? currentLocation;
  LatLng lok = LatLng(-7.544760, 110.792069);
  Future<BitmapDescriptor> markerbitmap = BitmapDescriptor.fromAssetImage(
    ImageConfiguration(),
    "assets/icons/ic_about.png",
  );

  Completer<GoogleMapController> _mapcontroller = Completer();

  final Geolocator geolocator = Geolocator();
  String? lat, lng;

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("Gambar tidak dipilih.");
      }
    });
  }

  // List<dynamic> data = [];
  // List datajson;
  // String chek = "";
  // Future ambildata() async {
  //   final Response = await http.post(
  //       Uri.parse("http://103.157.97.200/api_absen_qr/histori_absen.php"),
  //       body: {"pegawai_id": "000051", "aksi": "2"});
  //   if (Response.body == "false") {
  //     chek = "Belum Ada Data";
  //   } else {
  //     this.setState(() {
  //       data = jsonDecode(Response.body);
  //     });
  //   }
  // }

  @override
  void initState() {
    ambildata();

    _getpeta();
    super.initState();

    _timeString = _formatDateTime(DateTime.now());
    // Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    // super.initState();
    // addMarkers();
    // _locationController.text = lat + lng;
    myfung();

    //  _pageController = PageController();
  }

  bool get _isAppBarExpanded {
    return _scrollController!.hasClients &&
        _scrollController!.offset > (188 - kToolbarHeight);
  }

  //
  Set<Marker> markers = Set();

  addMarkers() async {
    BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/icons/ic_about.png",
    );

    markers.add(Marker(
      //add start location marker
      markerId: MarkerId(currentLocation.toString()),
      position: currentLocation!, //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: 'Starting Point ',
        snippet: 'Start Marker',
      ),
      icon: markerbitmap, //Icon for Marker
    ));

    String imgurl = "https://www.fluttercampus.com/img/car.png";
    Uint8List bytes = (await NetworkAssetBundle(Uri.parse(imgurl)).load(imgurl))
        .buffer
        .asUint8List();

    markers.add(Marker(
      //add start location marker
      markerId: MarkerId(lok.toString()),
      position: lok, //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: 'Car Point ',
        snippet: 'Car Marker',
      ),
      icon: BitmapDescriptor.fromBytes(bytes), //Icon for Marker
    ));

    setState(() {
      //refresh UI
    });
  }

  ///////// versi geolakator 2023
  GoogleMapController? mapController;
  LatLng? _center;

  Future<void> _getpeta() async {
    final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (this.mounted) {
      setState(() {
        _center = LatLng(position.latitude, position.longitude);
      });
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  //  String _locationMessage = '';

  // Future<void> getCurrentLocation() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   setState(() {
  //     _locationMessage =
  //         'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
  //   });

  //   List<Placemark> placemarks =
  //       await placemarkFromCoordinates(position.latitude, position.longitude);
  //   Placemark placemark = placemarks[0];

  //   setState(() {
  //     _locationMessage =
  //         'Alamat: ${placemark.name}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}, ${placemark.postalCode}';
  //   });
  // }

  Future<void> _getgambar() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
      );
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  String getDateFormatted() {
    initializeDateFormatting('id_ID', null);
    String formattedDate =
        DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.now());
    return formattedDate;
  }

  Widget googleMap2(BuildContext context) {
    return lokkasinya == null
        ? Container()
        : Container(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: lokkasinya!,
                zoom: 16.0,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId("marker2"),
                  position: lokkasinya!,
                ),
              },
              // onMapCreated: _onMapCreated,
              // onCameraMove: _onCameraMove,
              // onCameraIdle: _onCameraIdle,
              // myLocationEnabled: locStatus,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: true,
            ),
          );
  }

  final houseNumbController = new TextEditingController();
  final cityController = new TextEditingController();
  final districtController = new TextEditingController();
  String? _timeString;
  String? jam;
  String _formatDatejam(DateTime datejam) {
    return DateFormat('HH:mm:ss').format(datejam);
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  void _getjam() {
    final DateTime now = DateTime.now();
    final String formattedDatejam = _formatDateTime(now);
    setState(() {
      jam = formattedDatejam;
    });
  }

  //
  bool isSave = false;
  checkChanged() {
    if (houseNumbController.text.isNotEmpty &&
        cityController.text.isNotEmpty &&
        districtController.text.isNotEmpty) {
      setState(() {
        isSave = true;
      });
    } else {
      setState(() {
        isSave = false;
      });
    }
  }

  MediaQueryData? queryData;
  @override
  Widget build(BuildContext context) {
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
              Expanded(
                child: locCheckOut == null
                    ? Center(
                        child: Container(
                          width: 360,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Belum Melakukan Check Out",
                                style: TextStyle(
                                  color: Color(0xff141414),
                                  fontSize: 16,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 360,
                              child: Text(
                                "Detail Absensi",
                                style: TextStyle(
                                  color: Color(0xff141414),
                                  fontSize: 16,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 280,
                              height: 294,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x3f000000),
                                    blurRadius: 22,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                                color: Colors.white,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Container(
                                      width: 190,
                                      height: 244,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Color(0xffd9d9d9),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: fotoCheckOut == ""
                                                  ? NetworkImage(
                                                      "https://img.freepik.com/free-vector/illustration-businessman_53876-5856.jpg")
                                                  : NetworkImage(
                                                      fotoCheckOut ?? "",
                                                    ))),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Check In :",
                                              style: TextStyle(
                                                color: Color(0xff020438),
                                                fontSize: 12,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              checkOut ?? "",
                                              style: TextStyle(
                                                color: Color(0xffffa800),
                                                fontSize: 16,
                                                fontFamily: "Inter",
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        // Text(
                                        //   "Titik Kordinat :",
                                        //   style: TextStyle(
                                        //     color: Color(0xff141414),
                                        //     fontSize: 14,
                                        //   ),
                                        // ),
                                        // SizedBox(height: 8),
                                        // Text(
                                        //   locCheckOut ?? "",
                                        //   style: TextStyle(
                                        //     color: Color(0xff141414),
                                        //     fontSize: 14,
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 360,
                              child: Text(
                                "Lokasi Absensi",
                                style: TextStyle(
                                  color: Color(0xff141414),
                                  fontSize: 16,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          //Homitel
                          Center(
                            child: Container(
                              width: 328,
                              height: 340,
                              child: Stack(
                                children: [
                                  Container(
                                    width: 328,
                                    height: 340,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Color(0xffd9d9d9),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                          width: 340,
                                          height: 340,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: (locCheckOut == null)
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : googleMap2(context)
                                          // : GoogleMap(
                                          //     onMapCreated: _onMapCreated,
                                          //     initialCameraPosition: CameraPosition(
                                          //       target: _center,
                                          //       zoom: 11.0,
                                          //     ),
                                          //   ),
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
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
                          //         color: Theme.of(context)
                          //             .accentTextTheme
                          //             .headline2
                          //             .color),
                          //   ),
                          // ),
                          SizedBox(
                            height: 10,
                          ),

                          // Row(
                          //   children: [
                          //     Container(
                          //       padding: EdgeInsets.symmetric(
                          //         horizontal: 16,
                          //       ),
                          //       child: Text(
                          //         lat ?? "",
                          //         style: TextStyle(
                          //             fontSize: 14,
                          //             fontFamily: "medium",
                          //             color: Theme.of(context)
                          //                 .accentTextTheme
                          //                 .headline3
                          //                 .color),
                          //       ),
                          //     ),
                          //     Container(
                          //       padding: EdgeInsets.symmetric(
                          //         horizontal: 16,
                          //       ),
                          //       child: Text(
                          //         lng ?? "",
                          //         style: TextStyle(
                          //             fontSize: 14,
                          //             fontFamily: "medium",
                          //             color: Theme.of(context)
                          //                 .accentTextTheme
                          //                 .headline3
                          //                 .color),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // RaisedButton(
                          //   child: Text("Absen"),
                          // ),
                          SizedBox(
                            height: 10,
                          ),

                          //////////////////////////////////////////////////
                        ],
                      ),
              ),
              SizedBox(
                height: 10,
              ),
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
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
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
          ),
        ],
      ),
    );
  }
}
