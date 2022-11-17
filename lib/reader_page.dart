import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';

///Responsible for opening the PDF file
class ReaderPage extends StatefulWidget {
  const ReaderPage({Key? key, required this.document}) : super(key: key);

  final File document;

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  late PDFDocument doc;
  var isLoading = false;

  @override
  void initState() {
    super.initState();

    PDFDocument.fromFile(widget.document).then((pdfDoc){
      setState((){
        isLoading = true;
        doc = pdfDoc;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: isLoading
            ? PDFViewer(document: doc)
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
