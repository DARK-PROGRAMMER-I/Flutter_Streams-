import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stream_demo/stream.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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

  // Portion for Random Number
  int? newNumber;
  StreamController? numStreamController;
  NumberStream? numberStream;

  // Stream Tranformers
  final transformer = StreamTransformer<int, dynamic>.fromHandlers(
      handleData: (value, sink) {
        // final abc= value as int;
        sink.add(value * 10);
  },
      handleError: (error, trace, sink){
        sink.add(-1);
  },
      handleDone: (sink) => sink.close()
      );
  @override
  void initState(){
    // Commenting old Code
    colorStream = ColorStream();
    changeColor();

    // Code for number generator
    numberStream = NumberStream();
    numStreamController = numberStream?.controller;
    Stream stream = numStreamController!.stream;
    stream.transform(transformer).listen((event) {
      setState(() {
        newNumber = event;
      });
    }).onError((error){
      setState(() {
        newNumber = -1;
      });
    });
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
      body: SafeArea(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("$newNumber",style: TextStyle(fontSize: 18)),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(bgColor)
                  ),
                    onPressed: (){
                      random();
                    },
                    child: Text("Generate new ->", style: TextStyle(fontSize: 18),))
              ],
            ),
        ),
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

  // Generate Random Number
  random(){
    Random random = Random();
    int randomNum = random.nextInt(10);
    numberStream?.addNumberToSink(randomNum);
    // numberStream?.addError();
  }

}

