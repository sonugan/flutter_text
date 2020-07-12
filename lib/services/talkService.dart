import 'package:flutter_tts/flutter_tts.dart';

class TalkService {
  TalkService() {
    flutterTts = FlutterTts();
  }

  Future speach(String text) async {
    await flutterTts.setLanguage("es-AR");
    await flutterTts.setVolume(.5);
    await flutterTts.setSpeechRate(0.8);
    await flutterTts.setPitch(.9);
    if (text != null) {
      if (text.isNotEmpty) {
        await flutterTts.speak(text)
        .then((e) {
          print(e);
        })
        .catchError((e) {
          print(e);
        });
      }
    }
  }

  FlutterTts flutterTts;
}
