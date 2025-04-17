import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'theme_notifier.dart';
import 'locale_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedLanguage = 'kk';

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.about),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Who am I is a fun guessing game where one player enters a secret word (like a person or object), '
                'and the other player asks yes/no questions to figure out what it is. '
                'It is designed for quick play sessions and can be used to build communication skills.\n\n',
              ),
              Text(
                'Credits',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Developed by Amirkhan Pernebek and Shyngyskhan Meiram in the scope of the course “Crossplatform Development” at Astana IT University.\n'
                'Mentor (Teacher): Assistant Professor Abzal Kyzyrkanov',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.close),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentTheme = themeNotifier.themeMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.theme,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ListTile(
              title: Text(AppLocalizations.of(context)!.system),
              leading: Radio(
                value: ThemeMode.system,
                groupValue: currentTheme,
                onChanged: (value) => themeNotifier.setTheme(value!),
              ),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.light),
              leading: Radio(
                value: ThemeMode.light,
                groupValue: currentTheme,
                onChanged: (value) => themeNotifier.setTheme(value!),
              ),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.dark),
              leading: Radio(
                value: ThemeMode.dark,
                groupValue: currentTheme,
                onChanged: (value) => themeNotifier.setTheme(value!),
              ),
            ),
            const SizedBox(height: 24),
            Text(AppLocalizations.of(context)!.language,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _selectedLanguage,
              onChanged: (value) {
                setState(() => _selectedLanguage = value!);
                Provider.of<LocaleProvider>(context, listen: false).setLocale(value!);
              },
              items: const [
                DropdownMenuItem(value: 'kk', child: Text('Қазақ')),
                DropdownMenuItem(value: 'ru', child: Text('Русский')),
                DropdownMenuItem(value: 'en', child: Text('English')),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _showInfoDialog,
              icon: const Icon(Icons.info_outline),
              label: Text(AppLocalizations.of(context)!.info),
            ),
          ],
        ),
      ),
    );
  }
}
