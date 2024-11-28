import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebView extends StatefulWidget {
  const CustomWebView({super.key, required this.initialUrl});

  final String initialUrl;

  @override
  State<CustomWebView> createState() => CustomWebViewState();
}

class CustomWebViewState extends State<CustomWebView> {
  late WebViewController _controller;
  bool _isLoading = true; // 로딩 상태를 나타내는 변수

  // 캐시된 파일 경로 가져오기
  Future<String?> _getCachedFilePath(String url) async {
    final fileInfo = await DefaultCacheManager().getFileFromCache(url);
    return fileInfo?.file.path;
  }

  // URL 요청 시 캐시 여부 확인 후 로드
  Future<void> _loadUrl(String url) async {
    final cachedFilePath = await _getCachedFilePath(url);
    // 캐싱된 파일 경로를 WebView에 로드
    if (mounted) {
      if (cachedFilePath != null) {
        await _controller.loadRequest(Uri.parse('file://$cachedFilePath'));
      } else {
        await _controller.loadRequest(Uri.parse(widget.initialUrl));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            _isLoading = true;
            setState(() {});
          },
          onPageFinished: (String url) {
            _isLoading = false;
            setState(() {});
          },
        ),
      );
    // 초기 URL 로드
    _loadUrl(widget.initialUrl);
  }

  @override
  void didUpdateWidget(CustomWebView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialUrl != widget.initialUrl) {
      // URL이 변경되면 새 URL 로드
      _loadUrl(widget.initialUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width * 1,
          child: Stack(
            children: [
              WebViewWidget(
                controller: _controller,
              ),
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
