import 'dart:math';
import 'models.dart';
import 'database.dart';
import 'gemini_client.dart';

/// Mirrors Repository.kt — all business logic lives here.
class CareerRepository {
  final _db = FuturePathDatabase.instance;

  Future<UserProfile> getUserProfile() async {
    return await _db.getUserProfile() ?? const UserProfile();
  }

  Future<List<ChatMessage>> getChatMessages() async {
    return _db.getChatMessages();
  }

  Future<CareerSimulation?> getSimulation() async {
    return _db.getSimulation();
  }

  Future<void> saveProfile(UserProfile profile) async {
    await _db.saveUserProfile(profile);
  }

  Future<void> clearChat() async {
    await _db.clearChat();
  }

  // ----------------------------------------------------------------
  // Chat / Mentor
  // ----------------------------------------------------------------
  Future<String> sendMessage(String sender, String messageText) async {
    final ts = DateTime.now().millisecondsSinceEpoch;
    await _db.insertChatMessage(
        ChatMessage(sender: sender, text: messageText, timestamp: ts));

    final profile = await getUserProfile();
    final systemContext = '''
You are "Alpha-9", an elite futuristic AI mentor on 'FuturePath AI'.
You are advising a ${profile.age}-year-old student from ${profile.country}.
Interests: ${profile.interests}. Skills: ${profile.skills}.
Grades: ${profile.grades}. Financial Budget: ${profile.budget}.
Internet: ${profile.internetAccess}.
Role: Be highly motivational, strategically critical, clear, and actionable.
Answer questions about career roadmaps, skill gaps, salaries, automation threat, and study advice.
Keep it concise, friendly, futuristic, and highly informative.
''';

    String response;
    try {
      final raw = await GeminiClient.callGemini(messageText,
          systemPrompt: systemContext);
      if (raw.startsWith('API_NETWORK_ERROR') || raw.startsWith('Error')) {
        response = _proceduralAdvice(messageText, profile);
      } else {
        response = raw;
      }
    } catch (_) {
      response = _proceduralAdvice(messageText, profile);
    }

    final replyTs = DateTime.now().millisecondsSinceEpoch;
    await _db.insertChatMessage(
        ChatMessage(sender: 'mentor', text: response, timestamp: replyTs));

    // Award XP for learning session
    final newXp = profile.xp + 15;
    await _db.saveUserProfile(profile.copyWith(
      xp: newXp,
      level: 1 + (newXp ~/ 300),
      lastUpdate: replyTs,
    ));

    return response;
  }

  // ----------------------------------------------------------------
  // Career Simulation
  // ----------------------------------------------------------------
  Future<CareerSimulation> runCareerSimulation(UserProfile profile) async {
    final newXp = profile.xp + 50;
    final updatedProfile = profile.copyWith(
      xp: newXp,
      level: 1 + (newXp ~/ 300),
      streak: profile.streak + 1,
      futureScore: 75 + Random().nextInt(15),
      lastUpdate: DateTime.now().millisecondsSinceEpoch,
    );
    await _db.saveUserProfile(updatedProfile);

    final prompt = '''
Simulate 3 future career outcomes for a student with these details:
- Age: ${profile.age}
- Country: ${profile.country}
- Interests: ${profile.interests}
- Skills: ${profile.skills}
- Academic Performance (Grades): ${profile.grades}
- Financial Capacity / annual budget: ${profile.budget}
- Internet levels: ${profile.internetAccess}
- Preferred lifestyle/goals: ${profile.preferredLifestyle}

Provide exactly 3 paths:
1. OPTIMISTIC (High growth, globally optimized, leveraging US/foreign remote pay)
2. REALISTIC (Locally/regionally accessible, highly practical)
3. HIGH-RISK/HIGH-REWARD (Entrepreneurship, startup, volatile freelancing)

Also list:
- Missing skills (Skill Gap Analysis)
- A brief Dynamic Learning Roadmap over 6 months.

Keep it concise and descriptive. Do not repeat titles.
''';

    final systemPrompt =
        'You are FuturePath AI, an advanced Career Strategy Engine designed for youth in emerging economies. Provide realistic, motivational advice.';

    CareerSimulation simulation;
    try {
      final aiAnswer =
          await GeminiClient.callGemini(prompt, systemPrompt: systemPrompt);
      if (aiAnswer.startsWith('API_NETWORK_ERROR') ||
          aiAnswer.startsWith('Error')) {
        simulation = _proceduralSimulation(updatedProfile);
      } else {
        simulation = _parseAIPredictions(aiAnswer, updatedProfile);
      }
    } catch (_) {
      simulation = _proceduralSimulation(updatedProfile);
    }

    await _db.saveSimulation(simulation);
    return simulation;
  }

