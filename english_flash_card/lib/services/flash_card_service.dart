import 'dart:convert';
import 'package:flutter/services.dart';

class FlashCardService {
  /// 讀取單字卡資料
  Future<List<Map<String, String>>> loadFlashCards() async {
    // 讀取 JSON 文件
    final String response = await rootBundle.loadString('assets/data/word_list.json');
    final List<dynamic> data = json.decode(response);
    
    // 將動態資料轉換為正確的型別
    return data.map((item) => {
      'question': item['question'] as String,
      'answer': item['answer'] as String,
    }).toList();
  }
}