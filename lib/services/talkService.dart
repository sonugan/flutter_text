import 'package:flutter_tts/flutter_tts.dart';

class TalkService {
  TalkService() {
    flutterTts = FlutterTts();
  }

  Future speach(String text) async {
    await flutterTts.setLanguage("es-AR");
    await flutterTts.setVolume(0.5);
    await flutterTts.setSpeechRate(1.0);
    await flutterTts.setPitch(0.4);
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
