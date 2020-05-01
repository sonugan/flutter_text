// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:speech_recognition/speech_recognition.dart';
// import 'package:speech_to_text/speech_to_text.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: VoiceHome(),
//     );
//   }
// }

// class VoiceHome extends StatefulWidget {
//   @override
//   _VoiceHomeState createState() => _VoiceHomeState();
// }

// class _VoiceHomeState extends State<VoiceHome> {
//   SpeechRecognition _speechRecognition;
//   bool _isAvailable = false;
//   bool _isListening = false;

//   String resultText = "";

//   @override
//   void initState() {
//     super.initState();
//     initSpeechRecognizer();
//     initTextReader();
//   }

//   SpeechToText speech;
//   FlutterTts flutterTts;

//   void initSpeechRecognizer() {
//     speech = SpeechToText();
//     speech.initialize( onStatus: (e){}, onError: (e){} )
//     .then((res) => setState(() {
//       _isAvailable = res;
//     }));
    
//     _speechRecognition = SpeechRecognition();

//     _speechRecognition.setAvailabilityHandler(
//       (bool result) => setState((){
//         _isAvailable = result;
//       }),
//     );

//     _speechRecognition.setRecognitionStartedHandler(
//       () => setState((){
//         _isListening = true;
//       }),
//     );

//     _speechRecognition.setRecognitionResultHandler(
//       (String speech){
//         setState(() {
//           resultText = speech;
//         });
//       },
//     );

//     _speechRecognition.setRecognitionCompleteHandler(
//       () {
//         setState(() => _isListening = false);
//       },
//     );
//     _speechRecognition.activate().then(
//           (result) => setState(() => _isAvailable = result),
//         );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 FloatingActionButton(
//                   child: Icon(Icons.cancel),
//                   mini: true,
//                   backgroundColor: Colors.deepOrange,
//                   onPressed: () {
//                     if (_isListening)
//                       _speechRecognition.cancel().then(
//                             (result){
//                               setState(() {
//                                   _isListening = result;
//                                   resultText = "";
//                                 });},
//                           ).catchError((err){
//                             resultText = "";
//                           });
//                   },
//                 ),
//                 FloatingActionButton(
//                   child: Icon(Icons.mic),
//                   onPressed: () {
//                     if (_isAvailable && !_isListening)
//                       // speech.listen( onResult: (res) {
//                       //   setState(() {
//                       //     resultText = res.recognizedWords;
//                       //   });
//                       // });
//                       _speechRecognition
//                           .listen(locale: "es_AR")
//                           .then((result){
//                             //resultText = "";
//                           })
//                           .catchError((err){
//                             setState(() {
//                               resultText="errr";
//                             });
//                           })
//                           .whenComplete((){
//                             //resultText = "";
//                           });
//                   },
//                   backgroundColor: Colors.pink,
//                 ),
//                 FloatingActionButton(
//                   child: Icon(Icons.stop),
//                   mini: true,
//                   backgroundColor: Colors.deepPurple,
//                   onPressed: () {
//                     if (_isListening)
//                       _speechRecognition.stop().then(
//                             (result) => setState(() => _isListening = result),
//                           );
//                   },
//                 ),
//                 FloatingActionButton(
//                   child: Icon(Icons.chrome_reader_mode),
//                   onPressed: () {
//                     if(resultText != "") {
//                       flutterTts.speak(resultText).then((r){});
//                     }
//                   },
//                 )
//               ],
//             ),
//             Container(
//               width: MediaQuery.of(context).size.width * 0.8,
//               decoration: BoxDecoration(
//                 color: Colors.cyanAccent[100],
//                 borderRadius: BorderRadius.circular(6.0),
//               ),
//               padding: EdgeInsets.symmetric(
//                 vertical: 8.0,
//                 horizontal: 12.0,
//               ),
//               child: Text(
//                 resultText,
//                 style: TextStyle(fontSize: 24.0),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   void initTextReader() {
//     flutterTts = new FlutterTts();
//   }
// }
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _hasSpeech = false;
  bool _stressTest = false;
  double level = 0.0;
  int _stressLoops = 0;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = "";
  List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();

  @override
  void initState() {
    super.initState();
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (hasSpeech) {
      _localeNames = await speech.locales();

      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale.localeId;
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Speech to Text Example'),
        ),
        body: Column(children: [
          Center(
            child: Text(
              'Speech recognition available',
              style: TextStyle(fontSize: 22.0),
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                      child: Text('Initialize'),
                      onPressed: _hasSpeech ? null : initSpeechState,
                    ),
                    FlatButton(
                      child: Text('Stress Test'),
                      onPressed: stressTest,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                      child: Text('Start'),
                      onPressed: !_hasSpeech || speech.isListening
                          ? null
                          : startListening,
                    ),
                    FlatButton(
                      child: Text('Stop'),
                      onPressed: speech.isListening ? stopListening : null,
                    ),
                    FlatButton(
                      child: Text('Cancel'),
                      onPressed: speech.isListening ? cancelListening : null,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    DropdownButton(
                      onChanged: (selectedVal) => _switchLang(selectedVal),
                      value: _currentLocaleId,
                      items: _localeNames
                          .map(
                            (localeName) => DropdownMenuItem(
                              value: localeName.localeId,
                              child: Text(localeName.name),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              children: <Widget>[
                Center(
                  child: Text(
                    'Recognized Words',
                    style: TextStyle(fontSize: 22.0),
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        color: Theme.of(context).selectedRowColor,
                        child: Center(
                          child: Text(
                            lastWords,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        bottom: 10,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: .26,
                                    spreadRadius: level * 1.5,
                                    color: Colors.black.withOpacity(.05))
                              ],
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                            child: IconButton(icon: Icon(Icons.mic)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: <Widget>[
                Center(
                  child: Text(
                    'Error Status',
                    style: TextStyle(fontSize: 22.0),
                  ),
                ),
                Center(
                  child: Text(lastError),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            color: Theme.of(context).backgroundColor,
            child: Center(
              child: speech.isListening
                  ? Text(
                      "I'm listening...",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  : Text(
                      'Not listening',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ]),
      ),
    );
  }

  void stressTest() {
    if (_stressTest) {
      return;
    }
    _stressLoops = 0;
    _stressTest = true;
    print("Starting stress test...");
    startListening();
  }

  void changeStatusForStress(String status) {
    if (!_stressTest) {
      return;
    }
    if (speech.isListening) {
      stopListening();
    } else {
      if (_stressLoops >= 100) {
        _stressTest = false;
        print("Stress test complete.");
        return;
      }
      print("Stress loop: $_stressLoops");
      ++_stressLoops;
      startListening();
    }
  }

  void startListening() {
    lastWords = "";
    lastError = "";
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 30),
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        partialResults: true);
    setState(() {});
  }

  void stopListening() {
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = "${result.recognizedWords} - ${result.finalResult}";
    });
  }

  void soundLevelListener(double level) {
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    changeStatusForStress(status);
    setState(() {
      lastStatus = "$status";
    });
  }

  _switchLang(selectedVal) {
    setState(() {
      _currentLocaleId = selectedVal;
    });
    print(selectedVal);
  }
}
