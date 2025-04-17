import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  final String? initialWord;
  final String? category;

  const GameScreen({
    super.key,
    this.initialWord,
    this.category,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _questionController = TextEditingController();

  final List<Map<String, String>> _qaHistory = [];
  String? _hiddenWord;
  String? _currentQuestion;
  int _guessAttempts = 0;

  @override
  void initState() {
    super.initState();
    if (widget.initialWord != null) {
      _hiddenWord = widget.initialWord;
    }
  }

  void _submitHiddenWord() {
    if (_wordController.text.trim().isEmpty) return;
    setState(() {
      _hiddenWord = _wordController.text.trim();
    });
  }

  void _submitQuestion() {
    if (_questionController.text.trim().isEmpty) return;
    setState(() {
      _currentQuestion = _questionController.text.trim();
      _questionController.clear();
    });
  }

  void _submitAnswer(String answer) {
    if (_currentQuestion == null) return;
    setState(() {
      _qaHistory.add({'question': _currentQuestion!, 'answer': answer});
      _currentQuestion = null;
    });
  }

  void _restartGame() {
    setState(() {
      _qaHistory.clear();
      _hiddenWord = null;
      _currentQuestion = null;
      _guessAttempts = 0;
      _wordController.clear();
      _questionController.clear();
    });
  }

  void _showHiddenWord() {
    if (_hiddenWord == null) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Загаданное слово'),
        content: Text(_hiddenWord!),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _guessWordDialog() {
    final TextEditingController guessController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Попробуй угадать слово'),
        content: TextField(
          controller: guessController,
          decoration: const InputDecoration(hintText: 'Введите слово'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final guess = guessController.text.trim().toLowerCase();
              final correct = _hiddenWord?.trim().toLowerCase();

              Navigator.pop(context);

              if (guess == correct) {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('✅ Угадано!'),
                    content: const Text('Поздравляем! Ты угадал слово.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _restartGame();
                        },
                        child: const Text('Новый раунд'),
                      )
                    ],
                  ),
                );
              } else {
                _guessAttempts++;
                if (_guessAttempts >= 3) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('😢 Не угадал'),
                      content: Text('Правильный ответ: "$_hiddenWord"'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _restartGame();
                          },
                          child: const Text('Новый раунд'),
                        )
                      ],
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('❌ Неверно'),
                      content: Text('Осталось попыток: ${3 - _guessAttempts}'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        )
                      ],
                    ),
                  );
                }
              }
            },
            child: const Text('Проверить'),
          ),
        ],
      ),
    );
  }

  Widget _buildWordEntry() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Игрок 1: Введите загаданное слово или персонажа'),
          const SizedBox(height: 16),
          TextField(
            controller: _wordController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Слово',
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitHiddenWord,
            child: const Text('Подтвердить'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionInput() {
    return Column(
      children: [
        if (widget.category != null)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              'Категория: ${widget.category}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Expanded(
          child: _qaHistory.isEmpty
              ? const Center(child: Text('Пока нет вопросов.'))
              : ListView.builder(
                  itemCount: _qaHistory.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (_, index) {
                    final item = _qaHistory[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('❓ Вопрос: ${item['question']}'),
                        Text('✔ Ответ: ${item['answer']}'),
                        const Divider(),
                      ],
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _questionController,
                decoration: const InputDecoration(
                  labelText: 'Игрок 2: Введите вопрос',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _submitQuestion,
                child: const Text('Задать вопрос и передать телефон игроку 1'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnswerInput() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Игрок 1, ответьте на вопрос:',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          Text(
            '❓ ${_currentQuestion!}',
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: () => _submitAnswer('Да'), child: const Text('Да')),
              ElevatedButton(onPressed: () => _submitAnswer('Нет'), child: const Text('Нет')),
              ElevatedButton(onPressed: () => _submitAnswer('Не знаю'), child: const Text('Не знаю')),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (_hiddenWord == null) {
      content = _buildWordEntry();
    } else if (_currentQuestion != null) {
      content = _buildAnswerInput();
    } else {
      content = _buildQuestionInput();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Who Am I - Игра'),
        actions: [
          IconButton(
            onPressed: _hiddenWord == null ? null : _showHiddenWord,
            icon: const Icon(Icons.visibility),
            tooltip: 'Показать слово',
          ),
          IconButton(
            onPressed: _hiddenWord == null ? null : _guessWordDialog,
            icon: const Icon(Icons.question_mark),
            tooltip: 'Угадать слово',
          ),
          IconButton(
            onPressed: _restartGame,
            icon: const Icon(Icons.restart_alt),
            tooltip: 'Новая игра',
          ),
        ],
      ),
      body: content,
    );
  }
}
