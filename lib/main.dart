import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trivial_bot/stop_words.dart';
import 'package:trivial_bot/word_button.dart';

// void main() async {
//   // Firebase initialisation.
//   WidgetsFlutterBinding.ensureInitialized();
//   await FirebaseAuth.instance.signInAnonymously();
//   await Firebase.initializeApp();
//
//   runApp(const MyApp());
// }

void main() => runApp(MaterialApp(
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.blue[100],
    ),
    home: const MyApp()));

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // boolean to show CircularProgressIndication
  // while Web Scraping awaits
  bool isLoading = false;
  late Future<String> futureText;

  @override
  void initState() {
    super.initState();
    futureText = fetchText();
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
                    // if isLoading is true show loader
                    // else show Column of Texts
                    isLoading
                        ? const CircularProgressIndicator()
                        : FutureBuilder<String>(
                            future: futureText,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Wrap(
                                  children:
                                      getButtons(sentence: snapshot.data!),
                                  spacing: 10,
                                  runSpacing: 10,
                                );
                              } else if (snapshot.hasError) {
                                return Text('${snapshot.error}');
                              }

                              // By default, show a loading spinner.
                              return const CircularProgressIndicator();
                            },
                          ),
                    const SizedBox(height: 30),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white70,
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
              ))),
    );
  }

  getButtons({required String sentence}) {
    // TODO: Stop words (https://gist.github.com/sebleier/554280)
    var words = sentence.split(' ');
    List<String> delimited = [words[0]];
    var isFirstWordAStopWord = stopWords
        .contains(words[0].toLowerCase().replaceAll(RegExp('[,.:;]'), ''));
    var isStopWord = isFirstWordAStopWord;
    if (isStopWord) {
      delimited.first = "__________${delimited.first}";
    }

    for (var word in words.getRange(1, words.length)) {
      if (stopWords
          .contains(word.toLowerCase().replaceAll(RegExp('[,.:;]'), ''))) {
        if (isStopWord) {
          delimited.last += ' $word';
          isStopWord = true;
        } else {
          delimited.add('__________$word');
          isStopWord = true;
        }
      } else {
        if (isStopWord) {
          delimited.add(word);
          isStopWord = false;
        } else {
          delimited.last += ' $word';
          isStopWord = false;
        }
      }
    }
    return delimited.map((word) => WordButton(word: word)).toList();
  }
}

Future<String> fetchText() async {
  final response = await http.get(
      Uri.parse('https://pythonintegration.redblutac1.repl.co/text'),
      headers: {
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*"
      });

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return jsonDecode(response.body)['body']['summary'];
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load text');
  }
}
