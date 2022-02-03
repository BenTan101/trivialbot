import 'package:flutter/material.dart';
import 'package:trivial_bot/word_controller.dart';

class WordButton extends StatefulWidget {
  final String word;
  final bool isSelected = false;
  final WordController wordController = WordController();

  WordButton({Key? key, required this.word}) : super(key: key);

  @override
  _WordButtonState createState() => _WordButtonState();
}

class _WordButtonState extends State<WordButton> {
  String word = '';
  bool isSelected = false;
  late WordController wordController;

  @override
  void initState() {
    super.initState();
    word = widget.word;
    isSelected = widget.isSelected;
    wordController = widget.wordController;
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        setState(() {
          isSelected = !isSelected;
          if (isSelected) {
            wordController.addWord(word);
          } else {
            wordController.deleteWord(word);
          }
        });
      },
      child: Text(
        widget.word,
        style: TextStyle(
          color: isSelected ? Colors.green[900] : Colors.blue[900],
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: isSelected ? Colors.green[200] : Colors.blue[200],
        minimumSize: Size.zero,
        padding: const EdgeInsets.all(15),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