  // ----------------------------------------------------------------
  // AI response parser
  // ----------------------------------------------------------------
  CareerSimulation _parseAIPredictions(
      String aiResponse, UserProfile profile) {
    final lines = aiResponse.split('\n');

    String optTitle = 'Cloud & AI Architect';
    String optBrief = 'Global cloud infrastructure optimization.';
    String optSalary = '\$24,000 - \$90,000/yr (USD Remote)';
    String optDetails = 'Focus on cloud computing, Kubernetes, and API integrations.';

    String realTitle = 'Full Stack Mobile Developer';
    String realBrief = 'Regional application construction for commerce/mobile finance.';
    String realSalary = '\$8,000 - \$25,000/yr (Outsource Hub)';
    String realDetails = 'Learn Flutter, web-apps, SQL databases, and regional payment APIs.';

    String riskTitle = 'AI SaaS Indie Hacker';
    String riskBrief = 'Building niche micro-software solutions.';
    String riskSalary = '\$0 - \$150,000+/yr (Subscriptions)';
    String riskDetails = 'Focus on Rapid MVP building, no-code integrations.';

    String gaps = 'Cloud APIs, Docker containers, systems architecture';
    String roadmap =
        'Month 1: General coding practice | Month 2-3: Cloud basics | Month 4-6: Complete 3 mock client platforms.';

    try {
      final optIndex = lines.indexWhere((l) =>
          l.toLowerCase().contains('optimistic') ||
          l.trimLeft().startsWith('1.'));
      final realIndex = lines.indexWhere((l) =>
          l.toLowerCase().contains('realistic') ||
          l.trimLeft().startsWith('2.'));
      final riskIndex = lines.indexWhere((l) =>
          l.toLowerCase().contains('risk') || l.trimLeft().startsWith('3.'));

      if (optIndex != -1 && realIndex != -1 && realIndex > optIndex) {
        final block = lines.sublist(optIndex, realIndex).join('\n');
        final nonEmpty =
            block.split('\n').where((l) => l.trim().isNotEmpty).toList();
        if (nonEmpty.isNotEmpty) {
          optTitle = nonEmpty.first
              .replaceAll(RegExp(r'[#*0-9.]'), '')
              .trim()
              .take(80);
          optDetails = block;
          if (nonEmpty.length > 1) {
            optBrief = nonEmpty[1]
                .replaceAll(RegExp(r'[#*]'), '')
                .trim()
                .take(120);
          }
        }
      }
      if (realIndex != -1 && riskIndex != -1 && riskIndex > realIndex) {
        final block = lines.sublist(realIndex, riskIndex).join('\n');
        final nonEmpty =
            block.split('\n').where((l) => l.trim().isNotEmpty).toList();
        if (nonEmpty.isNotEmpty) {
          realTitle = nonEmpty.first
              .replaceAll(RegExp(r'[#*0-9.]'), '')
              .trim()
              .take(80);
          realDetails = block;
          if (nonEmpty.length > 1) {
            realBrief = nonEmpty[1]
                .replaceAll(RegExp(r'[#*]'), '')
                .trim()
                .take(120);
          }
        }
      }
      if (riskIndex != -1) {
        final block = lines.sublist(riskIndex).join('\n');
        final nonEmpty =
            block.split('\n').where((l) => l.trim().isNotEmpty).toList();
        if (nonEmpty.isNotEmpty) {
          riskTitle = nonEmpty.first
              .replaceAll(RegExp(r'[#*0-9.]'), '')
              .trim()
              .take(80);
          riskDetails = block;
          if (nonEmpty.length > 1) {
            riskBrief = nonEmpty[1]
                .replaceAll(RegExp(r'[#*]'), '')
                .trim()
                .take(120);
          }
        }
      }

      final gapIndex = lines.indexWhere((l) =>
          l.toLowerCase().contains('gap') ||
          l.toLowerCase().contains('missing'));
      if (gapIndex != -1) {
        gaps = lines
            .sublist(gapIndex, (gapIndex + 4).clamp(0, lines.length))
            .join(', ')
            .replaceAll(RegExp(r'[#*]'), '')
            .trim()
            .take(200);
      }

      final roadIndex = lines.indexWhere((l) =>
          l.toLowerCase().contains('roadmap') ||
          l.toLowerCase().contains('month'));
      if (roadIndex != -1) {
        roadmap = lines
            .sublist(roadIndex, (roadIndex + 6).clamp(0, lines.length))
            .join(' | ')
            .replaceAll(RegExp(r'[#*]'), '')
            .trim()
            .take(500);
      }
    } catch (_) {
      // keep defaults
    }

    return CareerSimulation(
      profileId: profile.id,
      optimisticTitle: optTitle,
      optimisticBrief: optBrief,
      optimisticSalary: optSalary,
      optimisticDetails: optDetails,
      realisticTitle: realTitle,
      realisticBrief: realBrief,
      realisticSalary: realSalary,
      realisticDetails: realDetails,
      riskTitle: riskTitle,
      riskBrief: riskBrief,
      riskSalary: riskSalary,
      riskDetails: riskDetails,
      salariesOptimistic: '18,34,55,80,120',
      salariesRealistic: '8,15,24,35,50',
      salariesRisk: '0,12,30,85,210',
      skillGaps: gaps,
      skillRoadmap: roadmap,
    );
  }

