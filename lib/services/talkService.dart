import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';

class TalkService {

  static TalkService _instance;
  static SpeechToText speech = SpeechToText();

  static TalkService getInstance() {
    if (_instance == null) {
      _instance = new TalkService();
      speech.initialize( onStatus: statusListener, onError: errorListener ).then((res) {

      });
    }
    return _instance;
  }

  TalkService() {
    flutterTts = FlutterTts();
  }

  Future listen(void Function() okFunc, void Function() noOkFunc) async {
    speech.listen(
        onResult: (res) {
          print(res.recognizedWords);
          if (isOkCommand(res.recognizedWords)) {
            okFunc();
          } else if (isNoOkCommand(res.recognizedWords)) {
            noOkFunc();
          }
        },
        listenFor: Duration(seconds: 10),
        cancelOnError: true,);
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

  static void errorListener(SpeechRecognitionError error) {
    print("Received error status: $error, listening: ${speech.isListening}");
  }

  static void statusListener(String status) {
    print("Received listener status: $status, listening: ${speech.isListening}");
  }

  static bool isOkCommand(String text) {
    return text == "tarea finalizada";
  }

  static bool isNoOkCommand(String text) {
    return text == "no finalizada";
  }
}