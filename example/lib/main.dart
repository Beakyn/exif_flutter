import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:exif/exif_flutter.dart';
import 'package:exif/tags.dart';
import 'package:flutter/material.dart';
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
    final filePath = tempPath.path + '/' + 'New Image - ${DateTime.now()}.jpeg';
    await writeToFile(
      bytes,
      filePath,
    );

    final attributesFirst = await Exif.getAttributes(filePath);
    print(attributesFirst);

    final latitude = -4.8055555;
    final longitude = -39.3555555;
    final dateTimeOriginal = DateTime.parse('2009-08-11 16:45:32');
    final userComment = 'You can add a metadata stringified version here';

    final newAttributes = Metadata(
      latitude: latitude,
      longitude: longitude,
      dateTimeOriginal: dateTimeOriginal,
      userComment: userComment,
    );

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
          title: const Text('Example App'),
        ),
        body: Center(
            child: RaisedButton(
          onPressed: getMetadata,
          child: Text("Get Image"),
        )),
      ),
    );
  }
}
