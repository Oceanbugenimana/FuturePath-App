package com.example.ui.theme

import android.os.Build
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.dynamicDarkColorScheme
import androidx.compose.material3.dynamicLightColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext

private val CyberColorScheme = darkColorScheme(
  primary = NeonPurple,
  secondary = NeonTeal,
  tertiary = NeonPink,
  background = CyberBg,
  surface = CyberCard,
  onPrimary = StellarWhite,
  onSecondary = CyberBg,
  onTertiary = StellarWhite,
  onBackground = StellarWhite,
  onSurface = StellarWhite,
  surfaceVariant = Color(0xFF16132D)
)

private val LightColorScheme = CyberColorScheme // Keep cyber dark theme as default to look premium and futuristic

@Composable
fun MyApplicationTheme(
  darkTheme: Boolean = true, // Force dark mode for futuristic feel
  dynamicColor: Boolean = false, // Disable dynamic colors to maintain custom artistic cyber identity
  content: @Composable () -> Unit,
) {
  MaterialTheme(
    colorScheme = CyberColorScheme,
    typography = Typography,
    content = content
  )
}
