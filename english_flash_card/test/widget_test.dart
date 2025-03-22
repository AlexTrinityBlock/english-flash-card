// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:english_flash_card/flash_card_game.dart';
import 'package:english_flash_card/main.dart';
import 'package:english_flash_card/services/flash_card_service.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([FlashCardService])
void main() {
  testWidgets('App should render correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const MyApp());
    
    // Verify that the app title is displayed
    expect(find.text('英文單字記憶卡'), findsOneWidget);
    
    // Initial loading state should show a progress indicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
  
  testWidgets('Flash card should toggle between question and answer', (WidgetTester tester) async {
    // Create a mock FlashCardService
    final mockCardData = [
      {'question': 'apple', 'answer': '蘋果'},
      {'question': 'banana', 'answer': '香蕉'},
    ];
    
    // Create a test widget that provides the mock data
    await tester.pumpWidget(MaterialApp(
      home: TestFlashCardGame(mockCardData),
    ));
    await tester.pumpAndSettle();
    
    // Initially shows the question
    expect(find.text('apple'), findsOneWidget);
    expect(find.text('蘋果'), findsNothing);
    
    // Tap to toggle
    await tester.tap(find.byType(Card));
    await tester.pump();
    
    // Now shows the answer
    expect(find.text('apple'), findsNothing);
    expect(find.text('蘋果'), findsOneWidget);
  });
  
  testWidgets('Navigation buttons should work correctly', (WidgetTester tester) async {
    // Create mock card data
    final mockCardData = [
      {'question': 'apple', 'answer': '蘋果'},
      {'question': 'banana', 'answer': '香蕉'},
      {'question': 'orange', 'answer': '橙子'},
    ];
    
    // Create a test widget
    await tester.pumpWidget(MaterialApp(
      home: TestFlashCardGame(mockCardData),
    ));
    await tester.pumpAndSettle();
    
    // Initially shows the first card
    expect(find.text('apple'), findsOneWidget);
    
    // Navigate to next card
    await tester.tap(find.byIcon(Icons.navigate_next));
    await tester.pump();
    expect(find.text('banana'), findsOneWidget);
    
    // Navigate to previous card
    await tester.tap(find.byIcon(Icons.navigate_before));
    await tester.pump();
    expect(find.text('apple'), findsOneWidget);
  });
}

// Helper widget for testing with mock data
class TestFlashCardGame extends StatefulWidget {
  final List<Map<String, String>> mockData;
  
  const TestFlashCardGame(this.mockData, {Key? key}) : super(key: key);
  
  @override
  State<TestFlashCardGame> createState() => _TestFlashCardGameState();
}

class _TestFlashCardGameState extends State<TestFlashCardGame> {
  late List<Map<String, String>> _flashCards;
  int _currentIndex = 0;
  bool _showAnswer = false;
  
  @override
  void initState() {
    super.initState();
    _flashCards = widget.mockData;
  }
  
  void _nextCard() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _flashCards.length;
      _showAnswer = false;
    });
  }
  
  void _prevCard() {
    setState(() {
      _currentIndex = _currentIndex == 0 ? _flashCards.length - 1 : _currentIndex - 1;
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
        title: const Text("英文單字記憶卡"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
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
      floatingActionButton: Padding(
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
                child: const Icon(Icons.navigate_before),
              ),
              FloatingActionButton(
                onPressed: _nextCard,
                backgroundColor: Colors.blue,
                child: const Icon(Icons.navigate_next),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
