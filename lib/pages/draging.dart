import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Drag extends StatefulWidget {
  const Drag({Key? key}) : super(key: key);

  @override
  State<Drag> createState() => _DragState();
}

class _DragState extends State<Drag> {
  FilePickerResult? result;
  String? fileName;
  PlatformFile? pickedFile;
  bool isloading = false;
  File? fileToDisplay;

  void pickFile() async {
    try {
      setState(() {
        isloading = true;
      });
      result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null) {
        fileName = result!.files.first.name;
        pickedFile = result!.files.first;

        if (kIsWeb) {
          // Handle web platform
          final fileBytes = result!.files.first.bytes;
          if (fileBytes != null) {
            fileToDisplay = File(
              'data:image/jpeg;base64,${base64Encode(fileBytes)}',
            );
          }
          print(fileName);
        } else {
          // Handle other platforms
          fileToDisplay = File(pickedFile!.path!);
          print(fileName);
        }
      }
      setState(() {
        isloading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  double x1 = 100.0,
      x2 = 200.0,
      x3 = 250.0,
      x4 = 300.0,
      y1 = 100.0,
      y2 = 200.0,
      y3 = 250.0,
      y4 = 300.0,
      x1Prev = 100.0,
      x2Prev = 200.0,
      x3Prev = 250.0,
      x4Prev = 300.0,
      y1Prev = 100.0,
      y2Prev = 100.0,
      y3Prev = 250.0,
      y4Prev = 300.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Drag widget on screen'),
      ),
      body: Stack(
        children: [
          Positioned(
            left: x1,
            top: y1,
            child: GestureDetector(
              onPanDown: (d) {
                x1Prev = x1;
                y1Prev = y1;
              },
              onPanUpdate: (details) {
                setState(() {
                  x1 = x1Prev + details.localPosition.dx;
                  y1 = y1Prev + details.localPosition.dy;
                });
              },
              child: ElevatedButton(
                onPressed: () {},
                child: Container(
                  width: 64,
                  height: 64,
                  color: Colors.amber,
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: x2,
            top: y2,
            child: GestureDetector(
              onPanDown: (d) {
                x2Prev = x2;
                y2Prev = y2;
              },
              onPanUpdate: (details) {
                setState(() {
                  x2 = x2Prev + details.localPosition.dx;
                  y2 = y2Prev + details.localPosition.dy;
                });
              },
              child: Container(
                width: 64,
                height: 64,
                color: Colors.red,
              ),
            ),
          ),
          Positioned(
            left: x3,
            top: y3,
            child: GestureDetector(
              onPanDown: (d) {
                x3Prev = x3;
                y3Prev = y3;
              },
              onPanUpdate: (details) {
                setState(() {
                  x3 = x3Prev + details.localPosition.dx;
                  y3 = y3Prev + details.localPosition.dy;
                });
              },
              child: isloading
                  ? CircularProgressIndicator()
                  : TextButton(
                      onPressed: () {
                        pickFile();
                      },
                      child: Text('Pick File'),
                    ),
            ),
          ),
          if (pickedFile != null)
            Positioned(
              left: x4,
              top: y4,
              child: GestureDetector(
                onPanDown: (d) {
                  x4Prev = x4;
                  y4Prev = y4;
                },
                onPanUpdate: (details) {
                  setState(() {
                    x4 = x4Prev + details.localPosition.dx;
                    y4 = y4Prev + details.localPosition.dy;
                  });
                },
                child: SizedBox(
                  height: 300,
                  width: 300,
                  child: kIsWeb
                      ? Image.network(fileToDisplay!.path)
                      : Image.file(fileToDisplay!),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
