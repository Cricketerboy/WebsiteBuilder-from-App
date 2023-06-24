import 'package:flutter/material.dart';

class DraggableWidget extends StatefulWidget {
  @override
  _DraggableWidgetState createState() => _DraggableWidgetState();
}

class _DraggableWidgetState extends State<DraggableWidget> {
  List<Widget> widgets = [];

  void addWidget() {
    setState(() {
      widgets.add(
        Draggable(
          feedback: TextFormField(
            decoration: InputDecoration(
              labelText: 'Draggable Widget',
            ),
          ),
          childWhenDragging: Container(),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Draggable Widget',
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Draggable Widget Example'),
      ),
      body: Stack(
        children: [
          ...widgets,
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: addWidget,
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
