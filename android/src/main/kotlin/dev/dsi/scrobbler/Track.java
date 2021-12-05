package dev.dsi.scrobbler;

import android.graphics.Bitmap;
import android.media.MediaMetadata;

import java.util.HashMap;

public class Track {

    private String id;
    private String title;
    private String subtitle;
    private String artist;
    private String composer;
    private String album;
    private String albumArtist;
    private long duration;
    private Bitmap art;

    public Track(){
    }

    static  Track fromMetaData(MediaMetadata metadata){
        ;
        Track track = new Track();

        if(metadata == null) return track;

        
        if(metadata.getString(MediaMetadata.METADATA_KEY_TITLE) !=null){
             track.withttitle(metadata.getString(MediaMetadata.METADATA_KEY_TITLE));
        }

        if(metadata.getString(MediaMetadata.METADATA_KEY_DISPLAY_SUBTITLE) !=null){
            track.withsubtitle(metadata.getString(MediaMetadata.METADATA_KEY_DISPLAY_SUBTITLE));
        }

        if(metadata.getString(MediaMetadata.METADATA_KEY_ARTIST) !=null){
            track.withartist(metadata.getString(MediaMetadata.METADATA_KEY_ARTIST));
        }

        if(metadata.getString(MediaMetadata.METADATA_KEY_MEDIA_ID) !=null){
            track.withid(metadata.getString(MediaMetadata.METADATA_KEY_MEDIA_ID));
        }

        if(metadata.getString(MediaMetadata.METADATA_KEY_COMPOSER) !=null){
            track.withcomposer(metadata.getString(MediaMetadata.METADATA_KEY_COMPOSER));
        }

        if(metadata.getString(MediaMetadata.METADATA_KEY_ALBUM) !=null){
            track.withalbum(metadata.getString(MediaMetadata.METADATA_KEY_ALBUM));
        }

        if(metadata.getString(MediaMetadata.METADATA_KEY_ALBUM_ARTIST) !=null){
            track.withalbumArtist(metadata.getString(MediaMetadata.METADATA_KEY_ALBUM_ARTIST));
        }

        if(metadata.getLong(MediaMetadata.METADATA_KEY_DURATION) !=0){
            track.withduration(metadata.getLong(MediaMetadata.METADATA_KEY_DURATION));
        }

        if(metadata.getBitmap(MediaMetadata.METADATA_KEY_ART) !=null){
            track.withart(metadata.getBitmap(MediaMetadata.METADATA_KEY_ART));
        }

        return track;
    };

    public Track withid(String id){
        this.id = id;
        return this;
    }
    public Track withttitle(String title){
        this.title = title;
        return this;
    }
    public Track withsubtitle(String title){
        this.subtitle = title;
        return this;
    }
    public  Track withartist(String artist){
        this.artist = artist;
        return this;
    }
    public Track withcomposer(String composer){
        this.composer = composer;
        return this;
    }
    public  Track withalbum(String album){
        this.album = album;
        return this;
    }
    public  Track withalbumArtist(String albumArtist){
        this.albumArtist = albumArtist;
        return this;
    }
    public Track withduration(long duration){
        this.duration = duration;
        return this;
    }
    public Track withart(Bitmap art){
        this.art = art;
        return this;
    }


    HashMap<String,Object> toJson(){
    HashMap<String,Object> map = new HashMap<>();
   if(id !=null)
                   map.put("id", id );
                   if(title !=null)
                   map.put("title", title );
                   if(subtitle !=null)
                   map.put("subtitle", subtitle );
                   if(artist !=null)
                   map.put("artist", artist );
                   if(composer !=null)
                   map.put("composer", composer );
                   if(album !=null)
                   map.put("album", album );
                   if(albumArtist !=null)
                   map.put("albumArtist", albumArtist );
                   if( duration > 0)
                   map.put("duration", duration );

    return map;
    };
}

