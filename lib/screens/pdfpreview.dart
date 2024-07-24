import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:convert';

class PdfPreviewPage extends StatelessWidget {
  String _notesheet;
  late final Map<String, dynamic> data;

  PdfPreviewPage(this._notesheet, {Key? key}) : super(key: key) {
    data = jsonDecode(_notesheet) as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PdfPreview(
        build: (context) => makePdf(),
      ),
    );
  }

  Future<Uint8List> makePdf() async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
        margin: const pw.EdgeInsets.all(10),
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Header(text: data['title'] ?? 'No Title', level: 1),
                    ]),
                pw.Divider(borderStyle: pw.BorderStyle.dashed),
                pw.Paragraph(text: data['summary'] ?? 'No Content'),
                pw.Divider(borderStyle: pw.BorderStyle.dashed),
                ...(data['notes'] as List<dynamic>? ?? [])
                    .expand((item) => [
                          pw.Header(text: item[0] as String, level: 2),
                          pw.Paragraph(text: item[1] as String),
                          pw.SizedBox(height: 10),
                        ])
                    .toList(),
              ]);
        }));
    return pdf.save();
  }
}
