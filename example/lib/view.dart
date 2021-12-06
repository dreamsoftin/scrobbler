import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:scrobbler/scrobbler.dart';

import 'main.dart';

class PortDataView extends StatefulWidget {
  const PortDataView({ Key? key }) : super(key: key);

  @override
  _PortDataViewState createState() => _PortDataViewState();
}

class _PortDataViewState extends State<PortDataView> {
    @override
  void initState() {
    super.initState();
    // initPlatformState();
    Scrobbler.initialize();

  bool isregistered =   IsolateNameServer.registerPortWithName(receivePort.sendPort, "data_reciver");
  
    if(isregistered){
      log("APP: Port Registred");
    }
    else{
    IsolateNameServer.removePortNameMapping("data_reciver");

      log("APP:Failed to  Port Registred");
      
    }
  }



  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping("data_reciver");
      log("APP:Unregistering Port.");

    receivePort.close();
    super.dispose();
  }
  ReceivePort receivePort = ReceivePort("data_reciver");
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
                  stream:receivePort,
                  // initialData: ,
                  builder:
                      (BuildContext context, AsyncSnapshot snapshot) {
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
                  await Scrobbler.start(onScrobblerEvent);
                  setState(() {});
                },
                icon: const Icon(Icons.play_arrow)),
            IconButton(
                onPressed: () async {
                  await Scrobbler.stop();
                  setState(() {});
                },
                icon: const Icon(Icons.stop)),
          ],
        ),
      
    );
  }
}