package flutterplugin.accs.com.flutter_plugin_qrcode;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.widget.Toast;

import com.google.zxing.integration.android.IntentIntegrator;
import com.google.zxing.integration.android.IntentResult;
import com.journeyapps.barcodescanner.CaptureActivity;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterPluginQrcodePlugin */
public class FlutterPluginQrcodePlugin implements MethodCallHandler, PluginRegistry.ActivityResultListener {

  Result result;
  Activity activity;

  private FlutterPluginQrcodePlugin(Activity context) {
    activity = context;
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_plugin_qrcode");
    FlutterPluginQrcodePlugin flutterPluginQrcodePlugin = new FlutterPluginQrcodePlugin(registrar.activity());
    channel.setMethodCallHandler(flutterPluginQrcodePlugin);
    registrar.addActivityResultListener(flutterPluginQrcodePlugin);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if(call.method.equals("getQRCode")){
      this.result = result;
      showQrCodeView();
    } else {
      result.notImplemented();
    }
  }



  private  void  showQrCodeView(){
    IntentIntegrator intentIntegrator = new IntentIntegrator(activity);
    // 开始扫描
    intentIntegrator.initiateScan();
  }

  @Override
  public boolean onActivityResult(int i, int i1, Intent intent) {
        // 获取解析结果
    IntentResult result = IntentIntegrator.parseActivityResult(i, i1, intent);
    if (result != null) {
      if (result.getContents() == null) {
        this.result.error("取消扫描",null,null);
      } else {
        this.result.success(result.getContents().toString());
      }
      return true;
    } else {
      this.result.error("扫描失败",null,null);
      return false;
    }
  }
}
