import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomInAppWebView extends StatefulWidget {
  const CustomInAppWebView({super.key, required this.initialUrl});

  final String initialUrl;

  @override
  State<CustomInAppWebView> createState() => _CustomInAppWebViewState();
}

class _CustomInAppWebViewState extends State<CustomInAppWebView> {
  final GlobalKey webViewKey = GlobalKey(debugLabel: 'WebView');
  late WebUri url;
  late String data = '';
  double progress = 0;

  @override
  void initState() {
    url = WebUri(widget.initialUrl);
    _getCachedHtml(url.toString()).then(
      (value) {
        data = value;
        setState(() {});
      },
    );
    super.initState();
  }

  Future<String> _getCachedHtml(String url) async {
    // CacheManager에서 URL 캐시 검색
    final fileInfo = await DefaultCacheManager().getFileFromCache(url);

    if (fileInfo != null) {
      // 캐시된 파일의 내용을 읽어 반환
      return fileInfo.file.readAsString();
    } else {
      // URL 요청 및 캐시 저장
      final response = await DefaultCacheManager().downloadFile(url);
      return response.file.readAsString();
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
              InAppWebView(
                key: webViewKey,
                initialData: InAppWebViewInitialData(
                  data: data,
                  baseUrl: url,
                ),
                onLoadStart: (InAppWebViewController controller, WebUri? url) {
                  if (url != null) this.url = url;
                  setState(() {});
                },
                onLoadStop: (InAppWebViewController controller, WebUri? url) {
                  if (url != null) this.url = url;
                  setState(() {});
                },
                onProgressChanged:
                    (InAppWebViewController controller, int progress) {
                  setState(() {
                    this.progress = progress / 100;
                  });
                },
              ),
              Align(
                alignment: Alignment.center,
                child: _buildProgressBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    if (progress != 1.0) {
      return const CircularProgressIndicator();
    }
    return const SizedBox.shrink();
  }
}
