import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:gocrane_v3/Widget/Alert.dart';
import 'package:gocrane_v3/main.dart';

import 'package:gocrane_v3/tampilan/tab/cameraAbsen.dart';
import 'package:gocrane_v3/tampilan/tab/beranda.dart';
import 'package:gocrane_v3/tampilan/tab/pengajuan/informasi.dart';
import 'package:gocrane_v3/theme_manager.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';



String? poliid;
String? id_dep;
String? kode_reservasi;
String? namapoli;
String? tglbooking;
String? nama_dokter;
String? id_dokter;
String? id_jam;

// ignore: must_be_immutable
class approvallemburPage extends StatefulWidget {
  @override
  _approvallemburPageState createState() => _approvallemburPageState();
}

class _approvallemburPageState extends State<approvallemburPage> {

        List<Color> theme = [Colors.grey, Colors.black];
  Color themeSingle = Colors.grey;

final Map<String, List<Color>> departmentColors = {
  "1": [const Color(0xFF0000FF), const Color(0xFF87CEFA)], 
  "01": [const Color(0xFF11A211), const Color(0xFF32CD32)],
  "03": [const Color(0xFFFFD700), const Color(0xFFFFC125)],
  "04": [const Color(0xFFFF0000), const Color(0xFFFFA07A)],
};

final Map<String, Color> singleColors = {
  "1": const Color(0xFF0000FF), 
  "01": const Color(0xFF0D7F0D),
  "03": const Color(0xFFFFD700),
  "04": const Color(0xFFFF0000),
};

Future<void> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    String? idDep = prefs.get('departemen_id') as String?;

    if (idDep != null) {
      await ThemeManager().fetchColorConfiguration(idDep);
    }
  }


var idDep = "0";

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
    setState(() {
      
    });
}

String selectedStatus = 'Semua';

// Fungsi untuk memfilter data lembur berdasarkan status
void filterlembur(String selectedStatus) async{
    await ambildata();
   switch (selectedStatus) {
      case 'Disetujui':
        selectedStatus = 'p';
        break;
      case 'Ditolak':
        selectedStatus = 'x';
        break;
      case 'Menunggu':
        selectedStatus = 'n';
        break;
      default:
        selectedStatus = 'Semua';
    }
  List? filteredJadwal;

   
  if (selectedStatus == 'Semua') {
    // print("Selected Status: $selectedStatus");
    filteredJadwal = jadwal;
  } else {
    print("Selected Status: $selectedStatus");
    
    filteredJadwal = jadwal?.where((item) {
      return item['lembur_status'] == selectedStatus; 
    }).toList();
  }

  setState(() {
    jadwal = filteredJadwal;
  });
}

void _filterApprovallembur() {
  if (selectedDateRange != null) {
    List? filteredJadwal = jadwal?.where((item) {
      DateTime lembur = DateTime.parse(item['lembur_tgl']);
      // DateTime lemburSelesai = DateTime.parse(item['lembur_tgl']);
      return lembur.isAfter(selectedDateRange!.start.subtract(Duration(days: 1))) && lembur.isBefore(selectedDateRange!.end.add(Duration(days: 1)));
    }).toList();

    setState(() {
      jadwal = filteredJadwal;
    });
  }
}

