/*

leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
          icon: Icon(Icons.settings),
        ),
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:indexed/indexed.dart';
import 'drawer.dart';

void main() {
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


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

    var isBig = MediaQuery
        .of(context)
        .size
        .width > 600.0; // set width threshold

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(

        title: Center(child: Text('Syncro')),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _webViewController.reload();
            },
          ),
        ],
      ),
      drawer: isBig ? null : Drawer(
        width: 250,
        backgroundColor: Colors.grey[900],
        child: DrawerContent(),
      ),
      body: Indexer( // use Indexer instead of Stack
        children: [
          Indexed( // use Indexed instead of Positioned
            index: 1, // lower index for web view
            child: WebviewScaffold(
              url: widget.url,
              withZoom: true,
              withLocalStorage: true,
              hidden: true,
              initialChild: Center(child: CircularProgressIndicator()),
            ),
          ),
          if (isBig) Indexed( // use Indexed instead of Positioned
            index: 2, // higher index for drawer
            child: Drawer(
              child: DrawerContent(),
              backgroundColor: Colors.grey[900],
              width: 250,
            ), // position the drawer on the left
          ),
        ],
      ),
    );
  }
}