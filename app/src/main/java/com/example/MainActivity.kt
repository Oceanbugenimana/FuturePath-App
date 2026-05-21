package com.example

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.viewModels
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.testTag
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.ui.*
import com.example.ui.theme.*

class MainActivity : ComponentActivity() {
    private val viewModel: FuturePathViewModel by viewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        
        setContent {
            MyApplicationTheme {
                val currentScreen by viewModel.currentScreen.collectAsState()
                val userProfile by viewModel.userProfile.collectAsState()

                LaunchedEffect(userProfile.favoriteTheme) {
                    ThemeSource.selectTheme(userProfile.favoriteTheme)
                }
                
                Scaffold(
                    modifier = Modifier.fillMaxSize(),
                    topBar = {
                        if (currentScreen != "splash" && currentScreen != "onboarding" && currentScreen != "auth" && currentScreen != "assessment") {
                            ImmersiveTopBar(
                                currentScreen = currentScreen,
                                level = userProfile.level,
                                xp = userProfile.xp,
                                isPremium = userProfile.isPremium,
                                onNavigateToPremium = { viewModel.navigateTo("premium") }
                            )
                        }
                    },
                    bottomBar = {
                        // Only show bottom navigation on application dashboard and internal labs
                        if (currentScreen != "splash" && currentScreen != "onboarding" && currentScreen != "auth" && currentScreen != "assessment") {
                            StrategicBottomBar(
                                currentScreen = currentScreen,
                                onTabSelected = { viewModel.navigateTo(it) }
                            )
                        }
                    }
                ) { innerPadding ->
                    ImmersiveAtmosphericBackground(
                        modifier = Modifier
                            .fillMaxSize()
                            .padding(innerPadding)
                    ) {
                        when (currentScreen) {
                            "splash" -> SplashScreen(onTimeout = { viewModel.navigateTo("onboarding") })
                            "onboarding" -> OnboardingScreen(onComplete = { viewModel.navigateTo("auth") })
                            "auth" -> AuthScreen(onAuthSuccess = { viewModel.navigateTo("assessment") })
                            "assessment" -> AssessmentScreen(viewModel = viewModel)
                            "dashboard" -> DashboardScreen(
                                viewModel = viewModel,
                                onMenuClick = { viewModel.navigateTo(it) }
                            )
                            "simulator" -> CareerSimulatorScreen(viewModel = viewModel)
                            "salary" -> SalaryTrajectoryScreen(viewModel = viewModel)
                            "roadmap" -> LearningRoadmapScreen(viewModel = viewModel)
                            "skillgap" -> SkillGapScreen(viewModel = viewModel)
                            "mentor" -> AiMentorScreen(viewModel = viewModel)
                            "scenario" -> FutureScenarioScreen(viewModel = viewModel)
                            "premium" -> PremiumScreen(viewModel = viewModel)
                            "architect" -> SystemArchitectScreen()
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun StrategicBottomBar(
    currentScreen: String,
    onTabSelected: (String) -> Unit
) {
    // Elegant custom bottom navigation holding safe Area Padding
    Surface(
        modifier = Modifier
            .fillMaxWidth()
            .navigationBarsPadding(),
        color = CyberCard,
        tonalElevation = 8.dp
    ) {
        Column {
            Divider(color = CyberGray.copy(0.12f), thickness = 1.dp)
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(64.dp)
                    .padding(horizontal = 8.dp),
                horizontalArrangement = Arrangement.SpaceAround,
                verticalAlignment = Alignment.CenterVertically
            ) {
                BottomTabItem(
                    label = "Overview",
                    icon = Icons.Default.Dashboard,
                    isSelected = currentScreen == "dashboard",
                    onClick = { onTabSelected("dashboard") }
                )
                BottomTabItem(
                    label = "Career",
                    icon = Icons.Default.RocketLaunch,
                    isSelected = currentScreen == "simulator" || currentScreen == "salary" || currentScreen == "roadmap" || currentScreen == "skillgap",
                    onClick = { onTabSelected("simulator") }
                )
                BottomTabItem(
                    label = "Mentor",
                    icon = Icons.Default.SmartToy,
                    isSelected = currentScreen == "mentor",
                    onClick = { onTabSelected("mentor") }
                )
                BottomTabItem(
                    label = "Scenario",
                    icon = Icons.Default.Science,
                    isSelected = currentScreen == "scenario",
                    onClick = { onTabSelected("scenario") }
                )
                BottomTabItem(
                    label = "Blueprint",
                    icon = Icons.Default.Terminal,
                    isSelected = currentScreen == "architect",
                    onClick = { onTabSelected("architect") }
                )
            }
        }
    }
}

@Composable
fun RowScope.BottomTabItem(
    label: String,
    icon: androidx.compose.ui.graphics.vector.ImageVector,
    isSelected: Boolean,
    onClick: () -> Unit
) {
    val tintColor = if (isSelected) NeonTeal else CyberGray
    
    Column(
        modifier = Modifier
            .weight(1f)
            .height(56.dp)
            .clickable(onClick = onClick),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Box(
            modifier = if (isSelected) {
                Modifier
                    .background(NeonTeal.copy(alpha = 0.12f), RoundedCornerShape(12.dp))
                    .padding(horizontal = 14.dp, vertical = 4.dp)
            } else {
                Modifier.padding(horizontal = 14.dp, vertical = 4.dp)
            },
            contentAlignment = Alignment.Center
        ) {
            Icon(
                imageVector = icon,
                contentDescription = label,
                tint = tintColor,
                modifier = Modifier.size(20.dp)
            )
        }
        Spacer(modifier = Modifier.height(2.dp))
        Text(
            text = label,
            color = tintColor,
            fontSize = 9.sp,
            fontWeight = if (isSelected) androidx.compose.ui.text.font.FontWeight.Bold else androidx.compose.ui.text.font.FontWeight.Medium,
            fontFamily = androidx.compose.ui.text.font.FontFamily.SansSerif
        )
    }
}

@Composable
fun ImmersiveTopBar(
    currentScreen: String,
    level: Int,
    xp: Int,
    isPremium: Boolean,
    onNavigateToPremium: () -> Unit
) {
    Surface(
        color = CyberBg.copy(alpha = 0.9f),
        modifier = Modifier.fillMaxWidth()
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .statusBarsPadding()
                .padding(horizontal = 20.dp, vertical = 12.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(10.dp)
            ) {
                Box(
                    modifier = Modifier
                        .size(36.dp)
                        .clip(RoundedCornerShape(10.dp))
                        .background(
                            Brush.linearGradient(
                                colors = listOf(NeonTeal, NeonPurple)
                            )
                        ),
                    contentAlignment = Alignment.Center
                ) {
                    Text(
                        text = "F",
                        color = Color.White,
                        fontWeight = androidx.compose.ui.text.font.FontWeight.Bold,
                        fontSize = 18.sp
                    )
                }
                Column {
                    Text(
                        text = "FuturePath AI",
                        color = StellarWhite,
                        fontWeight = androidx.compose.ui.text.font.FontWeight.SemiBold,
                        fontSize = 13.sp,
                        letterSpacing = (-0.25).sp
                    )
                    Text(
                        text = "SCENARIO ALPHA-7",
                        color = NeonTeal,
                        fontWeight = androidx.compose.ui.text.font.FontWeight.Medium,
                        fontSize = 8.sp,
                        letterSpacing = 1.sp
                    )
                }
            }

            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                if (isPremium) {
                    Box(
                        modifier = Modifier
                            .background(PremiumGold.copy(0.12f), RoundedCornerShape(16.dp))
                            .border(1.dp, PremiumGold.copy(0.4f), RoundedCornerShape(16.dp))
                            .padding(horizontal = 8.dp, vertical = 3.dp)
                    ) {
                        Text(
                            text = "PRO",
                            color = PremiumGold,
                            fontSize = 9.sp,
                            fontWeight = androidx.compose.ui.text.font.FontWeight.Bold,
                            letterSpacing = 0.5.sp
                        )
                    }
                } else {
                    Box(
                        modifier = Modifier
                            .clickable(onClick = onNavigateToPremium)
                            .background(Color.White.copy(0.05f), RoundedCornerShape(16.dp))
                            .border(1.dp, Color.White.copy(0.10f), RoundedCornerShape(16.dp))
                            .padding(horizontal = 8.dp, vertical = 3.dp)
                    ) {
                        Text(
                            text = "GO PRO",
                            color = NeonTeal,
                            fontSize = 8.sp,
                            fontWeight = androidx.compose.ui.text.font.FontWeight.Bold
                        )
                    }
                }

                Box(
                    modifier = Modifier
                        .background(Color.White.copy(0.04f), RoundedCornerShape(16.dp))
                        .border(1.dp, Color.White.copy(0.08f), RoundedCornerShape(16.dp))
                        .padding(horizontal = 10.dp, vertical = 3.dp)
                ) {
                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.spacedBy(4.dp)
                    ) {
                        Box(
                            modifier = Modifier
                                .size(5.dp)
                                .background(Color(0xFF4ADE80), RoundedCornerShape(50.dp))
                        )
                        Text(
                            text = "Lvl $level",
                            color = StellarWhite,
                            fontSize = 9.sp,
                            fontWeight = androidx.compose.ui.text.font.FontWeight.Bold
                        )
                    }
                }
            }
        }
    }
}

@Composable
fun ImmersiveAtmosphericBackground(
    modifier: Modifier = Modifier,
    content: @Composable BoxScope.() -> Unit
) {
    Box(
        modifier = modifier.background(CyberBg)
    ) {
        // Ambient Blue-glow (top-left)
        Box(
            modifier = Modifier
                .offset(x = (-100).dp, y = (-120).dp)
                .size(320.dp)
                .background(
                    Brush.radialGradient(
                        colors = listOf(
                            NeonTeal.copy(alpha = 0.15f),
                            NeonTeal.copy(alpha = 0.03f),
                            Color.Transparent
                        )
                    ),
                    shape = RoundedCornerShape(160.dp)
                )
        )

        // Ambient Purple-glow (bottom-right)
        Box(
            modifier = Modifier
                .align(Alignment.BottomEnd)
                .offset(x = 100.dp, y = 120.dp)
                .size(280.dp)
                .background(
                    Brush.radialGradient(
                        colors = listOf(
                            NeonPurple.copy(alpha = 0.12f),
                            NeonPurple.copy(alpha = 0.03f),
                            Color.Transparent
                        )
                    ),
                    shape = RoundedCornerShape(140.dp)
                )
        )

        // Actual viewport content overlayed
        Box(modifier = Modifier.fillMaxSize()) {
            content()
        }
    }
}

