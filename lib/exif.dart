import 'dart:io'; // For Platform.isXimport 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class Exif {
  static const MethodChannel _channel = const MethodChannel('beakyb.com/exif');

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

  static Future<File> setAttributesIOS(
      String filePath, Map<String, String> attributes) async {
    Uint8List bytes =
        await _channel.invokeMethod<Uint8List>('setImageAttributes', {
      'filePath': filePath,
      'attributes': attributes,
    });

    return File.fromRawPath(bytes);
  }
}
