import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageCtrl = PageController();
  int _page = 0;

  static const _pages = [
    _OnboardPage(
      icon: Icons.rocket_launch,
      color: kNeonTeal,
      title: 'Simulate Your Future',
      body:
          'AI-powered career simulations show you 3 possible futures based on your skills, interests, and country — before you commit to a path.',
    ),
    _OnboardPage(
      icon: Icons.trending_up,
      color: kNeonPurple,
      title: 'Predict Salary Growth',
      body:
          'See realistic salary trajectories for optimistic, realistic, and high-risk career paths over the next 5 years.',
    ),
    _OnboardPage(
      icon: Icons.map_outlined,
      color: kPremiumGold,
      title: 'Personalized Roadmaps',
      body:
          'Get a custom 6-month learning roadmap, skill gap analysis, and AI mentor guidance tailored to your profile.',
    ),
  ];

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCyberBg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageCtrl,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) => _buildPage(_pages[i]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Column(
                children: [
                  // Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == _page ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == _page
                              ? kNeonTeal
                              : kCyberGray.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_page < _pages.length - 1) {
                          _pageCtrl.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        } else {
                          widget.onComplete();
                        }
                      },
                      child: Text(
                          _page < _pages.length - 1 ? 'Next' : 'Get Started'),
                    ),
                  ),
                  if (_page < _pages.length - 1) ...[
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: widget.onComplete,
                      child: const Text('Skip',
                          style: TextStyle(color: kCyberGray)),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(_OnboardPage page) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: page.color.withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(color: page.color.withOpacity(0.3), width: 2),
            ),
            child: Icon(page.icon, color: page.color, size: 48),
          ),
          const SizedBox(height: 36),
          Text(page.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: kStellarWhite,
                  fontSize: 26,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text(page.body,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: kCyberGray.withOpacity(0.9),
                  fontSize: 15,
                  height: 1.6)),
        ],
      ),
    );
  }
}

class _OnboardPage {
  final IconData icon;
  final Color color;
  final String title;
  final String body;
  const _OnboardPage(
      {required this.icon,
      required this.color,
      required this.title,
      required this.body});
}
