import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:scrobbler_example/view.dart';

Future<void> main() async {
  // await Hive.initFlutter();
  await AppDatabase.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  String _platformVersion = 'Unknown';
  Box? hiveBox;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: PortDataView());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    AppDatabase.instance.didChangeAppLifecycleState(state);
  }
}

class AppDatabase {
  static AppDatabase instance = AppDatabase._();
  AppDatabase._();
  bool isInitialized = false;
  Box? box;
  ReceivePort receivePort = ReceivePort("data_reciver");

  void _registerPort() {
    receivePort = ReceivePort("data_reciver");

    bool isregistered = IsolateNameServer.registerPortWithName(
      receivePort.sendPort,
      "data_reciver",
    );

    if (isregistered) {
      receivePort.listen((data) {
        writeIntoBox(data as Map);
      });

      log("APP: Port Registred");
      final sendPort =  IsolateNameServer.lookupPortByName("background_thread");
      sendPort?.send("sync");
    } else {
      IsolateNameServer.removePortNameMapping("data_reciver");
      return _registerPort();
      // log("APP:Failed to  Port Registred");
    }
  }

  void unregisterPort() {
    IsolateNameServer.removePortNameMapping("data_reciver");
    log("APP:Unregistering Port.");

    receivePort.close();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    log("APP:didChangeAppLifecycleState.");
    switch (state) {
      case AppLifecycleState.resumed:
        _registerPort();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        unregisterPort();
        break;
    }
  }

  init() async {
    if (isInitialized) return;
    await Hive.initFlutter();
    _registerPort();
    box = await openScrobblerBox();

    isInitialized = true;
  }

  StreamController streamController = StreamController<String>.broadcast();

  // Box? box;

  Future<Box> openScrobblerBox() async {
    if (!Hive.isBoxOpen("app_box")) {
      await Hive.openBox("app_box");
    }
    var box = Hive.box("app_box");
    box.watch().listen((event) {
      streamController.add(box.toMap().values.length.toString());
    });
    return box;
  }

  Future<void> writeIntoBox(Map<dynamic,dynamic> scrobbled) async {
    if(scrobbled.isEmpty) return;
    box ??= await openScrobblerBox();
    // String? previous = box!.get("event");
    box!.putAll(scrobbled);
  }
}
