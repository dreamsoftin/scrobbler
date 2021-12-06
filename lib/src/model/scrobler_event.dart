import 'dart:convert';

import 'track.dart';

class ScrobblerEvent {
   final String event;

   final String? app;
    final  Track? track;
    final int? state;
  ScrobblerEvent({
    required this.event,
    this.app,
    this.track,
    this.state,
  });
    // ScrobblerEvent(String event, Track track, int state, String app) {
    //     this.event = event;
    //     this.track = track;
    //     this.state = state;
    //     this.app = app;
    // }

    // HashMap toJson(){
    //     HashMap map = new HashMap<>();


    //     if(event!=null){
    //         map.put("event",event);
    //     }
    //     if(track!=null){
    //         map.put("track",track.toJson());
    //     }
    //     if(state > -1){
    //         map.put("state",state);
    //     }

    //     return map;
    // }

  ScrobblerEvent copyWith({
    String? event,
    String? app,
    Track? track,
    int? state,
  }) {
    return ScrobblerEvent(
      event: event ?? this.event,
      app: app ?? this.app,
      track: track ?? this.track,
      state: state ?? this.state,
    );
  }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'event': event,
  //     'app': app,
  //     'track': track?.toMap(),
  //     'state': state,
  //   };
  // }

  factory ScrobblerEvent.fromMap(Map<String, dynamic> map) {
    return ScrobblerEvent(
      event: map['event'],
      app: map['app'],
      track: map['track'] != null ? Track.fromMap(map['track']) : null,
      state: map['state'],
    );
  }

  // String toJson() => json.encode(toMap());

  factory ScrobblerEvent.fromJson(String source) => ScrobblerEvent.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ScrobblerEvent(event: $event, app: $app, track: $track, state: $state)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ScrobblerEvent &&
      other.event == event &&
      other.app == app &&
      other.track == track &&
      other.state == state;
  }

  @override
  int get hashCode {
    return event.hashCode ^
      app.hashCode ^
      track.hashCode ^
      state.hashCode;
  }
}

