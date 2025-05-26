import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR-Code scannen')),
      body: MobileScanner(
        // Nur ein Parameter im Callback!
        onDetect: (capture) {
          // capture.barcodes ist eine Liste (normalerweise mit nur einem Barcode)
          final barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final String? code = barcodes.first.rawValue;
            if (code != null && code.isNotEmpty) {
              Navigator.of(context).pop(code);
            }
          }
        },
      ),
    );
  }
}
