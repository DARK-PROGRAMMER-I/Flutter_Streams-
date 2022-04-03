import 'package:flutter/material.dart';
import 'package:stream_demo/stream.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamHomePage(),
    );
  }
}

class StreamHomePage extends StatefulWidget {
  const StreamHomePage({Key? key}) : super(key: key);

  @override
  _StreamhomePageState createState() => _StreamhomePageState();
}

class _StreamhomePageState extends State<StreamHomePage> {
  Color? bgColor;
  ColorStream? colorStream;

  @override
  void initState(){
    colorStream = ColorStream();
    changeColor();
    super.initState();
  }
  @override
  void dispose(){
    changeColor();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stream Demo"),
        backgroundColor: bgColor,
      ),
      body: Container(
        color: bgColor,
      ),
    );
  }

  changeColor()async{
    colorStream?.getColors().listen((Color color) {
      setState(() {
        bgColor = color;
      });
    });

  }

}

