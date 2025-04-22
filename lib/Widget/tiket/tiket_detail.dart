import 'package:flutter/material.dart';

class TiketDetailCard extends StatelessWidget {
  final Map<String, dynamic> tiketData;

  TiketDetailCard({required this.tiketData});

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tiket"),
        backgroundColor: Color(0xFF1A73E8),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          margin: EdgeInsets.zero,  // Menghilangkan margin ekstra pada card
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tiket No
                _buildTiketDetailRow(
                  label: 'Tiket No',
                  value: tiketData['komplain_no'],
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                const SizedBox(height: 8),

                // Subject
                _buildTiketDetailRow(
                  label: 'Subject',
                  value: tiketData['komplain_subject'],
                  fontSize: 16,
                ),
                const SizedBox(height: 8),

                // Keterangan
                _buildTiketDetailRow(
                  label: 'Keterangan',
                  value: tiketData['komplain_keterangan'] ?? '-',
                  fontSize: 16,
                ),
                const SizedBox(height: 8),

                // Tanggal
                _buildTiketDetailRow(
                  label: 'Tanggal',
                  value: tiketData['komplain_when_create'],
                  fontSize: 16,
                ),
                const SizedBox(height: 16),

                // File
                _buildTiketDetailRow(
                  label: 'File',
                  value: tiketData['file'] ?? 'N/A',
                  fontSize: 16,
                ),
                const SizedBox(height: 8),

                // User
                _buildTiketDetailRow(
                  label: 'User',
                  value: tiketData['usr_name'],
                  fontSize: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTiketDetailRow({
    required String label,
    required String? value,
    FontWeight fontWeight = FontWeight.normal,
    double fontSize = 16,
  }) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            value ?? 'N/A',  // Default to 'N/A' if value is null
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
