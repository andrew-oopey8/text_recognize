import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';

class SecondPage extends StatefulWidget {
  final String scannedText;

  const SecondPage(this.scannedText, {Key? key}) : super(key: key);

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Your Text!'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.copy),
          onPressed: () async {
            await FlutterClipboard.copy(widget.scannedText);
            if (!mounted) return;
            // const snackBar = SnackBar(content: Text('Copied!'));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Incremented'),
                duration: Duration(milliseconds: 300),
              ),
            );
          },
        ),
        body: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: SelectableText(
            widget.scannedText.isEmpty
                ? 'No Text Available'
                : widget.scannedText,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      );
}
