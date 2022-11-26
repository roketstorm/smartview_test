import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'SmartView Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                onChanged: (value) => url = value,
                onSubmitted: (value) => goToSmartview,
                decoration: const InputDecoration(hintText: 'Type url with http:// or https://'),
              ),
              ElevatedButton(
                onPressed: goToSmartview,
                child: const Text('Show SmartView'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  goToSmartview() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SmartView(
                url: url,
              )),
    );
  }
}

class SmartView extends StatefulWidget {
  final String url;

  const SmartView({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  State<SmartView> createState() => _SmartViewState();
}

class _SmartViewState extends State<SmartView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('This is a SmartView'),
      ),
      body: FutureBuilder(
        future: getHtml(),
        builder: (context, snapshot) => ListView(
          children: [
            snapshot.data ??
                const Center(
                  child: CircularProgressIndicator(),
                ),
          ],
        ),
      ),
    );
  }

  Future<Widget> getHtml() async {
    try {
      var response = await Dio().get(widget.url);
      log(response.data);
      var data = response.data as String;
      Widget html = Html(
        data: data,
      );
      return html;
    } catch (e) {
      log(e.toString());
      return Text(e.toString());
    }
  }
}
