import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'custom_game_screen.dart';
import 'settings_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Фон (замени путь если нужно)
          Image.asset(
            'assets/bg.jpg',
            fit: BoxFit.cover,
          ),

          // Затемнение
          Container(
            color: Colors.black.withOpacity(0.5),
          ),

          // Контент
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Who Am I',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),

                // 🟢 Start Game
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GameScreen()),
                    );
                  },
                  child: const Text('Start Game'),
                ),
                const SizedBox(height: 12),

                // 🟡 Custom Game
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CustomGameScreen()),
                    );
                  },
                  child: const Text('Custom Game'),
                ),
                const SizedBox(height: 12),

                // ⚙ Settings
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsPage()),
                    );
                  },
                  child: const Text('Settings'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
