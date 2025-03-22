import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'services/flash_card_service.dart';

// 英文單字記憶卡遊戲
// 這是一個 StatefulWidget，因為遊戲中的狀態會隨著使用者操作而改變
class FlashCardGame extends StatefulWidget {
  const FlashCardGame({super.key});
  // 覆寫 createState 方法，建立並回傳 FlashCardGameState 物件
  @override
  State<FlashCardGame> createState() => _FlashCardGameState();
}

// 遊戲本體
// 這是 FlashCardGame 的狀態類別，繼承自 State 類別
class _FlashCardGameState extends State<FlashCardGame> {
  // 實例化 FlashCardService 類別，該類別用來讀取單字卡資料
  final FlashCardService _service = FlashCardService();
  // 這是一個 List，用來存放單字卡資料，單字卡結構為 Map<String, String>，包含單字與中文翻譯
  List<Map<String, String>> _flashCards = [];
  // 判斷是否正在載入資料
  bool _isLoading = true;
  // 當前顯示的單字是第幾張
  int _currentIndex = 0;
  // 是否顯示中文翻譯
  bool _showAnswer = false;

  // 覆寫 initState 方法，初始化狀態
  @override
  void initState() {
    super.initState();
    _loadFlashCards();
  }

  //非同步方法，載入單字卡資料 
  Future<void> _loadFlashCards() async {
    try {
      // 使用 FlashCardService 類別的 loadFlashCards 方法載入單字卡資料
      final cards = await _service.loadFlashCards();
      // 更新狀態
      setState(() {
        // 將載入的單字卡資料洗牌後存入 _flashCards
        _flashCards = cards..shuffle();
        // 載入完成
        _isLoading = false;
      });
    } catch (e) {
      // 處理錯誤情況
      setState(() {
        // 載入失敗，仍然顯示載入完成，但是後續段落顯示沒有可用的單字卡
        _isLoading = false;
      });
    }
  }

  // 下一張卡功能函數
  void _nextCard() {
    // 如果沒有單字卡，則不執行
    if (_flashCards.isEmpty) return;
    // 更新狀態
    setState(() {
      // 將 _currentIndex 加一，如果超過陣列長度，則回到第一張
      _currentIndex = (_currentIndex + 1) % _flashCards.length;
      // 顯示答案設為 false，顯示英文一面
      _showAnswer = false;
    });
  }

  // 上一張卡功能函數
  void _prevCard() {
    // 如果沒有單字卡，則不執行
    if (_flashCards.isEmpty) return;
    // 更新狀態
    setState(() {
      // 將 _currentIndex 減一，如果小於零，則回到最後一張
      _currentIndex =
          _currentIndex == 0 ? _flashCards.length - 1 : _currentIndex - 1;
      // 顯示答案設為 false，顯示英文一面
      _showAnswer = false;
    });
  }

  // 翻轉卡片功能函數
  void _toggleCard() {
    setState(() {
      _showAnswer = !_showAnswer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar 是應用程式的頂部欄位
      appBar: AppBar(
        // leading 是 AppBar 小標籤
        leading: IconButton(
          // 這邊使用 FontAwesomeIcons.book 來顯示一本書的圖示
          icon: const Icon(FontAwesomeIcons.book),
          // onPressed 是按鈕事件，沒有設定任何功能
          onPressed: () {
            // 處理 leading 按鈕事件 (可選)
          },
        ),
        // 上方文字標題
        title: const Text("英文單字記憶卡"),
        // AppBar 的背景顏色
        backgroundColor: Colors.blue,
      ),
      body:
          // 假如正在載入資料
          _isLoading
              // 顯示進度條
              ? const Center(child: CircularProgressIndicator())
              // 假如沒在載入資料，同時沒有單字卡
              : _flashCards.isEmpty
              // 顯示沒有可用的單字卡
              ? const Center(child: Text('沒有可用的單字卡'))
              // 假如沒在載入資料，且有單字卡
              : Center(
                // 偵測手指接觸到卡片的事件
                child: GestureDetector(
                  // onTap 是點擊事件，當點擊卡片時，執行 _toggleCard 翻牌
                  onTap: _toggleCard,
                  // 卡片元件
                  child: Card(
                    // 卡片顏色
                    color: Colors.blue.shade100,
                    // 卡片陰影
                    elevation: 4,
                    // 卡片內容
                    child: Container(
                      // 卡片寬高
                      width: 300,
                      height: 200,
                      // 卡片內容置中
                      alignment: Alignment.center,
                      // 卡片內容
                      child: Text(
                        // 假如 _showAnswer 為 true，顯示中文，否則顯示英文
                        _showAnswer
                            // 顯示中文
                            ? _flashCards[_currentIndex]["answer"]!
                            // 顯示英文
                            : _flashCards[_currentIndex]["question"]!,
                        // 文字樣式
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      // FloatingActionButton 下方浮動按鈕置中，FloatingActionButton 在 APP 語境中是一個下排浮動按鈕
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // 下方浮動按鈕，其實是浮動按鈕列
      floatingActionButton:
          // 假如沒有單字卡，則不顯示下方浮動按鈕      
          _flashCards.isEmpty
              ? null
              // 顯示下方浮動按鈕
              // 對外側保留 8 個像素的間距
              : Padding(
                padding: const EdgeInsets.all(8.0),
                // Container，雖然可以直接用 Row，但是 Container 可以設定 padding
                child: Container(
                  // 水平方向 padding 16 像素
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  // 寬度為螢幕寬度
                  width: MediaQuery.of(context).size.width,
                  // Row 是水平排列的元件
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
