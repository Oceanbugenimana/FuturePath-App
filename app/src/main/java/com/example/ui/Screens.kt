package com.example.ui

import androidx.compose.animation.*
import androidx.compose.animation.core.*
import androidx.compose.foundation.*
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.Send
import androidx.compose.material.icons.filled.*
import androidx.compose.material.icons.outlined.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.drawWithContent
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.data.*
import com.example.ui.theme.*
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

// --- Glassmorphism UI Card Helper ---
@Composable
fun CyberGlassCard(
    modifier: Modifier = Modifier,
    borderColor: Color = Color.White.copy(alpha = 0.12f),
    content: @Composable ColumnScope.() -> Unit
) {
    Card(
        modifier = modifier
            .border(
                width = 1.dp,
                brush = Brush.linearGradient(
                    colors = listOf(borderColor, borderColor.copy(alpha = 0.02f), Color.Transparent)
                ),
                shape = RoundedCornerShape(20.dp)
            ),
        shape = RoundedCornerShape(20.dp),
        colors = CardDefaults.cardColors(
            containerColor = Color.White.copy(alpha = 0.04f)
        )
    ) {
        Column(
            modifier = Modifier.padding(18.dp)
        ) {
            content()
        }
    }
}

// ==========================================
// 1. SPLASH SCREEN
// ==========================================
@Composable
fun SplashScreen(onTimeout: () -> Unit) {
    var startAnimation by remember { mutableStateOf(false) }
    val scale by animateFloatAsState(
        targetValue = if (startAnimation) 1f else 0.4f,
        animationSpec = spring(dampingRatio = Spring.DampingRatioMediumBouncy, stiffness = Spring.StiffnessLow),
        label = "Logo bounce"
    )
    val alpha by animateFloatAsState(
        targetValue = if (startAnimation) 1f else 0f,
        animationSpec = tween(1200),
        label = "Fade logo"
    )

    LaunchedEffect(key1 = true) {
        startAnimation = true
        delay(3000)
        onTimeout()
    }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(
                Brush.verticalGradient(
                    listOf(CyberBg, Color(0xFF10072B), CyberBg)
                )
            ),
        contentAlignment = Alignment.Center
    ) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            modifier = Modifier.padding(24.dp)
        ) {
            Box(
                modifier = Modifier
                    .size(120.dp)
                    .background(
                        Brush.radialGradient(listOf(NeonTeal.copy(0.4f), Color.Transparent)),
                        shape = CircleShape
                    ),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = Icons.Default.Timeline,
                    contentDescription = "Logo",
                    tint = NeonTeal,
                    modifier = Modifier
                        .size(72.dp)
                        .testTag("splash_logo")
                )
            }
            Spacer(modifier = Modifier.height(24.dp))
            Text(
                text = "FUTUREPATH AI",
                color = StellarWhite,
                fontSize = 32.sp,
                fontWeight = FontWeight.ExtraBold,
                fontFamily = FontFamily.Monospace,
                letterSpacing = 2.sp,
                textAlign = TextAlign.Center,
                modifier = Modifier.testTag("splash_title")
            )
            Spacer(modifier = Modifier.height(12.dp))
            Text(
                text = "Futuristic Career Strategy Ecosystem",
                color = NeonPurple,
                fontSize = 14.sp,
                fontWeight = FontWeight.Bold,
                letterSpacing = 1.sp,
                textAlign = TextAlign.Center
            )
            Spacer(modifier = Modifier.height(48.dp))
            CircularProgressIndicator(
                color = NeonTeal,
                strokeWidth = 3.dp,
                modifier = Modifier.size(32.dp)
            )
            Spacer(modifier = Modifier.height(16.dp))
            Text(
                text = "Initializing AI Strategy Models...",
                color = CyberGray,
                fontSize = 12.sp,
                fontFamily = FontFamily.Monospace
            )
        }
    }
}

// ==========================================
// 2. ONBOARDING & AUTH SIMULATOR
// ==========================================
@Composable
fun OnboardingScreen(onComplete: () -> Unit) {
    var pageState by remember { mutableStateOf(0) }
    val currentData = listOf(
        Triple("AI Career Simulation", "Simulate decades of career projections, income paths, and market demand under AI disruption cycles.", Icons.Default.PrecisionManufacturing),
        Triple("Skill Gap Analysis", "Compare your current performance to global engineering standards. Pinpoint immediate steps to elevate skills.", Icons.Default.BarChart),
        Triple("Global Career Arbitrage", "Bridge from local realities to global compensation. Exploit US/foreign remote work and outsourcing paths.", Icons.Default.Public)
    )

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(CyberBg)
            .padding(24.dp)
            .windowInsetsPadding(WindowInsets.safeDrawing),
        contentAlignment = Alignment.Center
    ) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            modifier = Modifier.fillMaxWidth()
        ) {
            // Header
            Row(
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(Icons.Default.Timeline, contentDescription = null, tint = NeonTeal, modifier = Modifier.size(24.dp))
                Spacer(modifier = Modifier.width(8.dp))
                Text("FUTUREPATH AI", color = StellarWhite, fontWeight = FontWeight.Bold, fontSize = 16.sp, fontFamily = FontFamily.Monospace)
            }
            Spacer(modifier = Modifier.weight(1f))

            // Info Card
            CyberGlassCard(
                modifier = Modifier
                    .fillMaxWidth()
                    .testTag("onboarding_card")
            ) {
                Box(
                    modifier = Modifier
                        .size(56.dp)
                        .background(NeonPurple.copy(alpha = 0.2f), RoundedCornerShape(12.dp)),
                    contentAlignment = Alignment.Center
                ) {
                    Icon(currentData[pageState].third, contentDescription = null, tint = NeonTeal, modifier = Modifier.size(32.dp))
                }
                Spacer(modifier = Modifier.height(16.dp))
                Text(
                    text = currentData[pageState].first,
                    color = StellarWhite,
                    fontWeight = FontWeight.ExtraBold,
                    fontSize = 22.sp
                )
                Spacer(modifier = Modifier.height(12.dp))
                Text(
                    text = currentData[pageState].second,
                    color = CyberGray,
                    fontSize = 14.sp,
                    lineHeight = 20.sp
                )
            }

            Spacer(modifier = Modifier.height(32.dp))

            // Page indicators
            Row(horizontalArrangement = Arrangement.Center) {
                repeat(3) { index ->
                    Box(
                        modifier = Modifier
                            .padding(horizontal = 4.dp)
                            .size(if (index == pageState) 12.dp else 8.dp)
                            .background(
                                color = if (index == pageState) NeonTeal else CyberGray.copy(alpha = 0.5f),
                                shape = CircleShape
                            )
                    )
                }
            }

            Spacer(modifier = Modifier.weight(1f))

            Button(
                onClick = {
                    if (pageState < 2) {
                        pageState++
                    } else {
                        onComplete()
                    }
                },
                modifier = Modifier
                    .fillMaxWidth()
                    .height(56.dp)
                    .testTag("onboarding_next"),
                colors = ButtonDefaults.buttonColors(containerColor = NeonPurple),
                shape = RoundedCornerShape(12.dp)
            ) {
                Text(if (pageState == 2) "Initialize Simulator" else "Continue", color = StellarWhite, fontSize = 16.sp, fontWeight = FontWeight.Bold)
            }
        }
    }
}

// Authentication simulated screen
@Composable
fun AuthScreen(onAuthSuccess: () -> Unit) {
    var email by remember { mutableStateOf("") }
    var inviteCode by remember { mutableStateOf("") }
    var biometricVerified by remember { mutableStateOf(false) }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(CyberBg)
            .padding(24.dp)
            .windowInsetsPadding(WindowInsets.safeDrawing),
        contentAlignment = Alignment.Center
    ) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            modifier = Modifier.fillMaxWidth()
        ) {
            Text(
                "SECURED ENTRY",
                color = NeonTeal,
                fontSize = 14.sp,
                fontFamily = FontFamily.Monospace,
                letterSpacing = 2.sp
            )
            Spacer(modifier = Modifier.height(8.dp))
            Text(
                "Verify Strategy Account",
                color = StellarWhite,
                fontSize = 24.sp,
                fontWeight = FontWeight.Bold,
                textAlign = TextAlign.Center
            )
            Spacer(modifier = Modifier.height(12.dp))
            Text(
                "For students & career-changers seeking global arbitrage.",
                color = CyberGray,
                fontSize = 13.sp,
                textAlign = TextAlign.Center
            )

            Spacer(modifier = Modifier.height(32.dp))

            OutlinedTextField(
                value = email,
                onValueChange = { email = it },
                label = { Text("Enter Email") },
                colors = OutlinedTextFieldDefaults.colors(
                    focusedTextColor = StellarWhite,
                    unfocusedTextColor = StellarWhite,
                    focusedBorderColor = NeonTeal,
                    unfocusedBorderColor = CyberGray
                ),
                modifier = Modifier
                    .fillMaxWidth()
                    .testTag("auth_email"),
                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Email),
                singleLine = true
            )

            Spacer(modifier = Modifier.height(16.dp))

            OutlinedTextField(
                value = inviteCode,
                onValueChange = { inviteCode = it },
                label = { Text("Invite/Access Code (Optional)") },
                colors = OutlinedTextFieldDefaults.colors(
                    focusedTextColor = StellarWhite,
                    unfocusedTextColor = StellarWhite,
                    focusedBorderColor = NeonTeal,
                    unfocusedBorderColor = CyberGray
                ),
                modifier = Modifier.fillMaxWidth(),
                singleLine = true
            )

            Spacer(modifier = Modifier.height(24.dp))

            CyberGlassCard(modifier = Modifier.fillMaxWidth()) {
                Row(
                    verticalAlignment = Alignment.CenterVertically,
                    modifier = Modifier.clickable {
                        biometricVerified = !biometricVerified
                    }
                ) {
                    Icon(
                        Icons.Default.Fingerprint,
                        contentDescription = null,
                        tint = if (biometricVerified) NeonTeal else CyberGray,
                        modifier = Modifier.size(36.dp)
                    )
                    Spacer(modifier = Modifier.width(16.dp))
                    Column(modifier = Modifier.weight(1f)) {
                        Text(
                            "Simulate Biometric lock",
                            color = StellarWhite,
                            fontSize = 14.sp,
                            fontWeight = FontWeight.Bold
                        )
                        Text(
                            if (biometricVerified) "Biometric Lock active" else "Fast secure access check",
                            color = CyberGray,
                            fontSize = 12.sp
                        )
                    }
                    Switch(
                        checked = biometricVerified,
                        onCheckedChange = { biometricVerified = it },
                        colors = SwitchDefaults.colors(checkedThumbColor = NeonTeal)
                    )
                }
            }

            Spacer(modifier = Modifier.height(48.dp))

            Button(
                onClick = onAuthSuccess,
                modifier = Modifier
                    .fillMaxWidth()
                    .height(56.dp)
                    .testTag("auth_submit"),
                colors = ButtonDefaults.buttonColors(containerColor = NeonPurple),
                shape = RoundedCornerShape(12.dp)
            ) {
                Text("Enter Future Database", color = StellarWhite, fontSize = 16.sp, fontWeight = FontWeight.Bold)
            }
        }
    }
}

