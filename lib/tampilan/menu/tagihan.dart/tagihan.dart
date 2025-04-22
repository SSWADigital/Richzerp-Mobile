import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';

class tagihan_page extends StatefulWidget {
  @override
  _tagihan_pageState createState() => _tagihan_pageState();
}

class _tagihan_pageState extends State<tagihan_page> {
  // void updateWidget() {
  //   setState(() {
  //     indikator = MyStepperWidget_3();
  //     btn = "Lanjut Cetak Bukti";
  //     tombol_riset = false;
  //     konten = pilihpekerjaan();
  //   });
  // }
  List<Map<String, String>>? listTagihan2;

  final List<Map<String, String>> listTagihan = [
    {
      "no": "1",
      "unit": "Unit 1",
      "tonase": "50",
      "jam": "08:00",
      "biaya": "1000",
    },
    {
      "no": "2",
      "unit": "Unit 2",
      "tonase": "40",
      "jam": "09:00",
      "biaya": "800",
    },
    // Tambahkan data lainnya di sini sesuai kebutuhan Anda
  ];

  //
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

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController tgllahirController = TextEditingController();

  String? nama_user;
  String? alamat_;
  String? nowa;
  String? id_user = "";
  String? image_profil;
  String? unit_list = "n";

  List? TabelWaktuOrder;

  String formatDate(String inputDate) {
    final inputFormat = DateFormat('y-M-d');
    final outputFormat = DateFormat('d-M-y');
    final date = inputFormat.parse(inputDate);
    return outputFormat.format(date);
  }

  String? totalHarga;

  Future lihatDetailOrder() async {
    final prefs = await SharedPreferences.getInstance();

    id_user = (prefs.get('usr_id')) as String?;

    try {
      final Respon = await http.post(
        Uri.parse("http://101.50.2.211/api_gocrane/tagihan2.php"),
        body: {
          "userId": id_user ?? "",
          "tgl_awal": tgl_awal_ymd ?? "",
          "tgl_selesai": tgl_akhir_ymd ?? ""
        },
      );

      if (Respon.statusCode == 200) {
        var data = jsonDecode(Respon.body);
        TabelWaktuOrder = data["transaksi"];
        totalHarga = data["total_nominal"];
        print(data);
      } else {
        print("HTTP Error: ${Respon.statusCode}");
      }
    } catch (error) {
      print("Error: $error");

      print(tgl_awal_ymd);
      print(id_user);
    }
  }

  DateTime currentDateStart = new DateTime.now();
  var datatglawal;
  var tgl_awal;

  var tgl_awal_ymd;
  var tgl_akhir_ymd;
  String?
      selectedStartTime; // Variabel untuk menyimpan nilai terpilih dari dropdown jam awal
  String? selectedEndTime;
  // var now = new DateTime.now();
  Future<void> buka_tgl_awal(BuildContext context) async {
    final DateTime? pilih_tgl_awal = await showDatePicker(
      context: context,
      initialDate: currentDateStart,
      firstDate: DateTime(1950),
      lastDate: DateTime(2101),
    );
    if (pilih_tgl_awal != null && pilih_tgl_awal != currentDateStart) {
      setState(() {
        datatglawal = DateFormat('dd-MM-yyyy').format(pilih_tgl_awal);
        tgl_awal_ymd = DateFormat('yyyy-MM-dd').format(pilih_tgl_awal);
        lihatDetailOrder();
      });
    }
  }

  DateTime currentDateEnd = new DateTime.now();
  var datatglakhir;
  var tgl_akhir;

  // var now = new DateTime.now();
  Future<void> buka_tgl_akhir(BuildContext context) async {
    final DateTime? pilih_tgl_akhir = await showDatePicker(
      context: context,
      initialDate: currentDateEnd,
      firstDate: DateTime(1950),
      lastDate: DateTime(2101),
    );
    if (pilih_tgl_akhir != null && pilih_tgl_akhir != currentDateEnd) {
      setState(() {
        datatglakhir = DateFormat('dd-MM-yyyy').format(pilih_tgl_akhir);
        tgl_akhir_ymd = DateFormat('yyyy-MM-dd').format(pilih_tgl_akhir);
        lihatDetailOrder();
      });
    }
  }

