import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/futurepath_viewmodel.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  final _pageCtrl = PageController();
  int _page = 0;

  // Form controllers
  late TextEditingController _interestsCtrl;
  late TextEditingController _skillsCtrl;
  late TextEditingController _gradesCtrl;
  late TextEditingController _countryCtrl;

  int _age = 17;
  String _budget = 'Under \$1,000/year (Requires scholarships/free paths)';
  String _internet = 'Mobile Data only, capped (Low Bandwidth)';
  String _lifestyle = 'Remote Freelancer or Tech Entrepreneur';

  static const _budgetOptions = [
    'Under \$1,000/year (Requires scholarships/free paths)',
    '\$1,000 - \$5,000/year (Community college level)',
    '\$5,000 - \$15,000/year (University level)',
    '\$15,000+/year (Premium education)',
  ];

  static const _internetOptions = [
    'Mobile Data only, capped (Low Bandwidth)',
    'Stable Home WiFi (Medium Bandwidth)',
    'High-Speed Fiber (High Bandwidth)',
  ];

  static const _lifestyleOptions = [
    'Remote Freelancer or Tech Entrepreneur',
    'Corporate Employee (Stable income)',
    'Academic / Researcher',
    'Social Impact / NGO Worker',
  ];

  @override
  void initState() {
    super.initState();
    final vm = context.read<FuturePathViewModel>();
    _interestsCtrl = TextEditingController(text: vm.formInterests);
    _skillsCtrl = TextEditingController(text: vm.formSkills);
    _gradesCtrl = TextEditingController(text: vm.formGrades);
    _countryCtrl = TextEditingController(text: vm.formCountry);
    _age = vm.formAge;
    _budget = vm.formBudget;
    _internet = vm.formInternet;
    _lifestyle = vm.formLifestyle;
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _interestsCtrl.dispose();
    _skillsCtrl.dispose();
    _gradesCtrl.dispose();
    _countryCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < 2) {
      _pageCtrl.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _submit();
    }
  }

  void _submit() {
    final vm = context.read<FuturePathViewModel>();
    vm.updateFormFields(
      age: _age,
      country: _countryCtrl.text,
      interests: _interestsCtrl.text,
      skills: _skillsCtrl.text,
      grades: _gradesCtrl.text,
      budget: _budget,
      internet: _internet,
      lifestyle: _lifestyle,
    );
    vm.saveUserProfileAndRunSimulation();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FuturePathViewModel>();

    if (vm.isSimulating) {
      return const LoadingOverlay(
          message: 'Running AI Career Simulation...\nThis may take a moment.');
    }

    return Scaffold(
      backgroundColor: kCyberBg,
      body: SafeArea(
        child: Column(
          children: [
            // Progress header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Profile Assessment',
                          style: TextStyle(
                              color: kStellarWhite,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      Text('${_page + 1}/3',
                          style: const TextStyle(
                              color: kNeonTeal, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (_page + 1) / 3,
                      backgroundColor: Colors.white.withOpacity(0.08),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(kNeonTeal),
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _page = i),
                children: [
                  _page0(),
                  _page1(),
                  _page2(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _next,
                  child: Text(_page < 2 ? 'Continue' : 'Run Simulation 🚀'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _page0() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
              title: 'About You',
              subtitle: 'Tell us the basics so we can personalise your path'),
          const SizedBox(height: 20),
          CyberGlassCard(
            child: Column(
              children: [
                // Age slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Age',
                        style: TextStyle(color: kStellarWhite, fontSize: 14)),
                    Text('$_age',
                        style: const TextStyle(
                            color: kNeonTeal,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ],
                ),
                Slider(
                  value: _age.toDouble(),
                  min: 13,
                  max: 35,
                  divisions: 22,
                  activeColor: kNeonTeal,
                  inactiveColor: Colors.white.withOpacity(0.1),
                  onChanged: (v) => setState(() => _age = v.round()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _countryCtrl,
                  style: const TextStyle(color: kStellarWhite),
                  decoration: const InputDecoration(
                    labelText: 'Country',
                    prefixIcon:
                        Icon(Icons.public_outlined, color: kCyberGray),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _interestsCtrl,
                  style: const TextStyle(color: kStellarWhite),
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Interests (e.g. Technology, Music, Design)',
                    prefixIcon:
                        Icon(Icons.interests_outlined, color: kCyberGray),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _page1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
              title: 'Skills & Academics',
              subtitle: 'Your current abilities and academic performance'),
          const SizedBox(height: 20),
          CyberGlassCard(
            child: Column(
              children: [
                TextField(
                  controller: _skillsCtrl,
                  style: const TextStyle(color: kStellarWhite),
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Current Skills',
                    prefixIcon:
                        Icon(Icons.code_outlined, color: kCyberGray),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _gradesCtrl,
                  style: const TextStyle(color: kStellarWhite),
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Academic Grades',
                    prefixIcon:
                        Icon(Icons.school_outlined, color: kCyberGray),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _page2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
              title: 'Resources & Goals',
              subtitle: 'Help us understand your constraints and ambitions'),
          const SizedBox(height: 20),
          CyberGlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _dropdownField(
                  label: 'Annual Budget',
                  value: _budget,
                  items: _budgetOptions,
                  onChanged: (v) => setState(() => _budget = v!),
                ),
                const SizedBox(height: 16),
                _dropdownField(
                  label: 'Internet Access',
                  value: _internet,
                  items: _internetOptions,
                  onChanged: (v) => setState(() => _internet = v!),
                ),
                const SizedBox(height: 16),
                _dropdownField(
                  label: 'Preferred Lifestyle',
                  value: _lifestyle,
                  items: _lifestyleOptions,
                  onChanged: (v) => setState(() => _lifestyle = v!),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: kCyberGray, fontSize: 12)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            dropdownColor: kCyberCard,
            underline: const SizedBox(),
            style: const TextStyle(color: kStellarWhite, fontSize: 13),
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
