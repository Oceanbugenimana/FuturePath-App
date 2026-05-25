import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/futurepath_viewmodel.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  static const _features = [
    _Feature(
        icon: Icons.all_inclusive,
        label: 'Unlimited AI Simulations',
        free: false),
    _Feature(
        icon: Icons.smart_toy,
        label: 'Priority Alpha-9 Responses',
        free: false),
    _Feature(
        icon: Icons.show_chart,
        label: 'Advanced Salary Analytics',
        free: false),
    _Feature(
        icon: Icons.download_outlined,
        label: 'Export Roadmap as PDF',
        free: false),
    _Feature(
        icon: Icons.rocket_launch_outlined,
        label: 'Basic Career Simulation',
        free: true),
    _Feature(
        icon: Icons.map_outlined, label: 'Learning Roadmap', free: true),
    _Feature(
        icon: Icons.psychology_outlined,
        label: 'Skill Gap Analysis',
        free: true),
    _Feature(
        icon: Icons.chat_bubble_outline,
        label: 'AI Mentor Chat',
        free: true),
  ];

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FuturePathViewModel>();
    final isPremium = vm.userProfile.isPremium;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero
          CyberGlassCard(
            borderColor: kPremiumGold.withOpacity(0.4),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kPremiumGold.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.workspace_premium,
                      color: kPremiumGold, size: 40),
                ),
                const SizedBox(height: 16),
                const Text('FuturePath PRO',
                    style: TextStyle(
                        color: kPremiumGold,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text(
                    'Unlock the full power of AI career intelligence',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: kCyberGray, fontSize: 14)),
                const SizedBox(height: 20),
                if (!isPremium) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('\$9',
                          style: TextStyle(
                              color: kStellarWhite,
                              fontSize: 36,
                              fontWeight: FontWeight.bold)),
                      const Text('.99',
                          style: TextStyle(
                              color: kStellarWhite,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(width: 4),
                      Text('/month',
                          style: TextStyle(
                              color: kCyberGray.withOpacity(0.8),
                              fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPremiumGold,
                        foregroundColor: kCyberBg,
                      ),
                      onPressed: () => vm.togglePremium(true),
                      child: const Text('Upgrade to PRO'),
                    ),
                  ),
                ] else ...[
                  NeonBadge(label: 'ACTIVE PRO MEMBER', color: kPremiumGold),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => vm.togglePremium(false),
                    child: const Text('Cancel Subscription',
                        style: TextStyle(color: kCyberGray, fontSize: 12)),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Feature comparison
          const SectionHeader(
              title: 'What\'s Included',
              subtitle: 'Compare Free vs PRO'),
          const SizedBox(height: 14),
          CyberGlassCard(
            child: Column(
              children: [
                // Header row
                Row(
                  children: [
                    const Expanded(
                        child: Text('Feature',
                            style: TextStyle(
                                color: kCyberGray,
                                fontSize: 11,
                                fontWeight: FontWeight.w600))),
                    _colHeader('FREE', kCyberGray),
                    const SizedBox(width: 16),
                    _colHeader('PRO', kPremiumGold),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(color: Color(0x1AFFFFFF)),
                const SizedBox(height: 8),
                ..._features.map((f) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Icon(f.icon, color: kCyberGray, size: 16),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(f.label,
                                style: const TextStyle(
                                    color: kStellarWhite, fontSize: 13)),
                          ),
                          _checkIcon(f.free, kCyberGray),
                          const SizedBox(width: 28),
                          _checkIcon(true, kPremiumGold),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Themes
          const SectionHeader(title: 'App Themes'),
          const SizedBox(height: 14),
          Row(
            children: [
              _themeChip(context, vm, 'default', 'Cyber Dark', kNeonTeal),
              const SizedBox(width: 10),
              _themeChip(context, vm, 'purple', 'Neon Purple', kNeonPurple),
              const SizedBox(width: 10),
              _themeChip(context, vm, 'gold', 'Premium Gold', kPremiumGold),
            ],
          ),
        ],
      ),
    );
  }

  Widget _colHeader(String label, Color color) {
    return SizedBox(
      width: 36,
      child: Text(label,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5)),
    );
  }

  Widget _checkIcon(bool checked, Color color) {
    return SizedBox(
      width: 36,
      child: Icon(
        checked ? Icons.check_circle : Icons.cancel_outlined,
        color: checked ? color : kCyberGray.withOpacity(0.3),
        size: 18,
      ),
    );
  }

  Widget _themeChip(BuildContext context, FuturePathViewModel vm,
      String theme, String label, Color color) {
    final selected = vm.userProfile.favoriteTheme == theme;
    return Expanded(
      child: GestureDetector(
        onTap: () => vm.setFavoriteTheme(theme),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? color.withOpacity(0.15)
                : Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? color.withOpacity(0.5)
                  : Colors.white.withOpacity(0.08),
            ),
          ),
          child: Column(
            children: [
              Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      color: color, shape: BoxShape.circle)),
              const SizedBox(height: 6),
              Text(label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: selected ? color : kCyberGray,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Feature {
  final IconData icon;
  final String label;
  final bool free;
  const _Feature(
      {required this.icon, required this.label, required this.free});
}
