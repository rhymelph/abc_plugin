import 'dart:async';
import 'dart:io';

import 'package:abc_plugin/abc_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  GlobalKey<ScaffoldState> _state;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = (await AbcPlugin.canPay()).toString();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _state,
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text('Running on: $_platformVersion\n'),
              FlatButton(
                  onPressed: () async {
                    if (await AbcPlugin.canPay()) {
                      String result = await AbcPlugin.requestPay(
                          'com.rhyme.abc_plugin_example',
                          Platform.isIOS ? 'abc_example' : 'MainActivity',
                          'pay',
                          'ON20140954103');
                      print(result);
                    } else {
                      _state.currentState.showSnackBar(
                          SnackBar(content: Text('请下载中国农业银行app')));
                    }
                  },
                  child: Text('调起支付'))
            ],
          ),
        ),
      ),
    );
  }
}
