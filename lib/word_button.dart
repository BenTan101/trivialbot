import 'package:flutter/material.dart';

import 'globals.dart';

class WordButton extends StatefulWidget {
  final String word;
  final int position;

  const WordButton({
    Key? key,
    required this.word,
    required this.position,
  }) : super(key: key);

  @override
  _WordButtonState createState() => _WordButtonState();
}

class _WordButtonState extends State<WordButton> {
  String word = '';
  int position = -1;

  // late bool isStopWord;
  // late bool isTitle;
  bool _hasBeenPressed = false;

  @override
  void initState() {
    super.initState();
    word = widget.word;
    position = widget.position;
    // isStopWord = stopWords.contains(word);
    // isStopWord = word.contains('_stop_');
    // isTitle = word.contains('__');
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Text(
          word,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              if (!_hasBeenPressed) {
                positionList.add(position);
              } else {
                positionList.remove(position);
              }
              print(positionList);
              _hasBeenPressed = !_hasBeenPressed;
            });
          },
          child: Text(
            '|',
            style: TextStyle(
              fontSize: 30,
              color: _hasBeenPressed ? Colors.blue[500] : Colors.transparent,
            ),
          ),
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.center,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
      crossAxisAlignment: WrapCrossAlignment.center,
    );
    // return TextButton(
    // onPressed:
    //     () {
    // if (!isStopWord & !isTitle) {
    //   stringList.add(word);
    //   print(stringList);
    //   setState(() {
    //     _hasBeenPressed = true;
    //   });
    // }
    // },
    // child: Text(
    //   word.contains('__')
    //       ? word.replaceAll('__', ' ').substring(1)
    //       : word.replaceAll(RegExp('_stop_'), ''),
    //   style: TextStyle(
    //     color: getColor(word, 900),
    //   ),
    // ),
    //   style: TextButton.styleFrom(
    //     // backgroundColor: _hasBeenPressed ? getColor(word, 500) : getColor(word, 200),
    //     minimumSize: Size.zero,
    //     padding: const EdgeInsets.all(15),
    //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    //   ),
    // );
  }

// getColor(String word, int i) {
//   if (isStopWord) {
//     return Colors.grey[i];
//   } else if (isTitle) {
//     return Colors.green[i];
//   } else {
//     return Colors.blue[i];
//   }
// }
}
