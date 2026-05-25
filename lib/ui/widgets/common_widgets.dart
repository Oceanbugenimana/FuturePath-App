import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ── Atmospheric background ─────────────────────────────────────
class AtmosphericBackground extends StatelessWidget {
  final Widget child;
  const AtmosphericBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: kCyberBg),
        // Top-left teal glow
        Positioned(
          top: -120,
          left: -100,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                kNeonTeal.withOpacity(0.15),
                kNeonTeal.withOpacity(0.03),
                Colors.transparent,
              ]),
            ),
          ),
        ),
        // Bottom-right purple glow
        Positioned(
          bottom: -120,
          right: -100,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                kNeonPurple.withOpacity(0.12),
                kNeonPurple.withOpacity(0.03),
                Colors.transparent,
              ]),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

// ── Glass card ─────────────────────────────────────────────────
class CyberGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color borderColor;

  const CyberGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderColor = const Color(0x1FFFFFFF),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
      ),
      padding: padding ?? const EdgeInsets.all(18),
      child: child,
    );
  }
}

// ── Neon badge ─────────────────────────────────────────────────
class NeonBadge extends StatelessWidget {
  final String label;
  final Color color;
  const NeonBadge({super.key, required this.label, this.color = kNeonTeal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8),
      ),
    );
  }
}

// ── Section header ─────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  const SectionHeader({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                color: kStellarWhite,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(subtitle!,
              style: TextStyle(
                  color: kCyberGray.withOpacity(0.8), fontSize: 12)),
        ],
      ],
    );
  }
}

// ── XP progress bar ────────────────────────────────────────────
class XpBar extends StatelessWidget {
  final int xp;
  final int level;
  const XpBar({super.key, required this.xp, required this.level});

  @override
  Widget build(BuildContext context) {
    final progress = (xp % 300) / 300.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Level $level',
                style: const TextStyle(
                    color: kNeonTeal,
                    fontSize: 11,
                    fontWeight: FontWeight.bold)),
            Text('$xp XP',
                style: const TextStyle(color: kCyberGray, fontSize: 11)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withOpacity(0.08),
            valueColor: const AlwaysStoppedAnimation<Color>(kNeonTeal),
            minHeight: 5,
          ),
        ),
      ],
    );
  }
}

// ── Stat chip ──────────────────────────────────────────────────
class StatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const StatChip({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.color = kNeonTeal,
  });

  @override
  Widget build(BuildContext context) {
    return CyberGlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(color: kCyberGray, fontSize: 10)),
        ],
      ),
    );
  }
}

// ── Loading overlay ────────────────────────────────────────────
class LoadingOverlay extends StatelessWidget {
  final String message;
  const LoadingOverlay({super.key, this.message = 'Processing...'});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kCyberBg.withOpacity(0.85),
      child: Center(
        child: CyberGlassCard(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: kNeonTeal),
              const SizedBox(height: 20),
              Text(message,
                  style: const TextStyle(
                      color: kStellarWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
