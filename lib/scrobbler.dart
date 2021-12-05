import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/services.dart';

import 'callback_dispatcher.dart';

class Scrobbler {
  static const String _canStart = "can_start";
  static const String _start = "start";
  static const String _stop = "stop";
  static const String _requestPermission = "request_permission";
  static const String _isServiceRunning = "is_service_running";

  static const MethodChannel _channel = MethodChannel('scrobbler');

    static Future<void> initialize() async {
    final CallbackHandle? callback =
        PluginUtilities.getCallbackHandle(callbackDispatcher);
    var raw = callback!.toRawHandle();
    await _channel.invokeMethod('initializeService', <dynamic>[raw]);
  }

  static void test(void Function(String s) callback) async {
    var raw = PluginUtilities.getCallbackHandle(callback)!.toRawHandle();
    await _channel.invokeMethod('run', [raw]);
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
      return (await _channel.invokeMethod<bool>(_isServiceRunning)) ?? false;
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
  static Future<bool> start() async {
    try {
      bool isGranted = await canStart();
      if (!isGranted) {
        await openSettings();
        return false;
      }
      final List<dynamic> args = <dynamic>[
      PluginUtilities.getCallbackHandle(testCallBack)!.toRawHandle()
    ];
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
      return (await _channel.invokeMethod<bool>(_stop)) ?? false;
    } catch (e) {
      log("Scrobbler Exception: $e");

      return false;
    }
  }


}
void testCallBack(String s){
  print("Hello Flutter  $s");
}