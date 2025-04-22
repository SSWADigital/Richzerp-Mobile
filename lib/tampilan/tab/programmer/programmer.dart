import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gocrane_v3/Widget/Alert.dart';
import 'package:gocrane_v3/Widget/programmer/programmer_card.dart';
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
class ProgrammerPage extends StatefulWidget {
  var data;
  ProgrammerPage({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  _ProgrammerPageState createState() => _ProgrammerPageState();
}

class _ProgrammerPageState extends State<ProgrammerPage> {
  DateTime currentDate = DateTime.now();
  var dateVal;
  var now = DateTime.now();
  
  String? selectedClient;
  List<String> clientList = ['Expressa', 'PT Cobra Dental Indonesia']; // Daftar client untuk dropdown
  
  @override
  Widget build(BuildContext context) {
    // Assuming 'data' is a list of items to be displayed
    List? filteredData = widget.data;

    // If a client is selected, filter the data
    if (selectedClient != null && selectedClient!.isNotEmpty) {
      filteredData = widget.data
          ?.where((item) => item['client_nama'] == selectedClient)
          .toList();
    }

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Programmer Belum Memulai"),
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
              Expanded(
                child: ListView(
                  children: filteredData!.isEmpty
                      ? [
                          Center(child: Text('Tidak ada tiket untuk client ini'))
                        ]
                      : filteredData!.map((jw) {
                          return ProgrammerCard(komplainData: jw);
                        }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
