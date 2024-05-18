part of '../view/watch_movies_view.dart';

class PlayMedia extends StatefulWidget {
  const PlayMedia({super.key, required this.url, this.httpHeaders});
  final String url;
  final Map<String, String>? httpHeaders;

  @override
  State<PlayMedia> createState() => _PlayMediaState();
}

class _PlayMediaState extends State<PlayMedia> {
  late WatchMoviesCubit _watchMoviesCubit;
  late Player _player;
  late VideoController _videoController;
  @override
  void initState() {
    _watchMoviesCubit = context.read<WatchMoviesCubit>();
    _watchMoviesCubit.initMediaPlayer();
    _player = _watchMoviesCubit.getPlayer!;
    _videoController = _watchMoviesCubit.getControllerMedia!;
    _player.open(Media(widget.url, httpHeaders: widget.httpHeaders));
    debugPrint("Play media : ${widget.url}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Video(
      controller: _videoController,
      aspectRatio: 16 / 9,
      onExitFullscreen: () async {
        if (DeviceUtils.isMobile) {
          await DeviceUtils.setOrientationPortrait();
        } else {
          defaultExitNativeFullscreen();
        }
      },
      // onEnterFullscreen: () async {
      //   await DeviceUtils.setOrientationLandscape();
      //   setState(() {});
      // },
    );
  }

  @override
  void didUpdateWidget(covariant PlayMedia oldWidget) {
    if (widget.url != oldWidget.url) {
      _player.open(Media(widget.url, httpHeaders: widget.httpHeaders));
    }
    super.didUpdateWidget(oldWidget);
  }
}
