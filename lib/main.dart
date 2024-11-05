import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // 使用更简单的方式来调试字体
  debugPrint('Starting app...');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '烟火簿',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3DDC84)),
        useMaterial3: true,
        fontFamily: 'huiwen',
      ),
      home: const MyHomePage(title: '烟火簿'),
    );
  }
}
