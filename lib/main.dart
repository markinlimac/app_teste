import 'dart:io';

import 'package:dartffiedmupdf/mupdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ffi/ffi.dart';

void main() {
  if (Platform.isAndroid) dartffiedmupdfinit('libdartffiedmupdf.so');
  if (Platform.isIOS) dartffiedmupdfinit('');
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _pdfFilePath;
  File _pdfFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openFileExplorer,
      ),
    );
  }

  void _openFileExplorer() async {
    try {
      final filename = 'sample.pdf';
      var bytes = await rootBundle.load("assets/sample.pdf");
      String dir = (await getApplicationDocumentsDirectory()).path;
      final buffer = bytes.buffer;
      _pdfFile = await File('$dir/$filename').writeAsBytes(buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes)); 
      _pdfFilePath = _pdfFile.absolute.path;
      print(_pdfFilePath);
    } on PlatformException catch (e) {
      print("Unsupported operation: " + e.toString());
    } catch (e) {
      print('Other exception: ' + e.toString());
    }

    try {
      FFImu_loadpdf(_pdfFilePath.toNativeUtf8());
    } catch(e) {
      print(e);
    }
  
    setState(() {});
  }
}
