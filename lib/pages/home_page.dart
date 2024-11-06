import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Version {
  final String version;
  final String date;
  final String description;
  final List<String> changes;

  const Version({
    required this.version,
    required this.date,
    required this.description,
    required this.changes,
  });
}

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

  // 添加布局相关的常量
  static const double _desktopBreakpoint = 900.0;
  static const double _tabletBreakpoint = 600.0;

  // 获取当前设备类型
  DeviceType _getDeviceType(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width >= _desktopBreakpoint) return DeviceType.desktop;
    if (width >= _tabletBreakpoint) return DeviceType.tablet;
    return DeviceType.mobile;
  }

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // 启动背景动画循环
    _startBackgroundAnimation();
  }

  void _startBackgroundAnimation() {
    Future.delayed(const Duration(seconds: 20), () {
      if (mounted) {
        setState(() {
          // 触发动画更新
        });
        _startBackgroundAnimation();
      }
    });
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
    final deviceType = _getDeviceType(context);
    final bool isDesktop = deviceType == DeviceType.desktop;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // 单一背景层，包含多个模糊渐变
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFFAFAFA),
            ),
            child: CustomPaint(
              painter: GradientBackgroundPainter(),
            ),
          ),
          // 内容层
          Center(
            child: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: screenHeight,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: 24.0,
                  ),
                  child: Center(
                    child: isDesktop
                        ? _buildDesktopLayout()
                        : _buildMobileLayout(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: _buildPhoneImage(),
            ),
            const SizedBox(width: 64),
            Expanded(
              flex: 1,
              child: _buildContent(),
            ),
          ],
        ),
        const SizedBox(height: 96),
        _buildVersionHistory(),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPhoneImage(),
        const SizedBox(height: 0),
        _buildContent(),
        const SizedBox(height: 64),
        _buildVersionHistory(),
      ],
    );
  }

  Widget _buildPhoneImage() {
    return FutureBuilder(
      // 使用 precacheImage 确保图片加载完成
      future: precacheImage(
        const AssetImage('lib/images/phone_035.png'),
        context,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return SizedBox(
            height: _getDeviceType(context) == DeviceType.mobile ? 600 : 900,
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(androidGreen),
              ),
            ),
          );
        }

        // 图片加载完成后再显示动画
        return FadeInLeft(
          duration: const Duration(milliseconds: 1200),
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: TweenAnimationBuilder(
              duration: const Duration(milliseconds: 800),
              tween: Tween<double>(begin: 0.0, end: 1.0),
              builder: (context, double value, child) {
                return Transform.translate(
                  offset: Offset(0.0, 20 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: Transform.scale(
                      scale: 0.95 + (0.05 * value),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        transform: Matrix4.identity()
                          ..translate(0.0, _isHovered ? -10.0 : 0.0),
                        child: Image.asset(
                          'lib/images/phone_035.png',
                          height: _getDeviceType(context) == DeviceType.mobile
                              ? 600
                              : 900,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    final deviceType = _getDeviceType(context);
    final titleSize = deviceType == DeviceType.mobile ? 32.0 : 48.0;
    final subtitleSize = deviceType == DeviceType.mobile ? 18.0 : 24.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: deviceType == DeviceType.mobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        DefaultTextStyle(
          style: TextStyle(
            fontSize: titleSize,
            color: const Color(0xFF333333),
            letterSpacing: 1.2,
            fontFamily: 'huiwen',
          ),
          textAlign: deviceType == DeviceType.mobile
              ? TextAlign.center
              : TextAlign.start,
          child: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                '烟火簿 Beta',
                speed: const Duration(milliseconds: 200),
              ),
            ],
            isRepeatingAnimation: false,
          ),
        ),
        const SizedBox(height: 24),
        FadeIn(
          delay: const Duration(milliseconds: 1500),
          duration: const Duration(milliseconds: 200),
          child: DefaultTextStyle(
            style: TextStyle(
              fontSize: subtitleSize,
              color: const Color(0xFF666666),
              letterSpacing: 0.5,
              fontFamily: 'danya',
            ),
            textAlign: deviceType == DeviceType.mobile
                ? TextAlign.center
                : TextAlign.start,
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  '一周食记，快速启程',
                  speed: const Duration(milliseconds: 150),
                ),
              ],
              isRepeatingAnimation: false,
              totalRepeatCount: 1,
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
            ),
          ),
        ),
        const SizedBox(height: 48),
        FadeInRight(
          delay: const Duration(milliseconds: 2800),
          duration: const Duration(milliseconds: 1000),
          child: _buildDownloadButtons(deviceType),
        ),
      ],
    );
  }

  Widget _buildDownloadButtons(DeviceType deviceType) {
    final buttonLayout = deviceType == DeviceType.mobile
        ? Column(
            children: _getDownloadButtons(spacing: 16.0, isVertical: true),
          )
        : Row(
            mainAxisAlignment: deviceType == DeviceType.mobile
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: _getDownloadButtons(spacing: 16.0, isVertical: false),
          );

    return buttonLayout;
  }

  List<Widget> _getDownloadButtons({
    required double spacing,
    required bool isVertical,
  }) {
    return [
      _buildDownloadButton(
        onPressed: () => _launchURL('http://47.104.253.90/app-release.apk'),
        icon: Icons.android,
        label: 'Android下载',
        isEnabled: true,
      ),
      isVertical ? SizedBox(height: spacing) : SizedBox(width: spacing),
      _buildDownloadButton(
        onPressed: null,
        icon: Icons.apple,
        label: 'iOS版本即将推出',
        isEnabled: false,
      ),
    ];
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

  final List<Version> _versions = const [
    Version(
      version: "v0.1.0",
      date: "2024-11-05",
      description: "Initial Beta Release",
      changes: [
        "Email login",
        "Basic meal plan management",
        "Swipe Logic demonstration",
      ],
    ),
    // Version(
    //   version: "v0.2.0",
    //   date: "2024-03-25",
    //   description: "Feature Update",
    //   changes: [
    //     "Data export feature",
    //     "UI improvements",
    //     "Bug fixes",
    //   ],
    // ),
  ];

  Widget _buildVersionHistory() {
    return FadeInUp(
      duration: const Duration(milliseconds: 1000),
      child: Column(
        children: [
          const Text(
            "Version History",
            style: TextStyle(
              fontSize: 24,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 32),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _versions.length,
              itemBuilder: (context, index) {
                final version = _versions[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: _buildVersionCard(version, index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionCard(Version version, int index) {
    return SlideInLeft(
      duration: Duration(milliseconds: 800 + (index * 200)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  version.version,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: androidGreen,
                  ),
                ),
                Text(
                  version.date,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              version.description,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 12),
            ...version.changes
                .map((change) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            color: androidGreen,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            change,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}

enum DeviceType {
  mobile,
  tablet,
  desktop,
}

// 添加自定义画布类
class GradientBackgroundPainter extends CustomPainter {
  const GradientBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100); // 增加模糊半径

    // 第一个渐变 - 亮紫色
    final gradient1 = RadialGradient(
      center: const Alignment(-0.5, -0.5),
      radius: 1.2,
      colors: [
        const Color(0xFF9C7EF3).withOpacity(0.25), // 更鲜艳的紫色
        Colors.transparent,
      ],
      stops: const [0.0, 0.7],
    );

    // 第二个渐变 - 青绿色
    final gradient2 = RadialGradient(
      center: const Alignment(0.8, 0.8),
      radius: 1.4,
      colors: [
        const Color(0xFF4AD9B0).withOpacity(0.2), // 更鲜艳的青绿色
        Colors.transparent,
      ],
      stops: const [0.0, 0.7],
    );

    // 第三个渐变 - 珊瑚粉色
    final gradient3 = RadialGradient(
      center: const Alignment(0.5, -0.2),
      radius: 1.0,
      colors: [
        const Color(0xFFFF7E7E).withOpacity(0.15), // 更鲜艳的珊瑚色
        Colors.transparent,
      ],
      stops: const [0.0, 0.7],
    );

    // 绘制渐变
    paint.shader = gradient1.createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, paint);

    paint.shader = gradient2.createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, paint);

    paint.shader = gradient3.createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(GradientBackgroundPainter oldDelegate) => false;
}
