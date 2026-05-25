import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/futurepath_viewmodel.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class SkillGapScreen extends StatelessWidget {
  const SkillGapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FuturePathViewModel>();
    final sim = vm.simulation;
    final profile = vm.userProfile;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Skill Gap Analysis',
            subtitle: 'What you need to learn to reach your goals',
          ),
          const SizedBox(height: 20),

          if (sim == null)
            const CyberGlassCard(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Run a simulation first to see your skill gaps.',
                      style: TextStyle(color: kCyberGray)),
                ),
              ),
            )
          else ...[
            // Current skills
            const SectionHeader(title: 'Your Current Skills'),
            const SizedBox(height: 12),
            CyberGlassCard(
              borderColor: kSuccessGreen.withOpacity(0.25),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: profile.skills
                    .split(',')
                    .map((s) => NeonBadge(
                        label: s.trim(), color: kSuccessGreen))
                    .toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Missing skills
            const SectionHeader(title: 'Skills to Acquire'),
            const SizedBox(height: 12),
            CyberGlassCard(
              borderColor: kDangerRed.withOpacity(0.25),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: sim.skillGaps
                    .split(',')
                    .map((s) =>
                        NeonBadge(label: s.trim(), color: kDangerRed))
                    .toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Gap progress bars
            const SectionHeader(
                title: 'Skill Readiness',
                subtitle: 'Estimated proficiency for your target path'),
            const SizedBox(height: 14),
            ..._buildSkillBars(profile.skills, sim.skillGaps),
            const SizedBox(height: 20),

            // Action CTA
            CyberGlassCard(
              borderColor: kNeonTeal.withOpacity(0.3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.lightbulb_outline,
                          color: kNeonTeal, size: 20),
                      SizedBox(width: 8),
                      Text('Next Step',
                          style: TextStyle(
                              color: kStellarWhite,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                      'Follow your Learning Roadmap to close these gaps systematically. Focus on one skill at a time for maximum retention.',
                      style: TextStyle(
                          color: kCyberGray, fontSize: 13, height: 1.5)),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          context.read<FuturePathViewModel>().navigateTo('roadmap'),
                      icon: const Icon(Icons.map_outlined, size: 16),
                      label: const Text('View Roadmap'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildSkillBars(String currentSkills, String gapSkills) {
    final current = currentSkills
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    final gaps = gapSkills
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final allSkills = <_SkillBar>[];
    for (final s in current) {
      allSkills.add(_SkillBar(name: s, progress: 0.6 + (s.length % 4) * 0.08,
          color: kSuccessGreen));
    }
    for (final s in gaps.take(6)) {
      allSkills.add(_SkillBar(name: s, progress: 0.05 + (s.length % 5) * 0.05,
          color: kDangerRed));
    }

    return allSkills
        .map((sb) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(sb.name,
                          style: const TextStyle(
                              color: kStellarWhite, fontSize: 13)),
                      Text('${(sb.progress * 100).toInt()}%',
                          style: TextStyle(
                              color: sb.color,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: sb.progress,
                      backgroundColor: Colors.white.withOpacity(0.08),
                      valueColor:
                          AlwaysStoppedAnimation<Color>(sb.color),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ))
        .toList();
  }
}

class _SkillBar {
  final String name;
  final double progress;
  final Color color;
  const _SkillBar(
      {required this.name, required this.progress, required this.color});
}
