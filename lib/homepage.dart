import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:wmt_ebook_reader/files_repository.dart';
import 'package:wmt_ebook_reader/reader_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var filesRepo = FilesRepository();
  var filesAccessed = <String>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DOC READER"),
      ),
      body: FutureBuilder(
        future: filesRepo.getFiles(),
        builder: (context, snapshot){
          if(snapshot.data == null) {
            return CircularProgressIndicator();
          }

          //assign the data to list of files accessed
          filesAccessed = snapshot.data as List<String>;
          return ListView.builder(
              itemCount: filesAccessed.length,
              itemBuilder: (context, index){
                var path = filesAccessed[index];
                return Dismissible(
                  key: Key(path),
                  child: Card(
                    child: GestureDetector(
                      onTap: (){
                        openReaderPage(context, File(path));
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          "${path.split("/").last}",//this gets the filename
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ),
                  ),
                  onDismissed: (dismissDirection){
                    filesAccessed.remove(path);
                    filesRepo.removeFile(path);
                    setState((){});
                  },
                );
              }
          );
        },
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
      String path = result.files.first.path!;
      File docFile = File(path);


      //navigate to ReaderPage
      openReaderPage(context, docFile);

      setState((){
        //add to file accessed list
        filesAccessed.add(path);
        //save to storage
        filesRepo.saveFiles(filesAccessed);
      });
    }else{
      //user cancelled the selection process
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("File Selection Cancelled"),
        )
      );
    }
  }

  void openReaderPage(BuildContext context, File docFile) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=>ReaderPage(document: docFile,))
    );
  }
}
