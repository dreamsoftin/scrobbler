package dev.dsi.scrobbler;

import android.app.Activity;
import android.app.ActivityManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.media.MediaMetadata;
import android.media.session.MediaController;
import android.media.session.MediaSessionManager;
import android.media.session.PlaybackState;
import android.net.ConnectivityManager;
import android.service.notification.NotificationListenerService;
import androidx.annotation.NonNull;
import androidx.core.app.NotificationManagerCompat;
import android.util.Log;

import com.google.common.base.Optional;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Iterables;
import com.google.common.collect.Sets;


import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.WeakHashMap;

import io.flutter.app.FlutterApplication;

public class ListenerService extends NotificationListenerService
        implements MediaSessionManager.OnActiveSessionsChangedListener {

    private static final String TAG = ListenerService.class.getName();

    private List<MediaController> mediaControllers = new ArrayList<>();
    private Map<MediaController, MediaController.Callback> controllerCallbacks = new WeakHashMap<>();

    private SharedPreferences sharedPreferences;

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
//        playbackTracker = new PlaybackTracker(scrobbleNotificationManager, scrobbler);

        Log.d(TAG, "NotificationListenerService started");

        MediaSessionManager mediaSessionManager =
                (MediaSessionManager)
                        getApplicationContext().getSystemService(Context.MEDIA_SESSION_SERVICE);

        ComponentName componentName = new ComponentName(this, this.getClass());
        mediaSessionManager.addOnActiveSessionsChangedListener(this, componentName);


        // Trigger change event with existing set of sessions.
        List<MediaController> initialSessions = mediaSessionManager.getActiveSessions(componentName);
        onActiveSessionsChanged(initialSessions);


    }

    public static boolean isNotificationAccessEnabled(Context context) {
        return NotificationManagerCompat.getEnabledListenerPackages(context)
                .contains(context.getPackageName());
    }

    @Override
    public void onActiveSessionsChanged(List<MediaController> activeMediaControllers) {
        Log.d(TAG, "Active MediaSessions changed");
        String data  = "";
        for (MediaController controller : activeMediaControllers){
            data+= " "+controller.getPackageName()+ " ";
            final MediaMetadata  metaData = controller.getMetadata();

          data+= logMetadata(metaData);

        }
        Log.d(TAG, "Active MediaSessions changed data = "+data);

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
        Log.d(TAG, "controller Playback State Changed "+ logMetadata(controller.getMetadata())+ " "+state);

//        playbackTracker.handlePlaybackStateChange(controller.getPackageName(), state);
    }

    private void controllerMetadataChanged(MediaController controller, MediaMetadata metadata) {
        Log.d(TAG, "controller Metadata Changed "+ logMetadata(metadata));

//        playbackTracker.handleMetadataChange(controller.getPackageName(), metadata);
    }

    private String logMetadata(MediaMetadata metaData){
        if(metaData == null) return "";
        String data = "";
        final Set<String> keys =  metaData.keySet();

        for (String key: keys){
            final String keyData =   metaData.getString(key);

            if(keyData == null) continue;
//              MediaMetadata.METADATA_KEY_GENRE;

            data+=" {"+ key + " : "+ keyData + " }";
        }
        return data;
    }
}
