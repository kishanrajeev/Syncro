import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: WebViewPage(url: 'https://kishan.knowledgeplatter.com/textsyncapp/'),
    ),
  );
}

class WebViewPage extends StatefulWidget {
  final String url;

  const WebViewPage({Key? key, required this.url}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final _webViewController = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    _webViewController.onStateChanged.listen((state) {
      if (state.type == WebViewState.finishLoad) {
        // Wait for the page to load before interacting with it
        _interactWithPage();
      }
    });
  }

  @override
  void dispose() {
    _webViewController.dispose();
    super.dispose();
  }

  void _interactWithPage() async {
    // Do nothing since we don't need to interact with the page
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.url));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('URL copied to clipboard'),
      duration: Duration(seconds: 1),
    ));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.grey[900],
    ));

    return WebviewScaffold(
      url: widget.url,
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      initialChild: Center(child: CircularProgressIndicator()),
      appBar: AppBar(
        title: Center(child: Text('Text Sync')),
        actions: [

        ],
      ),
    );
  }
}