// ==========================================
// 3. MAIN AI STRATEGY ASSESSMENT FORM
// ==========================================
@Composable
fun AssessmentScreen(viewModel: FuturePathViewModel) {
    var age by remember { mutableStateOf(17) }
    var country by remember { mutableStateOf("Nigeria") }
    var interests by remember { mutableStateOf("Coding, Web Apps, Robotics, Data Strategy") }
    var skills by remember { mutableStateOf("Basic HTML/CSS, Intermediate Arithmetic, High Motivation") }
    var grades by remember { mutableStateOf("Distinctions in Mathematics, High marks in English") }
    var budget by remember { mutableStateOf("Free Resource Route (Budget under $500/yr)") }
    var internet by remember { mutableStateOf("Limited connection, cap limits (Low Bandwidth)") }
    var lifestyle by remember { mutableStateOf("Remote Contractor, US Dollar outsourcing client models") }

    val isSimulating by viewModel.isSimulating.collectAsState()

    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .background(CyberBg)
            .padding(24.dp)
            .windowInsetsPadding(WindowInsets.safeDrawing),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        item {
            Column(horizontalAlignment = Alignment.CenterHorizontally, modifier = Modifier.fillMaxWidth()) {
                Text(
                    "CORE ASSESSMENT",
                    color = NeonTeal,
                    fontFamily = FontFamily.Monospace,
                    letterSpacing = 2.sp,
                    fontSize = 13.sp
                )
                Spacer(modifier = Modifier.height(4.dp))
                Text(
                    "AI Strategy Analyzer",
                    color = StellarWhite,
                    fontSize = 24.sp,
                    fontWeight = FontWeight.Bold
                )
                Spacer(modifier = Modifier.height(8.dp))
                Text(
                    "Provide your local context details. FuturePath's simulation engine compiles globally competitive pathways.",
                    color = CyberGray,
                    fontSize = 13.sp,
                    textAlign = TextAlign.Center
                )
            }
        }

        item {
            CyberGlassCard(modifier = Modifier.fillMaxWidth()) {
                Text("Demographics & Core Locale", color = NeonTeal, fontWeight = FontWeight.Bold, fontSize = 14.sp)
                Spacer(modifier = Modifier.height(12.dp))

                Text("Your Age: $age yrs", color = StellarWhite, fontSize = 14.sp)
                Slider(
                    value = age.toFloat(),
                    onValueChange = { age = it.toInt() },
                    valueRange = 13f..30f,
                    colors = SliderDefaults.colors(thumbColor = NeonTeal, activeTrackColor = NeonPurple)
                )

                Spacer(modifier = Modifier.height(8.dp))

                OutlinedTextField(
                    value = country,
                    onValueChange = { country = it },
                    label = { Text("Country of Residence") },
                    colors = OutlinedTextFieldDefaults.colors(focusedTextColor = StellarWhite, unfocusedTextColor = StellarWhite, focusedBorderColor = NeonTeal, unfocusedBorderColor = CyberGray),
                    modifier = Modifier.fillMaxWidth(),
                    singleLine = true
                )
            }
        }

        item {
            CyberGlassCard(modifier = Modifier.fillMaxWidth()) {
                Text("Interests, Strengths & Current Capabilities", color = NeonTeal, fontWeight = FontWeight.Bold, fontSize = 14.sp)
                Spacer(modifier = Modifier.height(12.dp))

                OutlinedTextField(
                    value = interests,
                    onValueChange = { interests = it },
                    label = { Text("Your Core Interests (Separate by commas)") },
                    colors = OutlinedTextFieldDefaults.colors(focusedTextColor = StellarWhite, unfocusedTextColor = StellarWhite, focusedBorderColor = NeonTeal, unfocusedBorderColor = CyberGray),
                    modifier = Modifier.fillMaxWidth(),
                    maxLines = 2
                )

                Spacer(modifier = Modifier.height(8.dp))

                OutlinedTextField(
                    value = skills,
                    onValueChange = { skills = it },
                    label = { Text("Active Skills / Familiar Technologies") },
                    colors = OutlinedTextFieldDefaults.colors(focusedTextColor = StellarWhite, unfocusedTextColor = StellarWhite, focusedBorderColor = NeonTeal, unfocusedBorderColor = CyberGray),
                    modifier = Modifier.fillMaxWidth(),
                    maxLines = 2
                )

                Spacer(modifier = Modifier.height(8.dp))

                OutlinedTextField(
                    value = grades,
                    onValueChange = { grades = it },
                    label = { Text("Academic Grades / School Score Quality") },
                    colors = OutlinedTextFieldDefaults.colors(focusedTextColor = StellarWhite, unfocusedTextColor = StellarWhite, focusedBorderColor = NeonTeal, unfocusedBorderColor = CyberGray),
                    modifier = Modifier.fillMaxWidth(),
                    singleLine = true
                )
            }
        }

        item {
            CyberGlassCard(modifier = Modifier.fillMaxWidth()) {
                Text("Economic Constraints & Target Goal", color = NeonTeal, fontWeight = FontWeight.Bold, fontSize = 14.sp)
                Spacer(modifier = Modifier.height(12.dp))

                OutlinedTextField(
                    value = budget,
                    onValueChange = { budget = it },
                    label = { Text("Annual Education Budget Capacity (USD)") },
                    colors = OutlinedTextFieldDefaults.colors(focusedTextColor = StellarWhite, unfocusedTextColor = StellarWhite, focusedBorderColor = NeonTeal, unfocusedBorderColor = CyberGray),
                    modifier = Modifier.fillMaxWidth(),
                    singleLine = true
                )

                Spacer(modifier = Modifier.height(8.dp))

                OutlinedTextField(
                    value = internet,
                    onValueChange = { internet = it },
                    label = { Text("Internet Connectivity & Devices Level") },
                    colors = OutlinedTextFieldDefaults.colors(focusedTextColor = StellarWhite, unfocusedTextColor = StellarWhite, focusedBorderColor = NeonTeal, unfocusedBorderColor = CyberGray),
                    modifier = Modifier.fillMaxWidth(),
                    singleLine = true
                )

                Spacer(modifier = Modifier.height(8.dp))

                OutlinedTextField(
                    value = lifestyle,
                    onValueChange = { lifestyle = it },
                    label = { Text("Target Goal / Lifestyle Desired") },
                    colors = OutlinedTextFieldDefaults.colors(focusedTextColor = StellarWhite, unfocusedTextColor = StellarWhite, focusedBorderColor = NeonTeal, unfocusedBorderColor = CyberGray),
                    modifier = Modifier.fillMaxWidth(),
                    singleLine = true
                )
            }
        }

        item {
            if (isSimulating) {
                Box(modifier = Modifier.fillMaxWidth().height(100.dp), contentAlignment = Alignment.Center) {
                    Column(horizontalAlignment = Alignment.CenterHorizontally) {
                        CircularProgressIndicator(color = NeonTeal)
                        Spacer(modifier = Modifier.height(8.dp))
                        Text("Futuristic AI Simulator crunching projections...", color = NeonTeal, fontSize = 12.sp, fontFamily = FontFamily.Monospace)
                    }
                }
            } else {
                Button(
                    onClick = {
                        viewModel.updateFormFields(
                            age = age,
                            country = country,
                            interests = interests,
                            skills = skills,
                            grades = grades,
                            budget = budget,
                            internet = internet,
                            lifestyle = lifestyle
                        )
                        viewModel.saveUserProfileAndRunSimulation()
                    },
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(56.dp)
                        .testTag("assessment_submit"),
                    colors = ButtonDefaults.buttonColors(containerColor = NeonPurple),
                    shape = RoundedCornerShape(12.dp)
                ) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Text("LAUNCH AI SIMULATOR ENGINE", color = StellarWhite, fontWeight = FontWeight.Bold, fontSize = 14.sp)
                        Spacer(modifier = Modifier.width(8.dp))
                        Icon(Icons.Default.Launch, contentDescription = null, modifier = Modifier.size(18.dp))
                    }
                }
            }
            Spacer(modifier = Modifier.height(48.dp))
        }
    }
}

