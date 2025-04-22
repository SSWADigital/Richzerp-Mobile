import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:gocrane_v3/Widget/Alert.dart';
import 'package:gocrane_v3/main.dart';
import 'package:gocrane_v3/tampilan/tab/geolocator.dart';
import 'package:image_editor/image_editor.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class CameraPopup extends StatefulWidget {
  final CameraDescription camera;

  const CameraPopup({Key? key, required this.camera}) : super(key: key);

  @override
  _CameraPopupState createState() => _CameraPopupState();
}

class _CameraPopupState extends State<CameraPopup> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  Location location = Location();
  bool _showCamera = true;
  bool berhasilAbsen = true;
  XFile? _pictureFile;
  String? _location;
  String? _dateTime;

   String idDep = "0";
    List<Color> theme = [Colors.grey, Colors.black];
  Color themeSingle = Colors.grey;

      final Map<String, List<Color>> departmentColors = {
  "1": [const Color(0xFF0000FF), const Color(0xFF87CEFA)], // Biru
  "01": [const Color(0xFF00FF00), const Color(0xFF32CD32)], // Hijau
  "03": [const Color(0xFFFFFF00), const Color(0xFFFFD700)], // Kuning
  "04": [const Color(0xFFFF0000), const Color(0xFFFFA07A)], // Merah
  
};

final Map<String, Color> singleColors = {
  "1": const Color(0xFF0000FF), // Biru
  "01": const Color(0xFF00FF00), // Hijau
  "03": const Color(0xFFFFFF00), // Kuning
  "04": const Color(0xFFFF0000), // Merah

};

List<Color> getColorsByDepartment(String idDepartemen) {
  return departmentColors[idDepartemen] ?? [Colors.grey, Colors.black]; // Default warna
}
Color getColorsByDepartmentSingle(String idDepartemen) {
  return singleColors[idDepartemen] ?? Colors.grey; // Default warna
}

get() async {
  final prefs = await SharedPreferences.getInstance();

    idDep = (prefs.get('departemen_id')) as String;
    print("idDep: $idDep");
    theme = getColorsByDepartment(idDep);
    themeSingle = getColorsByDepartmentSingle(idDep);
}

  @override
  void initState() {
    super.initState();
    get();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller!.initialize();
  }


  void _showFeedbackDialog(BuildContext context, String ket) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 63,
                    height: 63,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.send,
                      size: 80,
                      color: Color(0xff2ab2a2),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Terimakasih!",
                        style: TextStyle(
                          color: themeSingle,
                          fontSize: 36,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.18,
                        ),
                      ),
                      Text(
                        ket,
                        style: TextStyle(
                          color: Color(0xff141414),
                          fontSize: 12,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.06,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  Navigator.pop(dialogContext);
                  await ambildata();
                  // Tutup dialog
                },
                child: Container(
                  width: 229,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: themeSingle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Keluar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: "Inter",
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
        );
      },
    );
  }

  Future _absen() async {
    final prefs = await SharedPreferences.getInstance();

    var id_user = ((prefs.get('pegawai_id')) as String?)!;
    LocationData? locationData = await location.getLocation();
    if (cek_absen == '0') {
      var req = http.MultipartRequest(
          'POST', Uri.parse('${url}/${urlSubAPI}/absen/absenCheckIn/$id_user'));
      req.fields.addAll({
        'absen_checkin_lokasi':
            '${locationData?.latitude ?? 0}, ${locationData?.longitude ?? 0}',
      });
      req.files.add(await http.MultipartFile.fromPath(
          'absen_checkin_foto', _pictureFile!.path));
      http.StreamedResponse response = await req.send();

      if (response.statusCode == 200) {
        berhasilAbsen = false;
        ambildata();
        // print(response);
      }
    } else if (cek_absen == "1") {
      var request = http.MultipartRequest('POST',
          Uri.parse('${url}/${urlSubAPI}/absen/absenCheckOut/$id_absen'));
      request.fields.addAll({
        'absen_checkout_lokasi':
            '${locationData?.latitude ?? 0}, ${locationData?.longitude ?? 0}',
      });
      request.files.add(await http.MultipartFile.fromPath(
          'absen_checkout_foto', _pictureFile!.path));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        ambildata();
        berhasilAbsen = false;
        // print(response);
      }
    }
  }

  Future ambildata() async {
    final prefs = await SharedPreferences.getInstance();

    var id_user = (prefs.get('pegawai_id')) as String?;

    try {
      var response = await http
          .get(Uri.parse('${url}/${urlSubAPI}/absen/cekAbsen/$id_user'));
      var data = jsonDecode(response.body);

      if (data == false) {
        setState(() {
          cek_absen = '0';
        });
      } else {
        setState(() {
          masuk = data['checkin'] ?? "";
          keluar = data['checkout'];
          cek_absen = data['status'];
          id_absen = data['absen_id'];
        });
      }
    } catch (error) {
      print('Error: $error');
    }
  }
   

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
  try {
    await _initializeControllerFuture;
    XFile picture = await _controller!.takePicture();

    if (_controller!.description.lensDirection == CameraLensDirection.front) {
      var file = File(picture.path);
      Uint8List? imageBytes = await file.readAsBytes();

      final ImageEditorOption option = ImageEditorOption();
      option.addOption(const FlipOption(horizontal: true));
      imageBytes = await ImageEditor.editImage(image: imageBytes, imageEditorOption: option);

      await file.delete();
      await file.writeAsBytes(imageBytes!);
    }

    setState(() {
      _pictureFile = picture;
      _showCamera = false;
      _dateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      _getLocation();
    });
  } catch (e) {
    print('Error taking picture: $e');
  }
}


  Future<void> _getLocation() async {
    LocationData? locationData = await location.getLocation();
    setState(() {
      _location =
          '${locationData?.latitude ?? 0}, ${locationData?.longitude ?? 0}';
    });
  }

@override
Widget build(BuildContext context) {
  return AlertDialog(
    title: Text('Absen'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _showCamera
            ? FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CameraPreview(_controller!);
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              )
            : _pictureFile != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.file(
                        File(_pictureFile!.path),
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 10),
                      Text(' $_dateTime'), // Tampilkan waktu
                      // Text('$_location'), // Tampilkan lokasi
                    ],
                  )
                : Container(),
        SizedBox(height: 10),
        Visibility(
  visible: berhasilAbsen == true,
  child: ElevatedButton(
    onPressed: _showCamera
        ? _takePicture
        : () async {
            // Tampilkan dialog loading
            showDialog(
              context: context,
              barrierDismissible: false, // Mencegah dialog ditutup secara manual
              builder: (BuildContext context) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            );

            try {
              Navigator.pop(context);
              await _absen(); // Tunggu proses absensi selesai
              Navigator.pop(context); // Tutup modal kamera
              setState(() {
                ambildata();
                _showFeedbackDialog(
                    context,
                    cek_absen == "1"
                        ? "Selamat Beristirahat"
                        : "Selamat Bekerja");
              });
              
            } catch (e) {
              print("Error: $e");
            } finally {
              // Tutup dialog loading setelah proses selesai
            }
          },
    child: Text(_showCamera ? 'Ambil Foto Absensi' : "Kirim"),
  ),
),
Visibility(
          visible: !berhasilAbsen,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Tutup modal
            },
            child: Text('Kembali'),
          ),
        ),
      ],
    ),
  );
}
}
