import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NissanGTRR35App(),
    );
  }
}

class NissanGTRR35App extends StatefulWidget {
  const NissanGTRR35App({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NissanGTRR35AppState createState() => _NissanGTRR35AppState();
}

class _NissanGTRR35AppState extends State<NissanGTRR35App> {
  String _displayText = 'Який мотор в Nissan GTR R35?';

  void _updateDisplayText(String value) {
    if (value.trim().toUpperCase() == 'VR36') {
      setState(() {
        _displayText = 'Bro got knowledge balls';
      });
    } else {
      setState(() {
        _displayText = 'not wirno';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nissan GTR R35 quiz'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(_displayText, style: const TextStyle(fontSize: 20)),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                key: const Key('inputField'), // Use key in widget constructors
                decoration: const InputDecoration(
                  labelText: 'Введіть відповідь',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: _updateDisplayText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
