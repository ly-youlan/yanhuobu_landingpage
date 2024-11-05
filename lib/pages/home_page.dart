import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animate_do/animate_do.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  bool _isHovered = false;

  // Android品牌色
  static const androidGreen = Color(0xFF3DDC84);
  static const androidDarkGreen = Color(0xFF2DA866);

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw '无法打开链接 $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF2F2F2),
              Color(0xFFE5E5E5),
            ],
            stops: [0.0, 1.0],
            transform: GradientRotation(45 * 3.14 / 180), // 45度角旋转
            tileMode: TileMode.repeated, // 重复渐变
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: FadeInLeft(
                  duration: const Duration(milliseconds: 1200),
                  child: MouseRegion(
                    onEnter: (_) => setState(() => _isHovered = true),
                    onExit: (_) => setState(() => _isHovered = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      transform: Matrix4.identity()
                        ..translate(0.0, _isHovered ? -10.0 : 0.0),
                      child: Image.asset(
                        'lib/images/phone_035.png',
                        height: 600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 64),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInRight(
                      duration: const Duration(milliseconds: 1000),
                      child: const Text(
                        '测试烟火簿 Beta',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                          letterSpacing: 1.2,
                          fontFamily: 'huiwen',
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FadeInRight(
                      delay: const Duration(milliseconds: 200),
                      duration: const Duration(milliseconds: 1000),
                      child: const Text(
                        '一周食记，快速启程',
                        style: TextStyle(
                          fontSize: 24,
                          color: Color(0xFF666666),
                          letterSpacing: 0.5,
                          fontFamily: 'danya',
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    FadeInRight(
                      delay: const Duration(milliseconds: 400),
                      duration: const Duration(milliseconds: 1000),
                      child: Row(
                        children: [
                          _buildDownloadButton(
                            onPressed: () => _launchURL(
                                'https://publicityprobeijing.oss-cn-beijing.aliyuncs.com/app-release.apk'),
                            icon: Icons.android,
                            label: 'Android下载',
                            isEnabled: true,
                          ),
                          const SizedBox(width: 16),
                          _buildDownloadButton(
                            onPressed: null,
                            icon: Icons.apple,
                            label: 'iOS即将推出',
                            isEnabled: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
    required bool isEnabled,
  }) {
    return MouseRegion(
      cursor:
          isEnabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: isEnabled ? Colors.white : const Color(0xFF999999),
          ),
          label: Text(
            label,
            style: TextStyle(
              color: isEnabled ? Colors.white : const Color(0xFF999999),
              fontSize: 16,
              fontFamily: 'danya',
            ),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 20,
            ),
            backgroundColor: isEnabled ? androidGreen : const Color(0xFFE0E0E0),
            foregroundColor: Colors.white,
            elevation: isEnabled ? 8 : 0,
            shadowColor: isEnabled
                ? androidDarkGreen.withOpacity(0.3)
                : Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 在这里安全地访问 Theme
    debugPrint(
        'Current font family: ${Theme.of(context).textTheme.bodyLarge?.fontFamily}');
  }
}
