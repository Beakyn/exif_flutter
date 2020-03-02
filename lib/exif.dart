import 'dart:io'; // For Platform.isXimport 'dart:async';
import 'dart:typed_data';

import 'package:exif/tags.dart';
import 'package:flutter/services.dart';

class Exif {
  static const MethodChannel _channel = const MethodChannel('beakyn.com/exif');

  static Future<Map<String, dynamic>> getAttributes(String filePath) async {
    final Map<String, dynamic> attributes = await _channel
        .invokeMapMethod('getImageAttributes', {'filePath': filePath});
    return attributes;
  }

  static Future<void> setAttributes(
      String filePath, Metadata attributes) async {
    await _channel.invokeMapMethod('setImageAttributes', {
      'filePath': filePath,
      'attributes': attributes.toNative(),
    });
  }
}
