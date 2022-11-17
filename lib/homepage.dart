import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:wmt_ebook_reader/reader_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DOC READER"),
      ),
      body: Container(
        child: ListView(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.folder_open),
        onPressed: () async {
          await _selectFile(context);
        },
      ),
    );
  }

  Future<void> _selectFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowedExtensions: ["pdf"],
        type: FileType.custom
    );
    if(result != null){
      //the user selected a file
      //create file instance
      File docFile = File(result.files.first.path!);

      //navigate to ReaderPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=>ReaderPage(document: docFile,))
      );
    }else{
      //user cancelled the selection process
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("File Selection Cancelled"),
        )
      );
    }
  }
}
