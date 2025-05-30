import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';
import 'theme_notifier.dart';
import 'locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: const WhoAmIApp(),
    ),
  );
}

class WhoAmIApp extends StatefulWidget {
  const WhoAmIApp({super.key});

  @override
  State<WhoAmIApp> createState() => _WhoAmIAppState();
}

class _WhoAmIAppState extends State<WhoAmIApp> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<LocaleProvider>(context).addListener(_onLocaleChanged);
  }

  @override
  void dispose() {
    Provider.of<LocaleProvider>(context, listen: false).removeListener(_onLocaleChanged);
    super.dispose();
  }

  void _onLocaleChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      title: 'Who Am I',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: themeNotifier.themeMode,
      locale: localeProvider.locale,
      supportedLocales: const [
        Locale('kk'),
        Locale('ru'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const HomePage(),
    );
  }
}
