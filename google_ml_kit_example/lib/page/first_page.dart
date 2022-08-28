import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task1/page/second_page.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  bool textScanning = false;
  XFile? imageFile;
  String scannedText = '';

  @override
  Widget build(context) => Scaffold(
        appBar: AppBar(
          title: const Text('Text Recognizer'),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (textScanning) const CircularProgressIndicator(),
                if (!textScanning && imageFile == null)
                  Container(
                    width: 400,
                    height: 400,
                    color: Colors.grey[400]!,
                  ),
                if (imageFile != null) Image.file(File(imageFile!.path)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => getImage(ImageSource.gallery),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.image, size: 32),
                            Text('Gallery')
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () => getImage(ImageSource.camera),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.camera_alt, size: 32),
                            Text('Camera')
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Future getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        setState(() {
          textScanning = true;
          imageFile = pickedImage;
        });
        getRecognisedText(pickedImage);
      }
    } catch (e) {
      setState(() {
        textScanning = false;
        imageFile = null;
        scannedText = 'Error occurred while scanning';
      });
    }
  }

  Future getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    final recognisedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = '';
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText += '${line.text}\n';
      }
    }
    setState(() {
      textScanning = false;
    });
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SecondPage(scannedText)),
    );
  }
}
