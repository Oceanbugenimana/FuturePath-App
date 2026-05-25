import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/futurepath_viewmodel.dart';
import '../ui/theme/app_theme.dart';
import '../ui/widgets/common_widgets.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/assessment_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/career_simulator_screen.dart';
import 'screens/salary_trajectory_screen.dart';
import 'screens/learning_roadmap_screen.dart';
import 'screens/skill_gap_screen.dart';
import 'screens/ai_mentor_screen.dart';
import 'screens/future_scenario_screen.dart';
import 'screens/premium_screen.dart';
import 'screens/architect_screen.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  static const _noNavScreens = {
    'splash', 'onboarding', 'auth', 'assessment'
  };

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FuturePathViewModel>();
    final screen = vm.currentScreen;
    final showNav = !_noNavScreens.contains(screen);

    return Scaffold(
      backgroundColor: kCyberBg,
      appBar: showNav ? _buildTopBar(context, vm) : null,
      bottomNavigationBar: showNav ? _buildBottomBar(context, vm) : null,
      body: AtmosphericBackground(
        child: _buildScreen(screen, vm),
      ),
    );
  }

  PreferredSizeWidget _buildTopBar(
      BuildContext context, FuturePathViewModel vm) {
    final profile = vm.userProfile;
    return PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: Container(
        color: kCyberBg.withOpacity(0.9),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo + title
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          colors: [kNeonTeal, kNeonPurple],
                        ),
                      ),
                      child: const Center(
                        child: Text('F',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('FuturePath AI',
                            style: TextStyle(
                                color: kStellarWhite,
                                fontWeight: FontWeight.w600,
                                fontSize: 13)),
                        Text('SCENARIO ALPHA-7',
                            style: TextStyle(
                                color: kNeonTeal,
                                fontSize: 8,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
                // Right badges
                Row(
                  children: [
                    if (profile.isPremium)
                      _badge('PRO', kPremiumGold)
                    else
                      GestureDetector(
                        onTap: () => vm.navigateTo('premium'),
                        child: _badge('GO PRO', kNeonTeal),
                      ),
                    const SizedBox(width: 8),
                    _badge('Lvl ${profile.level}', kSuccessGreen),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(label,
          style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5)),
    );
  }

  Widget _buildBottomBar(BuildContext context, FuturePathViewModel vm) {
    final screen = vm.currentScreen;
    return Container(
      decoration: BoxDecoration(
        color: kCyberCard,
        border: Border(
            top: BorderSide(color: kCyberGray.withOpacity(0.12))),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _navItem(
                label: 'Overview',
                icon: Icons.dashboard_outlined,
                activeIcon: Icons.dashboard,
                isSelected: screen == 'dashboard',
                onTap: () => vm.navigateTo('dashboard'),
              ),
              _navItem(
                label: 'Career',
                icon: Icons.rocket_launch_outlined,
                activeIcon: Icons.rocket_launch,
                isSelected: ['simulator', 'salary', 'roadmap', 'skillgap']
                    .contains(screen),
                onTap: () => vm.navigateTo('simulator'),
              ),
              _navItem(
                label: 'Mentor',
                icon: Icons.smart_toy_outlined,
                activeIcon: Icons.smart_toy,
                isSelected: screen == 'mentor',
                onTap: () => vm.navigateTo('mentor'),
              ),
              _navItem(
                label: 'Scenario',
                icon: Icons.science_outlined,
                activeIcon: Icons.science,
                isSelected: screen == 'scenario',
                onTap: () => vm.navigateTo('scenario'),
              ),
              _navItem(
                label: 'Blueprint',
                icon: Icons.terminal_outlined,
                activeIcon: Icons.terminal,
                isSelected: screen == 'architect',
                onTap: () => vm.navigateTo('architect'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    required String label,
    required IconData icon,
    required IconData activeIcon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final color = isSelected ? kNeonTeal : kCyberGray;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? kNeonTeal.withOpacity(0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(isSelected ? activeIcon : icon,
                  color: color, size: 20),
            ),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                    color: color,
                    fontSize: 9,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildScreen(String screen, FuturePathViewModel vm) {
    switch (screen) {
      case 'splash':
        return SplashScreen(onTimeout: () => vm.navigateTo('onboarding'));
      case 'onboarding':
        return OnboardingScreen(onComplete: () => vm.navigateTo('auth'));
      case 'auth':
        return AuthScreen(onAuthSuccess: () => vm.navigateTo('assessment'));
      case 'assessment':
        return const AssessmentScreen();
      case 'dashboard':
        return const DashboardScreen();
      case 'simulator':
        return const CareerSimulatorScreen();
      case 'salary':
        return const SalaryTrajectoryScreen();
      case 'roadmap':
        return const LearningRoadmapScreen();
      case 'skillgap':
        return const SkillGapScreen();
      case 'mentor':
        return const AiMentorScreen();
      case 'scenario':
        return const FutureScenarioScreen();
      case 'premium':
        return const PremiumScreen();
      case 'architect':
        return const ArchitectScreen();
      default:
        return const DashboardScreen();
    }
  }
}
