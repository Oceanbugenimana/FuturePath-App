import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

/// System Architecture Blueprint screen — mirrors ArchitectScreen in Kotlin
class ArchitectScreen extends StatelessWidget {
  const ArchitectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'System Blueprint',
            subtitle: 'FuturePath AI architecture overview',
          ),
          const SizedBox(height: 20),

          // Architecture diagram (text-based)
          CyberGlassCard(
            borderColor: kNeonTeal.withOpacity(0.25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.terminal, color: kNeonTeal, size: 18),
                    const SizedBox(width: 8),
                    const Text('App Architecture',
                        style: TextStyle(
                            color: kNeonTeal,
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 16),
                _archNode('UI Layer', 'Flutter Widgets + Provider',
                    Icons.phone_android_outlined, kNeonTeal),
                _arrow(),
                _archNode('ViewModel', 'FuturePathViewModel (ChangeNotifier)',
                    Icons.memory_outlined, kNeonPurple),
                _arrow(),
                _archNode('Repository', 'CareerRepository (Business Logic)',
                    Icons.hub_outlined, kPremiumGold),
                _arrow(),
                Row(
                  children: [
                    Expanded(
                      child: _archNode('Local DB', 'SQLite via sqflite',
                          Icons.storage_outlined, kSuccessGreen),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _archNode('Gemini API', 'REST via http package',
                          Icons.cloud_outlined, kDangerRed),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Tech stack
          const SectionHeader(title: 'Tech Stack'),
          const SizedBox(height: 14),
          ..._stack.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: CyberGlassCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: s.color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(s.icon, color: s.color, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.name,
                                style: const TextStyle(
                                    color: kStellarWhite,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13)),
                            Text(s.description,
                                style: const TextStyle(
                                    color: kCyberGray, fontSize: 11)),
                          ],
                        ),
                      ),
                      NeonBadge(label: s.version, color: s.color),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 20),

          // Screens map
          const SectionHeader(title: 'Screen Map'),
          const SizedBox(height: 14),
          CyberGlassCard(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _screens
                  .map((s) => NeonBadge(label: s, color: kNeonTeal))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _archNode(
      String title, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
                Text(subtitle,
                    style: const TextStyle(
                        color: kCyberGray, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _arrow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
      child: Column(
        children: [
          Container(width: 2, height: 12, color: kCyberGray.withOpacity(0.3)),
          Icon(Icons.arrow_downward,
              color: kCyberGray.withOpacity(0.4), size: 14),
        ],
      ),
    );
  }

  static const _stack = [
    _StackItem(
        icon: Icons.flutter_dash,
        color: kNeonTeal,
        name: 'Flutter',
        description: 'Cross-platform UI framework',
        version: '3.x'),
    _StackItem(
        icon: Icons.change_circle_outlined,
        color: kNeonPurple,
        name: 'Provider',
        description: 'State management',
        version: '6.x'),
    _StackItem(
        icon: Icons.storage_outlined,
        color: kSuccessGreen,
        name: 'sqflite',
        description: 'Local SQLite database',
        version: '2.x'),
    _StackItem(
        icon: Icons.cloud_outlined,
        color: kDangerRed,
        name: 'Gemini API',
        description: 'Google AI career intelligence',
        version: '1.5'),
    _StackItem(
        icon: Icons.show_chart,
        color: kPremiumGold,
        name: 'fl_chart',
        description: 'Salary trajectory charts',
        version: '0.68'),
  ];

  static const _screens = [
    'Splash',
    'Onboarding',
    'Auth',
    'Assessment',
    'Dashboard',
    'Career Simulator',
    'Salary Trajectory',
    'Learning Roadmap',
    'Skill Gap',
    'AI Mentor',
    'Future Scenarios',
    'Premium',
    'Blueprint',
  ];
}

class _StackItem {
  final IconData icon;
  final Color color;
  final String name;
  final String description;
  final String version;
  const _StackItem(
      {required this.icon,
      required this.color,
      required this.name,
      required this.description,
      required this.version});
}
