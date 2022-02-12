import 'package:flutter/material.dart';
import 'package:trivial_bot/globals.dart';

class WordButton extends StatefulWidget {
  final String word;

  const WordButton({Key? key, required this.word}) : super(key: key);

  @override
  _WordButtonState createState() => _WordButtonState();
}

class _WordButtonState extends State<WordButton> {
  String word = '';
  late bool isStopWord;

  @override
  void initState() {
    super.initState();
    word = widget.word;
    // isStopWord = stopWords.contains(word);
    isStopWord = word.contains('__________');
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        stringList.add(word);
        print(stringList);
      },
      child: Text(
        word.replaceAll(RegExp('__________'), ''),
        style: TextStyle(
          color: getColor(word, 900),
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: getColor(word, 200),
        minimumSize: Size.zero,
        padding: const EdgeInsets.all(15),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  getColor(String word, int i) {
    if (isStopWord) {
      return Colors.grey[i];
    } else {
      return Colors.blue[i];
    }
  }
}
