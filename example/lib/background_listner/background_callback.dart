
import 'dart:ui';

import 'package:scrobbler/scrobbler.dart';

import 'background_database.dart';

Future<void> onScrobblerEvent(ScrobblerEvent event) async {

  ///
  /// Recieve Scrobbler Event.
  ///
  print("onScrobblerEvent: " + event.event);

  ///
  /// Initialize Isolated Storage
  ///
  await IsolateStorage.instance.init();
  await IsolateStorage.instance.writeAndSyncData(event);

  // var box = await IsolateStorage.instance
  //     .openScrobblerBox(); 

  // ///
  // /// Update the Stored Data.
  // ///
  // String previous = box.get("event", defaultValue: "");
  // box.put("event", "\n${DateTime.now()} " + event.toString()+previous);


  // // print("onScrobblerEvent: Stored. data is: " +
  // //     box.get("event", defaultValue: "--"));

  // if(event.event != "metadata_change") return;
  
  // ///
  // /// Check whether App is Registred for Foreground Event.
  // ///
  // final sendPort = IsolateNameServer.lookupPortByName("data_reciver");

  // if(sendPort == null) return;
  // print("onScrobblerEvent: Sendport is Available for data_reciver");
  // var message = box.get("event", defaultValue: "--");
  // sendPort.send(message);
  // // print("onScrobblerEvent: Send to data_reciver : "+message);

  // box.put("event", "");
}