import 'dart:io'; // For Platform.isXimport 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class Exif {
  static const MethodChannel _channel = const MethodChannel('beakyn.com/exif');

  static Future<Map<String, String>> getAttributes(String filePath) async {
    final Map<String, String> attributes = await _channel
        .invokeMapMethod('getImageAttributes', {'filePath': filePath});
    return attributes;
  }

  static Future<void> setAttributes(
      String filePath, Map<String, String> attributes) async {
    await _channel.invokeMapMethod('setImageAttributes', {
      'filePath': filePath,
      'attributes': attributes,
    });
  }

  static Future<Map<String, dynamic>> getAttributesIOS(String filePath) async {
    final Map<String, dynamic> attributes = await _channel
        .invokeMapMethod('getImageAttributes', {'filePath': filePath});
    return attributes;
  }

  static Future<bool> setAttributesIOS(
      String filePath, Map<String, String> attributes) async {
    return await _channel.invokeMethod<bool>('setImageAttributes', {
      'filePath': filePath,
      // 'attributes': attributes,
      'longitude': -38.253,
      'latitude': -3.180,
    });

    // return File.fromRawPath(bytes);
  }
}
