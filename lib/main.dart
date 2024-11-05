import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // 添加字体加载优化
  PlatformAssetBundle().loadStructuredData<void>(
    'FontManifest.json',
    (string) async {
      return; // 这里可以添加字体预加载逻辑
    },
  );

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
        // 考虑使用动态字体加载
        fontFamily: 'huiwen',
        // 设置透明背景
        scaffoldBackgroundColor: Colors.transparent,
        // 移除默认的水波纹效果
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      // 添加加载页面
      builder: (context, child) {
        return MediaQuery(
          // 设置最小宽度，防止内容过度压缩
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              clampDouble(
                MediaQuery.of(context).textScaleFactor,
                0.8,
                1.2,
              ),
            ),
          ),
          child: child!,
        );
      },
      home: const MyHomePage(title: '烟火簿'),
    );
  }

  Future<void> _loadInitialResources() async {
    // 在这里添加资源预加载逻辑
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
