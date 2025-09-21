import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
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

CMTime _cmTimeFromDuration(Duration duration) {
  return CMTimeMakeWithSeconds(duration.inMicroseconds / 1e6, 1000000);
}

Duration _durationFromCMTime(CMTime time) {
  if (time.flagsAsInt & CMTimeFlags.kCMTimeFlags_Valid.value == 0) {
    return Duration.zero;
  }

  return Duration(microseconds: (time.value * 1e6 / time.timescale).round());
}

class MusicPlayerService extends Service {
  MusicPlayerService() : super(logger: log.app.child('MusicPlayerService'));

  final _player = AVQueuePlayer();
  final _remoteCommandCenter = MPRemoteCommandCenterListener();
  final _observers = <NSObjectObserver>[];

  late final _currentSongSignal = $signal<Song?>(null);
  Song? get currentSong => _currentSongSignal.value;

  late final _currentPositionSignal = $signal<Duration>(Duration.zero);
  Duration get currentPosition => _currentPositionSignal.value;

  late final _durationSignal = $signal<Duration>(Duration.zero);
  Duration get duration => _durationSignal.value;

  late final _isPlayingSignal = $signal<bool>(false);
  bool get isPlaying => _isPlayingSignal.value;

  @override
  Future<void> initialize() {
    _remoteCommandCenter.setPlayCommandCallback(ObjCBlock_ffiVoid.listener(_player.play));
    _remoteCommandCenter.setPauseCommandCallback(ObjCBlock_ffiVoid.listener(_player.pause));
    _remoteCommandCenter.setTogglePlayPauseCommandCallback(
      ObjCBlock_ffiVoid.listener(() {
        if (_player.timeControlStatus == AVPlayerTimeControlStatus.AVPlayerTimeControlStatusPlaying) {
          _player.pause();
        } else {
          _player.play();
        }
      }),
    );

    _remoteCommandCenter.setNextTrackCommandCallback(ObjCBlock_ffiVoid.listener(() => print('next')));
    _remoteCommandCenter.setPreviousTrackCommandCallback(ObjCBlock_ffiVoid.listener(() => print('prev')));

    _observers.add(
      _createNSObjectObserver(
        _player,
        'timeControlStatus',
        () {
          final status = _player.timeControlStatus;
          final nowPlayingCenter = MPNowPlayingInfoCenter.defaultCenter();
          if (status == AVPlayerTimeControlStatus.AVPlayerTimeControlStatusPlaying) {
            nowPlayingCenter.playbackState = MPNowPlayingPlaybackState.MPNowPlayingPlaybackStatePlaying;
            _isPlayingSignal.value = true;
          } else if (status == AVPlayerTimeControlStatus.AVPlayerTimeControlStatusPaused) {
            nowPlayingCenter.playbackState = MPNowPlayingPlaybackState.MPNowPlayingPlaybackStatePaused;
            _isPlayingSignal.value = false;
          } else {
            nowPlayingCenter.playbackState = MPNowPlayingPlaybackState.MPNowPlayingPlaybackStateStopped;
            _isPlayingSignal.value = false;
          }
        },
        callCallbackImmediately: true,
      ),
    );

    _player.addPeriodicTimeObserverForInterval(
      _cmTimeFromDuration(Duration(milliseconds: 8)),
      queue: DispatchQueueShim.getMain(),
      usingBlock: ObjCBlock_ffiVoid_CMTime.listener((time) {
        _currentPositionSignal.value = _durationFromCMTime(time);
        _durationSignal.value = _player.currentItem?.duration != null
            ? _durationFromCMTime(_player.currentItem!.duration)
            : Duration.zero;

        // update now playing info center position
        final nowPlayingCenter = MPNowPlayingInfoCenter.defaultCenter();
        final nowPlayingInfo = NSMutableDictionary.of(nowPlayingCenter.nowPlayingInfo ?? NSDictionary());
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = _currentPositionSignal.value.inSeconds
            .toNSNumber();
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = (_isPlayingSignal.value ? 1.0 : 0.0).toNSNumber();
        nowPlayingCenter.nowPlayingInfo = nowPlayingInfo;
      }),
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

  Future<void> resume() async {
    logger.info('Resuming playback');
    _player.play();
  }

  Future<void> pause() async {
    logger.info('Pausing playback');
    _player.pause();
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
