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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF2F2F2),
              Color(0xFFE5E5E5),
            ],
            stops: [0.0, 1.0],
            transform: GradientRotation(45 * 3.14 / 180),
            tileMode: TileMode.repeated,
          ),
        ),
        child: Center(
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
                  child:
                      isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
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
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildContent(),
        const SizedBox(height: 32),
        _buildPhoneImage(),
      ],
    );
  }

  Widget _buildPhoneImage() {
    return FadeInLeft(
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
            height: _getDeviceType(context) == DeviceType.mobile ? 400 : 600,
          ),
        ),
      ),
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
        FadeInRight(
          duration: const Duration(milliseconds: 1000),
          child: Text(
            '测试烟火簿 Beta',
            style: TextStyle(
              fontSize: titleSize,
              color: const Color(0xFF333333),
              letterSpacing: 1.2,
              fontFamily: 'huiwen',
            ),
            textAlign: deviceType == DeviceType.mobile
                ? TextAlign.center
                : TextAlign.start,
          ),
        ),
        const SizedBox(height: 24),
        FadeInRight(
          delay: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 1000),
          child: Text(
            '一周食记，快速启程',
            style: TextStyle(
              fontSize: subtitleSize,
              color: const Color(0xFF666666),
              letterSpacing: 0.5,
              fontFamily: 'danya',
            ),
            textAlign: deviceType == DeviceType.mobile
                ? TextAlign.center
                : TextAlign.start,
          ),
        ),
        const SizedBox(height: 48),
        FadeInRight(
          delay: const Duration(milliseconds: 400),
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
        onPressed: () => _launchURL(
            'https://publicitypro.oss-cn-shenzhen.aliyuncs.com/landingpage/app-release.apk'),
        icon: Icons.android,
        label: 'Android下载',
        isEnabled: true,
      ),
      isVertical ? SizedBox(height: spacing) : SizedBox(width: spacing),
      _buildDownloadButton(
        onPressed: null,
        icon: Icons.apple,
        label: 'iOS即将推出',
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
}

enum DeviceType {
  mobile,
  tablet,
  desktop,
}
