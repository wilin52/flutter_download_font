import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

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
  String downloadProgress = "0.0";
  bool complete = false;

  @override
  Widget build(BuildContext context) {
    final textStyle = complete
        ? TextStyle(
            fontSize: 20,
            fontFamily: 'Montserrat-Light',
            fontWeight: FontWeight.bold,
            color: Colors.red,
          )
        : TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'download Progress:',
            ),
            Text(
              downloadProgress,
              style: textStyle,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: downloadFont,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<bool> isDirectoryExist(String path) async{
    File file = File(path);
    return await file.exists();
  }

  Future<void> createDirectory(String path) async {
    Directory directory = Directory(path);
    directory.create();
  }

  void downloadFont() async {
    String url =
        'https://raw.githubusercontent.com/google/fonts/master/ofl/montserrat/Montserrat-Light.ttf';
    String savePath = (await getExternalStorageDirectory()).path + "/fontDownloadDemo";
    bool exist = await isDirectoryExist(savePath);
    if(!exist){
      await createDirectory(savePath);
    }
    String fontPath = "$savePath/Montserrat-Light.ttf";
    OnDownloadProgress onDownloadProgress = (int received, int total) {
      double progress = received / total;
      downloadProgress = '$progress';
      checkProgress(progress, fontPath);
    };

    Dio dio = new Dio();
    await dio.download(url, fontPath, onProgress: onDownloadProgress);
  }

  void checkProgress(double progress, String savePath) async {
    if (progress == 1) {
      complete = true;
      downloadProgress = 'success';
      await readFont(savePath);
    }

    setState(() {});
  }

  Future<void> readFont(String path) async {
    var fontLoader = FontLoader("Montserrat-Light");
    fontLoader.addFont(getCustomFont(path));
    await fontLoader.load();
  }

  Future<ByteData> getCustomFont(String path) async {
    ByteData byteData = await rootBundle.load(path);
    return byteData;
  }
}
