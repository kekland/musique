import 'dart:ffi';
import 'dart:io';

import 'package:musique/ffi/darwin/gen/darwin_native_bindings.g.dart';
import 'package:musique/imports.dart';
import 'package:objective_c/objective_c.dart';

NSObjectObserver _createNSObjectObserver(
  NSObject target,
  String keyPath,
  void Function() callback, {
  bool callCallbackImmediately = false,
}) {
  final instance = NSObjectObserver.alloc().initWithObservable(
    target,
    keyPath: keyPath.toNSString(),
    callback: ObjCBlock_ffiVoid.listener(() {
      callback();
    }),
  );

  if (callCallbackImmediately) {
    callback();
  }

  return instance;
}

class MusicPlayerService extends Service {
  MusicPlayerService() : super(logger: log.app.child('MusicPlayerService'));

  final _player = AVQueuePlayer();
  final _remoteCommandCenter = MPRemoteCommandCenterListener();
  final _observers = <NSObjectObserver>[];

  late final _currentSongSignal = $signal<Song?>(null);
  Song? get currentSong => _currentSongSignal.value;

  @override
  Future<void> initialize() {
    _remoteCommandCenter.setPlayCommandCallback(ObjCBlock_ffiVoid.listener(_player.play));
    _remoteCommandCenter.setPauseCommandCallback(ObjCBlock_ffiVoid.listener(_player.pause));

    _observers.add(
      _createNSObjectObserver(
        _player,
        'timeControlStatus',
        () {
          final status = _player.timeControlStatus;
          final nowPlayingCenter = MPNowPlayingInfoCenter.defaultCenter();
          if (status == AVPlayerTimeControlStatus.AVPlayerTimeControlStatusPlaying) {
            nowPlayingCenter.playbackState = MPNowPlayingPlaybackState.MPNowPlayingPlaybackStatePlaying;
          } else if (status == AVPlayerTimeControlStatus.AVPlayerTimeControlStatusPaused) {
            nowPlayingCenter.playbackState = MPNowPlayingPlaybackState.MPNowPlayingPlaybackStatePaused;
          } else {
            nowPlayingCenter.playbackState = MPNowPlayingPlaybackState.MPNowPlayingPlaybackStateStopped;
          }
        },
        callCallbackImmediately: true,
      ),
    );

    return super.initialize();
  }

  Future<void> play(Song song) async {
    logger.info('Playing song: ${song.title}');
    _currentSongSignal.value = song;

    if (Platform.isIOS) {
      final audioSession = AVAudioSession.sharedInstance();
      audioSession.setCategory(AVAudioSessionCategoryPlayback, error: nullptr);
      Activation(audioSession).setActive(true, error: nullptr);
    }

    _player.replaceCurrentItemWithPlayerItem(
      AVPlayerItem.playerItemWithURL(NSURL.fileURLWithPath(song.filePath.toNSString())),
    );

    final nowPlayingCenter = MPNowPlayingInfoCenter.defaultCenter();
    nowPlayingCenter.nowPlayingInfo = NSDictionary.of(
      {
        MPMediaItemPropertyArtist: (song.artist ?? 'Unknown Artist').toNSString(),
        MPMediaItemPropertyTitle: (song.title).toNSString(),
        MPMediaItemPropertyAlbumTitle: (song.album ?? 'Unknown Album').toNSString(),
        if (song.durationMs != null) MPMediaItemPropertyPlaybackDuration: (song.durationMs! / 1000).toNSNumber(),
      },
    );

    nowPlayingCenter.playbackState = MPNowPlayingPlaybackState.MPNowPlayingPlaybackStatePlaying;
    _player.play();
  }

  @override
  void dispose() {
    _player.release();
    _remoteCommandCenter.release();
    for (final observer in _observers) {
      observer.release();
    }
    super.dispose();
  }
}