// ==========================================
// 4. MAIN CENTRAL DASHBOARD
// ==========================================
@Composable
fun DashboardScreen(viewModel: FuturePathViewModel, onMenuClick: (String) -> Unit) {
    val user by viewModel.userProfile.collectAsState()
    val simulation by viewModel.simulation.collectAsState()

    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .background(CyberBg)
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        // Welcomer Header
        item {
            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Column(modifier = Modifier.weight(1f)) {
                    Text(
                        text = "FUTUREPATH STRATEGIST",
                        color = NeonTeal,
                        fontSize = 11.sp,
                        fontFamily = FontFamily.Monospace,
                        letterSpacing = 1.sp
                    )
                    Text(
                        text = "Hello, Future Captain! 👋",
                        color = StellarWhite,
                        fontSize = 20.sp,
                        fontWeight = FontWeight.Bold
                    )
                    Text(
                        text = "Ready to audit global career possibilities",
                        color = CyberGray,
                        fontSize = 12.sp
                    )
                }

                if (user.isPremium) {
                    Box(
                        modifier = Modifier
                            .background(PremiumGold.copy(0.15f), RoundedCornerShape(20.dp))
                            .border(1.dp, PremiumGold, RoundedCornerShape(20.dp))
                            .padding(horizontal = 12.dp, vertical = 6.dp)
                    ) {
                        Text("PREMIUM", color = PremiumGold, fontSize = 10.sp, fontWeight = FontWeight.Bold)
                    }
                } else {
                    OutlinedButton(
                        onClick = { onMenuClick("premium") },
                        border = BorderStroke(1.dp, NeonPurple),
                        contentPadding = PaddingValues(horizontal = 12.dp, vertical = 4.dp),
                        modifier = Modifier.height(32.dp)
                    ) {
                        Text("UPGRADE", color = NeonPurple, fontSize = 10.sp, fontWeight = FontWeight.Bold)
                    }
                }
            }
        }

        // --- SECTION 1: GAMIFICATION ENGINE STATS ---
        item {
            CyberGlassCard(modifier = Modifier.fillMaxWidth()) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Column(modifier = Modifier.weight(1f)) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Icon(Icons.Default.Bolt, contentDescription = null, tint = EasyGreen, modifier = Modifier.size(20.dp))
                            Text("LEVEL ${user.level} STRATEGIST", color = StellarWhite, fontSize = 14.sp, fontWeight = FontWeight.ExtraBold)
                        }
                        Spacer(modifier = Modifier.height(4.dp))
                        Text("${user.xp} / ${user.level * 300} XP Accumulated", color = CyberGray, fontSize = 11.sp)
                        Spacer(modifier = Modifier.height(8.dp))
                        LinearProgressIndicator(
                            progress = (user.xp % 300).toFloat() / 300f,
                            color = NeonTeal,
                            trackColor = CyberGray.copy(0.2f),
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(6.dp)
                                .clip(CircleShape)
                        )
                    }

                    Spacer(modifier = Modifier.width(20.dp))

                    Column(horizontalAlignment = Alignment.CenterHorizontally) {
                        Box(
                            modifier = Modifier
                                .size(56.dp)
                                .background(NeonPurple.copy(0.1f), CircleShape)
                                .border(2.dp, NeonPurple, CircleShape),
                            contentAlignment = Alignment.Center
                        ) {
                            Text(
                                "${user.futureScore}",
                                color = NeonTeal,
                                fontSize = 18.sp,
                                fontWeight = FontWeight.Bold
                            )
                        }
                        Spacer(modifier = Modifier.height(4.dp))
                        Text("Future Score", color = CyberGray, fontSize = 10.sp, fontWeight = FontWeight.SemiBold)
                    }
                }

                Divider(color = CyberGray.copy(0.15f), modifier = Modifier.padding(vertical = 12.dp))

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Icon(Icons.Default.LocalFireDepartment, contentDescription = null, tint = NeonPink, modifier = Modifier.size(24.dp))
                        Spacer(modifier = Modifier.width(6.dp))
                        Text("${user.streak} Day planning Streak", color = StellarWhite, fontSize = 13.sp, fontWeight = FontWeight.Bold)
                    }

                    TextButton(
                        onClick = { viewModel.claimDailyReward() },
                        colors = ButtonDefaults.textButtonColors(contentColor = NeonTeal)
                    ) {
                        Icon(Icons.Default.CardGiftcard, contentDescription = null, modifier = Modifier.size(16.dp))
                        Spacer(modifier = Modifier.width(4.dp))
                        Text("+25 XP Reward", fontSize = 12.sp, fontWeight = FontWeight.Bold)
                    }
                }
            }
        }

        // --- SECTION 2: AI CAREER PATHWAY OVERVIEW ---
        item {
            Text("YOUR DETECTED FUTURE PATHWAYS", color = NeonTeal, fontSize = 13.sp, fontWeight = FontWeight.Bold, fontFamily = FontFamily.Monospace)
        }

        val activeSim = simulation
        if (activeSim != null) {
            item {
                PrimaryImmersiveCareerCard(
                    simulation = activeSim,
                    onClick = { onMenuClick("simulator") }
                )
            }
            item {
                Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                    CareerPathSmallCard(
                        title = "Realistic",
                        career = activeSim.realisticTitle,
                        salary = activeSim.realisticSalary,
                        color = EasyGreen,
                        modifier = Modifier.weight(1f),
                        onClick = { onMenuClick("simulator") }
                    )
                    CareerPathSmallCard(
                        title = "High Risk",
                        career = activeSim.riskTitle,
                        salary = activeSim.riskSalary,
                        color = NeonPink,
                        modifier = Modifier.weight(1f),
                        onClick = { onMenuClick("simulator") }
                    )
                }
            }
        } else {
            item {
                CyberGlassCard(modifier = Modifier.fillMaxWidth().clickable { onMenuClick("assessment") }) {
                    Column(horizontalAlignment = Alignment.CenterHorizontally, modifier = Modifier.fillMaxWidth()) {
                        Icon(Icons.Default.Search, contentDescription = null, tint = NeonPurple, modifier = Modifier.size(48.dp))
                        Spacer(modifier = Modifier.height(12.dp))
                        Text("No Career Projections Generated Yet", color = StellarWhite, fontWeight = FontWeight.Bold, fontSize = 15.sp)
                        Text("Initiate the AI Strategy Assessment form to synthesize simulation outcomes", color = CyberGray, fontSize = 12.sp, textAlign = TextAlign.Center)
                        Spacer(modifier = Modifier.height(16.dp))
                        Button(
                            onClick = { onMenuClick("assessment") },
                            colors = ButtonDefaults.buttonColors(containerColor = NeonPurple)
                        ) {
                            Text("Open Assessment Form", color = StellarWhite)
                        }
                    }
                }
            }
        }

        // --- SECTION 3: STRATEGIC APP SHORTCUT MENU ---
        item {
            Text("STRATEGIC CORE LABS", color = NeonTeal, fontSize = 13.sp, fontWeight = FontWeight.Bold, fontFamily = FontFamily.Monospace)
        }

        item {
            Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                ShortcutMenuRow("Salary Trajectory Analyzer", "Custom graphic growth projections & geographic comparisons", Icons.Default.Timeline, NeonTeal) { onMenuClick("salary") }
                ShortcutMenuRow("Dynamic Learning Roadmap", "6-Month personalized study plan and free resources", Icons.Default.Map, NeonPurple) { onMenuClick("roadmap") }
                ShortcutMenuRow("Skill Gap Report", "Determine missing competencies with prioritized order", Icons.Default.Speed, NeonPink) { onMenuClick("skillgap") }
                ShortcutMenuRow("Consult Alpha-9 (AI Mentor)", "Conversational strategy and motivation support chatbot", Icons.Default.SmartToy, EasyGreen) { onMenuClick("mentor") }
                ShortcutMenuRow("Future Scenario Sandbox", "Moving, changing skills, starting businesses simulator", Icons.Default.Science, PremiumGold) { onMenuClick("scenario") }
                ShortcutMenuRow("Systems Architecture Blueprint", "Backend/Frontend full production specifications, PostgreSQL & FastAPI", Icons.Default.Terminal, StellarWhite) { onMenuClick("architect") }
            }
        }

        // --- SECTION 4: CUSTOMIZE FAVORITE COLOR PALETTE ---
        item {
            Text("🎨 CHOOSE FAVORITE ACCENT COLOR", color = NeonTeal, fontSize = 13.sp, fontWeight = FontWeight.Bold, fontFamily = FontFamily.Monospace)
        }

        item {
            CyberGlassCard(modifier = Modifier.fillMaxWidth()) {
                Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
                    Text(
                        text = "Immersive Interface Palettes",
                        color = StellarWhite,
                        fontSize = 15.sp,
                        fontWeight = FontWeight.Bold
                    )
                    Text(
                        text = "Select your favorite accent color combination. This will dynamically update the backgrounds, glows, indicators, and buttons across the entire FuturePath AI experience.",
                        color = CyberGray,
                        fontSize = 11.sp,
                        lineHeight = 16.sp
                    )
                    Spacer(modifier = Modifier.height(4.dp))

                    val themesList = listOf(
                        Triple("default", "Neon Cyber Blue (Default)", Color(0xFF3B82F6)),
                        Triple("emerald", "Jade Forest Emerald", Color(0xFF10B981)),
                        Triple("solar", "Helios Solar Amber", Color(0xFFF59E0B)),
                        Triple("crimson", "Sleek Crimson Red", Color(0xFFEF4444)),
                        Triple("amethyst", "Royal Velvet Amethyst", Color(0xFF8B5CF6))
                    )

                    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                        themesList.forEach { (theKey, theLabel, primaryCol) ->
                            val isChosen = user.favoriteTheme == theKey
                            Row(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .clip(RoundedCornerShape(14.dp))
                                    .background(
                                        if (isChosen) primaryCol.copy(alpha = 0.12f) else Color.White.copy(alpha = 0.02f)
                                    )
                                    .border(
                                        width = 1.dp,
                                        color = if (isChosen) primaryCol else Color.White.copy(alpha = 0.08f),
                                        shape = RoundedCornerShape(14.dp)
                                    )
                                    .clickable {
                                        viewModel.setFavoriteTheme(theKey)
                                    }
                                    .padding(horizontal = 16.dp, vertical = 12.dp),
                                horizontalArrangement = Arrangement.SpaceBetween,
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                Row(
                                    verticalAlignment = Alignment.CenterVertically,
                                    horizontalArrangement = Arrangement.spacedBy(12.dp)
                                ) {
                                    Box(
                                        modifier = Modifier
                                            .size(20.dp)
                                            .clip(CircleShape)
                                            .background(primaryCol)
                                    )
                                    Text(
                                        text = theLabel,
                                        color = if (isChosen) StellarWhite else CyberGray,
                                        fontSize = 13.sp,
                                        fontWeight = if (isChosen) FontWeight.Bold else FontWeight.Medium
                                    )
                                }
                                if (isChosen) {
                                    Icon(
                                        imageVector = Icons.Default.CheckCircle,
                                        contentDescription = "Selected",
                                        tint = primaryCol,
                                        modifier = Modifier.size(20.dp)
                                    )
                                } else {
                                    Box(
                                        modifier = Modifier
                                            .size(18.dp)
                                            .border(1.dp, CyberGray.copy(alpha = 0.4f), CircleShape)
                                    )
                                }
                            }
                        }
                    }
                }
            }
        }

        item {
            Spacer(modifier = Modifier.height(48.dp))
        }
    }
}

