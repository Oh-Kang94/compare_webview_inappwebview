import 'package:compare_webview_inappwebview/in_app_web_view.dart';
import 'package:compare_webview_inappwebview/web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String editorTypeUrl = dotenv.env['editorTypeUrl'] ?? '';
final String imageTypeUrl = dotenv.env['imageTypeUrl'] ?? '';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () async => await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CustomInAppWebView(
                    initialUrl: imageTypeUrl,
                  ),
                ),
              ),
              child: const Text("Show flutter_inappwebview"),
            ),
            MaterialButton(
              onPressed: () async => await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CustomWebView(
                    initialUrl: editorTypeUrl,
                  ),
                ),
              ),
              child: const Text("Show webview_flutter"),
            ),
          ],
        ),
      ),
    );
  }
}
