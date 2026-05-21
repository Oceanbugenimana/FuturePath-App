package com.example.ui

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import com.example.data.*
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch

class FuturePathViewModel(application: Application) : AndroidViewModel(application) {
    private val repository = CareerRepository(application)

    // UI States
    val userProfile: StateFlow<UserProfile> = repository.getUserProfile()
        .map { it ?: UserProfile() }
        .stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), UserProfile())

    val chatMessages: StateFlow<List<ChatMessage>> = repository.getChatMessages()
        .stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), emptyList())

    val simulation: StateFlow<CareerSimulation?> = repository.getSimulation()
        .stateIn(viewModelScope, SharingStarted.WhileSubscribed(5000), null)

    // Screen navigation tracking
    private val _currentScreen = MutableStateFlow("splash")
    val currentScreen: StateFlow<String> = _currentScreen.asStateFlow()

    // Interactive UI controls
    private val _isSimulating = MutableStateFlow(false)
    val isSimulating: StateFlow<Boolean> = _isSimulating.asStateFlow()

    private val _isChatLoading = MutableStateFlow(false)
    val isChatLoading: StateFlow<Boolean> = _isChatLoading.asStateFlow()

    private val _simulationComplete = MutableStateFlow(false)
    val simulationComplete: StateFlow<Boolean> = _simulationComplete.asStateFlow()

    // Form states temporary hold
    private val _formAge = MutableStateFlow(17)
    val formAge = _formAge.asStateFlow()

    private val _formCountry = MutableStateFlow("Nigeria")
    val formCountry = _formCountry.asStateFlow()

    private val _formInterests = MutableStateFlow("Technology, Coding, Mathematics")
    val formInterests = _formInterests.asStateFlow()

    private val _formSkills = MutableStateFlow("Basic Logic, English, Writing")
    val formSkills = _formSkills.asStateFlow()

    private val _formGrades = MutableStateFlow("A in Math, B in English, A in Physics")
    val formGrades = _formGrades.asStateFlow()

    private val _formBudget = MutableStateFlow("Under $1,000/year (Requires scholarships/free paths)")
    val formBudget = _formBudget.asStateFlow()

    private val _formInternet = MutableStateFlow("Mobile Data only, capped (Low Bandwidth)")
    val formInternet = _formInternet.asStateFlow()

    private val _formLifestyle = MutableStateFlow("Remote Freelancer or Tech Entrepreneur")
    val formLifestyle = _formLifestyle.asStateFlow()

    // Initializer
    init {
        // Prepare database with default items on launch
        viewModelScope.launch {
            val existing = repository.getUserProfile().firstOrNull()
            if (existing == null) {
                repository.saveProfile(UserProfile())
            }
        }
    }

    // Setters
    fun navigateTo(screen: String) {
        _currentScreen.value = screen
    }

    fun updateFormFields(
        age: Int,
        country: String,
        interests: String,
        skills: String,
        grades: String,
        budget: String,
        internet: String,
        lifestyle: String
    ) {
        _formAge.value = age
        _formCountry.value = country
        _formInterests.value = interests
        _formSkills.value = skills
        _formGrades.value = grades
        _formBudget.value = budget
        _formInternet.value = internet
        _formLifestyle.value = lifestyle
    }

    fun saveUserProfileAndRunSimulation() {
        viewModelScope.launch {
            _isSimulating.value = true
            val profile = UserProfile(
                age = _formAge.value,
                country = _formCountry.value,
                interests = _formInterests.value,
                skills = _formSkills.value,
                grades = _formGrades.value,
                budget = _formBudget.value,
                internetAccess = _formInternet.value,
                preferredLifestyle = _formLifestyle.value,
                xp = userProfile.value.xp,
                level = userProfile.value.level,
                streak = userProfile.value.streak,
                futureScore = userProfile.value.futureScore,
                isPremium = userProfile.value.isPremium
            )
            repository.saveProfile(profile)
            repository.runCareerSimulation(profile)
            _isSimulating.value = false
            _simulationComplete.value = true
            _currentScreen.value = "dashboard"
        }
    }

    fun togglePremium(isPremium: Boolean) {
        viewModelScope.launch {
            val prof = userProfile.value.copy(isPremium = isPremium)
            repository.saveProfile(prof)
        }
    }

    fun sendChatMessage(text: String) {
        if (text.isBlank()) return
        viewModelScope.launch {
            _isChatLoading.value = true
            repository.sendMessage("user", text)
            _isChatLoading.value = false
        }
    }

    fun clearChatHistory() {
        viewModelScope.launch {
            repository.clearChat()
        }
    }

    // Award bonus event XP for dashboard learning engagement clicks
    fun claimDailyReward() {
        viewModelScope.launch {
            val profile = userProfile.value
            val bonus = 25
            val currentXp = profile.xp + bonus
            val level = 1 + (currentXp / 300)
            repository.saveProfile(profile.copy(
                xp = currentXp,
                level = level,
                streak = profile.streak + 1,
                lastUpdate = System.currentTimeMillis()
            ))
        }
    }
}
