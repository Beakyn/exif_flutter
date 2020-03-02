import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:exif/exif.dart';
import 'package:exif/tags.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gallery_saver/gallery_saver.dart';

Future<void> writeToFile(ByteData data, String path) {
  final buffer = data.buffer;
  return new File(path)
      .writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File result;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    // final imageName = 'img1_with_exif.jpg';
    final imageName = 'augusto_img.JPEG';
    final fileBytes = await rootBundle.load('assets' + '/' + imageName);
    mainCheckFlow(fileBytes);
  }

  getMetadata() async {
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      final fileBytes = await file.readAsBytes();
      mainCheckFlow(ByteData.view(fileBytes.buffer));
    }
  }

  Future<void> mainCheckFlow(ByteData bytes) async {
    final tempPath = await getTemporaryDirectory();
      final filePath = tempPath.path + '/' + 'test-${DateTime.now()}.jpeg';
      await writeToFile(
        bytes,
        filePath,
      );

      final attributesFirst = await Exif.getAttributes(filePath);
      print(attributesFirst);

      final latitude = -3.180;
      final latitudeRef = getLatitudeRef(latitude);
      final longitude = -38.235;
      final longitudeRef = getLongitudeRef(longitude);
      final dateTimeOriginal = '2009:08:11 16:45:32';
      final userComment = 'We can add the stringified version of the entry here';

      final newAttributes = {
        MetadataTag.latitude: latitude.abs().toString(),
        MetadataTag.latitudeRef: latitudeRef,
        MetadataTag.longitude: longitude.abs().toString(),
        MetadataTag.longitudeRef: longitudeRef,
        MetadataTag.dateTimeOriginal: dateTimeOriginal,
        MetadataTag.userComment: userComment,
      };

      await Exif.setAttributes(filePath, newAttributes);
      final attributesSecond = await Exif.getAttributes(filePath);
      print(attributesSecond);

      await GallerySaver.saveImage(filePath);
      print('Image saved to gallery');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: RaisedButton(
          onPressed: getMetadata,
          child: Text("test"),
        )),
      ),
    );
  }
}
