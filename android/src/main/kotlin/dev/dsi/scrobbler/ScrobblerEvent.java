package dev.dsi.scrobbler;

import androidx.annotation.Nullable;

import java.util.HashMap;

class ScrobblerEvent {
   final String event;

   final String app;

    @Nullable
    final  Track track;
    @Nullable
    final int state;
    protected ScrobblerEvent(String event, Track track, int state, String app) {
        this.event = event;
        this.track = track;
        this.state = state;
        this.app = app;
    }

    HashMap toJson(){
        HashMap map = new HashMap<>();


        if(event!=null){
            map.put("event",event);
        }
        if(track!=null){
            map.put("track",track.toJson());
        }
        if(state > -1){
            map.put("state",state);
        }
        if(app !=null){
            map.put("app",app);
        }

        return map;
    }
}

