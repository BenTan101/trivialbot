import 'package:flutter/material.dart';
import 'package:trivial_bot/word_button.dart';
import 'package:trivial_bot/word_controller.dart';

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
                    : Wrap(
                        children: getButtons(
                            sentence:
                                "In nuclear physics, atomic physics, and nuclear chemistry, the nuclear shell model is a model of the atomic nucleus which uses the Pauli exclusion principle to describe the structure of the nucleus in terms of energy levels.[1] The first shell model was proposed by Dmitry Ivanenko (together with E. Gapon) in 1932. The model was developed in 1949 following independent work by several physicists, most notably Eugene Paul Wigner, Maria Goeppert Mayer and J. Hans D. Jensen, who shared the 1963 Nobel Prize in Physics for their contributions."),
                        spacing: 10,
                        runSpacing: 10,
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
