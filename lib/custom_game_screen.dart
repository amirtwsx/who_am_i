import 'package:flutter/material.dart';
import 'game_screen.dart';

class CustomGameScreen extends StatefulWidget {
  const CustomGameScreen({super.key});

  @override
  State<CustomGameScreen> createState() => _CustomGameScreenState();
}

class _CustomGameScreenState extends State<CustomGameScreen> {
  final TextEditingController _wordController = TextEditingController();

  String? _selectedCategory;
  final List<String> _categories = ['Животные', 'Профессии', 'Еда', 'Объекты'];

  final Map<String, List<String>> _wordsByCategory = {
    'Животные': ['Лев', 'Слон', 'Кошка', 'Собака', 'Жираф'],
    'Профессии': ['Врач', 'Учитель', 'Пожарный', 'Полицейский'],
    'Еда': ['Пицца', 'Суши', 'Бургер', 'Плов', 'Шашлык'],
    'Объекты': ['Стул', 'Телефон', 'Часы', 'Компьютер'],
  };

  void _fillRandomWord() {
    if (_selectedCategory == null) return;

    final words = _wordsByCategory[_selectedCategory]!;
    words.shuffle();
    setState(() {
      _wordController.text = words.first;
    });
  }

  void _startGame() {
    final word = _wordController.text.trim();
    if (word.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          initialWord: word,
          category: _selectedCategory,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Game')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Выберите категорию:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              hint: const Text('Категория'),
              onChanged: (value) => setState(() => _selectedCategory = value),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text('Введите или сгенерируйте слово:'),
            const SizedBox(height: 8),
            TextField(
              controller: _wordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Введите слово...',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _fillRandomWord,
                  icon: const Icon(Icons.shuffle),
                  label: const Text('Случайное слово'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _startGame,
                  child: const Text('Начать игру'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
