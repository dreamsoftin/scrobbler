//
//package dev.dsi.scrobbler.transforms;
//
//import dev.dsi.scrobbler.model.Track;
//
///**
// * Fixes artist names emitted by Pandora while playing back offline.
// *
// * <p>During offline playback, artist names are prefixed with "Ofln - ".
// */
//public class PandoraOfflineArtistCleaner implements MetadataTransform {
//
//  @Override
//  public Track transform(Track track) {
//    return track.toBuilder().artist(track.artist().replaceAll("^Ofln - ", "")).build();
//  }
//}
