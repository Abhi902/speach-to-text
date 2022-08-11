import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: speechScreen());
  }
}

class speechScreen extends StatefulWidget {
  @override
  State<speechScreen> createState() => _speechScreenState();
}

class _speechScreenState extends State<speechScreen> {
  stt.SpeechToText _speech = stt.SpeechToText();
  double confidence = 1.0;
  bool islistening = false;
  String text = "press the button and start speaking";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('confidence:${(confidence * 100).toStringAsFixed(1)}%'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: islistening,
        endRadius: 75,
        duration: Duration(milliseconds: 2000),
        repeatPauseDuration: Duration(milliseconds: 100),
        repeat: true,
        glowColor: Theme.of(context).primaryColor,
        child: FloatingActionButton(
          onPressed: startListening,
          child: Icon(islistening ? Icons.mic : Icons.mic_off),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: EdgeInsets.fromLTRB(30, 30, 30, 150),
          child: Text('$text'),
        ),
      ),
    );
  }

  void startListening() async {
    if (!islistening) {
      bool avaialable = await _speech.initialize(
          onStatus: (val) => print('$val'), onError: (val) => print('$val'));

      if (avaialable) {
        setState(() => islistening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            print(val);
            text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => islistening = false);
      _speech.stop();
    }
  }
}
