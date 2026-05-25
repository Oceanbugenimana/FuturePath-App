import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/futurepath_viewmodel.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class CareerSimulatorScreen extends StatelessWidget {
  const CareerSimulatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FuturePathViewModel>();
    final sim = vm.simulation;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Career Simulator',
            subtitle: 'Your 3 AI-generated future paths',
          ),
          const SizedBox(height: 20),

          if (sim == null) ...[
            CyberGlassCard(
              child: Column(
                children: [
                  const Icon(Icons.rocket_launch_outlined,
                      color: kNeonTeal, size: 48),
                  const SizedBox(height: 16),
                  const Text('No simulation yet',
                      style: TextStyle(
                          color: kStellarWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text(
                      'Complete your profile assessment to generate your career paths.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: kCyberGray, fontSize: 13)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => vm.navigateTo('assessment'),
                    child: const Text('Run Assessment'),
                  ),
                ],
              ),
            ),
          ] else ...[
            _pathCard(
              icon: Icons.rocket_launch,
              color: kSuccessGreen,
              tag: 'OPTIMISTIC PATH',
              title: sim.optimisticTitle,
              brief: sim.optimisticBrief,
              salary: sim.optimisticSalary,
              details: sim.optimisticDetails,
            ),
            const SizedBox(height: 16),
            _pathCard(
              icon: Icons.balance,
              color: kNeonTeal,
              tag: 'REALISTIC PATH',
              title: sim.realisticTitle,
              brief: sim.realisticBrief,
              salary: sim.realisticSalary,
              details: sim.realisticDetails,
            ),
            const SizedBox(height: 16),
            _pathCard(
              icon: Icons.casino_outlined,
              color: kNeonPurple,
              tag: 'HIGH RISK / HIGH REWARD',
              title: sim.riskTitle,
              brief: sim.riskBrief,
              salary: sim.riskSalary,
              details: sim.riskDetails,
            ),
            const SizedBox(height: 24),

            // Sub-navigation
            const SectionHeader(title: 'Explore Further'),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _navButton(
                    context,
                    icon: Icons.show_chart,
                    label: 'Salary Trajectory',
                    color: kNeonTeal,
                    onTap: () => vm.navigateTo('salary'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _navButton(
                    context,
                    icon: Icons.map_outlined,
                    label: 'Learning Roadmap',
                    color: kNeonPurple,
                    onTap: () => vm.navigateTo('roadmap'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _navButton(
                    context,
                    icon: Icons.psychology_outlined,
                    label: 'Skill Gap',
                    color: kPremiumGold,
                    onTap: () => vm.navigateTo('skillgap'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _navButton(
                    context,
                    icon: Icons.refresh,
                    label: 'Re-run Simulation',
                    color: kDangerRed,
                    onTap: () => vm.navigateTo('assessment'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _pathCard({
    required IconData icon,
    required Color color,
    required String tag,
    required String title,
    required String brief,
    required String salary,
    required String details,
  }) {
    return CyberGlassCard(
      borderColor: color.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
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
                            fontSize: 15)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(brief,
              style: const TextStyle(color: kCyberGray, fontSize: 13)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.attach_money, color: color, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(salary,
                      style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(details,
              style: const TextStyle(
                  color: kStellarWhite, fontSize: 12, height: 1.5),
              maxLines: 5,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _navButton(BuildContext context,
      {required IconData icon,
      required String label,
      required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: CyberGlassCard(
        padding: const EdgeInsets.all(14),
        borderColor: color.withOpacity(0.2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
