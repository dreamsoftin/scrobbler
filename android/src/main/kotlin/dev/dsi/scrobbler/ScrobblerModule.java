//package dev.dsi.scrobbler;
//
//import android.content.res.AssetManager;
//
//import androidx.annotation.NonNull;
//
//import io.flutter.Log;
//import io.flutter.embedding.engine.FlutterEngine;
//import io.flutter.embedding.engine.dart.DartExecutor;
//import io.flutter.embedding.engine.loader.ApplicationInfoLoader;
//import io.flutter.embedding.engine.loader.FlutterApplicationInfo;
//import io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry;
//import io.flutter.plugin.common.MethodCall;
//import io.flutter.plugin.common.MethodChannel;
//import io.flutter.view.FlutterCallbackInformation;
//
//public class ScrobblerModule implements MethodChannel.MethodCallHandler {
//    @Override
//    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
//
//    }
//
//    private  static ScrobblerModule sInstance;
//
//    private  static FlutterEngine sBackgroundFlutterEngine;
//   static  ScrobblerModule getInstance(){
//        if(sInstance == null){
//            sInstance = new ScrobblerModule();
//        }
//        return sInstance;
//   }
//
//    private void startBackgroundIsolate() {
//        if (sBackgroundFlutterEngine != null) {
//            Log.w(BackgroundFetch.TAG, "Background isolate already started");
//            return;
//        }
//
//        FlutterApplicationInfo info = ApplicationInfoLoader.load(mContext);
//        String appBundlePath = info.flutterAssetsDir;
//
//        AssetManager assets = mContext.getAssets();
//        if (!sHeadlessTaskRegistered.get()) {
//            sBackgroundFlutterEngine = new FlutterEngine(mContext);
//            DartExecutor executor = sBackgroundFlutterEngine.getDartExecutor();
//            // Create the Transmitter channel
//            sDispatchChannel = new MethodChannel(executor, "background_channel");
//            sDispatchChannel.setMethodCallHandler(this);
//
//            FlutterCallbackInformation callbackInfo = FlutterCallbackInformation.lookupCallbackInformation(mRegistrationCallbackId);
//
//            if (callbackInfo == null) {
//                Log.e(BackgroundFetch.TAG, "Fatal: failed to find callback: " + mRegistrationCallbackId);
//                BackgroundFetch.getInstance(mContext).finish(mTask.getTaskId());
//                return;
//            }
//            DartExecutor.DartCallback dartCallback = new DartExecutor.DartCallback(assets, appBundlePath, callbackInfo);
//            executor.executeDartCallback(dartCallback);
//
//            // The pluginRegistrantCallback should only be set in the V1 embedding as
//            // plugin registration is done via reflection in the V2 embedding.
//            if (sPluginRegistrantCallback != null) {
//                sPluginRegistrantCallback.registerWith(new ShimPluginRegistry(sBackgroundFlutterEngine));
//            }
//        }
//    }
//}
