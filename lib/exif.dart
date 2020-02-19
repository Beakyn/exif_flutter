import 'dart:ffi'; // For FFI
import 'dart:io'; // For Platform.isXimport 'dart:async';

import 'package:ffi/ffi.dart';
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

final Pointer<Utf8> Function(Pointer<Utf8>) _nativeAdd = nativeAddLib
    .lookup<NativeFunction<Pointer<Utf8> Function(Pointer<Utf8>)>>("native_add")
    .asFunction();

String nativeAdd(String filepath) {
  print('oi - ${Utf8.fromUtf8(_nativeAdd(Utf8.toUtf8(filepath)))}');
  return 'default';
}