  String formatDuration(int seconds) {
    final Duration duration = Duration(seconds: seconds);
    final int hours = duration.inHours;
    final int minutes = (duration.inMinutes % 60);
    final int remainingSeconds = (duration.inSeconds % 60);

    String formattedDuration = '';

    if (hours > 0) {
      formattedDuration += '$hours Jam ';
    }

    if (minutes > 0) {
      formattedDuration += '$minutes Menit ';
    }

    if (remainingSeconds > 0) {
      formattedDuration += '$remainingSeconds Detik';
    }

    return formattedDuration.trim();
  }

  Future lihatprofil() async {
    final prefs = await SharedPreferences.getInstance();

    id_user = (prefs.get('usr_id')) as String?;
    final Response = await http
        .get(Uri.parse("http://101.50.2.211/richzspot/user/getData/$id_user"));
    var profil = jsonDecode(Response.body);
    this.setState(() {
      if (Response.body == "false") {
        print("null");
      } else {
        // nama_user = profil[0]['username'] ?? "";
        nameController.text = profil['user_nama_lengkap'] ?? "";
        phoneNumController.text = profil['user_no_telp'] ?? "";
        image_profil = profil['user_foto'];
        dateVal = profil['user_tgl_lahir'] ?? "";
        alamat.text = profil['user_alamat'] ?? "";
      }
      // gambar = datajson[0]['faskes_foto'];
    });
  }

