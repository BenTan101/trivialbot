import 'package:flutter/material.dart';

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
      primaryColor: Colors.blueGrey,
    ),
    home: const MyApp()));

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Strings to store the extracted Article titles
  String result1 = 'Result 1';
  String result2 = 'Result 2';
  String result3 = 'Result 3';

  // boolean to show CircularProgressIndication
  // while Web Scraping awaits
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help us complete our CS project please thanks')),
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
                            "The NUS (National University of Singapore) High School of Math and Science (NUSH) is a specialized independent high school in Singapore offering a six-year Integrated Programme (IP) leading to the NUS High School Diploma."),
                    spacing: 10,
                    runSpacing: 10,
                  ),
          ],
        )),
      ),
    );
  }

  getButtons({required String sentence}) {
    return sentence
        .split(' ')
        .map((word) => TextButton(
              onPressed: () {},
              child: Text(
                word,
                style: TextStyle(
                  color: Colors.blue[900],
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue[200],
                minimumSize: Size.zero,
                padding: const EdgeInsets.all(15),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ))
        .toList();
  }
}
