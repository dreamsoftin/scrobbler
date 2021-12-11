import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'callback_dispatcher.dart';
import 'src/model/scrobler_event.dart';

export 'src/model/index.dart';
class Scrobbler {
  static const String _canStart = "can_start";
  static const String _requestPermission = "request_permission";
  static const String _isServiceRunning = "is_service_running";

  static const MethodChannel _channel = MethodChannel('scrobbler');

    static Future<void> initialize() async {
    final CallbackHandle? callback =
        PluginUtilities.getCallbackHandle(callbackDispatcher);
    var raw = callback!.toRawHandle();
    await _channel.invokeMethod('initializeService', <dynamic>[raw]);
  }


  ///
  /// Returns `bool` value representing whether service can start or not.
  ///
  static Future<bool> canStart() async {
    try {
      return (await _channel.invokeMethod<bool>(_canStart)) ?? false;
    } catch (e) {
      log("Scrobbler Exception: $e");

      return false;
    }
  }

  ///
  /// Returns `bool` value representing whether service can start or not.
  ///
  static Future<bool> isRunning() async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      return ((await _channel.invokeMethod<bool>(_isServiceRunning)) ?? false) && (sharedPreferences.getInt("scobller_registered_callback")!=null);
    } catch (e) {
      log("Scrobbler Exception: $e");

      return false;
    }
  }

  ///
  /// Opens the settings page for Notification Access.
  ///
  static Future<void> openSettings() async {
    try {
      await _channel.invokeMethod(_requestPermission);
    } catch (e) {
      log("Scrobbler Exception: $e");
    }
  }

  ///
  /// Returns `bool` value representing whether service started or not.
  /// 
  /// ## `callback` parameter should be a static or a global Function.
  /// 
  static Future<bool> start(Function(ScrobblerEvent event) callback) async {
    try {
      bool isGranted = await canStart();
      if (!isGranted) {
        await openSettings();
        return false;
      }
      var rawHandle = PluginUtilities.getCallbackHandle(callback)!.toRawHandle();
      final List<dynamic> args = <dynamic>[
      rawHandle
    ];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setInt("scobller_registered_callback", rawHandle);
  
      return (await _channel.invokeMethod("run",args)) ?? false;
    } catch (e) {
      log("Scrobbler Exception: $e");

      return false;
    }
  }



  ///
  /// Returns `bool` value representing whether service stoped or not.
  ///
  static Future<bool> stop() async {
    try {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

return  sharedPreferences.remove("scobller_registered_callback");



  // const MethodChannel _backgroundChannel = MethodChannel('background_channel');

  //     return (await _backgroundChannel.invokeMethod<bool>(_stop)) ?? false;
    } catch (e) {
      log("Scrobbler Exception: $e");

      return false;
    }
  }


}