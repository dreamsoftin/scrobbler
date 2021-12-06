import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:scrobbler/scrobbler.dart';
import 'package:scrobbler_example/view.dart';

Future<void> main() async {
  // await Hive.initFlutter();
  await LocalStorage.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  Box? hiveBox;
  // @override
  // void initState() {
  //   super.initState();
  //   initPlatformState();
  //   Scrobbler.initialize();

  // bool isregistered =   IsolateNameServer.registerPortWithName(receivePort.sendPort, "data_reciver");
  
  //   if(isregistered){
  //     log("APP: Port Registred");
  //   }
  //   else{
  //   IsolateNameServer.removePortNameMapping("data_reciver");

  //     log("APP:Failed to  Port Registred");
      
  //   }
  // }



  // @override
  // void dispose() {
  //   IsolateNameServer.removePortNameMapping("data_reciver");
  //     log("APP:Unregistering Port.");

  //   receivePort.close();
  //   super.dispose();
  // }
  // ReceivePort receivePort = ReceivePort("data_reciver");

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = "";
      hiveBox = await LocalStorage.instance
          .openScrobblerBox(); //await Hive.openBox("scrobbled");

      // (await Scrobbler.canStart()).toString() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  String text = "";
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PortDataView()
      
    );
  }
}

Future<void> onScrobblerEvent(ScrobblerEvent event) async {
  print("onScrobblerEvent: " + event.event);

  //  Hive.init(path);
  // await Hive.initFlutter();
  await LocalStorage.instance.init();

  var box = await LocalStorage.instance
      .openScrobblerBox(); //await Hive.openBox('scrobbled');

  String previous = box.get("event", defaultValue: "");
  box.put("event", "\n${DateTime.now()} " + event.toString()+previous);
  // log("onScrobblerEvent: Stored. data is: " +
  //     box.get("event", defaultValue: "--"));

  final sendPort = IsolateNameServer.lookupPortByName("data_reciver");
  if(sendPort == null) return;
  print("onScrobblerEvent: Sendport is Available for data_reciver");
  sendPort.send(box.get("event", defaultValue: "--"));
  print("onScrobblerEvent: Send to data_reciver");

  box.put("event", "");
}

class LocalStorage {
  static LocalStorage instance = LocalStorage._();
  LocalStorage._();
  bool isInitialized = false;
  init() async {
    if (isInitialized) return;
    await Hive.initFlutter();
    isInitialized = true;
  }

  // Box? box;

  Future<Box> openScrobblerBox() async {
    if (!Hive.isBoxOpen("Scrobbler")) {
      await Hive.openBox("Scrobbler");
    }
    return Hive.box("Scrobbler");
  }
}

class IsolatedDB{
  ReceivePort receivePort = ReceivePort("");
  static spawn() async{

  }
}