@Composable
fun CareerPathSmallCard(
    title: String,
    career: String,
    salary: String,
    color: Color,
    modifier: Modifier = Modifier,
    onClick: () -> Unit
) {
    Card(
        modifier = modifier
            .heightIn(min = 120.dp)
            .border(1.dp, color.copy(alpha = 0.3f), RoundedCornerShape(12.dp))
            .clickable(onClick = onClick),
        shape = RoundedCornerShape(12.dp),
        colors = CardDefaults.cardColors(containerColor = CyberCard)
    ) {
        Column(modifier = Modifier.padding(12.dp)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Box(modifier = Modifier.size(6.dp).background(color, CircleShape))
                Spacer(modifier = Modifier.width(6.dp))
                Text(title.uppercase(), color = color, fontSize = 10.sp, fontWeight = FontWeight.Bold, fontFamily = FontFamily.Monospace)
            }
            Spacer(modifier = Modifier.height(8.dp))
            Text(career, color = StellarWhite, fontSize = 14.sp, fontWeight = FontWeight.Bold, maxLines = 2)
            Spacer(modifier = Modifier.weight(1f))
            Text(salary, color = NeonTeal, fontSize = 12.sp, fontWeight = FontWeight.SemiBold, fontFamily = FontFamily.Monospace)
        }
    }
}

@Composable
fun PrimaryImmersiveCareerCard(
    simulation: CareerSimulation,
    onClick: () -> Unit
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .heightIn(min = 220.dp)
            .border(
                width = 1.dp,
                brush = Brush.linearGradient(
                    colors = listOf(Color.White.copy(alpha = 0.15f), Color.White.copy(alpha = 0.02f))
                ),
                shape = RoundedCornerShape(24.dp)
            )
            .clickable(onClick = onClick),
        shape = RoundedCornerShape(24.dp),
        colors = CardDefaults.cardColors(
            containerColor = Color.White.copy(alpha = 0.04f)
        )
    ) {
        Box(modifier = Modifier.padding(20.dp)) {
            // Background decor light glow
            Box(
                modifier = Modifier
                    .align(Alignment.BottomEnd)
                    .size(100.dp)
                    .background(
                        Brush.radialGradient(
                            colors = listOf(NeonTeal.copy(alpha = 0.15f), Color.Transparent)
                        )
                    )
            )

            Column(
                verticalArrangement = Arrangement.SpaceBetween,
                modifier = Modifier.fillMaxWidth()
            ) {
                // Header badge row
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Box(modifier = Modifier.size(8.dp).background(NeonTeal, CircleShape))
                        Spacer(modifier = Modifier.width(6.dp))
                        Text(
                            text = "OPTIMISTIC TARGET",
                            color = NeonTeal,
                            fontSize = 10.sp,
                            fontWeight = FontWeight.Bold,
                            fontFamily = FontFamily.Monospace,
                            letterSpacing = 1.sp
                        )
                    }

                    Box(
                        modifier = Modifier
                            .background(NeonTeal.copy(alpha = 0.1f), RoundedCornerShape(8.dp))
                            .border(1.dp, NeonTeal.copy(alpha = 0.3f), RoundedCornerShape(8.dp))
                            .padding(horizontal = 8.dp, vertical = 3.dp)
                    ) {
                        Text(
                            text = "ALPHA PATHWAY",
                            color = StellarWhite,
                            fontSize = 8.sp,
                            fontWeight = FontWeight.Bold,
                            letterSpacing = 0.5.sp
                        )
                    }
                }

                Spacer(modifier = Modifier.height(16.dp))

                // Title and regional detail
                Text(
                    text = simulation.optimisticTitle,
                    color = StellarWhite,
                    fontSize = 24.sp,
                    fontWeight = FontWeight.Light,
                    lineHeight = 28.sp
                )
                Text(
                    text = "Based on Global remote clusters, target arbitrage USD.",
                    color = CyberGray,
                    fontSize = 12.sp,
                )

                Spacer(modifier = Modifier.height(24.dp))

                // Projected Salary & visual Sparkline Graph representation
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.Bottom
                ) {
                    Column {
                        Text(
                            text = "PROJECTED SALARY (YR 5)",
                            color = CyberGray,
                            fontSize = 8.sp,
                            fontWeight = FontWeight.Bold,
                            letterSpacing = 1.sp
                        )
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Text(
                                text = simulation.optimisticSalary,
                                color = StellarWhite,
                                fontSize = 22.sp,
                                fontWeight = FontWeight.Bold,
                                fontFamily = FontFamily.Monospace,
                                letterSpacing = (-0.5).sp
                            )
                            Spacer(modifier = Modifier.width(6.dp))
                            Text(
                                text = "+12%",
                                color = EasyGreen,
                                fontSize = 12.sp,
                                fontWeight = FontWeight.Bold
                            )
                        }
                    }

                    // Elegant Sparkline widget
                    Row(
                        verticalAlignment = Alignment.Bottom,
                        horizontalArrangement = Arrangement.spacedBy(3.dp),
                        modifier = Modifier.padding(bottom = 2.dp)
                    ) {
                        Box(modifier = Modifier.width(4.dp).height(12.dp).background(NeonTeal.copy(alpha = 0.3f), CircleShape))
                        Box(modifier = Modifier.width(4.dp).height(20.dp).background(NeonTeal.copy(alpha = 0.5f), CircleShape))
                        Box(modifier = Modifier.width(4.dp).height(32.dp).background(NeonTeal.copy(alpha = 0.7f), CircleShape))
                        Box(modifier = Modifier.width(4.dp).height(24.dp).background(NeonTeal.copy(alpha = 0.9f), CircleShape))
                        Box(modifier = Modifier.width(4.dp).height(42.dp).background(NeonTeal, CircleShape))
                    }
                }

                Spacer(modifier = Modifier.height(16.dp))

                // Skill readiness indicator slider
                LinearProgressIndicator(
                    progress = 0.68f,
                    color = NeonTeal,
                    trackColor = Color.White.copy(alpha = 0.08f),
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(6.dp)
                        .clip(CircleShape)
                )

                Spacer(modifier = Modifier.height(6.dp))

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = "Current Skillset Readiness",
                        color = CyberGray,
                        fontSize = 9.sp,
                        fontWeight = FontWeight.Medium
                    )
                    Text(
                        text = "68% Readiness",
                        color = NeonTeal,
                        fontSize = 9.sp,
                        fontWeight = FontWeight.Bold
                    )
                }
            }
        }
    }
}

@Composable
fun ShortcutMenuRow(
    title: String,
    desc: String,
    icon: ImageVector,
    color: Color,
    onClick: () -> Unit
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .clickable(onClick = onClick),
        shape = RoundedCornerShape(12.dp),
        colors = CardDefaults.cardColors(containerColor = CyberCard.copy(alpha = 0.5f))
    ) {
        Row(
            modifier = Modifier.padding(12.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Box(
                modifier = Modifier
                    .size(40.dp)
                    .background(color.copy(0.12f), RoundedCornerShape(8.dp)),
                contentAlignment = Alignment.Center
            ) {
                Icon(icon, contentDescription = null, tint = color, modifier = Modifier.size(20.dp))
            }
            Spacer(modifier = Modifier.width(16.dp))
            Column(modifier = Modifier.weight(1f)) {
                Text(title, color = StellarWhite, fontSize = 14.sp, fontWeight = FontWeight.Bold)
                Text(desc, color = CyberGray, fontSize = 11.sp)
            }
            Icon(Icons.Default.ChevronRight, contentDescription = null, tint = CyberGray, modifier = Modifier.size(20.dp))
        }
    }
}

// ==========================================
// 5. CAREER SIMULATOR DETAILS SCREEN
// ==========================================
@Composable
fun CareerSimulatorScreen(viewModel: FuturePathViewModel) {
    val sim by viewModel.simulation.collectAsState()

    if (sim == null) {
        Box(modifier = Modifier.fillMaxSize().background(CyberBg), contentAlignment = Alignment.Center) {
            Text("Run Career simulation first from dashboard assessment", color = StellarWhite)
        }
        return
    }

    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .background(CyberBg)
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        item {
            Column(horizontalAlignment = Alignment.CenterHorizontally, modifier = Modifier.fillMaxWidth()) {
                Text("STRATEGY METRICS", color = NeonTeal, fontFamily = FontFamily.Monospace, letterSpacing = 2.sp, fontSize = 11.sp)
                Text("Simulated Futures", color = StellarWhite, fontSize = 24.sp, fontWeight = FontWeight.Bold)
            }
        }

        item {
            PathDetailCard(
                pathName = "Optimistic Pathway (Global USD remote target)",
                career = sim!!.optimisticTitle,
                salary = sim!!.optimisticSalary,
                brief = sim!!.optimisticBrief,
                details = sim!!.optimisticDetails,
                color = NeonPurple,
                automationThreat = "Low (12% Automation Risk)",
                mitigation = "Systemic design, secure cloud integration and AI orchestration keep this extremely resilient."
            )
        }

        item {
            PathDetailCard(
                pathName = "Realistic Pathway (Regional hub & outsourcing)",
                career = sim!!.realisticTitle,
                salary = sim!!.realisticSalary,
                brief = sim!!.realisticBrief,
                details = sim!!.realisticDetails,
                color = EasyGreen,
                automationThreat = "Medium (38% Automation Risk)",
                mitigation = "Standard UI writing is vulnerable; focus heavily on bespoke localized software integrations and data engineering."
            )
        }

        item {
            PathDetailCard(
                pathName = "High-Risk High-Reward (Independent founder / SaaS)",
                career = sim!!.riskTitle,
                salary = sim!!.riskSalary,
                brief = sim!!.riskBrief,
                details = sim!!.riskDetails,
                color = NeonPink,
                automationThreat = "Extremely Low (5% Risk - Creative Entrepreneurship)",
                mitigation = "Indie SaaS builders utilize AI to fast-track MVP creation. Risk is marketing and competition, not code automation."
            )
        }

        item {
            Spacer(modifier = Modifier.height(48.dp))
        }
    }
}

