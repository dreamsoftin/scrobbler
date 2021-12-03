import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';

class Scrobbler {
  static const String _canStart = "can_start";
  static const String _start = "start";
  static const String _stop = "stop";
  static const String _requestPermission = "request_permission";
  static const String _isServiceRunning = "is_service_running";

  static const MethodChannel _channel = MethodChannel('scrobbler');

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
      if(!isGranted){
        await openSettings();
        return false;
      }
      return (await _channel.invokeMethod<bool>(_start)) ?? false;
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
