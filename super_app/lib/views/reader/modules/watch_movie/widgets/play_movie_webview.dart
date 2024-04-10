part of '../view/watch_movies_view.dart';

class PlayMovieWebView extends StatefulWidget {
  const PlayMovieWebView(
      {super.key, required this.url, required this.onTapWatch});
  final String url;
  final VoidCallback onTapWatch;

  @override
  State<PlayMovieWebView> createState() => _PlayMovieWebViewState();
}

class _PlayMovieWebViewState extends State<PlayMovieWebView> {
  final GlobalKey _webViewKey = GlobalKey();

  InAppWebViewController? _webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      supportZoom: false,
      mediaPlaybackRequiresUserGesture: true,
      iframeAllowFullscreen: true,
      userAgent:
          "Mozilla/5.0 (Linux; Android 13; Pixel 6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Mobile Safari/537.36");
  String url = "https://lamphuchai-dev.github.io/";
  bool _loading = false;

  bool _isFullScreen = false;
  @override
  void initState() {
    debugPrint("Play url : ${widget.url}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Center(
            child: InAppWebView(
              key: _webViewKey,
              initialUrlRequest: URLRequest(url: WebUri(widget.url)),
              initialSettings: InAppWebViewSettings(
                  supportZoom: false,
                  mediaPlaybackRequiresUserGesture: false,
                  iframeAllowFullscreen: true,
                  allowsInlineMediaPlayback: false,
                  allowsPictureInPictureMediaPlayback: false),
              onWebViewCreated: (controller) {
                _webViewController = controller;
                setState(() {
                  _loading = true;
                });
              },
              onLoadStart: (controller, url) {
                setState(() {
                  _loading = true;
                });
              },
              onLoadStop: (controller, url) {
                setState(() {
                  _loading = false;
                });
              },
              onReceivedError: (controller, request, error) {
                setState(() {
                  _loading = false;
                });
              },
              onEnterFullscreen: (controller) {
                _isFullScreen = true;
                var isPortrait =
                    MediaQuery.of(context).orientation == Orientation.portrait;
                if (isPortrait) {
                  DeviceUtils.setOrientationLandscape();
                }
              },
              onExitFullscreen: (controller) {
                if (_isFullScreen) {
                  DeviceUtils.setOrientationPortrait();
                }
              },
            ),
          ),
        ),
        if (_loading) const LoadingMovie()
      ],
    );
  }

  @override
  void dispose() {
    _webViewController?.dispose();
    super.dispose();
  }
}
