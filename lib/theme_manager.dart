import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ThemeManager {
  static final ThemeManager _instance = ThemeManager._internal();

  factory ThemeManager() {
    return _instance;
  }

  ThemeManager._internal();

  // The theme list (gradient colors)
  List<Color> theme = [Colors.blue, Colors.lightBlue];

  // The single theme color
  Color themeSingle = Colors.blue;

  // Fetch color configuration from the server
  Future<void> fetchColorConfiguration(String idDep) async {
    final response = await http.get(Uri.parse("http://103.157.97.152/richzspot/konfigurasi/getColor/$idDep"));
    var color = jsonDecode(response.body);
    
    if (color.isNotEmpty) {
      for (var item in color) {
        if (item['nama_konfigurasi'] == 'Warna Gradasi' && item['konfigurasi_value'] != null) {
          List<String> colorStrings = item['konfigurasi_value'].split(',');
          theme = colorStrings.map((color) => Color(int.parse(color.trim()))).toList();
        }

        if (item['nama_konfigurasi'] == 'Warna Tunggal' && item['konfigurasi_value'] != null) {
          themeSingle = Color(int.parse(item['konfigurasi_value'].trim()));
    print("COLOR: $themeSingle");
        }
      }
    }
  }
}
