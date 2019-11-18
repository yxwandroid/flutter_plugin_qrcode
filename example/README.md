 
## 引入方式
 
      dependencies:
        flutter_plugin_qrcode: ^1.0.1

     
## 导入头文件
        
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

 