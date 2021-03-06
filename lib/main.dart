import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trivial_bot/word_button.dart';

import 'globals.dart';

void main() async {
  // Firebase initialisation.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyB_EaR5_n-w3JW4yjhc50kkyjGLxnKZShw",
        authDomain: "trivial-bot-4.firebaseapp.com",
        databaseURL:
            "https://trivial-bot-4-default-rtdb.asia-southeast1.firebasedatabase.app",
        projectId: "trivial-bot-4",
        storageBucket: "trivial-bot-4.appspot.com",
        messagingSenderId: "680830530835",
        appId: "1:680830530835:web:1e013e356ba838d73616e6",
        measurementId: "G-G4T7PSGY4Y"),
  );

  runApp(MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.blue[100],
      ),
      home: const MyApp()));
}

// void main() => runApp(MaterialApp(
//     theme: ThemeData(
//       scaffoldBackgroundColor: Colors.blue[100],
//     ),
//     home: const MyApp()));

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // boolean to show CircularProgressIndication
  // while Web Scraping awaits
  bool isLoading = false;
  late Future<List<String>> futureTextAndTitle;
  late String text;
  late String title;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _mainCollection;

  @override
  void initState() {
    super.initState();
    futureTextAndTitle = fetchTextAndTitle();
    _mainCollection = _firestore.collection('data');
  }

  void _cancel() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => const MyApp(),
      ),
    );
    stringList.clear();
    positionList.clear();
  }

  Future<void> _submit() async {
    DocumentReference documentReferencer = _mainCollection.doc();
    List<String> phraseList = [];

    positionList.sort();

    for (var p = 0; p < positionList.length; p++) {
      if (p == 0) {
        phraseList.add(stringList.getRange(0, positionList[p] + 1).join(' '));
      } else {
        phraseList.add(stringList
            .getRange(positionList[p - 1] + 1, positionList[p] + 1)
            .join(' '));
      }
    }

    phraseList.add(stringList
        .getRange(positionList.last + 1, stringList.length)
        .join(' '));

    print(phraseList);
    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "sentence": text,
      "keys": phraseList,
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Notes item added to the database"))
        .catchError((e) => print(e));

    counter++;
    _cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Help us complete our CS project please thanks')),
      body: LayoutBuilder(
          builder: (context, constraints) => Padding(
              padding: EdgeInsets.symmetric(
                horizontal:
                    constraints.maxWidth * constraints.maxWidth * .00016,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isLoading
                        ? const CircularProgressIndicator()
                        : FutureBuilder<List<String>>(
                            future: futureTextAndTitle,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SelectableText(
                                      snapshot.data![1],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Wrap(
                                      children: getButtons(
                                        sentence: snapshot.data![0],
                                      ),
                                      runSpacing: 10,
                                    ),
                                  ],
                                );
                              } else if (snapshot.hasError) {
                                return Text('${snapshot.error}');
                              }

                              // By default, show a loading spinner.
                              return const CircularProgressIndicator();
                            },
                          ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: _cancel,
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.redAccent[200],
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 25,
                            ),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: () => _submit(),
                          child: const Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blueAccent[200],
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 25,
                            ),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "You've done $counter! Keep it up!",
                          style: TextStyle(
                            fontSize: 40,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ))),
    );
  }

  getButtons({required String sentence}) {
    title = cleanThing(title);
    text = cleanThing(sentence);

    stringList = text.split(RegExp('[\\s,???]+'));
    print(stringList);
    return stringList
        .mapIndexed(
            (position, word) => WordButton(word: word, position: position))
        .toList();

    if (sentence.contains(title)) {
      sentence = sentence.replaceAll(title, '__${title.replaceAll(' ', '__')}');
    }

    print('TITLE: $title');
    print('SENTENCE: $sentence');

    // TODO: Stop words (https://gist.github.com/sebleier/554280)
    var words = sentence.split(RegExp('[\\s,???]+'));

    // return words.map((word) => WordButton(word: word)).toList();

    List<String> delimited = [words[0]];
    var isFirstWordAStopWord =
        stopWords.contains(words[0].replaceAll(RegExp('["\',.:;]'), ''));
    var isStopWord = isFirstWordAStopWord;
    if (isStopWord) {
      delimited.first = "_stop_${delimited.first}";
    }

    for (var word in words.getRange(1, words.length)) {
      if (word.contains('__')) {
        delimited.add(word);
      } else if (stopWords.contains(word.replaceAll(RegExp('["\',.:;]'), ''))) {
        if (isStopWord) {
          if (delimited.last.contains('__')) {
            delimited.add('_stop_$word');
          } else {
            delimited.last += ' $word';
          }
          isStopWord = true;
        } else {
          delimited.add('_stop_$word');
          isStopWord = true;
        }
      } else {
        if (isStopWord) {
          delimited.add(word);
          isStopWord = false;
        } else {
          if (delimited.last.contains('__')) {
            delimited.add(word);
          } else {
            delimited.last += ' $word';
          }
          isStopWord = false;
        }
      }
    }
    // return delimited.map((word) => WordButton(word: word)).toList();
  }

  String cleanThing(String thing) {
    thing = thing
        .toLowerCase()
        .replaceAll('\n', '')
        .replaceAll('.', '')
        .replaceAll('&', 'and')
        .replaceAll(RegExp('\\((.*?)\\)'), '')
        .replaceAll(RegExp('\\[(.*?)\\]'), '')
        .replaceAll(RegExp('\\{(.*?)\\}'), '')
        .replaceAll(RegExp('\\((.*?)'), '')
        .replaceAll(RegExp('\\[(.*?)'), '')
        .replaceAll(RegExp('\\{(.*?)'), '')
        .replaceAll(RegExp('["\',.:;?!]'), '')
        .replaceAll(RegExp('\\s\\s+/g'), ' ')
        .trim();
    return thing;
  }

  Future<List<String>> fetchTextAndTitle() async {
    final response = await http.get(
        Uri.parse('https://pythonintegration.redblutac1.repl.co/text'),
        headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*"
        });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      text = jsonDecode(response.body)['body']['summary'];
      title = jsonDecode(response.body)['body']['title'];

      return [text, title];
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load text');
    }
  }
}
