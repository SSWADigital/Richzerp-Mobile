import 'package:flutter/material.dart';
import 'package:gocrane_v3/Widget/tiket/tiket_detail.dart';

class TiketCard extends StatelessWidget {
  final Map<String, dynamic> komplainData;

  TiketCard({required this.komplainData});

  String getTimeAgo(String dateTimeString) {
    DateTime createdTime = DateTime.parse(dateTimeString);
    Duration difference = DateTime.now().difference(createdTime);

    int days = difference.inDays;
    int hours = difference.inHours % 24; // Jam yang tersisa setelah menghitung hari
    int minutes = difference.inMinutes % 60; // Menit yang tersisa setelah menghitung jam

    return '$days hari, $hours jam, $minutes menit';
  }

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
              'Komplain NO: ${komplainData['komplain_no']}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Komplain Urgensi: ${komplainData['komplain_urgensi'] ?? '-'}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Project: ${komplainData['project_nama'] ?? 'N/A'}'),
            Text('Client: ${komplainData['client_nama'] ?? 'N/A'}'),
            SizedBox(height: 8),
            Text('Subject: ${komplainData['komplain_subject'] ?? 'N/A'}'),
            SizedBox(height: 8),
            // Text('Status: ${komplainData['komplain_status']}'),
            // SizedBox(height: 8),
            Text('Created By: ${komplainData['usr_name']}'),
            SizedBox(height: 8),
            Text('Created On: ${komplainData['komplain_when_create']}'),
            SizedBox(height: 8),
             SizedBox(height: 8),
            komplainData['komplain_status'] == 'n' ?
            Text(
              'Lama di Antrian: ${getTimeAgo(komplainData['komplain_when_create'])}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ) : komplainData['komplain_status'] == 'd' ? 
            Text(
              'Lama Mengerjakan: ${getTimeAgo(komplainData['komplain_when_create'])}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ) : SizedBox(),
            Text('Category: ${komplainData['komplain_kategori_nama'] ?? 'N/A'}'),
            SizedBox(height: 8),
            Text('Module: ${komplainData['modul_nama'] ?? 'N/A'}'),
            SizedBox(height: 8),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TiketDetailCard(tiketData: komplainData)));
            }, 
            child: Text('Detail'), 
            )
          ],
        ),
      ),
    );
  }
}