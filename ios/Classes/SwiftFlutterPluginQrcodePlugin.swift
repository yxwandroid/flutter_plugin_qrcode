import Flutter
import UIKit

public class SwiftFlutterPluginQrcodePlugin: NSObject, FlutterPlugin {
    
    var result:FlutterResult?;
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_plugin_qrcode", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterPluginQrcodePlugin()
        
//       let viewController = UIApplication.shared.keyWindow!.rootViewController //as! YourViewController
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
           if #available(iOS 13.0, *) {
                aCScanViewController.modalPresentationStyle = .fullScreen
            }
            aCScanViewController.qrCodeBlock={
                (qrCodeResult:String) in
                print("扫描成功的获取结果    \(qrCodeResult)")
                self.result!(qrCodeResult)
            }

            let objViewController =  UIApplication.shared.keyWindow?.rootViewController
            objViewController?.present(aCScanViewController, animated: true, completion: nil)
            
        }
    }
    
}
