import 'package:flutter/material.dart';
import 'package:trivial_bot/word_button.dart';
import 'package:trivial_bot/word_controller.dart';

import 'package:http/http.dart' as http;

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
      body: Padding(
          padding: const EdgeInsets.all(16.0),
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
                        children: getButtons(
                            sentence: snapshot.data!),
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
                  onPressed: () {
                    print(WordController.words);
                  },
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
          )),
    );
  }

  getButtons({required String sentence}) {
    // TODO: Stop words (https://gist.github.com/sebleier/554280)
    return sentence.split(' ').map((word) => WordButton(word: word)).toList();
  }
}

Future<String> fetchText() async {
  final response = await http
      .get(Uri.parse('https://pythonintegration.redblutac1.repl.co/text'),
  headers: {"Accept": "application/json","Access-Control-Allow-Origin": "*"});

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return response.body;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load text');
  }
}

class Page {
  final int ns;
  final int pageid;
  final String title;
  final String type;

  const Page({
    required this.ns,
    required this.pageid,
    required this.title,
    required this.type
  });

  factory Page.fromJson(Map<String, dynamic> json) {
    return Page(
      ns: json['ns'],
      pageid: json['pageid'],
      title: json['title'],
      type: json['type']
    );
  }
}
