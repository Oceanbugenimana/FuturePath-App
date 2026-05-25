import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/futurepath_viewmodel.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class LearningRoadmapScreen extends StatelessWidget {
  const LearningRoadmapScreen({super.key});

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
            title: 'Learning Roadmap',
            subtitle: 'Your personalised 6-month action plan',
          ),
          const SizedBox(height: 20),

          if (sim == null)
            const CyberGlassCard(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Run a simulation first to generate your roadmap.',
                      style: TextStyle(color: kCyberGray)),
                ),
              ),
            )
          else ...[
            // Roadmap steps
            ..._parseRoadmap(sim.skillRoadmap).asMap().entries.map((e) {
              final idx = e.key;
              final step = e.value;
              return _roadmapStep(idx, step);
            }),

            const SizedBox(height: 24),

            // Recommended resources
            const SectionHeader(
                title: 'Recommended Resources',
                subtitle: 'Free & low-bandwidth friendly'),
            const SizedBox(height: 14),
            ..._resources.map((r) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _resourceCard(r),
                )),
          ],
        ],
      ),
    );
  }

  List<String> _parseRoadmap(String roadmap) {
    return roadmap
        .split('|')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  Widget _roadmapStep(int index, String step) {
    final colors = [
      kNeonTeal,
      kNeonPurple,
      kPremiumGold,
      kSuccessGreen,
      kDangerRed,
      kNeonTeal,
    ];
    final color = colors[index % colors.length];

    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline
            Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: color.withOpacity(0.5)),
                  ),
                  child: Center(
                    child: Text('${index + 1}',
                        style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  ),
                ),
                if (index < 5)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: color.withOpacity(0.2),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: CyberGlassCard(
                  borderColor: color.withOpacity(0.2),
                  padding: const EdgeInsets.all(14),
                  child: Text(step,
                      style: const TextStyle(
                          color: kStellarWhite,
                          fontSize: 13,
                          height: 1.5)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resourceCard(_Resource r) {
    return CyberGlassCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: r.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(r.icon, color: r.color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.name,
                    style: const TextStyle(
                        color: kStellarWhite,
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
                Text(r.description,
                    style:
                        const TextStyle(color: kCyberGray, fontSize: 11)),
              ],
            ),
          ),
          NeonBadge(label: r.tag, color: r.color),
        ],
      ),
    );
  }

  static const _resources = [
    _Resource(
      icon: Icons.code,
      color: kNeonTeal,
      name: 'freeCodeCamp',
      description: 'Full-stack web development, free forever',
      tag: 'FREE',
    ),
    _Resource(
      icon: Icons.school_outlined,
      color: kNeonPurple,
      name: 'Coursera Financial Aid',
      description: 'University-level courses with 100% fee waiver',
      tag: 'FREE',
    ),
    _Resource(
      icon: Icons.play_circle_outline,
      color: kPremiumGold,
      name: 'YouTube Tutorials',
      description: 'Low-bandwidth video lessons on any topic',
      tag: 'FREE',
    ),
    _Resource(
      icon: Icons.hub_outlined,
      color: kSuccessGreen,
      name: 'GitHub',
      description: 'Build your portfolio and collaborate globally',
      tag: 'FREE',
    ),
    _Resource(
      icon: Icons.laptop_outlined,
      color: kDangerRed,
      name: 'Replit',
      description: 'Code from any device, even a phone',
      tag: 'FREE',
    ),
  ];
}

class _Resource {
  final IconData icon;
  final Color color;
  final String name;
  final String description;
  final String tag;
  const _Resource(
      {required this.icon,
      required this.color,
      required this.name,
      required this.description,
      required this.tag});
}
