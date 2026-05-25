import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/futurepath_viewmodel.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FuturePathViewModel>();
    final profile = vm.userProfile;
    final sim = vm.simulation;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting
          Text('Hello, Explorer 👋',
              style: TextStyle(color: kCyberGray.withOpacity(0.8), fontSize: 13)),
          const SizedBox(height: 4),
          const Text('Your Career Dashboard',
              style: TextStyle(
                  color: kStellarWhite,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          // XP bar
          CyberGlassCard(
            child: Column(
              children: [
                XpBar(xp: profile.xp, level: profile.level),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _miniStat('🔥', '${profile.streak}', 'Day Streak'),
                    _miniStat('⚡', '${profile.xp}', 'Total XP'),
                    _miniStat('🎯', '${profile.futureScore}%', 'Readiness'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Stats row
          Row(
            children: [
              Expanded(
                child: StatChip(
                  icon: Icons.trending_up,
                  value: sim?.optimisticSalary.split(' ').first ?? '--',
                  label: 'Best Case',
                  color: kSuccessGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatChip(
                  icon: Icons.balance,
                  value: sim?.realisticSalary.split(' ').first ?? '--',
                  label: 'Realistic',
                  color: kNeonTeal,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatChip(
                  icon: Icons.casino_outlined,
                  value: sim?.riskSalary.split(' ').first ?? '--',
                  label: 'High Risk',
                  color: kNeonPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Career paths
          if (sim != null) ...[
            const SectionHeader(
                title: 'Your Career Paths',
                subtitle: 'AI-generated based on your profile'),
            const SizedBox(height: 14),
            _careerCard(
              context,
              icon: Icons.rocket_launch,
              color: kSuccessGreen,
              tag: 'OPTIMISTIC',
              title: sim.optimisticTitle,
              brief: sim.optimisticBrief,
              salary: sim.optimisticSalary,
              onTap: () => vm.navigateTo('simulator'),
            ),
            const SizedBox(height: 12),
            _careerCard(
              context,
              icon: Icons.balance,
              color: kNeonTeal,
              tag: 'REALISTIC',
              title: sim.realisticTitle,
              brief: sim.realisticBrief,
              salary: sim.realisticSalary,
              onTap: () => vm.navigateTo('simulator'),
            ),
            const SizedBox(height: 12),
            _careerCard(
              context,
              icon: Icons.casino_outlined,
              color: kNeonPurple,
              tag: 'HIGH RISK',
              title: sim.riskTitle,
              brief: sim.riskBrief,
              salary: sim.riskSalary,
              onTap: () => vm.navigateTo('simulator'),
            ),
            const SizedBox(height: 24),
          ],

          // Quick actions
          const SectionHeader(title: 'Quick Actions'),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              _actionCard(context, Icons.map_outlined, 'Learning Roadmap',
                  kNeonTeal, () => vm.navigateTo('roadmap')),
              _actionCard(context, Icons.psychology_outlined, 'Skill Gap',
                  kNeonPurple, () => vm.navigateTo('skillgap')),
              _actionCard(context, Icons.smart_toy_outlined, 'AI Mentor',
                  kPremiumGold, () => vm.navigateTo('mentor')),
              _actionCard(context, Icons.science_outlined, 'Scenarios',
                  kDangerRed, () => vm.navigateTo('scenario')),
            ],
          ),
          const SizedBox(height: 24),

          // Daily reward
          GestureDetector(
            onTap: vm.claimDailyReward,
            child: CyberGlassCard(
              borderColor: kPremiumGold.withOpacity(0.3),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: kPremiumGold.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.card_giftcard,
                        color: kPremiumGold, size: 24),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Claim Daily Reward',
                            style: TextStyle(
                                color: kStellarWhite,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                        SizedBox(height: 2),
                        Text('+25 XP • Keep your streak alive!',
                            style:
                                TextStyle(color: kCyberGray, fontSize: 12)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: kPremiumGold),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: kStellarWhite,
                fontWeight: FontWeight.bold,
                fontSize: 15)),
        Text(label,
            style: const TextStyle(color: kCyberGray, fontSize: 10)),
      ],
    );
  }

  Widget _careerCard(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String tag,
    required String title,
    required String brief,
    required String salary,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CyberGlassCard(
        borderColor: color.withOpacity(0.25),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NeonBadge(label: tag, color: color),
                  const SizedBox(height: 4),
                  Text(title,
                      style: const TextStyle(
                          color: kStellarWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(brief,
                      style: const TextStyle(
                          color: kCyberGray, fontSize: 11),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(salary.split('/').first,
                    style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
                const Icon(Icons.chevron_right,
                    color: kCyberGray, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionCard(BuildContext context, IconData icon, String label,
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CyberGlassCard(
        padding: const EdgeInsets.all(14),
        borderColor: color.withOpacity(0.2),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(label,
                  style: const TextStyle(
                      color: kStellarWhite,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }
}
