import 'package:flutter/foundation.dart';
import '../data/models.dart';
import '../data/repository.dart';

/// Mirrors FuturePathViewModel.kt — ChangeNotifier replaces StateFlow
class FuturePathViewModel extends ChangeNotifier {
  final _repo = CareerRepository();

  // ── State ──────────────────────────────────────────────────────
  UserProfile _userProfile = const UserProfile();
  List<ChatMessage> _chatMessages = [];
  CareerSimulation? _simulation;
  String _currentScreen = 'splash';
  bool _isSimulating = false;
  bool _isChatLoading = false;
  bool _simulationComplete = false;

  // Form fields
  int _formAge = 17;
  String _formCountry = 'Nigeria';
  String _formInterests = 'Technology, Coding, Mathematics';
  String _formSkills = 'Basic Logic, English, Writing';
  String _formGrades = 'A in Math, B in English, A in Physics';
  String _formBudget = 'Under \$1,000/year (Requires scholarships/free paths)';
  String _formInternet = 'Mobile Data only, capped (Low Bandwidth)';
  String _formLifestyle = 'Remote Freelancer or Tech Entrepreneur';

  // ── Getters ────────────────────────────────────────────────────
  UserProfile get userProfile => _userProfile;
  List<ChatMessage> get chatMessages => _chatMessages;
  CareerSimulation? get simulation => _simulation;
  String get currentScreen => _currentScreen;
  bool get isSimulating => _isSimulating;
  bool get isChatLoading => _isChatLoading;
  bool get simulationComplete => _simulationComplete;

  int get formAge => _formAge;
  String get formCountry => _formCountry;
  String get formInterests => _formInterests;
  String get formSkills => _formSkills;
  String get formGrades => _formGrades;
  String get formBudget => _formBudget;
  String get formInternet => _formInternet;
  String get formLifestyle => _formLifestyle;

  // ── Init ───────────────────────────────────────────────────────
  Future<void> init() async {
    _userProfile = await _repo.getUserProfile();
    _chatMessages = await _repo.getChatMessages();
    _simulation = await _repo.getSimulation();
    notifyListeners();
  }

  // ── Navigation ─────────────────────────────────────────────────
  void navigateTo(String screen) {
    _currentScreen = screen;
    notifyListeners();
  }

  // ── Form setters ───────────────────────────────────────────────
  void updateFormFields({
    int? age,
    String? country,
    String? interests,
    String? skills,
    String? grades,
    String? budget,
    String? internet,
    String? lifestyle,
  }) {
    if (age != null) _formAge = age;
    if (country != null) _formCountry = country;
    if (interests != null) _formInterests = interests;
    if (skills != null) _formSkills = skills;
    if (grades != null) _formGrades = grades;
    if (budget != null) _formBudget = budget;
    if (internet != null) _formInternet = internet;
    if (lifestyle != null) _formLifestyle = lifestyle;
    notifyListeners();
  }

  // ── Save profile & run simulation ─────────────────────────────
  Future<void> saveUserProfileAndRunSimulation() async {
    _isSimulating = true;
    notifyListeners();

    final profile = UserProfile(
      age: _formAge,
      country: _formCountry,
      interests: _formInterests,
      skills: _formSkills,
      grades: _formGrades,
      budget: _formBudget,
      internetAccess: _formInternet,
      preferredLifestyle: _formLifestyle,
      xp: _userProfile.xp,
      level: _userProfile.level,
      streak: _userProfile.streak,
      futureScore: _userProfile.futureScore,
      isPremium: _userProfile.isPremium,
      favoriteTheme: _userProfile.favoriteTheme,
    );

    await _repo.saveProfile(profile);
    _simulation = await _repo.runCareerSimulation(profile);
    _userProfile = await _repo.getUserProfile();

    _isSimulating = false;
    _simulationComplete = true;
    _currentScreen = 'dashboard';
    notifyListeners();
  }

  // ── Premium toggle ─────────────────────────────────────────────
  Future<void> togglePremium(bool isPremium) async {
    final updated = _userProfile.copyWith(isPremium: isPremium);
    await _repo.saveProfile(updated);
    _userProfile = updated;
    notifyListeners();
  }

  // ── Theme ──────────────────────────────────────────────────────
  Future<void> setFavoriteTheme(String theme) async {
    final updated = _userProfile.copyWith(favoriteTheme: theme);
    await _repo.saveProfile(updated);
    _userProfile = updated;
    notifyListeners();
  }

  // ── Chat ───────────────────────────────────────────────────────
  Future<void> sendChatMessage(String text) async {
    if (text.trim().isEmpty) return;
    _isChatLoading = true;
    notifyListeners();

    await _repo.sendMessage('user', text);
    _chatMessages = await _repo.getChatMessages();
    _userProfile = await _repo.getUserProfile();

    _isChatLoading = false;
    notifyListeners();
  }

  Future<void> clearChatHistory() async {
    await _repo.clearChat();
    _chatMessages = [];
    notifyListeners();
  }

  // ── Daily reward ───────────────────────────────────────────────
  Future<void> claimDailyReward() async {
    const bonus = 25;
    final newXp = _userProfile.xp + bonus;
    final updated = _userProfile.copyWith(
      xp: newXp,
      level: 1 + (newXp ~/ 300),
      streak: _userProfile.streak + 1,
      lastUpdate: DateTime.now().millisecondsSinceEpoch,
    );
    await _repo.saveProfile(updated);
    _userProfile = updated;
    notifyListeners();
  }
}
