import 'dart:ffi'; // For FFI
import 'dart:io'; // For Platform.isXimport 'dart:async';

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
}

final DynamicLibrary nativeAddLib = Platform.isAndroid
    ? DynamicLibrary.open("libnative_add.so")
    : DynamicLibrary.process();

final int Function(int x, int y) nativeAdd = nativeAddLib
    .lookup<NativeFunction<Int32 Function(Int32, Int32)>>("native_add")
    .asFunction();
