import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'services/flash_card_service.dart';

class FlashCardGame extends StatefulWidget {
  const FlashCardGame({super.key});

  @override
  State<FlashCardGame> createState() => _FlashCardGameState();
}

class _FlashCardGameState extends State<FlashCardGame> {
  final FlashCardService _service = FlashCardService();
  List<Map<String, String>> _flashCards = [];
  bool _isLoading = true;
  int _currentIndex = 0;
  bool _showAnswer = false;

  @override
  void initState() {
    super.initState();
    _loadFlashCards();
  }

  Future<void> _loadFlashCards() async {
    try {
      final cards = await _service.loadFlashCards();
      setState(() {
        _flashCards = cards..shuffle();
        _isLoading = false;
      });
    } catch (e) {
      // 處理錯誤情況
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _nextCard() {
    if (_flashCards.isEmpty) return;
    setState(() {
      _currentIndex = (_currentIndex + 1) % _flashCards.length;
      _showAnswer = false;
    });
  }

  void _prevCard() {
    if (_flashCards.isEmpty) return;
    setState(() {
      _currentIndex =
          _currentIndex == 0 ? _flashCards.length - 1 : _currentIndex - 1;
      _showAnswer = false;
    });
  }

  void _toggleCard() {
    setState(() {
      _showAnswer = !_showAnswer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.book),
          onPressed: () {
            // 處理 leading 按鈕事件 (可選)
          },
        ),
        title: const Text("英文單字記憶卡"),
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _flashCards.isEmpty
              ? const Center(child: Text('沒有可用的單字卡'))
              : Center(
                  child: GestureDetector(
                    onTap: _toggleCard,
                    child: Card(
                      color: Colors.blue.shade100,
                      elevation: 4,
                      child: Container(
                        width: 300,
                        height: 200,
                        alignment: Alignment.center,
                        child: Text(
                          _showAnswer ? _flashCards[_currentIndex]["answer"]! : _flashCards[_currentIndex]["question"]!,
                          style: TextStyle(fontSize: 32, color: Colors.blue.shade900),
                        ),
                      ),
                    ),
                  ),
                ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _flashCards.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FloatingActionButton(
                      onPressed: _prevCard,
                      backgroundColor: Colors.blue,
                      tooltip: '上一個',
                      child: const Icon(Icons.navigate_before),
                    ),
                    FloatingActionButton(
                      onPressed: _nextCard,
                      backgroundColor: Colors.blue,
                      tooltip: '下一個',
                      child: const Icon(Icons.navigate_next),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}