  List? list_tagihan;
  MediaQueryData? queryData;
  @override
  void initState() {
    lihatDetailOrder();
    list_tagihan = [
      {
        "no": "1",
        "unit": "FLT",
        "tonase": "FLT",
        "jam": "y",
        "biaya": "2.50",
      },
    ];
    // indikator = MyStepperWidget();
    // btn = "Lanjut Pilih Unit";
    // tombol_riset = false;
    // konten = formwaktu();
    // lihatprofil();
    // TODO: implement initState
    super.initState();
  }

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
                          child: const Text(
                            "Tagihan",
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
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Row(
                    children: [
                      Text(
                        "Tanggal Awal ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.07,
                        ),
                      ),
                      Text(
                        "*",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.07,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: InkWell(
                    onTap: () {
                      buka_tgl_awal(context);
                      lihatDetailOrder();
                    },
                    child: Stack(
                      children: [
                        TextFormField(
                          enabled: false,
                          onChanged: (_) {
                            print(tgl_awal);
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 14),
                            labelText: datatglawal == null
                                ? DateFormat('dd/MM/yyyy')
                                    .format(DateTime.now())
                                : datatglawal.toString(),
                            labelStyle: TextStyle(
                                fontSize: 14,
                                fontFamily: "medium",
                                color: datatglawal == null
                                    ? const Color.fromARGB(255, 100, 100, 100)
                                    : Colors.black),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                    width: 1,
                                    color: Color.fromARGB(255, 100, 100, 100))),
                          ),
                        ),
                        Positioned.directional(
                          textDirection: Directionality.of(context),
                          end: 8,
                          top: 5,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "assets/icons/ic_calendar.png",
                                scale: 25,
                              )),
                        )
                      ],
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.only(left: 16, top: 15),
                  child: Row(
                    children: [
                      Text(
                        "Tanggal Akhir",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.07,
                        ),
                      ),
                      Text(
                        "*",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.07,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: InkWell(
                    onTap: () {
                      buka_tgl_akhir(context);
                      lihatDetailOrder();
                    },
                    child: Stack(
                      children: [
                        TextFormField(
                          enabled: false,
                          onChanged: (value) {
                            print(tgl_akhir);
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 14),
                            labelText: datatglakhir == null
                                ? DateFormat('dd/MM/yyyy')
                                    .format(DateTime.now())
                                : datatglakhir.toString(),
                            labelStyle: TextStyle(
                                fontSize: 14,
                                fontFamily: "medium",
                                color: datatglakhir == null
                                    ? const Color.fromARGB(255, 100, 100, 100)
                                    : const Color.fromARGB(255, 0, 0, 0)),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                    width: 1,
                                    color: Color.fromARGB(255, 0, 0, 0))),
                          ),
                        ),
                        Positioned.directional(
                          textDirection: Directionality.of(context),
                          end: 8,
                          top: 5,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "assets/icons/ic_calendar.png",
                                scale: 25,
                              )),
                        )
                      ],
                    ),
                  ),
                ),

                // indikator,
                const SizedBox(
                  height: 30,
                ),

                // Expanded(
                //     child: ListView(
                //   children: [
                //     Container(
                //       padding: EdgeInsets.symmetric(horizontal: 16),
                //       child: Column(
                //         children: [
                //           _buildTableHeader(),
                //           _buildDataTable(),
                //         ],
                //       ),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.symmetric(horizontal: 16),
                //       child: Container(
                //         decoration: ShapeDecoration(
                //           color: Colors.white,
                //           shape: RoundedRectangleBorder(
                //             side: BorderSide(width: 1, color: Colors.black),
                //             borderRadius: BorderRadius.circular(2),
                //           ),
                //         ),
                //         padding: const EdgeInsets.symmetric(
                //             horizontal: 10, vertical: 2),
                //         child: Row(
                //           mainAxisSize: MainAxisSize.min,
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           crossAxisAlignment: CrossAxisAlignment.center,
                //           children: [
                //             Text(
                //               'Total Durasi :',
                //               textAlign: TextAlign.center,
                //               style: TextStyle(
                //                 color: Colors.black,
                //                 fontSize: 15,
                //                 fontWeight: FontWeight.w700,
                //                 letterSpacing: 0.06,
                //               ),
                //             ),
                //             Spacer(),
                //             _buildTotalBiayaRow(),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ],
                // )),

                Expanded(
                    child: Container(
                  child: ListView(
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TabelWaktuOrder == null
                              ? Center(
                                  child: Container(),
                                )
                              : Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(
                                        0.5), // Kolom 0 memiliki lebar sebanding dengan kontennya
                                    // Kolom 2 memiliki lebar tetap 100 piksel
                                    1: FlexColumnWidth(0.5),
                                    2: FlexColumnWidth(0.7),
                                    3: FlexColumnWidth(0.7),
                                  },
                                  border: TableBorder.all(
                                    color: Colors.black,
                                    width: 1.0,
                                    style: BorderStyle.solid,
                                  ),
                                  children: [
                                    const TableRow(
                                      decoration: BoxDecoration(
                                        color: Color(0xff2ab2a2),
                                      ),
                                      children: [
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Text(
                                              'No',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'Unit',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'Tonase',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'Waktu',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'Biaya',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ...TabelWaktuOrder!
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      final int index = entry.key;
                                      final Map<String, dynamic> item =
                                          entry.value;
                                      return TableRow(
                                        children: [
                                          TableCell(
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Text(
                                                  (index + 1).toString(),
                                                ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                item['alber_kode'] ?? "",
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(item[
                                                      'transaksi_tonase_crane'] ??
                                                  "-"),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                item['total_durasi'] ?? "",
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                item['total_nominal'],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ],
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TabelWaktuOrder == null
                            ? Center(
                                child: Container(),
                              )
                            : Container(
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        width: 1, color: Colors.black),
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
                                    const Text(
                                      'Total Tagihan :',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.06,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      totalHarga ?? "",
                                      // accumulateDurations(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
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
                      // Container(
                      //   padding: EdgeInsets.symmetric(
                      //       horizontal: 16), // Padding untuk tabel
                      //   child: Table(
                      //     columnWidths: {
                      //       0: FlexColumnWidth(
                      //           0.4), // Kolom 0 memiliki lebar sebanding dengan kontennya
                      //       // Kolom 2 memiliki lebar tetap 100 piksel
                      //     },
                      //     border: TableBorder.all(
                      //         color: Colors.black,
                      //         width: 1.0), // Garis pemisah antara sel
                      //     children: [
                      //       TableRow(
                      //         children: [
                      //           TableCell(
                      //             child: Container(
                      //               color: Color(0xff2ab2a2),
                      //               padding: EdgeInsets.all(8.0),
                      //               child: Text(
                      //                 'No',
                      //                 style: TextStyle(
                      //                     fontWeight: FontWeight.bold),
                      //               ),
                      //             ),
                      //           ),
                      //           TableCell(
                      //             child: Container(
                      //               color: Color(0xff2ab2a2),
                      //               padding: EdgeInsets.all(8.0),
                      //               child: Text(
                      //                 'Start',
                      //                 style: TextStyle(
                      //                     fontWeight: FontWeight.bold),
                      //               ),
                      //             ),
                      //           ),
                      //           TableCell(
                      //             child: Container(
                      //               color: Color(0xff2ab2a2),
                      //               padding: EdgeInsets.all(8.0),
                      //               child: Text(
                      //                 'Stop',
                      //                 style: TextStyle(
                      //                     fontWeight: FontWeight.bold),
                      //               ),
                      //             ),
                      //           ),
                      //           TableCell(
                      //             child: Container(
                      //               color: Color(0xff2ab2a2),
                      //               padding: EdgeInsets.all(8.0),
                      //               child: Text(
                      //                 'Durasi',
                      //                 style: TextStyle(
                      //                     fontWeight: FontWeight.bold),
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       TableRow(
                      //         children: [
                      //           TableCell(
                      //             child: Container(
                      //               padding: EdgeInsets.all(8.0),
                      //               child: Text('1'),
                      //             ),
                      //           ),
                      //           TableCell(
                      //             child: Container(
                      //               padding: EdgeInsets.all(8.0),
                      //               child: Text('08:00'),
                      //             ),
                      //           ),
                      //           TableCell(
                      //             child: Container(
                      //               padding: EdgeInsets.all(8.0),
                      //               child: Text('09:00'),
                      //             ),
                      //           ),
                      //           TableCell(
                      //             child: Container(
                      //               padding: EdgeInsets.all(8.0),
                      //               child: Text('1 jam'),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 16),
                      //   child: Container(
                      //     decoration: ShapeDecoration(
                      //       color: Colors.white,
                      //       shape: RoundedRectangleBorder(
                      //         side: BorderSide(width: 1, color: Colors.black),
                      //         borderRadius: BorderRadius.circular(2),
                      //       ),
                      //     ),
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 10, vertical: 2),
                      //     child: Row(
                      //       mainAxisSize: MainAxisSize.min,
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       crossAxisAlignment: CrossAxisAlignment.center,
                      //       children: [
                      //         Text(
                      //           'Total Durasi :',
                      //           textAlign: TextAlign.center,
                      //           style: TextStyle(
                      //             color: Colors.black,
                      //             fontSize: 15,
                      //             fontWeight: FontWeight.w700,
                      //             letterSpacing: 0.06,
                      //           ),
                      //         ),
                      //         Spacer(),
                      //         Text(
                      //           '00 jam 00 menit 00 detik',
                      //           textAlign: TextAlign.center,
                      //           style: TextStyle(
                      //             color: Colors.black,
                      //             fontSize: 15,
                      //             fontWeight: FontWeight.w700,
                      //             letterSpacing: 0.06,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //

  Widget _buildTableHeader() {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: {
        0: const FlexColumnWidth(1),
        1: const FlexColumnWidth(2),
        2: const FlexColumnWidth(2),
        3: const FlexColumnWidth(2),
        4: const FlexColumnWidth(2),
      },
      border: TableBorder.all(width: 1.0),
      children: [
        TableRow(
          decoration: const BoxDecoration(
            color: Color(0xff2ab2a2),
          ),
          children: [
            _buildHeaderCell('No'),
            _buildHeaderCell('Unit'),
            _buildHeaderCell('Tonase'),
            _buildHeaderCell('Jam'),
            _buildHeaderCell('Biaya'),
          ],
        ),
      ],
    );
  }

  TableCell _buildHeaderCell(String title) {
    return TableCell(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildDataTable() {
    // ignore: unnecessary_null_comparison
    if (listTagihan == null || listTagihan.isEmpty) {
      return const Text(
          'Data Tagihan Kosong'); // Menampilkan pesan jika listTagihan bernilai null atau kosong
    }
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: {
        0: const FlexColumnWidth(1),
        1: const FlexColumnWidth(2),
        2: const FlexColumnWidth(2),
        3: const FlexColumnWidth(2),
        4: const FlexColumnWidth(2),
      },
      border: TableBorder.all(width: 1.0),
      children: listTagihan.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, String> data = entry.value;
        return TableRow(
          children: [
            _buildDataCell((index + 1).toString()), // Auto-generated "No" value
            _buildDataCell(data['unit']!),
            _buildDataCell(data['tonase']!),
            _buildDataCell(data['jam']!),
            _buildDataCell(data['biaya']!),
          ],
        );
      }).toList(),
    );
  }

  TableCell _buildDataCell(String value) {
    return TableCell(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          value,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildTotalBiayaRow() {
    // ignore: unnecessary_null_comparison
    if (listTagihan == null || listTagihan.isEmpty) {
      return const SizedBox
          .shrink(); // Jika listTagihan bernilai null atau kosong, tidak menampilkan baris total biaya
    }
    final totalBiaya = _calculateTotalBiaya(listTagihan);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          totalBiaya,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  String _calculateTotalBiaya(List<Map<String, String>> data) {
    int totalBiaya = 0;
    data.forEach((item) {
      totalBiaya += int.parse(item['biaya']!);
    });
    return totalBiaya.toString();
  }
}
