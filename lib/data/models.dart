// ============================================================
// Data Models — mirrors Kotlin Entities.kt
// ============================================================

class UserProfile {
  final String id;
  final int age;
  final String country;
  final String interests;
  final String skills;
  final String grades;
  final String budget;
  final String internetAccess;
  final String preferredLifestyle;
  final String strengths;
  final String weaknesses;
  final String learningHabits;
  final String timeCommitment;
  final bool isPremium;
  final String favoriteTheme;
  final int xp;
  final int level;
  final int streak;
  final int futureScore;
  final int lastUpdate;

  const UserProfile({
    this.id = 'current_user',
    this.age = 17,
    this.country = 'Nigeria',
    this.interests = 'Technology, Music, Problem Solving',
    this.skills = 'Coding (Python), Writing, Visual Design',
    this.grades = 'A in Math, B in English, A in Physics',
    this.budget = 'Under \$1,000/year (Requires scholarships/free paths)',
    this.internetAccess = 'Mobile Data only, capped (Low Bandwidth)',
    this.preferredLifestyle = 'Remote Freelancer or Tech Entrepreneur',
    this.strengths = 'Analytical thinking, fast learner',
    this.weaknesses = 'Public speaking, procrastination',
    this.learningHabits = 'Self-paced tutorials, coding challenges',
    this.timeCommitment = '15-20 hours/week part-time',
    this.isPremium = false,
    this.favoriteTheme = 'default',
    this.xp = 350,
    this.level = 2,
    this.streak = 5,
    this.futureScore = 84,
    this.lastUpdate = 0,
  });

  UserProfile copyWith({
    String? id,
    int? age,
    String? country,
    String? interests,
    String? skills,
    String? grades,
    String? budget,
    String? internetAccess,
    String? preferredLifestyle,
    String? strengths,
    String? weaknesses,
    String? learningHabits,
    String? timeCommitment,
    bool? isPremium,
    String? favoriteTheme,
    int? xp,
    int? level,
    int? streak,
    int? futureScore,
    int? lastUpdate,
  }) {
    return UserProfile(
      id: id ?? this.id,
      age: age ?? this.age,
      country: country ?? this.country,
      interests: interests ?? this.interests,
      skills: skills ?? this.skills,
      grades: grades ?? this.grades,
      budget: budget ?? this.budget,
      internetAccess: internetAccess ?? this.internetAccess,
      preferredLifestyle: preferredLifestyle ?? this.preferredLifestyle,
      strengths: strengths ?? this.strengths,
      weaknesses: weaknesses ?? this.weaknesses,
      learningHabits: learningHabits ?? this.learningHabits,
      timeCommitment: timeCommitment ?? this.timeCommitment,
      isPremium: isPremium ?? this.isPremium,
      favoriteTheme: favoriteTheme ?? this.favoriteTheme,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      streak: streak ?? this.streak,
      futureScore: futureScore ?? this.futureScore,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'age': age,
        'country': country,
        'interests': interests,
        'skills': skills,
        'grades': grades,
        'budget': budget,
        'internetAccess': internetAccess,
        'preferredLifestyle': preferredLifestyle,
        'strengths': strengths,
        'weaknesses': weaknesses,
        'learningHabits': learningHabits,
        'timeCommitment': timeCommitment,
        'isPremium': isPremium ? 1 : 0,
        'favoriteTheme': favoriteTheme,
        'xp': xp,
        'level': level,
        'streak': streak,
        'futureScore': futureScore,
        'lastUpdate': lastUpdate,
      };

  factory UserProfile.fromMap(Map<String, dynamic> map) => UserProfile(
        id: map['id'] as String,
        age: map['age'] as int,
        country: map['country'] as String,
        interests: map['interests'] as String,
        skills: map['skills'] as String,
        grades: map['grades'] as String,
        budget: map['budget'] as String,
        internetAccess: map['internetAccess'] as String,
        preferredLifestyle: map['preferredLifestyle'] as String,
        strengths: map['strengths'] as String,
        weaknesses: map['weaknesses'] as String,
        learningHabits: map['learningHabits'] as String,
        timeCommitment: map['timeCommitment'] as String,
        isPremium: (map['isPremium'] as int) == 1,
        favoriteTheme: map['favoriteTheme'] as String,
        xp: map['xp'] as int,
        level: map['level'] as int,
        streak: map['streak'] as int,
        futureScore: map['futureScore'] as int,
        lastUpdate: map['lastUpdate'] as int,
      );
}

// -------------------------------------------------------

class ChatMessage {
  final int? id;
  final String sender; // "user" or "mentor"
  final String text;
  final int timestamp;

