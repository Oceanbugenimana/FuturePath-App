import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onTimeout;
  const SplashScreen({super.key, required this.onTimeout});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _scale = Tween<double>(begin: 0.4, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));
    _ctrl.forward();

    Future.delayed(const Duration(seconds: 3), widget.onTimeout);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [kCyberBg, Color(0xFF10072B), kCyberBg],
        ),
      ),
      child: Center(
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) => Opacity(
            opacity: _fade.value,
            child: Transform.scale(
              scale: _scale.value,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: const LinearGradient(
                        colors: [kNeonTeal, kNeonPurple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: kNeonTeal.withOpacity(0.4),
                            blurRadius: 30,
                            spreadRadius: 4),
                      ],
                    ),
                    child: const Center(
                      child: Text('FP',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -1)),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text('FuturePath AI',
                      style: TextStyle(
                          color: kStellarWhite,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5)),
                  const SizedBox(height: 8),
                  Text('CAREER INTELLIGENCE ENGINE',
                      style: TextStyle(
                          color: kNeonTeal.withOpacity(0.8),
                          fontSize: 11,
                          letterSpacing: 3,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 160,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.white.withOpacity(0.08),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(kNeonTeal),
                      minHeight: 3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
