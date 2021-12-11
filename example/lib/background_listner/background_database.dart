import 'dart:isolate';
import 'dart:ui';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:scrobbler/scrobbler.dart';

///
/// [IsolateStorage] handels the storage and sync in background thread.
///
///
class IsolateStorage {
  static IsolateStorage instance = IsolateStorage._();
  IsolateStorage._();

  bool isInitialized = false;

  ReceivePort _receivePort = ReceivePort("background_thread");

  init() async {
    if (isInitialized) return;
    await Hive.initFlutter();
closeAndRepoenPort();
    isInitialized = true;
  }

  void closeAndRepoenPort() {
    final sendPort = IsolateNameServer.lookupPortByName("background_thread");
    if (sendPort != null) {
      IsolateNameServer.removePortNameMapping("background_thread");
    }
 _receivePort = ReceivePort("background_thread");

    IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, "background_thread");

    _receivePort.listen((message) {
      syncData();
    });
  }

  ///
  /// Adds new Data to storage.
  /// if `data_reciver` isolate is registered then it will sync the data with the same.
  ///
  Future<void> writeAndSyncData(ScrobblerEvent event) async {
    await writeData(event);
    await syncData();
  }

  ///
  /// Stores lates event with timestamp.
  ///
  Future<void> writeData(ScrobblerEvent event) async {
    final box = await openScrobblerBox();
    await box.put(DateTime.now().toIso8601String(), event.toMap());
  }

  ///
  ///
  /// Checks for the isolate with port name `data_reciver`.
  /// If found Sends all collected data as map to `data_reciver` port and cleares storage of background thread.
  ///
  ///
  Future<void> syncData() async {
    final sendPort = IsolateNameServer.lookupPortByName("data_reciver");

    if (sendPort == null) return;
    print("onScrobblerEvent: Sendport is Available for data_reciver");
    final box = await openScrobblerBox();
    var message = box.toMap();
    sendPort.send(message);
    box.clear();
  }

  Future<Box> openScrobblerBox() async {
    if (!Hive.isBoxOpen("Scrobbler")) {
      await Hive.openBox("Scrobbler");
    }
    return Hive.box("Scrobbler");
  }
}
