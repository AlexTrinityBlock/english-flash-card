import 'package:flutter/material.dart';
import 'flash_card_game.dart'; // 匯入剛才建立的小遊戲

// 主程式進入點
void main() {
  runApp(const MyApp());
}

// APP 主程式與樣式設定
class MyApp extends StatelessWidget {
  // 建立 MyApp 類別建構子
  const MyApp({super.key});
  // 覆寫 build 方法
  @override
  Widget build(BuildContext context) {
    // 回傳 MaterialApp 物件，MaterialApp 是 Flutter Material Design 組件
    return MaterialApp(
      // 這並不是APP上方標題，而是APP的名稱
      title: 'flash_card_game',
      // 主題配色設定
      theme: ThemeData(
        // 色彩主題設定，這邊採用藍色
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      // 引入主頁面
      home: const FlashCardGame(),
    );
  }
}
