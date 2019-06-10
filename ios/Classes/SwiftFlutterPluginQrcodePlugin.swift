import Flutter
import UIKit

public class SwiftFlutterPluginQrcodePlugin: NSObject, FlutterPlugin {
    
    var result:FlutterResult?;
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_plugin_qrcode", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterPluginQrcodePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if(call.method=="getQRCode"){
            self.result = result;
            openScanView();
        }else{
        
        }
        //    result("iOS " + UIDevice.current.systemVersion)
    }
    
    
    func  openScanView(){
        DispatchQueue.main.async {
            let aCScanViewController = ACScanViewController();
            aCScanViewController.qrCodeBlock={
                (qrCodeResult:String) in
                print("扫描成功的获取结果    \(qrCodeResult)")
                self.result!(qrCodeResult)
            }
            UIApplication.shared.keyWindow?.rootViewController?.present(aCScanViewController, animated: false, completion: nil)
        }
    }
    
}