@Composable
fun PathDetailCard(
    pathName: String,
    career: String,
    salary: String,
    brief: String,
    details: String,
    color: Color,
    automationThreat: String,
    mitigation: String
) {
    CyberGlassCard(modifier = Modifier.fillMaxWidth()) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            Box(modifier = Modifier.size(8.dp).background(color, CircleShape))
            Spacer(modifier = Modifier.width(8.dp))
            Text(pathName, color = color, fontWeight = FontWeight.Bold, fontSize = 12.sp, fontFamily = FontFamily.Monospace)
        }
        Spacer(modifier = Modifier.height(8.dp))
        Text(career, color = StellarWhite, fontSize = 20.sp, fontWeight = FontWeight.ExtraBold)
        Text(salary, color = NeonTeal, fontSize = 15.sp, fontWeight = FontWeight.Bold, fontFamily = FontFamily.Monospace)
        
        Spacer(modifier = Modifier.height(12.dp))
        Text("AI Summary:", color = color, fontSize = 11.sp, fontWeight = FontWeight.SemiBold, fontFamily = FontFamily.Monospace)
        Text(brief, color = StellarWhite, fontSize = 13.sp)
        
        Spacer(modifier = Modifier.height(12.dp))
        Text("Detailed Career Plan:", color = color, fontSize = 11.sp, fontWeight = FontWeight.SemiBold, fontFamily = FontFamily.Monospace)
        Text(details, color = CyberGray, fontSize = 13.sp, lineHeight = 18.sp)

        Divider(color = CyberGray.copy(0.12f), modifier = Modifier.padding(vertical = 12.dp))

        Row(verticalAlignment = Alignment.CenterVertically) {
            Icon(Icons.Default.Security, contentDescription = null, tint = NeonTeal, modifier = Modifier.size(16.dp))
            Spacer(modifier = Modifier.width(6.dp))
            Text("Automation Susceptibility:", color = StellarWhite, fontSize = 11.sp, fontWeight = FontWeight.Bold)
            Spacer(modifier = Modifier.width(8.dp))
            Text(automationThreat, color = if (automationThreat.contains("Low")) EasyGreen else NeonPink, fontSize = 11.sp, fontWeight = FontWeight.Bold, fontFamily = FontFamily.Monospace)
        }
        Spacer(modifier = Modifier.height(4.dp))
        Text(mitigation, color = CyberGray, fontSize = 11.sp, lineHeight = 15.sp)
    }
}

// ==========================================
// 6. SALARY TRAJECTORY (CUSTOM COMPONENT CHART SCREEN)
// ==========================================
@Composable
fun SalaryTrajectoryScreen(viewModel: FuturePathViewModel) {
    val sim by viewModel.simulation.collectAsState()
    var selectedPath by remember { mutableStateOf("optimistic") }

    if (sim == null) {
        Box(modifier = Modifier.fillMaxSize().background(CyberBg), contentAlignment = Alignment.Center) {
            Text("Simulate career trajectories first in Assessment", color = StellarWhite)
        }
        return
    }

    val optData = sim!!.salariesOptimistic.split(",").map { it.toFloatOrNull() ?: 0f }
    val realData = sim!!.salariesRealistic.split(",").map { it.toFloatOrNull() ?: 0f }
    val riskData = sim!!.salariesRisk.split(",").map { it.toFloatOrNull() ?: 0f }

    val activeDataList = when (selectedPath) {
        "optimistic" -> optData
        "realistic" -> realData
        else -> riskData
    }
    val activeColor = when (selectedPath) {
        "optimistic" -> NeonPurple
        "realistic" -> EasyGreen
        else -> NeonPink
    }

    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .background(CyberBg)
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        item {
            Column(horizontalAlignment = Alignment.CenterHorizontally, modifier = Modifier.fillMaxWidth()) {
                Text("STRATEGIC FORECASTS", color = NeonTeal, fontFamily = FontFamily.Monospace, letterSpacing = 2.sp, fontSize = 11.sp)
                Text("Salary Growth Curves", color = StellarWhite, fontSize = 24.sp, fontWeight = FontWeight.Bold)
                Text("Simulating trajectory scales over 20 years", color = CyberGray, fontSize = 12.sp)
            }
        }

        item {
            // Select Tab Row
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .background(CyberCard, RoundedCornerShape(12.dp))
                    .padding(4.dp)
            ) {
                PathSelectorBtn("Optimistic", selectedPath == "optimistic", NeonPurple, Modifier.weight(1f)) { selectedPath = "optimistic" }
                PathSelectorBtn("Realistic", selectedPath == "realistic", EasyGreen, Modifier.weight(1f)) { selectedPath = "realistic" }
                PathSelectorBtn("High Risk", selectedPath == "risk", NeonPink, Modifier.weight(1f)) { selectedPath = "risk" }
            }
        }

        item {
            // --- HIGH FIDELITY GRAPH CANVAS DRAWING ---
            CyberGlassCard(modifier = Modifier.fillMaxWidth()) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(Icons.Default.TrendingUp, contentDescription = null, tint = NeonTeal, modifier = Modifier.size(20.dp))
                    Spacer(modifier = Modifier.width(8.dp))
                    Text("Projected Trajectory: $${activeDataList.first()?.toInt()}k to $${activeDataList.last()?.toInt()}k/yr", color = StellarWhite, fontSize = 14.sp, fontWeight = FontWeight.Bold)
                }
                Spacer(modifier = Modifier.height(16.dp))

                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(180.dp)
                        .padding(horizontal = 8.dp)
                ) {
                    Canvas(
                        modifier = Modifier
                            .fillMaxSize()
                            .testTag("salary_chart")
                    ) {
                        val canvasWidth = size.width
                        val canvasHeight = size.height
                        
                        // draw background graticule grid lines
                        val steps = 4
                        for (i in 0..steps) {
                            val y = (canvasHeight / steps) * i
                            drawLine(
                                color = CyberGray.copy(0.1f),
                                start = Offset(0f, y),
                                end = Offset(canvasWidth, y),
                                strokeWidth = 1.dp.toPx()
                            )
                        }

                        // draw growth line curve
                        if (activeDataList.size >= 2) {
                            val maxVal = activeDataList.maxOrNull() ?: 100f
                            val pathPoints = mutableListOf<Offset>()
                            for (idx in activeDataList.indices) {
                                val x = (canvasWidth / (activeDataList.size -1)) * idx
                                val y = canvasHeight - (canvasHeight * (activeDataList[idx] / maxVal))
                                pathPoints.add(Offset(x, y))
                            }

                            // build custom curved spline path
                            val path = Path()
                            path.moveTo(pathPoints[0].x, pathPoints[0].y)
                            for (i in 1 until pathPoints.size) {
                                path.lineTo(pathPoints[i].x, pathPoints[i].y)
                            }

                            drawPath(
                                path = path,
                                color = activeColor,
                                style = Stroke(width = 3.dp.toPx())
                            )

                            // draw glowing coordinate dots
                            pathPoints.forEachIndexed { dotIdx, pt ->
                                drawCircle(
                                    color = activeColor,
                                    radius = 6.dp.toPx(),
                                    center = pt
                                )
                                drawCircle(
                                    color = CyberBg,
                                    radius = 3.dp.toPx(),
                                    center = pt
                                )
                            }
                        }
                    }
                }

                // X-axis timelines labels
                Row(
                    modifier = Modifier.fillMaxWidth().padding(top = 8.dp),
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    listOf("Entry", "Yr 3", "Yr 5", "Yr 10", "Yr 20").forEach { label ->
                        Text(label, color = CyberGray, fontSize = 11.sp, fontFamily = FontFamily.Monospace)
                    }
                }
            }
        }

        item {
            CyberGlassCard(modifier = Modifier.fillMaxWidth()) {
                Text("Geographic & Remote Arbitrage Comparisons", color = NeonTeal, fontWeight = FontWeight.Bold, fontSize = 14.sp)
                Spacer(modifier = Modifier.height(12.dp))

                RegionalSalaryRow("Global USD Remote Contracts", "$3k - $8.5k/month", "Arbitrage Index: 10x leverage. Live locally, earn in USD.", EasyGreen)
                RegionalSalaryRow("Regional Technology Centers", "$1.2k - $3k/month", "Arbitrage Index: 4x leverage. Accessible in cities.", NeonPurple)
                RegionalSalaryRow("Local Standard Corporate", "$400 - $900/month", "Traditional office base. High taxes, slower progression.", CyberGray)
            }
        }

        item {
            Spacer(modifier = Modifier.height(48.dp))
        }
    }
}

@Composable
fun PathSelectorBtn(
    label: String,
    isSelected: Boolean,
    color: Color,
    modifier: Modifier = Modifier,
    onClick: () -> Unit
) {
    Box(
        modifier = modifier
            .padding(2.dp)
            .clip(RoundedCornerShape(8.dp))
            .background(if (isSelected) color.copy(alpha = 0.15f) else Color.Transparent)
            .border(1.dp, if (isSelected) color else Color.Transparent, RoundedCornerShape(8.dp))
            .clickable(onClick = onClick)
            .padding(vertical = 8.dp),
        contentAlignment = Alignment.Center
    ) {
        Text(
            label,
            color = if (isSelected) color else CyberGray,
            fontWeight = FontWeight.Bold,
            fontSize = 12.sp
        )
    }
}

@Composable
fun RegionalSalaryRow(
    region: String,
    rates: String,
    leverageDetails: String,
    badgeColor: Color
) {
    Column(modifier = Modifier.padding(vertical = 8.dp)) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(region, color = StellarWhite, fontSize = 13.sp, fontWeight = FontWeight.Bold)
            Box(
                modifier = Modifier
                    .background(badgeColor.copy(0.12f), RoundedCornerShape(4.dp))
                    .padding(horizontal = 8.dp, vertical = 2.dp)
            ) {
                Text(rates, color = badgeColor, fontSize = 11.sp, fontWeight = FontWeight.Bold, fontFamily = FontFamily.Monospace)
            }
        }
        Spacer(modifier = Modifier.height(2.dp))
        Text(leverageDetails, color = CyberGray, fontSize = 11.sp)
    }
}

