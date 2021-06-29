import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geschehen/model/database.dart';
import 'package:geschehen/service/download_notifier.dart';

import 'article_thumbnail.dart';

enum PlayerState { stopped, playing, paused }
enum PlayingRouteState { speakers, earpiece }

class PlayerSheet extends StatefulWidget {
  final String url;
  final Article article;
  final PlayerMode mode;

  PlayerSheet({
    Key? key,
    required this.url,
    required this.article,
    this.mode = PlayerMode.MEDIA_PLAYER,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState(url, mode);
  }
}

class _PlayerWidgetState extends State<PlayerSheet> {
  String url;
  PlayerMode mode;

  late AudioPlayer _audioPlayer;
  AudioPlayerState? _audioPlayerState;
  Duration? _duration;
  Duration? _position;

  String? localFilePath;

  PlayerState _playerState = PlayerState.stopped;
  PlayingRouteState _playingRouteState = PlayingRouteState.speakers;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerErrorSubscription;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription<PlayerControlCommand>? _playerControlCommandSubscription;

  get _isPlaying => _playerState == PlayerState.playing;
  // get _isPaused => _playerState == PlayerState.paused;
  // get _durationText => _duration?.toString().split('.').first ?? '';
  // get _positionText => _position?.toString().split('.').first ?? '';
  get _remainingTimeText => remainingTime().toString().split('.').first;

  Duration remainingTime() {
    if (_duration != null && _position != null) {
      var rs = _duration!.inSeconds - _position!.inSeconds;
      return Duration(seconds: rs);
    } else {
      return Duration(seconds: 0);
    }
  }

  _PlayerWidgetState(this.url, this.mode);

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _playerControlCommandSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var iconUrl =
        'https://www.google.com/s2/favicons?sz=64&domain=${Uri.parse(widget.article.link).host}';
    return Container(
      color: Colors.transparent,
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
          boxShadow: [
            BoxShadow(
                offset: Offset(2.0, -2.0),
                spreadRadius: 5.0,
                color: Theme.of(context).dividerColor,
                blurRadius: 10.0),
          ],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(8.0),
            topRight: const Radius.circular(8.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListTile(
                leading: ArticleThumbnail(iconUrl,
                    width: 36.0, height: 36.0, radius: true),
                title: Text(widget.article.title,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyText1),
                trailing: IconButton(
                  icon: Icon(
                      _isPlaying
                          ? Icons.pause_outlined
                          : Icons.play_arrow_outlined,
                      color: Theme.of(context).accentColor,
                      semanticLabel: 'play audio',
                      size: 32.0),
                  onPressed: _isPlaying ? () => _pause() : () => _play(),
                ),
                subtitle: Text(_duration != null
                    ? parseTimeText(_remainingTimeText)
                    : '00:00'),
              ),
              Expanded(
                child: Slider.adaptive(
                    inactiveColor: Colors.transparent,
                    activeColor: Theme.of(context).accentColor,
                    onChanged: (v) {
                      final position = v * _duration!.inMilliseconds;
                      _audioPlayer
                          .seek(Duration(milliseconds: position.round()));
                    },
                    value: (_position != null &&
                            _duration != null &&
                            _position!.inMilliseconds > 0 &&
                            _position!.inMilliseconds <
                                _duration!.inMilliseconds)
                        ? _position!.inMilliseconds / _duration!.inMilliseconds
                        : 0.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String parseTimeText(String text) {
    return text.split(":").getRange(1, 3).join(":");
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer(mode: mode);

    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);

      if (Theme.of(context).platform == TargetPlatform.iOS) {
        // (Optional) listen for notification updates in the background
        _audioPlayer.startHeadlessService();

        // set at least title to see the notification bar on ios.
        _audioPlayer.setNotification(
          title: 'CHAD bytes',
          artist: 'Artist or blank',
          albumTitle: widget.article.title,
          imageUrl: widget.article.thumbnail,
          duration: duration,
          elapsedTime: Duration(seconds: 0),
          hasNextTrack: true,
          hasPreviousTrack: false,
        );
      }
    });

    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
              _position = p;
            }));

    _playerCompleteSubscription =
        _audioPlayer.onPlayerCompletion.listen((event) {
      _onComplete();
      setState(() {
        _position = _duration;
      });
    });

    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        _playerState = PlayerState.stopped;
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
      });
    });

    _playerControlCommandSubscription =
        _audioPlayer.onPlayerCommand.listen((command) {
      print('command');
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _audioPlayerState = state;
      });
    });

    _audioPlayer.onNotificationPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() => _audioPlayerState = state);
    });

    _playingRouteState = PlayingRouteState.speakers;
  }

  Future<int> _play() async {
    final playPosition = (_position != null &&
            _duration != null &&
            _position!.inMilliseconds > 0 &&
            _position!.inMilliseconds < _duration!.inMilliseconds)
        ? _position
        : null;
    var filepath =
        await getLocalFile(widget.article.audioLink!.split('/').last);
    if (filepath != null) {
      url = filepath;
    }
    print("url audio: " + url);
    final result = await _audioPlayer.play(url, position: playPosition);
    if (result == 1) setState(() => _playerState = PlayerState.playing);

    // default playback rate is 1.0
    // this should be called after _audioPlayer.play() or _audioPlayer.resume()
    // this can also be called everytime the user wants to change playback rate in the UI
    _audioPlayer.setPlaybackRate(playbackRate: 1.0);
    return result;
  }

  Future<int> _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) setState(() => _playerState = PlayerState.paused);
    return result;
  }

  Future<int> _earpieceOrSpeakersToggle() async {
    final result = await _audioPlayer.earpieceOrSpeakersToggle();
    if (result == 1)
      setState(() => _playingRouteState =
          _playingRouteState == PlayingRouteState.speakers
              ? PlayingRouteState.earpiece
              : PlayingRouteState.speakers);
    return result;
  }

  Future<int> _stop() async {
    final result = await _audioPlayer.stop();
    if (result == 1) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration();
      });
    }
    return result;
  }

  void _onComplete() {
    setState(() => _playerState = PlayerState.stopped);
  }
}