  // ----------------------------------------------------------------
  // Procedural fallback simulation (no API key needed)
  // ----------------------------------------------------------------
  CareerSimulation _proceduralSimulation(UserProfile prof) {
    final kw = prof.interests.toLowerCase();
    final hasTech = kw.contains('tech') ||
        kw.contains('cod') ||
        kw.contains('comput') ||
        kw.contains('software');
    final hasDesign = kw.contains('design') ||
        kw.contains('art') ||
        kw.contains('photograph');

    String optTitle, optBrief, optDetails, optSals;
    String realTitle, realBrief, realDetails, realSals;
    String riskTitle, riskBrief, riskDetails, riskSals;
    String gapList, roadmapText;

    if (hasTech) {
      optTitle = 'Global Remote Systems Engineer';
      optBrief =
          'High-pay infrastructure specialist serving high-growth startup markets remotely.';
      optDetails =
          'Build state-of-the-art container infrastructure (Kubernetes, AWS/GCP, Docker). Master microservices, security protocols, API pipelines, and high-concurrency systems.';
      optSals = '20,38,62,95,140';

      realTitle = 'Full-Stack Web Developer (Regional Agency)';
      realBrief =
          'Constructing scalable e-commerce portals, mobile engines, and enterprise dashboards.';
      realDetails =
          'Establish proficiency in React/TypeScript, local databases like PostgreSQL, REST API management, and low-latency rendering for mobile devices.';
      realSals = '6,12,20,30,45';

      riskTitle = 'AI Micro-SaaS Indie Creator';
      riskBrief =
          'Developing highly targeted web/mobile micro-tools powered by intelligent models.';
      riskDetails =
          'Extremely fast MVP launching. Use low-code, wrapper APIs, micro-billing, and organic visual marketing.';
      riskSals = '0,18,5,80,240';

      gapList =
          'Docker, Kubernetes, AWS/GCP, FastAPI backend structure, PostgreSQL schema design';
      roadmapText =
          'Month 1: Command Line, Python & Git basics | Month 2-3: Complete clean API building with FastAPI & Postgres | Month 4-5: Master Docker & basic Cloud deployment | Month 6: Develop 3 polished GitHub portfolios.';
    } else if (hasDesign) {
      optTitle = 'UX Product Strategist (Global Agency)';
      optBrief =
          'Elite digital designer engineering product architectures with advanced Figma/interactive layouts.';
      optDetails =
          'Develop user journeys, clean component hierarchies, responsive frameworks, and UX-research databases.';
      optSals = '15,26,42,65,95';

      realTitle = 'Digital Branding & Ad Lead';
      realBrief =
          'Crafting social narratives, advertising visuals, and brand assets for emerging companies.';
      realDetails =
          'Coordinate vector designs, customized graphic frameworks, social-media marketing campaigns.';
      realSals = '5,9,15,22,32';

      riskTitle = 'Independent Digital Creator / Agency Founder';
      riskBrief =
          'Launching a solo branding studio leveraging global freelancer contracts.';
      riskDetails =
          'Requires high-speed network client searching, active social presence, 3D interactive graphics.';
      riskSals = '0,12,25,60,150';

      gapList =
          'UX prototyping, Interactive design systems, Typography structure, Framer web animations';
      roadmapText =
          'Month 1: Color theory, typography structure, visual hierarchy | Month 2-3: Advanced Figma, UI wireframing | Month 4-5: Responsive web creation tools | Month 6: Serve 2 non-profit clients.';
    } else {
      optTitle = 'Emerging Market Fintech Consultant';
      optBrief =
          'Strategic intelligence bridging local business commerce with global digital banking.';
      optDetails =
          'Establish micro-payment pipelines, regional wallet interfaces, cross-border digital contracts.';
      optSals = '18,32,50,78,115';

      realTitle = 'E-Commerce & Logistics Operator';
      realBrief =
          'Optimizing regional warehouse databases and local distribution networks.';
      realDetails =
          'Coordinate inventory databases, optimize delivery route logs, handle customer records.';
      realSals = '5,10,16,24,35';

      riskTitle = 'Independent Digital Creator / Agency Founder';
      riskBrief =
          'Launching a solo branding studio leveraging global freelancer contracts.';
      riskDetails =
          'Requires high-speed network client searching, active social presence.';
      riskSals = '0,12,25,60,150';

      gapList = 'Digital marketing, E-commerce APIs, Ledger entries, CRM databases';
      roadmapText =
          'Month 1: Business fundamentals & spreadsheets | Month 2-3: Digital marketing & SEO | Month 4-5: E-commerce platform setup | Month 6: Launch first online store.';
    }

    return CareerSimulation(
      profileId: prof.id,
      optimisticTitle: optTitle,
      optimisticBrief: optBrief,
      optimisticSalary:
          '\$${optSals.split(',').first}k - \$${optSals.split(',').last}k/yr',
      optimisticDetails: optDetails,
      realisticTitle: realTitle,
      realisticBrief: realBrief,
      realisticSalary:
          '\$${realSals.split(',').first}k - \$${realSals.split(',').last}k/yr',
      realisticDetails: realDetails,
      riskTitle: riskTitle,
      riskBrief: riskBrief,
      riskSalary:
          '\$${riskSals.split(',').first}k - \$${riskSals.split(',').last}k/yr',
      riskDetails: riskDetails,
      salariesOptimistic: optSals,
      salariesRealistic: realSals,
      salariesRisk: riskSals,
      skillGaps: gapList,
      skillRoadmap: roadmapText,
    );
  }

