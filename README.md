[TOC]

# flutter_plugin_qrcode

二维码扫描  同时支持 Android&IOS 


## Getting Started

扫描效果 

android 

<img src=".README_images/android.gif" width="400"  align=center />

IOS 
 
<img src=".README_images/ios.gif" width="400"  align=center />

 
## 引入方式
 
      dependencies:
        flutter_plugin_qrcode: ^1.0.1

     
##导入头文件
        
            import 'package:flutter_plugin_qrcode/flutter_plugin_qrcode.dart';
     
## 使用 


      Future<void> getQrcodeState() async {
        String qrcode;
        try {
          qrcode = await FlutterPluginQrcode.getQRCode;
        } on PlatformException {
          qrcode = 'Failed to get platform version.';
        }
    
        if (!mounted) return;
        //获取到扫描的结果进行页面更新
        setState(() {
          _qrcode = qrcode;
        });
      }

 
 
##  关注公众号获取更多内容



<img src=".README_images/a1d43655.png" width="200" hegiht="313" align=center />

