import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

///Responsible for opening the PDF file
class ReaderPage extends StatefulWidget {
  const ReaderPage({Key? key, required this.document}) : super(key: key);

  final File document;

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: PdfView(
          controller: PdfController(
            document: PdfDocument.openFile(widget.document.path)
          )
        ),
      ),
    );
  }
}