Widget statuslembur(String status) {
return Container(
  decoration: BoxDecoration(
    color: status == "p" ? Colors.green : status == "n" ? Colors.orange : Colors.red,
    borderRadius: BorderRadius.circular(5),
  ),
  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  child: Text(
    status == "p" ? "Disetujui" : status == "n" ? "Menunggu" : "Ditolak",
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),
);
}

  var tgl_awal_ymd;
  var tgl_akhir_ymd;
  String?
      selectedStartTime; // Variabel untuk menyimpan nilai terpilih dari dropdown jam awal
  String? selectedEndTime;
  String? dp_id;
  String? bagian_jenis;
  String? alber_jenis;
  String? user_nama;
  String? shift_awal;
  String? shift_akhir;
  TextEditingController tanggalawal = TextEditingController();
  TextEditingController tanggalakhir = TextEditingController();
  TextEditingController jamawal = TextEditingController();
  TextEditingController jamakhir = TextEditingController();
  TextEditingController jenisalber = TextEditingController();
  TextEditingController departemen = TextEditingController();
  TextEditingController bagian = TextEditingController();
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
  String? jenis;
  List? jadwal;
  Future ambildata() async {
    final prefs = await SharedPreferences.getInstance();

    var id_user = (prefs.get('pegawai_id'));
    // var id_dep = (prefs.get('departemen_id'));
    final Response = await http.get(
      Uri.parse("${url}/${urlSubAPI}/lembur/getlemburHistoryByIdDep/$idDep"),
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
            jadwal = _data;
            print(jadwal);
          });
        }
      });
    }
  }

 DateTimeRange? selectedDateRange;

  // Fungsi untuk memilih rentang tanggal
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange: selectedDateRange,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: ThemeManager().themeSingle,
            hintColor: ThemeManager().themeSingle,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDateRange) {
      setState(() {
        selectedDateRange = picked;
      });
    }
  }

// Variabel untuk menyimpan nilai terpilih dari dropdown jam akhir

  List? startTimeList;
  List? endTimeList;

  String formatDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    String formattedDate =
        DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(date);
    return formattedDate;
  }


  int _calculateTotalDays(String startDate, String endDate) {
    DateTime startDateTime = DateTime.parse(startDate);
    DateTime endDateTime = DateTime.parse(endDate);
    Duration difference = endDateTime.difference(startDateTime);
    return difference.inDays +
        1; // Menambahkan 1 karena ingin memasukkan hari terakhir
  }

  MediaQueryData? queryData;
  @override
  void initState() {
    getTheme();
    get();
    ambildata();
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
                          child: Text(
                            "Approval lembur",
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

                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView(
  children: [
Column(
  children: [
    // Filter Status
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Agar elemen diatur dari kiri
        crossAxisAlignment: CrossAxisAlignment.center, // Menjaga elemen sejajar secara vertikal
        children: [
          // Dropdown Status
          Container(
            width: 120, // Menetapkan lebar tetap untuk dropdown agar seragam
            child: DropdownButton<String>(
              value: selectedStatus,  // Nilai yang dipilih
              onChanged: (String? newValue) {
                setState(() {
                  selectedStatus = newValue!;
                  filterlembur(selectedStatus);
                });
              },
              isExpanded: true, // Agar dropdown mengisi seluruh lebar yang tersedia
              items: <String>['Semua', 'Disetujui', 'Ditolak', 'Menunggu']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),

          SizedBox(width: 10),

          // Filter Tanggal Mulai
          Flexible(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () => _selectDateRange(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade400, width: 1),
                      ),
                      child: Text(
                        selectedDateRange == null
                            ? 'Pilih Tanggal'
                            : '${selectedDateRange!.start.toLocal()} - ${selectedDateRange!.end.toLocal()}'.split(' ')[0],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),

          SizedBox(width: 10),

          // Tombol Search dengan ukuran lebih kecil
          ElevatedButton(
            onPressed: () {
              _filterApprovallembur();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeManager().themeSingle,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Ukuran padding lebih kecil
              minimumSize: Size(0, 36), // Ukuran minimum tombol
            ),
            child: Icon(Icons.search, color: Colors.white, size: 20), // Ukuran icon lebih kecil
          ),
        ],
      ),
    ),
  ],
),

Container(
  child: Column(
    children: jadwal == null
        ? []
        : jadwal!.map((jw) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Memberikan warna putih pada container
                  borderRadius: BorderRadius.circular(12), // Menambahkan border-radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Memberikan shadow berwarna putih
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3), // Posisi shadow
                    ),
                  ],
                ),
                margin: const EdgeInsets.symmetric(horizontal: 16), // Margin untuk container
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16), // Padding di dalam container
                      child: ListTile(
                        title: Text(
                          "${jw['user_nama_lengkap']} | ${formatDate(jw['lembur_created'])}",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.07,
                          ),
                        ),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${jw['lembur_tgl'] != null?formatDate(jw['lembur_tgl']) : '-'}",
                              style: TextStyle(
                                fontSize: 14,
                                color: ThemeManager().themeSingle,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.07,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          // Pindah ke halaman detail lembur
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetaillemburPage(jw: jw),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
  top: 5, // Menempatkan status di pojok kiri atas
  right: 5,
  child: Container(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: _getStatusColor(jw['lembur_status']),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Text(
          jw['lembur_status'] == "p"
              ? "Disetujui"
              : jw['lembur_status'] == "n"
                  ? "Menunggu"
                  : "Ditolak",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12, // Ukuran font lebih kecil
          ),
        ),
      ],
    ),
  ),
),

                  ],
                ),
              ),
            );
          }).toList(),
  ),
)




  ],
),

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

