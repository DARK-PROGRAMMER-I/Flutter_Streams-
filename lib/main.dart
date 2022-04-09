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
  // Stream Subscription
  StreamSubscription? subscription;
  StreamSubscription? subscription2;
  String values = '';
  Color? bgColor;
  ColorStream? colorStream;

  // Portion for Random Number
  int? newNumber;
  StreamController? numStreamController;
  NumberStream? numberStream;

  // Stream Tranformers
  // final transformer = StreamTransformer<int, dynamic>.fromHandlers(
  //     handleData: (value, sink) {
  //       // final abc= value as int;
  //       sink.add(value * 10);
  // },
  //     handleError: (error, trace, sink){
  //       sink.add(-1);
  // },
  //     handleDone: (sink) => sink.close()
  //     );
  @override
  void initState(){
    // Commenting old Code
    colorStream = ColorStream();
    changeColor();

    // Code for number generator
    numberStream = NumberStream();
    numStreamController = numberStream?.controller;
    Stream stream = numStreamController!.stream.asBroadcastStream();
    subscription = stream.listen((event) {
      setState(() {
        values += event.toString() + '-';
      });
    });
    subscription2 = stream.listen((event) {
      setState(() {
        values += event.toString() + "-";
      });
    });

    subscription?.onError((e){
      setState(() {
        newNumber = -1;
      });
    });
    subscription?.onDone(() {
      print("OnDone Method was called");

    });
    super.initState();
  }
  void closeStream(){
    numStreamController?.close();
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("$values",style: TextStyle(fontSize: 18)),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(bgColor)
                  ),
                    onPressed: (){
                      random();
                    },
                    child: Text("Generate Random Number", style: TextStyle(fontSize: 18),)),
                SizedBox(height: 20,),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(bgColor)
                    ),
                    onPressed: (){
                      closeStream();
                    },
                    child: Text("Stop Stream", style: TextStyle(fontSize: 18),))
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
    if(!numStreamController!.isClosed){
      numberStream?.addNumberToSink(randomNum);
    }else{
      setState(() {
        newNumber = -1;
      });
    }
    // numberStream?.addError();
  }

}

