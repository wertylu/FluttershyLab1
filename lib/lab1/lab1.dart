import 'package:flutter/material.dart';

class NissanGTRR35App extends StatefulWidget {
  const NissanGTRR35App({super.key});

  @override
  State<NissanGTRR35App> createState() => _NissanGTRR35AppState();
}

class _NissanGTRR35AppState extends State<NissanGTRR35App> {
  String _displayText = 'Which engine does Nissan GTR R35 has?';
  bool _showImage = false;

  void _updateDisplayText(String value) {
    if (value.trim().toUpperCase() == 'VR38DETT') {
      setState(() {
        _displayText = 'Hooray, the answer is correct,here is the image';
        _showImage = true;
      });
    } else {
      setState(() {
        _displayText = 'not correct';
        _showImage = false;
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
          children: [
            if (_showImage)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset('assets/vr38dett_engine.jpg'),
              ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(_displayText, style: const TextStyle(fontSize: 20)),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                key: const Key('inputField'),
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