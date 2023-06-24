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
  List<String> buttons = [];
  List<Offset> buttonPositions = [];
  List<String> textFieldValues = [];
  Map<int, TextStyle> textStyles = {};

  double x1 = 300;
  double y1 = 300;
  double x1prev = 300;
  double y1prev = 300;
  double imageScale = 1.0; // Initial scale factor

  // for another file
  double x2 = 350;
  double y2 = 350;
  double x2prev = 350;
  double y2prev = 350;
  double imageScale2 = 1.0;

  FilePickerResult? result;
  String? fileName;
  PlatformFile? pickedFile;
  bool isloading = false;
  File? fileToDisplay;
  Color? backgroundColor;
  Color? textColor;

  FilePickerResult? result2;
  String? fileName2;
  PlatformFile? pickedFile2;
  bool isloading2 = false;
  File? fileToDisplay2;

  final colorController = TextEditingController();
  final textcolorController = TextEditingController();

  void pickFile() async {
    try {
      result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
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
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  void pickanotherFile() async {
    try {
      result2 = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result2 != null) {
        fileName2 = result2!.files.first.name;
        pickedFile2 = result2!.files.first;

        if (kIsWeb) {
          // Handle web platform
          final fileBytes = result2!.files.first.bytes;
          if (fileBytes != null) {
            fileToDisplay2 = File(
              'data:image/jpeg;base64,${base64Encode(fileBytes)}',
            );
          }
          print(fileName2);
        } else {
          // Handle other platforms
          fileToDisplay2 = File(pickedFile2!.path!);
          print(fileName2);
        }
      }
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  void addButton() {
    setState(() {
      buttons.add('Button ${buttons.length + 1}');
      int centerX = (MediaQuery.of(context).size.width / 2).floor();
      int centerY = (MediaQuery.of(context).size.height / 2).floor();
      buttonPositions.add(Offset(centerX.toDouble(), centerY.toDouble()));
      textFieldValues.add('');
    });
  }

  void changeBackgroundColor() {
    final inputColor = colorController.text;
    setState(() {
      backgroundColor = inputColor.isNotEmpty ? HexColor(inputColor) : null;
    });
  }

  void changeTextColor() {
    final inputColor = textcolorController.text;
    setState(() {
      textColor = inputColor.isNotEmpty ? HexColor(inputColor) : null;
    });
  }

  void changeTextStyle(int index, TextStyle textStyle) {
    setState(() {
      textStyles[index] = textStyle;
    });
  }

  @override
  void dispose() {
    colorController.dispose();
    textcolorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Website Builder'),
        centerTitle: true,
      ),
      body: Container(
        color: backgroundColor,
        child: Center(
          child: Stack(
            children: [
              if (pickedFile != null)
                Positioned(
                  left: x1,
                  top: y1,
                  child: GestureDetector(
                    onPanDown: (d) {
                      x1prev = x1;
                      y1prev = y1;
                    },
                    onPanUpdate: (details) {
                      setState(() {
                        x1 = x1prev + details.localPosition.dx;
                        y1 = y1prev + details.localPosition.dy;
                      });
                    },
                    child: SizedBox(
                      height: 300,
                      width: 300,
                      child: Transform.scale(
                        scale: imageScale,
                        child: kIsWeb
                            ? Image.network(fileToDisplay!.path)
                            : Image.file(fileToDisplay!),
                      ),
                    ),
                  ),
                ),
              if (pickedFile2 != null)
                Positioned(
                  left: x2,
                  top: y2,
                  child: GestureDetector(
                    onPanDown: (d) {
                      x2prev = x2;
                      y2prev = y2;
                    },
                    onPanUpdate: (details) {
                      setState(() {
                        x2 = x2prev + details.localPosition.dx;
                        y2 = y2prev + details.localPosition.dy;
                      });
                    },
                    child: SizedBox(
                      height: 300,
                      width: 300,
                      child: Transform.scale(
                        scale: imageScale2,
                        child: kIsWeb
                            ? Image.network(fileToDisplay2!.path)
                            : Image.file(fileToDisplay2!),
                      ),
                    ),
                  ),
                ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Expanded(
                    child: Stack(
                      children: List.generate(buttons.length, (index) {
                        final textStyle = textStyles[index] ?? TextStyle();

                        return Positioned(
                          left: buttonPositions[index].dx,
                          top: buttonPositions[index].dy,
                          child: Draggable(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0.0),
                              onPressed: () {
                                // Perform action when the dynamically generated button is pressed.
                              },
                              child: Container(
                                width: 300,
                                child: TextField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  controller: TextEditingController(
                                      text: textFieldValues[index]),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  style: textStyle.copyWith(color: textColor),
                                  onChanged: (value) {
                                    textFieldValues[index] = value;
                                  },
                                ),
                              ),
                            ),
                            feedback: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                              ),
                              onPressed: () {},
                              child: Container(
                                width: 300,
                                child: TextField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  controller: TextEditingController(
                                      text: textFieldValues[index]),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  style: textStyle.copyWith(color: textColor),
                                ),
                              ),
                            ),
                            childWhenDragging: Container(),
                            onDraggableCanceled: (velocity, offset) {
                              setState(() {
                                RenderBox stackBox =
                                    context.findRenderObject() as RenderBox;
                                Offset stackOffset =
                                    stackBox.localToGlobal(Offset.zero);
                                Offset relativeOffset = offset - stackOffset;
                                buttonPositions[index] = relativeOffset;
                              });
                            },
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              margin: EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 200, 245, 78),
              ),
              child: Center(
                  child: Text('Select Fields',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                          fontWeight: FontWeight.bold))),
            ),
            TextField(
              controller: colorController,
              decoration: InputDecoration(
                labelText: 'Background Color',
              ),
            ),
            ElevatedButton(
              onPressed: changeBackgroundColor,
              child: Text('Change Background Color'),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: addButton,
              child: Text('Add Item'),
            ),
            SizedBox(height: 15),
            TextField(
              controller: textcolorController,
              decoration: InputDecoration(
                labelText: 'Text Color',
              ),
            ),
            ElevatedButton(
              onPressed: changeTextColor,
              child: Text('Change Text Color'),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: pickFile,
              child: Text('Pick an Image'),
            ),
            SizedBox(height: 15),
            Text('Change Image width and height'),
            SizedBox(height: 15),
            Slider(
              value: imageScale,
              min: 0.5,
              max: 2.0,
              onChanged: (newValue) {
                setState(() {
                  imageScale = newValue;
                });
              },
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: pickanotherFile,
              child: Text('Pick an Logo'),
            ),
            SizedBox(height: 15),
            Text('Change Logo width and height'),
            SizedBox(height: 15),
            Slider(
              value: imageScale2,
              min: -0.5,
              max: 2.0,
              onChanged: (newValue) {
                setState(() {
                  imageScale2 = newValue;
                });
              },
            ),
            Divider(),
            Text(
              'Text Formatting',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: buttons.length,
              itemBuilder: (context, index) {
                final textStyle = textStyles[index] ?? TextStyle();

                return ListTile(
                  title: Text('Item ${index + 1}'),
                  subtitle: Text(
                    'Font Size: ${textStyle.fontSize ?? 14}, '
                    'Bold: ${textStyle.fontWeight == FontWeight.bold}, '
                    'Italic: ${textStyle.fontStyle == FontStyle.italic}',
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => TextFormattingDialog(
                          textStyle: textStyle,
                          onSave: (updatedTextStyle) {
                            changeTextStyle(index, updatedTextStyle);
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HexColor extends Color {
  static const Map<String, int> _colorMap = {
    'black': 0xFF000000,
    'darkGrey': 0xFF444444,
    'grey': 0xFF888888,
    'white': 0xFFFFFFFF,
    'red': 0xFFFF0000,
    'green': 0xFF00FF00,
    'blue': 0xFF0000FF,
    'yellow': 0xFFFFFF00,
    'purple': 0xFF800080,
    'palegreen': 0xff98fb98,
    'salmon': 0xfffa8072,
  };

  static int _getColorFromHex(String color) {
    color = color.toLowerCase();
    if (_colorMap.containsKey(color)) {
      return _colorMap[color]!;
    }

    color = color.replaceAll('#', '');
    if (color.length == 6) {
      color = 'FF$color';
    }
    return int.parse(color, radix: 16);
  }

  HexColor(final String color) : super(_getColorFromHex(color));
}

class TextFormattingDialog extends StatefulWidget {
  final TextStyle textStyle;
  final void Function(TextStyle) onSave;

  const TextFormattingDialog({
    Key? key,
    required this.textStyle,
    required this.onSave,
  }) : super(key: key);

  @override
  _TextFormattingDialogState createState() => _TextFormattingDialogState();
}

class _TextFormattingDialogState extends State<TextFormattingDialog> {
  bool isBold = false;
  bool isItalic = false;
  double fontSize = 14.0;

  @override
  void initState() {
    super.initState();
    final initialTextStyle = widget.textStyle;
    isBold = initialTextStyle.fontWeight == FontWeight.bold;
    isItalic = initialTextStyle.fontStyle == FontStyle.italic;
    fontSize = initialTextStyle.fontSize ?? 14.0;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Text Formatting'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CheckboxListTile(
            title: Text('Bold'),
            value: isBold,
            onChanged: (value) {
              setState(() {
                isBold = value ?? false;
              });
            },
          ),
          CheckboxListTile(
            title: Text('Italic'),
            value: isItalic,
            onChanged: (value) {
              setState(() {
                isItalic = value ?? false;
              });
            },
          ),
          Slider(
            value: fontSize,
            min: 10.0,
            max: 30.0,
            divisions: 20,
            onChanged: (value) {
              setState(() {
                fontSize = value;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            final updatedTextStyle = TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
              fontSize: fontSize,
            );
            widget.onSave(updatedTextStyle);
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