  // ----------------------------------------------------------------
  // Procedural mentor advice fallback
  // ----------------------------------------------------------------
  String _proceduralAdvice(String userPrompt, UserProfile profile) {
    final p = userPrompt.toLowerCase();
    if (p.contains('streak') || p.contains('xp') || p.contains('level')) {
      return 'Alpha-9 Mentorship: 🌟 Every learning interaction, simulation quiz, and roadmap query rewards you with XP. Streaks double your multiplier! Maintain your daily learning habit to keep your Career Readiness Score rising.';
    } else if (p.contains('salary') ||
        p.contains('money') ||
        p.contains('income')) {
      return 'Alpha-9 Mentorship: 📈 Salary trajectory in modern times is about arbitrage. As a learner in ${profile.country}, your peak leverage is learning global skills and charging in global currencies (USD/EUR) while living locally. Remote freelancing is the fastest way to boost income!';
    } else if (p.contains('automation') ||
        p.contains('ai') ||
        p.contains('replace')) {
      return 'Alpha-9 Mentorship: 🛡️ AI is a strong accelerator, not a simple replacement. Standard repetitive coders will be marginalized, but systems architects, UX designers, and prompt-integrated engineers will be 10x more valuable.';
    } else if (p.contains('start') ||
        p.contains('begin') ||
        p.contains('how to')) {
      return 'Alpha-9 Mentorship: 🚀 Start with your 6-month roadmap! Focus on building small, working public projects and sharing your progress on GitHub or LinkedIn. Pick *one* primary stack and master it.';
    } else if (p.contains('budget') ||
        p.contains('fee') ||
        p.contains('cost')) {
      return 'Alpha-9 Mentorship: 💡 Wealth is not a prerequisite for tech proficiency. Platforms like FreeCodeCamp, Coursera Financial Aid, YouTube, and GitHub provide peerless curricula completely free.';
    } else {
      return 'Alpha-9 Mentorship: Excellent strategic question. In ${profile.country}, digital transformation is opening unprecedented opportunities. In the ${profile.interests} workspace, combining logical strategy with rapid prototyping will make you globally competitive. Focus on mastering ${profile.skills.split(',').first.trim()}, build local portfolios, and target remote outsourcing networks!';
    }
  }
}

extension _StringTake on String {
  String take(int n) => length <= n ? this : substring(0, n);
}