// ==========================================
// 7. MULTI-LEVEL LEARNING ROADMAP
// ==========================================
@Composable
fun LearningRoadmapScreen(viewModel: FuturePathViewModel) {
    val sim by viewModel.simulation.collectAsState()

    if (sim == null) {
        Box(modifier = Modifier.fillMaxSize().background(CyberBg), contentAlignment = Alignment.Center) {
            Text("Ensure Assessment is done first from dashboard", color = StellarWhite)
        }
        return
    }

    val steps = sim!!.skillRoadmap.split("|")

    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .background(CyberBg)
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        item {
            Column(horizontalAlignment = Alignment.CenterHorizontally, modifier = Modifier.fillMaxWidth()) {
                Text("STRATEGIC KNOWLEDGE TREE", color = NeonTeal, fontFamily = FontFamily.Monospace, letterSpacing = 2.sp, fontSize = 11.sp)
                Text("Study Roadmaps", color = StellarWhite, fontSize = 24.sp, fontWeight = FontWeight.Bold)
                Text("Personalized high-bandwidth free source curricula", color = CyberGray, fontSize = 12.sp)
            }
        }

        items(steps.size) { index ->
            val milestone = steps[index].trim()
            val (num, textTitle) = if (milestone.contains(":")) {
                val parts = milestone.split(":", limit = 2)
                Pair(parts[0], parts[1])
            } else {
                Pair("Month ${index + 1}", milestone)
            }

            CyberGlassCard(modifier = Modifier.fillMaxWidth()) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Box(
                        modifier = Modifier
                            .size(32.dp)
                            .background(NeonPurple.copy(alpha = 0.2f), RoundedCornerShape(8.dp)),
                        contentAlignment = Alignment.Center
                    ) {
                        Text(
                            text = (index + 1).toString(),
                            color = NeonTeal,
                            fontWeight = FontWeight.Bold,
                            fontSize = 14.sp,
                            fontFamily = FontFamily.Monospace
                        )
                    }
                    Spacer(modifier = Modifier.width(16.dp))
                    Column {
                        Text(num.uppercase(), color = NeonTeal, fontSize = 11.sp, fontWeight = FontWeight.Bold, fontFamily = FontFamily.Monospace)
                        Text(textTitle, color = StellarWhite, fontSize = 14.sp, fontWeight = FontWeight.Bold)
                    }
                }
                Spacer(modifier = Modifier.height(12.dp))
                Text("Core Materials & Free Certs suggestions:", color = CyberGray, fontSize = 11.sp, fontWeight = FontWeight.Bold)
                Spacer(modifier = Modifier.height(4.dp))
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(Icons.Default.Download, contentDescription = null, tint = EasyGreen, modifier = Modifier.size(16.dp))
                    Spacer(modifier = Modifier.width(6.dp))
                    Text("FreeCodeCamp, Coursera Open Courseware, GitHub Sandbox references", color = EasyGreen, fontSize = 11.sp)
                }
            }
        }

        item {
            CyberGlassCard(modifier = Modifier.fillMaxWidth()) {
                Text("Recommended Industrial Certs Checklist", color = NeonTeal, fontWeight = FontWeight.Bold, fontSize = 14.sp)
                Spacer(modifier = Modifier.height(12.dp))

                CertRow("AWS Cloud Practitioner (Entry Cloud)", "Free learning via AWS Skill Builder. Exam cost $100 (Scholarships available)")
                CertRow("Meta Front-End Developer Professional", "Access free via Coursera Financial Aid. Projects: React portfolio")
                CertRow("Terraform Associate (HashiCorp Cloud)", "High outlier salary value, excellent for remote contracts")
            }
        }

        item {
            Spacer(modifier = Modifier.height(48.dp))
        }
    }
}

@Composable
fun CertRow(title: String, meta: String) {
    Row(
        modifier = Modifier.padding(vertical = 8.dp),
        verticalAlignment = Alignment.Top
    ) {
        Icon(Icons.Default.WorkspacePremium, contentDescription = null, tint = PremiumGold, modifier = Modifier.size(20.dp))
        Spacer(modifier = Modifier.width(12.dp))
        Column {
            Text(title, color = StellarWhite, fontSize = 13.sp, fontWeight = FontWeight.Bold)
            Text(meta, color = CyberGray, fontSize = 11.sp)
        }
    }
}

// ==========================================
// 8. AI SKILL GAP ANALYZER SCREEN
// ==========================================
@Composable
fun SkillGapScreen(viewModel: FuturePathViewModel) {
    val sim by viewModel.simulation.collectAsState()

    if (sim == null) {
        Box(modifier = Modifier.fillMaxSize().background(CyberBg), contentAlignment = Alignment.Center) {
            Text("Projections needed to identify skill gaps", color = StellarWhite)
        }
        return
    }

    val gaps = sim!!.skillGaps.split(",")

    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .background(CyberBg)
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        item {
            Column(horizontalAlignment = Alignment.CenterHorizontally, modifier = Modifier.fillMaxWidth()) {
                Text("CAPABILITY MATRICES", color = NeonTeal, fontFamily = FontFamily.Monospace, letterSpacing = 2.sp, fontSize = 11.sp)
                Text("AI Skill Gap Analyzer", color = StellarWhite, fontSize = 24.sp, fontWeight = FontWeight.Bold)
                Text("Comparing current skills to simulated targets", color = CyberGray, fontSize = 12.sp)
            }
        }

        items(gaps.size) { index ->
            val skill = gaps[index].trim()
            val rndPriority = when (index % 3) {
                0 -> Pair("CRITICAL PRIORITY", NeonPink)
                1 -> Pair("HIGH PRIORITY", NeonPurple)
                else -> Pair("STRATEGIC ADDITION", NeonTeal)
            }

            val rndPercent = 100 - (15 + (index * 15))

            CyberGlassCard(modifier = Modifier.fillMaxWidth()) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(skill, color = StellarWhite, fontWeight = FontWeight.Bold, fontSize = 15.sp)
                    Box(
                        modifier = Modifier
                            .background(rndPriority.second.copy(alpha = 0.15f), RoundedCornerShape(4.dp))
                            .border(1.dp, rndPriority.second, RoundedCornerShape(4.dp))
                            .padding(horizontal = 8.dp, vertical = 2.dp)
                    ) {
                        Text(rndPriority.first, color = rndPriority.second, fontSize = 9.sp, fontWeight = FontWeight.Bold)
                    }
                }
                Spacer(modifier = Modifier.height(12.dp))
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Text("Current Competency Gap", color = CyberGray, fontSize = 12.sp)
                    Text("$rndPercent%", color = NeonTeal, fontSize = 12.sp, fontWeight = FontWeight.Bold, fontFamily = FontFamily.Monospace)
                }
                Spacer(modifier = Modifier.height(4.dp))
                LinearProgressIndicator(
                    progress = rndPercent.toFloat() / 100f,
                    color = rndPriority.second,
                    trackColor = CyberGray.copy(0.12f),
                    modifier = Modifier.fillMaxWidth().height(8.dp).clip(CircleShape)
                )

                Spacer(modifier = Modifier.height(12.dp))
                Text("Recommended training timeline: ${index + 1} months of peer reviews and portfolio drafts.", color = CyberGray, fontSize = 11.sp)
            }
        }

        item {
            Spacer(modifier = Modifier.height(48.dp))
        }
    }
}

// ==========================================
// 9. AI MENTOR CONVERSATION CHAT SCREEN
// ==========================================
@Composable
fun AiMentorScreen(viewModel: FuturePathViewModel) {
    val messages by viewModel.chatMessages.collectAsState()
    val isChatLoading by viewModel.isChatLoading.collectAsState()
    var messageText by remember { mutableStateOf("") }
    val scope = rememberCoroutineScope()
    val listState = rememberScrollState()

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(CyberBg)
            .padding(16.dp)
    ) {
        // Chat Header
        Row(
            modifier = Modifier.fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Box(
                modifier = Modifier
                    .size(48.dp)
                    .background(NeonPurple.copy(0.15f), CircleShape)
                    .border(1.dp, NeonTeal, CircleShape),
                contentAlignment = Alignment.Center
            ) {
                Icon(Icons.Default.SmartToy, contentDescription = null, tint = NeonTeal)
            }
            Spacer(modifier = Modifier.width(16.dp))
            Column(modifier = Modifier.weight(1f)) {
                Text("Alpha-9 Tactical Mentor", color = StellarWhite, fontWeight = FontWeight.Bold, fontSize = 16.sp)
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Box(modifier = Modifier.size(6.dp).background(EasyGreen, CircleShape))
                    Spacer(modifier = Modifier.width(6.dp))
                    Text("Strategy Engine Active", color = EasyGreen, fontSize = 11.sp, fontFamily = FontFamily.Monospace)
                }
            }
            IconButton(onClick = { viewModel.clearChatHistory() }) {
                Icon(Icons.Default.Delete, contentDescription = "Clear Chat", tint = CyberGray)
            }
        }

        Divider(color = CyberGray.copy(alpha = 0.15f), modifier = Modifier.padding(vertical = 12.dp))

        // Chat Space
        Box(modifier = Modifier.weight(1f)) {
            if (messages.isEmpty()) {
                Column(
                    modifier = Modifier.fillMaxSize(),
                    verticalArrangement = Arrangement.Center,
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Icon(Icons.Default.Quiz, contentDescription = null, tint = NeonPurple.copy(0.5f), modifier = Modifier.size(48.dp))
                    Spacer(modifier = Modifier.height(12.dp))
                    Text("No Questions Recorded Yet", color = StellarWhite, fontWeight = FontWeight.Bold, fontSize = 14.sp)
                    Text("Ask Alpha-9 about salaries, automation threat, specific certifications or study habit optimization.", color = CyberGray, fontSize = 12.sp, textAlign = TextAlign.Center, modifier = Modifier.padding(horizontal = 24.dp))
                }
            } else {
                val scrollState = rememberScrollState()
                Column(
                    modifier = Modifier
                        .fillMaxSize()
                        .verticalScroll(scrollState)
                        .padding(bottom = 8.dp),
                    verticalArrangement = Arrangement.spacedBy(12.dp)
                ) {
                    messages.forEach { msg ->
                        val isUser = msg.sender == "user"
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = if (isUser) Arrangement.End else Arrangement.Start
                        ) {
                            Box(
                                modifier = Modifier
                                    .widthIn(max = 280.dp)
                                    .clip(
                                        RoundedCornerShape(
                                            topStart = 16.dp,
                                            topEnd = 16.dp,
                                            bottomStart = if (isUser) 16.dp else 2.dp,
                                            bottomEnd = if (isUser) 2.dp else 16.dp
                                        )
                                    )
                                    .background(if (isUser) NeonPurple else CyberCard)
                                    .border(1.dp, if (isUser) NeonTeal.copy(0.4f) else CyberGray.copy(0.12f), RoundedCornerShape(12.dp))
                                    .padding(12.dp)
                            ) {
                                Text(
                                    text = msg.text,
                                    color = StellarWhite,
                                    fontSize = 13.sp,
                                    lineHeight = 18.sp
                                )
                            }
                        }
                    }

                    if (isChatLoading) {
                        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.Start) {
                            Box(
                                modifier = Modifier
                                    .background(CyberCard, RoundedCornerShape(12.dp))
                                    .padding(12.dp)
                            ) {
                                CircularProgressIndicator(color = NeonTeal, modifier = Modifier.size(16.dp), strokeWidth = 2.dp)
                            }
                        }
                    }

                    // Auto scroll bottom hook
                    LaunchedEffect(messages.size, isChatLoading) {
                        scrollState.animateScrollTo(scrollState.maxValue)
                    }
                }
            }
        }

        // Chat Input box
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(vertical = 8.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            OutlinedTextField(
                value = messageText,
                onValueChange = { messageText = it },
                placeholder = { Text("Ask mentor strategy...", color = CyberGray, fontSize = 13.sp) },
                colors = OutlinedTextFieldDefaults.colors(
                    focusedTextColor = StellarWhite,
                    unfocusedTextColor = StellarWhite,
                    focusedBorderColor = NeonTeal,
                    unfocusedBorderColor = CyberGray
                ),
                modifier = Modifier
                    .weight(1f)
                    .testTag("mentor_entry_box"),
                singleLine = true
            )
            Spacer(modifier = Modifier.width(8.dp))
            IconButton(
                onClick = {
                    if (messageText.isNotBlank()) {
                        viewModel.sendChatMessage(messageText)
                        messageText = ""
                    }
                },
                modifier = Modifier
                    .size(48.dp)
                    .background(NeonPurple, CircleShape)
                    .testTag("mentor_send_btn")
            ) {
                Icon(Icons.AutoMirrored.Filled.Send, contentDescription = "Send", tint = StellarWhite, modifier = Modifier.size(18.dp))
            }
        }
    }
}