  const ChatMessage({
    this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'sender': sender,
        'text': text,
        'timestamp': timestamp,
      };

  factory ChatMessage.fromMap(Map<String, dynamic> map) => ChatMessage(
        id: map['id'] as int?,
        sender: map['sender'] as String,
        text: map['text'] as String,
        timestamp: map['timestamp'] as int,
      );
}

// -------------------------------------------------------

class CareerSimulation {
  final String id;
  final String profileId;

  final String optimisticTitle;
  final String optimisticBrief;
  final String optimisticSalary;
  final String optimisticDetails;

  final String realisticTitle;
  final String realisticBrief;
  final String realisticSalary;
  final String realisticDetails;

  final String riskTitle;
  final String riskBrief;
  final String riskSalary;
  final String riskDetails;

  final String salariesOptimistic; // comma-separated numbers
  final String salariesRealistic;
  final String salariesRisk;

  final String skillGaps;
  final String skillRoadmap;

  const CareerSimulation({
    this.id = 'current_simulation',
    this.profileId = 'current_user',
    this.optimisticTitle = 'Cloud Solutions Architect (Global Remote)',
    this.optimisticBrief = 'Highly demanded, global pay, resilient to automation.',
    this.optimisticSalary = '\$18,000 - \$85,000/yr (Remote USD scaling)',
    this.optimisticDetails = 'Focus on AWS certificates, Kubernetes, Python & Terraform.',
    this.realisticTitle = 'Full Stack Developer (Regional Tech Hub)',
    this.realisticBrief = 'Strong regional demand in Lagos/Nairobi with outsourcing scope.',
    this.realisticSalary = '₦400k - ₦1.8M/month locally or \$12,000/yr outsourcing',
    this.realisticDetails = 'Deepen TypeScript, React, and Django.',
    this.riskTitle = 'AI Micro-SaaS Solo Founder',
    this.riskBrief = 'High margin, direct global payment, but volatile.',
    this.riskSalary = '\$0 - \$120,000+/yr (Highly variable)',
    this.riskDetails = 'Focus on rapid no-code/low-code API wrapping.',
    this.salariesOptimistic = '15,28,45,67,110',
    this.salariesRealistic = '8,14,22,32,48',
    this.salariesRisk = '2,18,5,75,180',
    this.skillGaps = 'Kubernetes, Docker, Advanced Algorithms, Cloud FinOps',
    this.skillRoadmap =
        'Month 1: AWS Cloud Practitioner | Month 2-3: Docker & Linux | Month 4-6: Build 3 portfolios.',
  });

  List<double> get optimisticSalaryList =>
      salariesOptimistic.split(',').map((e) => double.tryParse(e.trim()) ?? 0).toList();
  List<double> get realisticSalaryList =>
      salariesRealistic.split(',').map((e) => double.tryParse(e.trim()) ?? 0).toList();
  List<double> get riskSalaryList =>
      salariesRisk.split(',').map((e) => double.tryParse(e.trim()) ?? 0).toList();

  Map<String, dynamic> toMap() => {
        'id': id,
        'profileId': profileId,
        'optimisticTitle': optimisticTitle,
        'optimisticBrief': optimisticBrief,
        'optimisticSalary': optimisticSalary,
        'optimisticDetails': optimisticDetails,
        'realisticTitle': realisticTitle,
        'realisticBrief': realisticBrief,
        'realisticSalary': realisticSalary,
        'realisticDetails': realisticDetails,
        'riskTitle': riskTitle,
        'riskBrief': riskBrief,
        'riskSalary': riskSalary,
        'riskDetails': riskDetails,
        'salariesOptimistic': salariesOptimistic,
        'salariesRealistic': salariesRealistic,
        'salariesRisk': salariesRisk,
        'skillGaps': skillGaps,
        'skillRoadmap': skillRoadmap,
      };

  factory CareerSimulation.fromMap(Map<String, dynamic> map) => CareerSimulation(
        id: map['id'] as String,
        profileId: map['profileId'] as String,
        optimisticTitle: map['optimisticTitle'] as String,
        optimisticBrief: map['optimisticBrief'] as String,
        optimisticSalary: map['optimisticSalary'] as String,
        optimisticDetails: map['optimisticDetails'] as String,
        realisticTitle: map['realisticTitle'] as String,
        realisticBrief: map['realisticBrief'] as String,
        realisticSalary: map['realisticSalary'] as String,
        realisticDetails: map['realisticDetails'] as String,
        riskTitle: map['riskTitle'] as String,
        riskBrief: map['riskBrief'] as String,
        riskSalary: map['riskSalary'] as String,
        riskDetails: map['riskDetails'] as String,
        salariesOptimistic: map['salariesOptimistic'] as String,
        salariesRealistic: map['salariesRealistic'] as String,
        salariesRisk: map['salariesRisk'] as String,
        skillGaps: map['skillGaps'] as String,
        skillRoadmap: map['skillRoadmap'] as String,
      );
}
