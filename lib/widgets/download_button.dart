import 'package:flutter/material.dart';

enum DownloadStatus {
  notDownloaded,
  fetchingDownload,
  downloading,
  downloaded,
}

@immutable
class DownloadButton extends StatefulWidget {
  const DownloadButton({
    Key? key,
    required this.status,
    this.transitionDuration = const Duration(milliseconds: 500),
    this.progress = 0.0,
    required this.init,
    required this.onDownload,
    // required this.onCancel,
    required this.onOpen,
  }) : super(key: key);

  final DownloadStatus status;
  final Duration transitionDuration;
  final double progress;

  final VoidCallback init;
  final VoidCallback onDownload;
  // final VoidCallback onCancel;
  final VoidCallback onOpen;

  @override
  _DownloadButtonState createState() {
    init();
    return _DownloadButtonState();
  }
}

class _DownloadButtonState extends State<DownloadButton> {
  bool get _isDownloading => widget.status == DownloadStatus.downloading;

  bool get _isFetching => widget.status == DownloadStatus.fetchingDownload;

  bool get _isDownloaded => widget.status == DownloadStatus.downloaded;

  void _onPressed() {
    switch (widget.status) {
      case DownloadStatus.notDownloaded:
        widget.onDownload();
        break;
      case DownloadStatus.fetchingDownload:
        // do nothing.
        break;
      case DownloadStatus.downloading:
        //   widget.onCancel();
        break;
      case DownloadStatus.downloaded:
        widget.onOpen();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onPressed,
      child: Stack(
        children: [
          _buildButtonShape(
            child: _buildText(),
          ),
          _buildDownloadingProgress(),
        ],
      ),
    );
  }

  Widget _buildButtonShape({
    required Widget child,
  }) {
    return AnimatedContainer(
      duration: widget.transitionDuration,
      curve: Curves.ease,
      // decoration: _isDownloading || _isFetching
      //     ? ShapeDecoration(
      //         shape: const CircleBorder(),
      //         color: Theme.of(context).scaffoldBackgroundColor,
      //       )
      //     : _isDownloaded
      //         ? ShapeDecoration(
      //             shape: StadiumBorder(),
      //             color: Theme.of(context).accentColor,
      //           )
      //         : ShapeDecoration(
      //             shape: StadiumBorder(),
      //             color: Colors.blue,
      //           ),
      child: child,
    );
  }

  Widget _buildText() {
    final opacity = _isDownloading || _isFetching ? 0.0 : 1.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: AnimatedOpacity(
          duration: widget.transitionDuration,
          opacity: opacity,
          curve: Curves.ease,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
                _isDownloaded
                    ? Icons.download_done_rounded
                    : Icons.download_outlined,
                size: 32,
                color: _isDownloaded
                    ? Theme.of(context).accentColor
                    : Theme.of(context).iconTheme.color,
                semanticLabel: 'download'),
          )),
    );
  }

  Widget _buildDownloadingProgress() {
    return Positioned.fill(
      top: 2.0,
      bottom: 2.0,
      left: 4.0,
      right: 4.0,
      child: AnimatedOpacity(
        duration: widget.transitionDuration,
        opacity: _isDownloading || _isFetching ? 1.0 : 0.0,
        curve: Curves.ease,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildProgressIndicator(),
            if (_isDownloading)
              Text(
                  "${double.parse((widget.progress).toStringAsFixed(1)) * 100}")
            // const Icon(
            //   Icons.stop,
            //   size: 14.0,
            //   color: Colors.redAccent,
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return AspectRatio(
      aspectRatio: 1.0,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: widget.progress),
        duration: const Duration(milliseconds: 200),
        builder: (BuildContext context, double progress, Widget? child) {
          return CircularProgressIndicator(
            backgroundColor: Theme.of(context).dividerColor,
            valueColor: AlwaysStoppedAnimation(Colors.redAccent),
            strokeWidth: 3.0,
            value: _isFetching ? null : progress,
          );
          // return CircularProgressIndicator(
          //   backgroundColor: _isDownloading
          //       ? Color(0xFF393939)
          //       : Theme.of(context).scaffoldBackgroundColor,
          //   valueColor: AlwaysStoppedAnimation(
          //       _isFetching ? Colors.redAccent.shade100 : Colors.redAccent),
          //   strokeWidth: 2.0,
          //   value: _isFetching ? null : progress,
          // );
        },
      ),
    );
  }
}