// ==========================================
// 10. FUTURE SCENARIO SANDBOX SIMULATOR
// ==========================================
@Composable
fun FutureScenarioScreen(viewModel: FuturePathViewModel) {
    var locationInput by remember { mutableStateOf("United Kingdom (Remote scale)") }
    var skillInput by remember { mutableStateOf("Systems Engineering, Kubernetes") }
    var yearCommit by remember { mutableStateOf(3) }
    
    var isSimulating by remember { mutableStateOf(false) }
    var simulatedOutput by remember { mutableStateOf<String?>(null) }

    val scope = rememberCoroutineScope()

    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .background(CyberBg)
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        item {
            Column(horizontalAlignment = Alignment.CenterHorizontally, modifier = Modifier.fillMaxWidth()) {
                Text("SANDBOX LABORATORY", color = NeonTeal, fontFamily = FontFamily.Monospace, letterSpacing = 2.sp, fontSize = 11.sp)
                Text("What-If Scenario Pod", color = StellarWhite, fontSize = 24.sp, fontWeight = FontWeight.Bold)
                Text("Alter life variables to view simulated strategy trajectories", color = CyberGray, fontSize = 12.sp, textAlign = TextAlign.Center)
            }
        }

        item {
            CyberGlassCard(modifier = Modifier.fillMaxWidth()) {
                Text("Configure Sandbox Metrics", color = NeonTeal, fontWeight = FontWeight.Bold, fontSize = 14.sp)
                Spacer(modifier = Modifier.height(12.dp))

                OutlinedTextField(
                    value = locationInput,
                    onValueChange = { locationInput = it },
                    label = { Text("Target Work Location / Migration Option") },
                    colors = OutlinedTextFieldDefaults.colors(focusedTextColor = StellarWhite, unfocusedTextColor = StellarWhite, focusedBorderColor = NeonTeal, unfocusedBorderColor = CyberGray),
                    modifier = Modifier.fillMaxWidth(),
                    singleLine = true
                )

                Spacer(modifier = Modifier.height(8.dp))

                OutlinedTextField(
                    value = skillInput,
                    onValueChange = { skillInput = it },
                    label = { Text("Target Skill to master") },
                    colors = OutlinedTextFieldDefaults.colors(focusedTextColor = StellarWhite, unfocusedTextColor = StellarWhite, focusedBorderColor = NeonTeal, unfocusedBorderColor = CyberGray),
                    modifier = Modifier.fillMaxWidth(),
                    singleLine = true
                )

                Spacer(modifier = Modifier.height(12.dp))

                Text("Study & Dedication period: $yearCommit Years", color = StellarWhite, fontSize = 13.sp)
                Slider(
                    value = yearCommit.toFloat(),
                    onValueChange = { yearCommit = it.toInt() },
                    valueRange = 1f..6f,
                    colors = SliderDefaults.colors(thumbColor = NeonTeal, activeTrackColor = NeonPurple)
                )
            }
        }

        item {
            if (isSimulating) {
                Box(modifier = Modifier.fillMaxWidth().height(100.dp), contentAlignment = Alignment.Center) {
                    Column(horizontalAlignment = Alignment.CenterHorizontally) {
                        CircularProgressIndicator(color = NeonTeal)
                        Spacer(modifier = Modifier.height(8.dp))
                        Text("Futuristic Strategy Engine recalculating...", color = NeonTeal, fontSize = 12.sp, fontFamily = FontFamily.Monospace)
                    }
                }
            } else {
                Button(
                    onClick = {
                        scope.launch {
                            isSimulating = true
                            delay(1800)
                            simulatedOutput = """
                                SUCCESSFUL OUTBREAK PROJECTION:
                                
                                Study route: $skillInput for $yearCommit years while targeting $locationInput.
                                
                                📊 Outlier Likelihood Metrics:
                                - Entry Trajectory Pay: $45,000 / year USD equivalent.
                                - Mid Career (Year 5): $98,000 / year USD remote billing.
                                - Automation risk dropped to 4.2% due to high-value architectural skill convergence.
                                - Critical Roadmap requirement: Launch at least 4 public products in Github. Integrate standard CRM payment layers.
                                
                                Suggested Action: Commit 15 hours / week immediately. Acquire HashiCorp or AWS Solution architectures badges as portfolio proof.
                            """.trimIndent()
                            isSimulating = false
                        }
                    },
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(56.dp)
                        .testTag("sandbox_submit"),
                    colors = ButtonDefaults.buttonColors(containerColor = NeonPurple),
                    shape = RoundedCornerShape(12.dp)
                ) {
                    Text("RECONSTRUCT TIMELINE", color = StellarWhite, fontWeight = FontWeight.Bold, fontSize = 14.sp)
                }
            }
        }

        if (simulatedOutput != null) {
            item {
                CyberGlassCard(modifier = Modifier.fillMaxWidth(), borderColor = EasyGreen) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Icon(Icons.Default.Analytics, contentDescription = null, tint = EasyGreen)
                        Spacer(modifier = Modifier.width(8.dp))
                        Text("Simulation Result Breakdown", color = StellarWhite, fontWeight = FontWeight.Bold)
                    }
                    Spacer(modifier = Modifier.height(12.dp))
                    Text(
                        simulatedOutput!!,
                        color = StellarWhite,
                        fontSize = 13.sp,
                        lineHeight = 18.sp,
                        fontFamily = FontFamily.Monospace
                    )
                }
            }
        }

        item {
            Spacer(modifier = Modifier.height(48.dp))
        }
    }
}

// ==========================================
// 11. MONETIZATION / PREMIUM SCREEN
// ==========================================
@Composable
fun PremiumScreen(viewModel: FuturePathViewModel) {
    val user by viewModel.userProfile.collectAsState()

    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .background(CyberBg)
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        item {
            Icon(Icons.Default.MilitaryTech, contentDescription = null, tint = PremiumGold, modifier = Modifier.size(64.dp))
            Spacer(modifier = Modifier.height(8.dp))
            Text("FUTUREPATH ELITE", color = PremiumGold, fontSize = 14.sp, fontFamily = FontFamily.Monospace, letterSpacing = 2.sp, fontWeight = FontWeight.Bold)
            Text("Scale Your Insights", color = StellarWhite, fontSize = 24.sp, fontWeight = FontWeight.Bold)
            Text("Unlock premium predictions and mentorship strategy tracks.", color = CyberGray, fontSize = 12.sp, textAlign = TextAlign.Center)
        }

        item {
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .border(
                        1.dp,
                        if (user.isPremium) PremiumGold else NeonPurple.copy(0.3f),
                        RoundedCornerShape(16.dp)
                    ),
                shape = RoundedCornerShape(16.dp),
                colors = CardDefaults.cardColors(containerColor = CyberCard)
            ) {
                Column(modifier = Modifier.padding(20.dp)) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text("STRATEGIST LICENSE", color = StellarWhite, fontWeight = FontWeight.Bold, fontSize = 16.sp)
                        Box(
                            modifier = Modifier
                                .background(NeonPurple.copy(0.12f), RoundedCornerShape(4.dp))
                                .padding(horizontal = 8.dp, vertical = 2.dp)
                        ) {
                            Text("$4.99 / mo", color = NeonTeal, fontSize = 12.sp, fontWeight = FontWeight.Bold, fontFamily = FontFamily.Monospace)
                        }
                    }
                    Spacer(modifier = Modifier.height(12.dp))
                    Text("Unlock standard high-value predictions. Ideal for individual competitive teenage strategists.", color = CyberGray, fontSize = 12.sp)
                    Spacer(modifier = Modifier.height(16.dp))
                    
                    PremiumFeatureRow("Infinite AI Simulations (Gemini 3.5-Flash optimized)")
                    PremiumFeatureRow("Continuous Career Drift alerts.")
                    PremiumFeatureRow("Detailed 1-on-1 Alpha-9 Mentor hours.")
                    PremiumFeatureRow("Direct PDF Strategy Report Export.")

                    Spacer(modifier = Modifier.height(24.dp))

                    Button(
                        onClick = { viewModel.togglePremium(!user.isPremium) },
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(48.dp),
                        colors = ButtonDefaults.buttonColors(containerColor = if (user.isPremium) EasyGreen else NeonPurple),
                        shape = RoundedCornerShape(10.dp)
                    ) {
                        Text(
                            if (user.isPremium) "ACTIVE LICENSE (Click to Cancel)" else "UPGRADE INSTANTLY",
                            color = StellarWhite,
                            fontWeight = FontWeight.Bold,
                            fontSize = 13.sp
                        )
                    }
                }
            }
        }

        item {
            CyberGlassCard(modifier = Modifier.fillMaxWidth()) {
                Text("SCHOOLS PARTNERSHIP SUITE", color = NeonTeal, fontWeight = FontWeight.Bold, fontSize = 14.sp)
                Spacer(modifier = Modifier.height(4.dp))
                Text("Equip an entire classroom or school cluster with strategy modules", color = CyberGray, fontSize = 12.sp)
                Spacer(modifier = Modifier.height(12.dp))
                Text("Contact: institutional@futurepath.ai for custom dashboards and cohort assessment analytics.", color = StellarWhite, fontWeight = FontWeight.Bold, fontSize = 12.sp)
            }
        }

        item {
            Spacer(modifier = Modifier.height(48.dp))
        }
    }
}

