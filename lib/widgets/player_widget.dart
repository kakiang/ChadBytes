import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geschehen/model/database.dart';
import 'package:geschehen/service/download_notifier.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'download_button.dart';

enum PlayerState { stopped, playing, paused }
enum PlayingRouteState { speakers, earpiece }

class PlayerWidget extends StatefulWidget {
  final String url;
  final Article article;
  final PlayerMode mode;

  PlayerWidget({
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

class _PlayerWidgetState extends State<PlayerWidget> {
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
    // var iconUrl =
    //     'https://www.google.com/s2/favicons?sz=64&domain=${Uri.parse(widget.article.link).host}';
    return Container(
      height: 72,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          playPausedSection(),
          Expanded(
              child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
            title: Text(
              widget.article.title,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: GoogleFonts.montserrat(
                  fontSize: 14, fontWeight: FontWeight.w400),
            ),
            subtitle: Text(_duration != null
                ? parseTimeText(_remainingTimeText)
                : '00:00'),
          )),
          Consumer<DownloadNotifier>(
            builder: (context, downloader, _) {
              initStatus() {
                downloader
                    .initStatus(widget.article.audioLink!.split('/').last);
              }

              onDownload() {
                downloader.startDownloading(widget.article.audioLink!,
                    widget.article.audioLink!.split('/').last);
              }

              onTap() {
                print("onTap");
                if (downloader.downloadStatus == DownloadStatus.downloaded)
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: TextButton(
                              onPressed: () {
                                downloader.delete(
                                    widget.article.audioLink!.split('/').last);
                                Navigator.of(context).pop();
                              },
                              child: Text("Remove download")),
                          contentPadding: EdgeInsets.zero,
                        );
                      });

                // return PopupMenuButton<int>(
                //   itemBuilder: (context) => [
                //     PopupMenuItem<int>(
                //       value: 1,
                //       child: const Text("Remove download"),
                //     ),
                //   ],
                //   onSelected: (val) {
                //     downloader
                //         .delete(widget.article.audioLink!.split('/').last);
                //   },
                // );
              }

              return DownloadButton(
                status: downloader.downloadStatus,
                progress: downloader.downloadProgress,
                init: initStatus,
                onDownload: onDownload,
                onOpen: onTap,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget playPausedSection() {
    return InkWell(
      onTap: _isPlaying ? () => _pause() : () => _play(),
      child: Stack(alignment: Alignment.center, children: [
        IconButton(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          alignment: Alignment.center,
          iconSize: 48,
          icon: Icon(_isPlaying ? Icons.pause_outlined : Icons.play_arrow,
              color: Theme.of(context).accentColor,
              semanticLabel: 'play audio',
              size: 24.0),
          onPressed: _isPlaying ? () => _pause() : () => _play(),
        ),
        Positioned.fill(
          top: 1.0,
          bottom: 1.0,
          left: 4.0,
          right: 4.0,
          child: Container(
            child: CircularProgressIndicator(
              strokeWidth: 3,
              value: (_position != null &&
                      _duration != null &&
                      _position!.inMilliseconds > 0 &&
                      _position!.inMilliseconds < _duration!.inMilliseconds)
                  ? _position!.inMilliseconds / _duration!.inMilliseconds
                  : 0.0,
              valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
              backgroundColor: Theme.of(context).dividerColor,
            ),
          ),
        ),
      ]),
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