Color _getStatusColor(String status) {
  switch (status) {
    case 'p':
      return Colors.green; 
    case 'n':
      return Colors.orange;
    case 'x':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

IconData _getStatusIcon(String status) {
  print("Status: $status");
  switch (status) {
    case 'p':
      return Icons.check; 
    case 'n':
      return Icons.access_time; 
    case 'x':
      return Icons.close; 
    default:
      return Icons.help_outline; 
  }
}

String _getStatusText(String status) {
  switch (status) {
    case 'p':
      return 'Disetujui';
    case 'n':
      return 'Menunggu';
    case 'x':
      return 'Ditolak';
    default:
      return 'Status Tidak Dikenal';
  }
}
  //
}

class DetaillemburPage extends StatelessWidget {
  final Map<String, dynamic> jw; // Menerima data lembur

  // Konstruktor
  DetaillemburPage({required this.jw});

  Widget statuslembur(String status) {
return Container(
  decoration: BoxDecoration(
    color: status == "p" ? Colors.green : status == "n" ? Colors.orange : Colors.red,
    borderRadius: BorderRadius.circular(5),
  ),
  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  child: Text(
    status == "p" ? "Disetujui" : status == "n" ? "Menunggu" : "Ditolak",
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),
);
}


  String formatDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    String formattedDate =
        DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(date);
    return formattedDate;
  }


   _approvelembur(BuildContext context, String keterangan) async {
    // print("APROVE");
    final prefs = await SharedPreferences.getInstance();

    var id_user = (prefs.get('pegawai_id'));

    // print("Keterangan: $keterangan");
    // print("ID lembur: ${jw['lembur_id']}");
    // print("ID User: ${jw['user_id']}");
    // print("ID Dokter: ${jw['dokter_id']}");
    // print("ID Jam: ${jw['jam_id']}");
    // print("Keterangan: $keterangan");

    var data = {
      "lembur_id": jw['lembur_id'],
      "user_id": id_user,
      // "dokter_id": jw['dokter_id'],
      // "jam_id": jw['jam_id'],
      "keterangan": keterangan,
    };

    var jsonData = jsonEncode(data);

    // print("Data: $jsonData");

    http.post(
      Uri.parse("${url}/${urlSubAPI}/lembur/approvelembur"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonData,
    ).then((response) {
      // print("Response: ${response.body}");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'success') {
   
  Navigator.pop(context);
  Navigator.pop(context);
  Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => approvallemburPage()),
);
        ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Lembur berhasil disetujui')),
  );
          // Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menyetujui lembur')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyetujui lembur')),
        );
      }
    }).catchError((error) {
      print("Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyetujui lembur')),
      );
    });
  }
   _rejectlembur(BuildContext context, String keterangan) async {
    final prefs = await SharedPreferences.getInstance();

    var id_user = (prefs.get('pegawai_id'));

    // print("Keterangan: $keterangan");
    // print("ID lembur: ${jw['lembur_id']}");
    // print("ID User: ${jw['user_id']}");
    // print("ID Dokter: ${jw['dokter_id']}");
    // print("ID Jam: ${jw['jam_id']}");
    // print("Keterangan: $keterangan");

    var data = {
      "lembur_id": jw['lembur_id'],
      "user_id": id_user,
      // "dokter_id": jw['dokter_id'],
      // "jam_id": jw['jam_id'],
      "keterangan": keterangan,
    };

    var jsonData = jsonEncode(data);

    print("Data: $jsonData");

    http.post(
  Uri.parse("${url}/${urlSubAPI}/lembur/rejectlembur"),  // Change this line
  headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  },
  body: jsonData,
).then((response) {
  // print("Response: ${response.body}");
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    if (data['status'] == 'success') {
      
      Navigator.pop(context);
  Navigator.pop(context);
  Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => approvallemburPage()),
);
        ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Lembur berhasil ditolak')),
  );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menolak lembur')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gagal menolak lembur')),
    );
  }
}).catchError((error) {
  print("Error: $error");
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Gagal menolak lembur')),
  );
});

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail lembur"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: getStatusColor(jw['lembur_status']),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusText(jw['lembur_status']),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 16),
              detailRow("Nama", jw['user_nama_lengkap']),
              detailRow("Tanggal", "${jw['lembur_tgl'] != null ? formatDate(jw['lembur_tgl']) : '-'}"),
              detailRow("Jam", "${jw['lembur_jam_mulai']} - ${jw['lembur_jam_selesai']}"),
              detailRow("Keterangan", jw['lembur_keterangan'] ?? "-"),
              detailRow("Jenis lembur", jw['jenis_lembur_nama'] ?? "-"),
              detailRow("Keterangan HRD", jw['lembur_keterangan_hrd'] !=null  ? "${jw['lembur_keterangan_hrd']} (${jw['user_hrd']})" : "-"),
              ],
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(context, jw['lembur_status']),
    );
  }

  Widget detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$title:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  String statusText(String? status) {
    switch (status) {
      case "p":
        return "Disetujui";
      case "x":
        return "Ditolak";
      default:
        return "Menunggu";
    }
  }

  Color getStatusColor(String? status) {
    switch (status) {
      case "p":
        return Colors.green;
      case "x":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  Widget buildBottomNavigationBar(BuildContext context, String? status) {
  if (status != "p" && status != "x") {
    return buildApproveRejectButtons(context);
  }

  return SizedBox.shrink();
}


  Widget buildApproveRejectButtons(BuildContext context) {
    return Material(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  showConfirmationDialog(context, "Apakah Anda yakin ingin menyetujui lembur ini?", "p");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.all(16),
                ),
                child: Text("Approve", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  showConfirmationDialog(context, "Apakah Anda yakin ingin menolak lembur ini?", "x");
                  // _rejectlembur(context, keterangan.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.all(16),
                ),
                child: Text("Tolak", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCancelButton(BuildContext context) {
    return Material(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
        child: ElevatedButton(
          onPressed: () {
            // Add cancel logic
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.all(16),
          ),
          child: Text("Batal", style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ),
    );
  }

  void showConfirmationDialog(BuildContext context, String message, String type) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController keterangan = TextEditingController();
        return AlertDialog(
          title: Text("Konfirmasi"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Container(
                          // width: 318,
                          // height: 104,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Color(0xff020438),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            maxLines: 4,
                            controller: keterangan,
                            // Jumlah baris yang ingin ditampilkan
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(8),
                            ),
                          ),
                        ),
                      ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Batal"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                if (type == "p") {
                  await _approvelembur(context, keterangan.text);
                } else {
                  await _rejectlembur(context, keterangan.text);
                }
                // await _approvelembur(context, keterangan.text);
              },
              child: Text("Ya"),
            ),
          ],
        );
      },
    );
  }
  }