@Composable
fun PremiumFeatureRow(text: String) {
    Row(verticalAlignment = Alignment.CenterVertically, modifier = Modifier.padding(vertical = 4.dp)) {
        Icon(Icons.Default.Check, contentDescription = null, tint = EasyGreen, modifier = Modifier.size(16.dp))
        Spacer(modifier = Modifier.width(8.dp))
        Text(text, color = StellarWhite, fontSize = 12.sp)
    }
}

// ==========================================
// 12. SYSTEM CODE BLUEPRINT / ARCHITECT VIEW
// ==========================================
@Composable
fun SystemArchitectScreen() {
    var selectedTab by remember { mutableStateOf("flutter") }

    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .background(CyberBg)
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp)
    ) {
        item {
            Column(horizontalAlignment = Alignment.CenterHorizontally, modifier = Modifier.fillMaxWidth()) {
                Text("DEVELOPER CENTER", color = NeonTeal, fontFamily = FontFamily.Monospace, letterSpacing = 2.sp, fontSize = 11.sp)
                Text("Strategic Blueprints", color = StellarWhite, fontSize = 24.sp, fontWeight = FontWeight.Bold)
                Text("Complete folder, schema & API architecture of FuturePath AI Production", color = CyberGray, fontSize = 12.sp, textAlign = TextAlign.Center)
            }
        }

        item {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .background(CyberCard, RoundedCornerShape(12.dp))
                    .padding(4.dp)
            ) {
                PathSelectorBtn("Flutter Code", selectedTab == "flutter", NeonPurple, Modifier.weight(1f)) { selectedTab = "flutter" }
                PathSelectorBtn("FastAPI Backend", selectedTab == "fastapi", NeonTeal, Modifier.weight(1f)) { selectedTab = "fastapi" }
                PathSelectorBtn("Database & APIs", selectedTab == "api", NeonPink, Modifier.weight(1f)) { selectedTab = "api" }
                PathSelectorBtn("Enterprise Scal.", selectedTab == "scale", PremiumGold, Modifier.weight(1f)) { selectedTab = "scale" }
            }
        }

        item {
            val content = when (selectedTab) {
                "flutter" -> """
                    // ====================================
                    // FLUTTER ARCHITECTURE FOLDER TREE & FLOW
                    // ====================================
                    
                    lib/
                    ├── main.dart
                    ├── app.dart
                    ├── core/
                    │   ├── theme/
                    │   │   ├── colors.dart
                    │   │   └── typography.dart
                    │   ├── network/
                    │   │   └── is_low_bandwidth_checker.dart
                    │   └── utils/
                    │       └── pdf_generator.dart
                    ├── services/
                    │   ├── gemini_service.dart (Embeddings + REST fallback)
                    │   ├── local_storage.dart (Secure encrypted state caching)
                    │   └── analytics_service.dart
                    ├── database/
                    │   └── local_database.g.dart (Hive/SQLite local tables)
                    ├── models/
                    │   ├── user_profile.dart
                    │   ├── simulation_result.dart
                    │   └── chat_message.dart
                    └── presentation/
                        ├── state_management/
                        │   ├── auth_provider.dart
                        │   ├── profile_provider.dart (Riverpod Controller)
                        │   └── simulation_controller.dart
                        └── screens/
                            ├── splash_screen.dart
                            ├── assessment_form_screen.dart
                            ├── dashboard_screen.dart
                            └── simulation_charts_screen.dart
                            
                    // Presentations are decoupled from Data sources using Riverpod.
                    // Employs GoRouter with safe Type keys to handle multi-tier navigation.
                """.trimIndent()
                
                "fastapi" -> """
                    # ====================================
                    # FASTAPI PRODUCTION BACKEND STRUCTURE
                    # ====================================
                    
                    app/
                    ├── main.py (FastAPI application entry point)
                    ├── core/
                    │   ├── config.py (Redis configs + system keys)
                    │   ├── security.py (JWT Bearer, custom rate limits)
                    │   └── cache.py (Redis read caching strategies)
                    ├── database/
                    │   ├── session.py (SQLAlchemy scoped db sessions)
                    │   └── base_class.py
                    ├── models/
                    │   ├── user.py
                    │   └── career_snapshots.py
                    ├── schemas/
                    │   ├── profile.py
                    │   └── simulation.py
                    ├── services/
                    │   ├── gemini_orchestrator.py (Handles prompt context trees)
                    │   └── recommend_engine.py (Matrix Factorization)
                    └── api/
                        ├── v1/
                        │   ├── router.py
                        │   ├── endpoints/
                        │   │   ├── auth.py
                        │   │   ├── assessments.py
                        │   │   ├── simulations.py
                        │   │   └── mentor_chat.py
                        
                    # Deployment file: Dockerfile (Multi-stage optimization)
                    FROM python:3.11-alpine AS builder
                    WORKDIR /usr/src/app
                    RUN apk add --no-cache build-base postgresql-dev
                    COPY requirements.txt .
                    RUN pip install --no-cache-dir -r requirements.txt
                    
                    # Caching logic uses Redis: TTL set to 24 hrs for career simulations
                """.trimIndent()

                "api" -> """
                    /* ====================================
                       POSTGRESQL SCHEMAS & API ENDPOINTS
                       ==================================== */
                       
                    -- Profile table 
                    CREATE TABLE user_profiles (
                        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                        email VARCHAR(255) UNIQUE NOT NULL,
                        age INT NOT NULL,
                        country VARCHAR(100) NOT NULL,
                        interests TEXT[],
                        skills TEXT[],
                        academic_records JSONB,
                        budget NUMERIC(10, 2),
                        internet_tier INT NOT NULL,
                        xp INT DEFAULT 0,
                        is_premium BOOLEAN DEFAULT FALSE,
                        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
                    );
                    
                    -- Simulation snapshots
                    CREATE TABLE career_simulations (
                        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                        user_id UUID REFERENCES user_profiles(id) ON DELETE CASCADE,
                        optimistic_json JSONB NOT NULL,
                        realistic_json JSONB NOT NULL,
                        high_risk_json JSONB NOT NULL,
                        growth_coordinates NUMERIC[] NOT NULL,
                        timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
                    );

                    -- API endpoints exposed by Backend
                    POST /api/v1/auth/verify (Google / Biometric signature)
                    POST /api/v1/assessments/initiate (Cruches assessments)
                    GET  /api/v1/simulations/results (Fetch graphs & coordinates)
                    POST /api/v1/mentor/comms (Ask Strategy questions)
                    GET  /api/v1/intelligence/insights (General market reports)
                """.trimIndent()

                else -> """
                    // ====================================
                    // MONETIZATION & ENTERPRISE SCALABILITY
                    // ====================================
                    
                    1. Freemuim Model:
                       - Free: 1 Complete AI simulation + 1 Learning roadmap. Basic charts.
                       - Strategist Subscription: $4.99/mo. Unlimited simulations, real-time automation threats, PDF reports, AI intelligence triggers.
                    
                    2. Institutional Marketplace (B2B):
                       - Sell custom administrative insights directly to secondary schools.
                       - Dashboard tracking cumulative student capabilities and local job mismatches.
                       - Mentorship coaching networks with vetted remote consultants.
                       
                    3. Security & Caching (Targeting African learners):
                       - AES-256 local configuration. Cached SQLite database for offline operations.
                       - Compress Gemini payload size. Run localized vector calculations inside FastAPI memory.
                       - Scale backend with Kubernetes clusters + Redis caching. Ensure response limits do not throttle mobile data.
                """.trimIndent()
            }

            CyberGlassCard(modifier = Modifier.fillMaxWidth()) {
                Text(
                    text = content,
                    color = StellarWhite,
                    fontSize = 11.sp,
                    fontFamily = FontFamily.Monospace,
                    lineHeight = 16.sp
                )
            }
        }

        item {
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(60.dp)
                    .background(NeonPurple.copy(0.12f), RoundedCornerShape(12.dp))
                    .padding(12.dp),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    text = "Production Code architectures vetted as startup-ready.",
                    color = NeonTeal,
                    fontWeight = FontWeight.Bold,
                    fontSize = 12.sp,
                    fontFamily = FontFamily.Monospace,
                    textAlign = TextAlign.Center
                )
            }
        }

        item {
            Spacer(modifier = Modifier.height(48.dp))
        }
    }
}
