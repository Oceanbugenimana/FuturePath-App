import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/futurepath_viewmodel.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class FutureScenarioScreen extends StatefulWidget {
  const FutureScenarioScreen({super.key});

  @override
  State<FutureScenarioScreen> createState() => _FutureScenarioScreenState();
}

class _FutureScenarioScreenState extends State<FutureScenarioScreen> {
  int _selectedYear = 2;

  static const _scenarios = [
    _Scenario(
      year: 1,
      label: '1 Year',
      icon: Icons.looks_one_outlined,
      color: kNeonTeal,
      title: 'Foundation Builder',
      description:
          'You\'ve completed your core skill stack and built 2 portfolio projects. You\'re landing your first freelance clients and earning your first \$500/month online.',
      milestones: [
        'Completed primary skill course',
        'Built 2 portfolio projects',
        'First freelance client',
        'GitHub profile active',
      ],
    ),
    _Scenario(
      year: 2,
      label: '2 Years',
      icon: Icons.looks_two_outlined,
      color: kNeonPurple,
      title: 'Growth Phase',
      description:
          'You\'re consistently earning \$1,500-3,000/month remotely. You\'ve built a reputation in your niche and are getting referrals. Your skills are now market-competitive.',
      milestones: [
        'Consistent remote income',
        'Niche reputation established',
        'Referral network growing',
        'Advanced certifications',
      ],
    ),
    _Scenario(
      year: 3,
      label: '3 Years',
      icon: Icons.looks_3_outlined,
      color: kPremiumGold,
      title: 'Market Leader',
      description:
          'You\'re earning \$3,000-8,000/month. You\'ve transitioned from freelancer to specialist. Companies are approaching you. You\'re mentoring others in your community.',
      milestones: [
        'Specialist-level income',
        'Inbound client requests',
        'Mentoring others',
        'Building your own team',
      ],
    ),
    _Scenario(
      year: 5,
      label: '5 Years',
      icon: Icons.star_outline,
      color: kSuccessGreen,
      title: 'Elite Operator',
      description:
          'You\'re in the top 10% of earners in your field globally. You\'ve built systems that generate income while you sleep. You\'re financially independent and location-free.',
      milestones: [
        'Top 10% global earner',
        'Passive income streams',
        'Location independence',
        'Financial freedom achieved',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FuturePathViewModel>();
    final profile = vm.userProfile;
    final scenario = _scenarios[_selectedYear];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Future Scenarios',
            subtitle: 'Visualise where you could be',
          ),
          const SizedBox(height: 20),

          // Year selector
          Row(
            children: _scenarios.asMap().entries.map((e) {
              final i = e.key;
              final s = e.value;
              final selected = i == _selectedYear;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedYear = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.only(right: i < 3 ? 8 : 0),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: selected
                          ? s.color.withOpacity(0.15)
                          : Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? s.color.withOpacity(0.5)
                            : Colors.white.withOpacity(0.08),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(s.icon,
                            color: selected ? s.color : kCyberGray,
                            size: 18),
                        const SizedBox(height: 4),
                        Text(s.label,
                            style: TextStyle(
                                color: selected ? s.color : kCyberGray,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Scenario card
          CyberGlassCard(
            borderColor: scenario.color.withOpacity(0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: scenario.color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(scenario.icon,
                          color: scenario.color, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NeonBadge(
                              label: 'YEAR ${scenario.year}',
                              color: scenario.color),
                          const SizedBox(height: 4),
                          Text(scenario.title,
                              style: const TextStyle(
                                  color: kStellarWhite,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(scenario.description,
                    style: const TextStyle(
                        color: kStellarWhite,
                        fontSize: 14,
                        height: 1.6)),
                const SizedBox(height: 16),
                const Text('Milestones',
                    style: TextStyle(
                        color: kCyberGray,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8)),
                const SizedBox(height: 10),
                ...scenario.milestones.map((m) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline,
                              color: scenario.color, size: 16),
                          const SizedBox(width: 10),
                          Text(m,
                              style: const TextStyle(
                                  color: kStellarWhite, fontSize: 13)),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Profile context
          CyberGlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Your Starting Point',
                    style: TextStyle(
                        color: kStellarWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
                const SizedBox(height: 12),
                _profileRow(Icons.public_outlined, 'Country', profile.country),
                _profileRow(Icons.interests_outlined, 'Interests',
                    profile.interests),
                _profileRow(Icons.code_outlined, 'Skills', profile.skills),
                _profileRow(Icons.trending_up, 'Career Readiness',
                    '${profile.futureScore}%'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // CTA
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => vm.navigateTo('mentor'),
              icon: const Icon(Icons.smart_toy_outlined, size: 16),
              label: const Text('Discuss with Alpha-9'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: kCyberGray, size: 16),
          const SizedBox(width: 10),
          Text('$label: ',
              style: const TextStyle(color: kCyberGray, fontSize: 12)),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    color: kStellarWhite, fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

class _Scenario {
  final int year;
  final String label;
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final List<String> milestones;
  const _Scenario({
    required this.year,
    required this.label,
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
    required this.milestones,
  });
}
