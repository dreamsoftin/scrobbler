package dev.dsi.scrobbler

import android.app.Activity
import android.app.ActivityManager
import android.content.Context
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.content.Intent
import android.os.Build
import android.provider.Settings
import androidx.core.content.ContextCompat.getSystemService
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import java.lang.Exception
import java.util.ArrayList





/** ScrobblerPlugin */
class ScrobblerPlugin: FlutterPlugin, MethodCallHandler,ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  val  CALLBACK_HANDLE_KEY: String ="CALLBACK_HANDLE_KEY";
  val  CALLBACK_DISPATCHER_HANDLE_KEY: String ="CALLBACK_DISPATCHER_HANDLE_KEY";


  private var activity : Activity? = null;
  private var mCallbackDispatcherHandle: Long = 0
  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "scrobbler")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method.equals("initializeService")) {
      val args: ArrayList<*> = call.arguments()
      val callBackHandle = args[0] as Long
      mCallbackDispatcherHandle = callBackHandle
      result.success(null)
      return
    }
//    else if (call.method.equals("run")) {
//      val args: ArrayList<*> = call.arguments()
//      val callbackHandle = args[0] as Long
//      val i = Intent(mContext, MyService::class.java)
//      i.putExtra(CALLBACK_HANDLE_KEY, callbackHandle)
//      i.putExtra(CALLBACK_DISPATCHER_HANDLE_KEY, mCallbackDispatcherHandle)
//      mContext.startService(i)
//      result.success(null)
//      return
//    }
    when (call.method) {
        "can_start" -> {
          return result.success(ListenerService.isNotificationAccessEnabled(activity))
        }
        "run"->{
          val args: ArrayList<*> = call.arguments()
          val callbackHandle = args[0] as Long

          val i = Intent(activity, ListenerService::class.java)
          i.putExtra(CALLBACK_HANDLE_KEY, callbackHandle)
          i.putExtra(CALLBACK_DISPATCHER_HANDLE_KEY, mCallbackDispatcherHandle)
          activity?.startService(i)

          result.success(null)
          return
        }

        "request_permission" ->{
          requestPermission();
          return result.success("started Activity");
        }
        "is_service_running" ->{
          result.success(isMyServiceRunning(ListenerService::class.java))
        }
        "start" -> {
          try {
            val isStarted = startListenerService();
            if(isStarted){
              result.success(true)
            } else throw  Throwable("Failed to Start Service due to unknown Reason.")
          }catch (e:Throwable){
            result.error("Failed to Start",e.message,e.stackTrace);
            return;
          }

        }
        "stop" -> {
          try {
            stopListenerService();
            result.success(true);
          } catch (e: Exception){
            result.error(e.message,e.message,e.stackTrace);
          }
        }
        else -> {
          result.notImplemented()
        }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }


  private fun startListenerService(): Boolean {
    if(activity == null) throw Throwable("No Activity Registered");
    if (ListenerService.isNotificationAccessEnabled(activity)) { //&& getLastfmClient().isAuthenticated()
      val i :Intent = Intent(activity, ListenerService::class.java);
//      i.putExtra(CALLBACK_HANDLE_KEY, callbackHandle)
//      i.putExtra(CALLBACK_DISPATCHER_HANDLE_KEY, mCallbackDispatcherHandle)
      activity!!.startService(i);
      return true;
    }
    return throw Throwable("Notification Access is not Granted. Please Provide Notification access to start service.");
  }

  private fun stopListenerService() {
    if(activity == null) return;
    activity!!.stopService(Intent(activity, ListenerService::class.java))
  }

  fun  requestPermission(){
    val action: String = if (Build.VERSION.SDK_INT >= 22) {
      Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS
    } else {
      "android.settings.ACTION_NOTIFICATION_LISTENER_SETTINGS"
    }
    activity?.startActivity(Intent(action));
  }

  private fun isMyServiceRunning(serviceClass: Class<*>): Boolean {
    if(activity == null) return false;
    val manager = activity?.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
    for (service in manager.getRunningServices(Int.MAX_VALUE)) {
      if (serviceClass.name == service.service.className) {
        return true
      }
    }
    return false
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
activity = binding.activity;
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null;

  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity;

  }

  override fun onDetachedFromActivity() {
    activity = null;

  }
}
