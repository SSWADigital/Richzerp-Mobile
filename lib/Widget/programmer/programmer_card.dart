import 'package:flutter/material.dart';
import 'package:gocrane_v3/Widget/tiket/tiket_detail.dart';
class ProgrammerCard extends StatelessWidget {
  final Map komplainData;

  // Constructor untuk menerima data komplain
  ProgrammerCard({required this.komplainData});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama Pegawai: ${komplainData['pegawai_nama']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          SizedBox(height: 8),
            Text(
              'Project: ${komplainData['project_nama']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Tasklist: ${komplainData['tasklist_nama']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Start Time: ${komplainData['tasklist_start_real']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Durasi: ${komplainData['tasklist_durasi_jam']} Jam',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Selisih: ${komplainData['selisih']} Jam',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Status: ${komplainData['status']}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}