import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _fetchCounterValue();
  }

  Future<void> _fetchCounterValue() async {
    final response = await http.get(Uri.parse('https://counter-lehh.onrender.com/get'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _counter = data['counter'];
      });
    } else {
      throw Exception('Failed to fetch counter value');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Counter: $_counter',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: Text('Increment Counter'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _refreshCounter,
              child: Text('Refresh Counter'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _resetCounter,
              child: Text('Reset Counter'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _incrementCounter() async {
    final response = await http.post(
      Uri.parse('https://counter-lehh.onrender.com/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'increment': 1}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _counter = data['counter'];
      });
    } else {
      throw Exception('Failed to increment counter');
    }
  }

  Future<void> _refreshCounter() async {
    _fetchCounterValue();
  }

  Future<void> _resetCounter() async {
    final response = await http.post(
      Uri.parse('https://counter-lehh.onrender.com/reset'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _counter = 0;
      });
    } else {
      throw Exception('Failed to reset counter');
    }
  }
}
