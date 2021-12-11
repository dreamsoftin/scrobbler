
import 'package:flutter/material.dart';
import 'package:scrobbler/scrobbler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'background_listner/background_listner.dart';
import 'main.dart';

class PortDataView extends StatefulWidget {
  const PortDataView({Key? key}) : super(key: key);

  @override
  _PortDataViewState createState() => _PortDataViewState();
}

class _PortDataViewState extends State<PortDataView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // initPlatformState();
    WidgetsBinding.instance?.addObserver(this);
    Scrobbler.initialize();

    // registerPort();
  }

//   void registerPort() {

// receivePort = ReceivePort("data_reciver");

//     bool isregistered = IsolateNameServer.registerPortWithName(
//         receivePort.sendPort, "data_reciver");

//     if (isregistered) {
//       log("APP: Port Registred");
//     } else {
//       // IsolateNameServer.removePortNameMapping("data_reciver");
//       // return registerPort();
//       log("APP:Failed to  Port Registred");
//     }
//     setState(() {
      
//     });
//   }

  // void unregisterPort() {
  //   IsolateNameServer.removePortNameMapping("data_reciver");
  //   log("APP:Unregistering Port.");

  //   receivePort.close();
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   log("APP:didChangeAppLifecycleState.");
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       registerPort();
  //       break;
  //     case AppLifecycleState.inactive:
  //     case AppLifecycleState.paused:
  //     case AppLifecycleState.detached:
  //       unregisterPort();
  //       break;
  //   }
  // }

// @override
//   void deactivate() {

//         super.deactivate();
//   }

  @override
  void dispose() {
    // IsolateNameServer.removePortNameMapping("data_reciver");
    // log("APP:Unregistering Port.");

    // receivePort.close();
    super.dispose();
  }

  // ReceivePort receivePort = ReceivePort("data_reciver");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: Scrobbler.isRunning(),
                builder: (context, snapshot) {
                  return Center(
                    child: Text('is Running ${snapshot.data}\n'),
                  );
                }),
            StreamBuilder(
              stream: AppDatabase.instance.streamController.stream,
              // initialData: ,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return Text("/////${snapshot.data}");
              },
            ),
            // Text(text)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        // hiveBox = await LocalStorage.instance.openScrobblerBox();
        // text = hiveBox?.get("event") ?? "--";

        // setState(() {});
      }),
      bottomNavigationBar: Row(
        children: [
          IconButton(
              onPressed: () async {
                // (await SharedPreferences.getInstance()).setString("isActive", "yes");
                await Scrobbler.start(onScrobblerEvent);
                setState(() {});
              },
              icon: const Icon(Icons.play_arrow)),
          IconButton(
              onPressed: () async {
                // (await SharedPreferences.getInstance()).setString("isActive", "NO");
                await Scrobbler.stop();


                setState(() {});
              },
              icon: const Icon(Icons.stop)),
        ],
      ),
    );
  }
}


// class Listner extends WidgetsBindingObserver{
//   Listner(){
//     WidgetsBinding.instance?.addObserver(this);
//   }


// }