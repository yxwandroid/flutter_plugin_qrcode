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
  String _qrcode = '二维码扫描';

  @override
  void initState() {
    super.initState();
  }


  Future<void> getQrcodeState() async {
    String qrcode;
    try {
      qrcode = await FlutterPluginQrcode.getQRCode;
    } on PlatformException {
      qrcode = 'Failed to get platform version.';
    }

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
          title: const Text('Flutter QRCode Plugin example app'),
        ),
        body: Center(

          child: FlatButton(onPressed: (){
            getQrcodeState();

          },
              child: Text('$_qrcode')),
        ),
      ),
    );
  }
}
