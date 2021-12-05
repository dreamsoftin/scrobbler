package dev.dsi.scrobbler;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.media.MediaMetadata;
import android.media.session.MediaController;
import android.media.session.MediaSessionManager;
import android.media.session.PlaybackState;
import android.service.notification.NotificationListenerService;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.NotificationManagerCompat;
import android.util.Log;

import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Iterables;
import com.google.common.collect.Sets;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.WeakHashMap;

//import dev.dsi.scrobbler.tracker.PlaybackTracker;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.view.FlutterCallbackInformation;
import io.flutter.view.FlutterMain;
import io.flutter.view.FlutterNativeView;
import io.flutter.view.FlutterRunArguments;

public class ListenerService extends NotificationListenerService
        implements MediaSessionManager.OnActiveSessionsChangedListener , MethodChannel.MethodCallHandler {

    private static final String TAG = ListenerService.class.getName();

    private List<MediaController> mediaControllers = new ArrayList<>();
    private Map<MediaController, MediaController.Callback> controllerCallbacks = new WeakHashMap<>();

    private SharedPreferences sharedPreferences;
//    private PlaybackTracker playbackTracker;
    @Override
    public void onCreate() {
//        FlutterApplication application = (FlutterApplication) getApplication();
//        sharedPreferences = application.getSharedPreferences();

//        ConnectivityManager connectivityManager =
//                (ConnectivityManager) this.getSystemService(Context.CONNECTIVITY_SERVICE);
//        ScroballDB scroballDB = application.getScroballDB();
//        ScrobbleNotificationManager scrobbleNotificationManager =
//                new ScrobbleNotificationManager(this, sharedPreferences, scroballDB);
//        LastfmClient lastfmClient = application.getLastfmClient();
//        TrackLover trackLover = new TrackLover(lastfmClient, scroballDB, connectivityManager);
//        Scrobbler scrobbler =
//                new Scrobbler(
//                        lastfmClient, scrobbleNotificationManager, scroballDB, connectivityManager, trackLover);
//
//        playbackTracker = new PlaybackTracker();//scrobbleNotificationManager, scrobbler

        Log.d(TAG, "NotificationListenerService started");

        MediaSessionManager mediaSessionManager =
                (MediaSessionManager)
                        getApplicationContext().getSystemService(Context.MEDIA_SESSION_SERVICE);

        ComponentName componentName = new ComponentName(this, this.getClass());
        mediaSessionManager.addOnActiveSessionsChangedListener(this, componentName);


        // Trigger change event with existing set of sessions.
        List<MediaController> initialSessions = mediaSessionManager.getActiveSessions(componentName);
        onActiveSessionsChanged(initialSessions);


        /*
        * Flutter Callback Related
        * */



    }
    @Nullable
    MethodChannel mBackgroundChannel;

    long callbackHandle;
    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {

        long callbackDispatcherHandle = intent.getLongExtra("CALLBACK_DISPATCHER_HANDLE_KEY", 0);

        FlutterCallbackInformation flutterCallbackInformation =
                FlutterCallbackInformation.lookupCallbackInformation(callbackDispatcherHandle);

        FlutterRunArguments flutterRunArguments = new FlutterRunArguments();
        flutterRunArguments.bundlePath = FlutterMain.findAppBundlePath();
        flutterRunArguments.entrypoint = flutterCallbackInformation.callbackName;
        flutterRunArguments.libraryPath = flutterCallbackInformation.callbackLibraryPath;

        FlutterNativeView backgroundFlutterView = new FlutterNativeView(this, true);
        backgroundFlutterView.runFromBundle(flutterRunArguments);

        mBackgroundChannel = new MethodChannel(backgroundFlutterView, "background_channel");
        mBackgroundChannel.setMethodCallHandler(this);

        callbackHandle = intent.getLongExtra("CALLBACK_HANDLE_KEY", 0);

//     invoke("Service Started");

        return START_STICKY;
    }

    private void invoke(HashMap content){
        if(mBackgroundChannel == null) return;
        final ArrayList<Object> l = new ArrayList<Object>();
        l.add(callbackHandle);
        l.add(content);

        mBackgroundChannel.invokeMethod("", l);
    }
    public static boolean isNotificationAccessEnabled(Context context) {
        return NotificationManagerCompat.getEnabledListenerPackages(context)
                .contains(context.getPackageName());
    }

    @Override
    public void onActiveSessionsChanged(List<MediaController> activeMediaControllers) {
        Log.d(TAG, "Active MediaSessions changed");
//        String data  = "";
//        for (MediaController controller : activeMediaControllers){
//            data+= " "+controller.getPackageName()+ " ";
//            final MediaMetadata  metaData = controller.getMetadata();
//
//          data+= logMetadata(metaData);
//
//        }
//        Log.d(TAG, "Active MediaSessions changed data = "+data);

        Set<MediaController> existingControllers =
                ImmutableSet.copyOf(Iterables.filter(mediaControllers, controllerCallbacks::containsKey));
        Set<MediaController> newControllers = new HashSet<>(activeMediaControllers);

        Set<MediaController> toRemove = Sets.difference(existingControllers, newControllers);
        Set<MediaController> toAdd = Sets.difference(newControllers, existingControllers);


        /*
        *
        * Unregister Callbacks From Closed Player
        *
        */
        for (MediaController controller : toRemove) {
            controller.unregisterCallback(controllerCallbacks.get(controller));
//            playbackTracker.handleSessionTermination(controller.getPackageName());
            controllerCallbacks.remove(controller);
        }
        /*
         *
         * Register Callbacks For New Players
         *
         */
        for (final MediaController controller : toAdd) {
            String packageName = controller.getPackageName();

//            String prefKey = "player." + packageName;
//
//            if (!sharedPreferences.contains(prefKey)) {
//                boolean defaultVal = sharedPreferences.getBoolean("scrobble_new_players", true);
//
//                SharedPreferences.Editor editor = sharedPreferences.edit();
//                editor.putBoolean(prefKey, defaultVal);
//                editor.apply();
//            }
//
//            if (!sharedPreferences.getBoolean(prefKey, true)) {
//                Log.d(TAG, String.format("Ignoring player %s", packageName));
//                continue;
//            }

            Log.d(TAG, String.format("Listening for events from %s", packageName));

            MediaController.Callback callback =
                    new MediaController.Callback() {
                        @Override
                        public void onPlaybackStateChanged(@NonNull PlaybackState state) {
                            controllerPlaybackStateChanged(controller, state);
                        }

                        @Override
                        public void onMetadataChanged(MediaMetadata metadata) {
                            controllerMetadataChanged(controller, metadata);
                        }
                    };

            controllerCallbacks.put(controller, callback);
            controller.registerCallback(callback);

            // Media may already be playing - update with current state.
            controllerPlaybackStateChanged(controller, controller.getPlaybackState());
            controllerMetadataChanged(controller, controller.getMetadata());
        }

        mediaControllers = activeMediaControllers;
    }



    private void controllerPlaybackStateChanged(MediaController controller, PlaybackState state) {
        controller.getPackageName();
        Log.d(TAG, "controller Playback State Changed "+ logMetadata(controller.getMetadata())+ " "+state);

        ScrobblerEvent event = new ScrobblerEvent(
                "playback_state_change",
                Track.fromMetaData(controller.getMetadata()),
                state.getState(),
                controller.getPackageName()
        );
        invoke(event.toJson());

//        playbackTracker.handlePlaybackStateChange(controller.getPackageName(), state);
    }

    private void controllerMetadataChanged(MediaController controller, MediaMetadata metadata) {
        Log.d(TAG, "controller Metadata Changed "+ logMetadata(metadata));
        ScrobblerEvent event = new ScrobblerEvent(
                "metadata_change",
                Track.fromMetaData(controller.getMetadata()),
                -1,
                controller.getPackageName()
        );
        invoke(event.toJson());
//        playbackTracker.handleMetadataChange(controller.getPackageName(), metadata);
    }

    private HashMap logMetadata(MediaMetadata metaData){
        if(metaData == null) return new HashMap<>();
        String data = "";
        Track track = Track.fromMetaData(metaData);


        //final Set<String> keys =  metaData.keySet();

//        for (String key: keys){
//            final String keyData =   metaData.getString(key);
//
//            if(keyData == null) continue;
////              MediaMetadata.METADATA_KEY_GENRE;
//
//            data+=" {"+ key + " : "+ keyData + " }";
//        }
        return track.toJson();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        Log.d(TAG, "onMethodCall: "+call.method);
    }
}
