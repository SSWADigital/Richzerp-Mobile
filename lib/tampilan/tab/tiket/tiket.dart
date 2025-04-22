import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gocrane_v3/Widget/Alert.dart';
import 'package:gocrane_v3/Widget/tiket/tiket_card.dart';
import 'package:gocrane_v3/main.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// String? poliid;
// String? id_dep;
// String? kode_reservasi;
// String? namapoli;
// String? tglbooking;
// String? nama_dokter;
// String? id_dokter;
// String? id_jam;

// ignore: must_be_immutable
class TiketPage extends StatefulWidget {
  String action;
  TiketPage({
    Key? key,
    required this.action,
  }) : super(key: key);

  @override
  _TiketPageState createState() => _TiketPageState();
}

class _TiketPageState extends State<TiketPage> {
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

  DateTime currentDateEnd = new DateTime.now();
  var datatglakhir;
  var tgl_akhir;

  // var now = new DateTime.now();

  //alber
  List? datajson;

  Future ambildata() async {
    final prefs = await SharedPreferences.getInstance();

    var id_user = (prefs.get('pegawai_id'));
    print("id_user: $id_user");
    // print("${url}/${urlSubAPI}/Cuti/getCutiHistory/$id_user");
    final Response = await http.get(
      Uri.parse("http://103.157.97.152/mycrm/api.php?action=getTiket&status=${widget.action}&id_user=$id_user&id_dep=1&limit=10"),
    );
    var _data = jsonDecode(Response.body);

    if (this.mounted) {
      setState(() {
        if (_data == false) {
          // chek = "Belum Ada Data";

          this.setState(() {
            //    cek_absen = "0";
          });
        } else {
          this.setState(() {
            cutiData = _data;
            print(cutiData);
          });
        }
      });
    }
  }

  String? jenis;
  // List? cutiData;
  // List cutiData = [
  //   {
  //     "riwayat_cuti_tanggal": "2024-01-01",
  //     "cuti_nama": "Cuti Tahunan",
  //     "shift_kode": "SS",
  //     "cuti_status": "y",
  //     "cuti_maks": "3",
  //   },
  //   {
  //     "riwayat_cuti_tanggal": "2024-01-05",
  //     "cuti_nama": "Cuti Tahunan",
  //     "shift_kode": "SS",
  //     "cuti_maks": "3",
  //     "cuti_status": "n",
  //   },
  //   {
  //     "riwayat_cuti_tanggal": "2024-01-15",
  //     "cuti_nama": "Cuti Tahunan",
  //     "shift_kode": "SS",
  //     "cuti_maks": "3",
  //     "cuti_status": "x",
  //   },
  // ];

  List? cutiData;
  String formatDate(String dateStr) {
    if (dateStr == "") {
      return "-";
    } else {
      DateTime date = DateTime.parse(dateStr);
      String formattedDate =
          DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(date);
      return formattedDate;
    }
  }

  int _calculateTotalDays(String startDate, String endDate) {
    DateTime startDateTime = DateTime.parse(startDate);
    DateTime endDateTime = DateTime.parse(endDate);
    Duration difference = endDateTime.difference(startDateTime);
    return difference.inDays +
        1; // Menambahkan 1 karena ingin memasukkan hari terakhir
  }

  List? jenis_alber;

  List<dynamic>? jenis_bagian;

// Variabel untuk menyimpan nilai terpilih dari dropdown jam akhir

  List? startTimeList;
  List? endTimeList;

  MediaQueryData? queryData;
  @override
  void initState() {
    ambildata();

    // lihatprofil();
    // TODO: implement initState
    super.initState();
  }

String? selectedClient;
  List<String> clientList = ['Expressa', 'PT Cobra Dental Indonesia']; // Daftar client untuk dropdown

  @override
  Widget build(BuildContext context) {
    List? filteredData = cutiData;

    // Jika ada client yang dipilih, filter cutiData sesuai client tersebut
    if (selectedClient != null && selectedClient!.isNotEmpty) {
      filteredData = cutiData
          ?.where((item) => item['client_nama'] == selectedClient)
          .toList();
    }

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Tiket"),
            backgroundColor: Color(0xFF1A73E8),
            foregroundColor: Colors.white,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButton<String>(
                  value: selectedClient,
                  hint: Text("Pilih Client"),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedClient = newValue;
                    });
                  },
                  items: clientList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              filteredData == null
                  ? const Center(child: CircularProgressIndicator())
                  : Expanded(
                child: ListView(
                  children: filteredData!.isEmpty
                      ? [
                          Center(child: Text('Tidak ada tiket untuk client ini'))
                        ]
                      : filteredData!.map((jw) {
                          return TiketCard(komplainData: jw);
                        }).toList(),
                ),
              ),
           

               ],
          ),
        ),
      ),
    );
  }
  //
}
