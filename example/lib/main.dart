import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_plugin_qrcode/flutter_plugin_qrcode.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _qrcode = 'Unknown';

  @override
  void initState() {
    super.initState();
  }


  Future<void> getQrcodeState() async {
    String qrcode;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      qrcode = await FlutterPluginQrcode.getQRCode;
    } on PlatformException {
      qrcode = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _qrcode = qrcode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(

          child: FlatButton(onPressed: (){
            getQrcodeState();

          },

              child: Text('点击  $_qrcode')),
        ),
      ),
    );
  }
}
