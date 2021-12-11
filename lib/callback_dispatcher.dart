import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrobbler/scrobbler.dart';
import 'package:shared_preferences/shared_preferences.dart';

///
///## Very Importent Method.
///
/// ### In Native Whenver We get data
///  1. we call this function to setup [MethodChannel] for background channel.
///  2. Pass data via method channel which includes call back function id and scrobbled data
///
///

void callbackDispatcher() {
  // 1. Initialize MethodChannel used to communicate with the platform portion of the plugin.
  const MethodChannel _backgroundChannel = MethodChannel('background_channel');

  // 2. Setup internal state needed for MethodChannels.
  WidgetsFlutterBinding.ensureInitialized();

  // 3. Listen for background events from the platform portion of the plugin.
  ///
  /// This is very importent, because we are calling application callback
  ///
  _backgroundChannel.setMethodCallHandler((MethodCall call) async {
    ///
    ///
    ///
    print(
        "callbackDispatcher: On Mehod Call ${call.method} with args ${call.arguments}");

    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.reload();

    int? userCallback = preferences.getInt("scobller_registered_callback");
    if (userCallback == null) return;
    print(
        "callbackDispatcher: WidgetsFlutterBinding.ensureInitialized() Completed $userCallback");

    final List<dynamic> args = call.arguments;

    // 3.1. Retrieve callback instance for handle.
    final Function? callbackThis = PluginUtilities.getCallbackFromHandle(
        CallbackHandle.fromRawHandle(userCallback));
    // print("callbackDispatcher: getCallbackFromHandle $callbackThis");

    assert(callbackThis != null);

    // 3.2. Preprocess arguments.
    Map s = args[1] as Map;

    // print("callbackDispatcher: Invoking function $callbackThis  with Args $s");
    // 3.3. Invoke callback.
    callbackThis!.call(ScrobblerEvent.fromJson(json.encode(s)));
    // print("callbackDispatcher: Invoked function $callbackThis  with Args $s");
  });
}
