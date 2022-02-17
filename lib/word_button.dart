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
  late bool isTitle;

  @override
  void initState() {
    super.initState();
    word = widget.word;
    // isStopWord = stopWords.contains(word);
    isStopWord = word.contains('_stop_');
    isTitle = word.contains('__');
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        stringList.add(word);
        print(stringList);
      },
      child: Text(
        word.contains('__')
            ? word.replaceAll('__', ' ').substring(1)
            : word.replaceAll(RegExp('_stop_'), ''),
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
    } else if (isTitle) {
      return Colors.green[i];
    } else {
      return Colors.blue[i];
    }
  }
}
