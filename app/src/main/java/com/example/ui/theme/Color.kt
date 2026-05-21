package com.example.ui.theme

import androidx.compose.ui.graphics.Color
import androidx.compose.runtime.getValue
import androidx.compose.runtime.setValue
import androidx.compose.runtime.mutableStateOf

val Purple80 = Color(0xFFD0BCFF)
val PurpleGrey80 = Color(0xFFCCC2DC)
val Pink80 = Color(0xFFEFB8C8)

val Purple40 = Color(0xFF6650a4)
val PurpleGrey40 = Color(0xFF625b71)
val Pink40 = Color(0xFF7D5260)

object ThemeSource {
    var activeTheme by mutableStateOf("default") // default, emerald, solar, crimson, amethyst, ice, vaporwave

    fun selectTheme(theme: String) {
        activeTheme = theme
    }

    fun getCyberBg(): Color = when (activeTheme) {
        "emerald" -> Color(0xFF030705)  // Deep Forest Emerald Black
        "solar" -> Color(0xFF080603)    // Solar Amber Warm Black
        "crimson" -> Color(0xFF080202)  // Crimson Blood Black
        "amethyst" -> Color(0xFF060309) // Velvet Amethyst Dark Purple
        "ice" -> Color(0xFF020608)      // Nordic Frost Deep Ocean Black
        "vaporwave" -> Color(0xFF090306) // Sunset Velvet Dark Purple
        else -> Color(0xFF05060B)       // Default Cyber Midnight
    }

    fun getCyberCard(): Color = when (activeTheme) {
        "emerald" -> Color(0xFF09140F)
        "solar" -> Color(0xFF141009)
        "crimson" -> Color(0xFF140808)
        "amethyst" -> Color(0xFF0F0814)
        "ice" -> Color(0xFF091216)
        "vaporwave" -> Color(0xFF160912)
        else -> Color(0xFF0E111A)
    }

    fun getNeonPurple(): Color = when (activeTheme) {
        "emerald" -> Color(0xFF10B981) // Emerald Primary
        "solar" -> Color(0xFFF59E0B)   // Solar Gold Primary
        "crimson" -> Color(0xFFEF4444) // Crimson Red Primary
        "amethyst" -> Color(0xFF8B5CF6) // Velvet Violet/Purple Primary
        "ice" -> Color(0xFF00E5FF)      // Nordic Frozen Cyan Primary
        "vaporwave" -> Color(0xFFFF007F) // Retro Cyber Pink Primary
        else -> Color(0xFF6366F1)       // default Indigo Primary Accents
    }

    fun getNeonTeal(): Color = when (activeTheme) {
        "emerald" -> Color(0xFF34D399) // Minty Teal secondary
        "solar" -> Color(0xFFFBBF24)   // Amber Yellow secondary
        "crimson" -> Color(0xFFFCA5A5) // Soft Coral secondary
        "amethyst" -> Color(0xFFC084FC) // Orchid Magenta secondary
        "ice" -> Color(0xFF00E5FF)      // Frozen Teal secondary
        "vaporwave" -> Color(0xFF00FFFF) // Sunset Cyan secondary
        else -> Color(0xFF3B82F6)       // default Royal Blue secondary
    }

    fun getNeonPink(): Color = when (activeTheme) {
        "emerald" -> Color(0xFF059669)
        "solar" -> Color(0xFFD97706)
        "crimson" -> Color(0xFFB91C1C)
        "amethyst" -> Color(0xFFEC4899)
        "ice" -> Color(0xFF059669)
        "vaporwave" -> Color(0xFFFFB300)
        else -> Color(0xFFEC4899)
    }
}

// Dynamic neon/cyber theme colors (Immersive UI specification)
val CyberBg: Color get() = ThemeSource.getCyberBg()       // Dynamic Deep midnight background
val CyberCard: Color get() = ThemeSource.getCyberCard()   // Dynamic Glassmorphism card back
val NeonPurple: Color get() = ThemeSource.getNeonPurple() // Dynamic Primary accents
val NeonTeal: Color get() = ThemeSource.getNeonTeal()     // Dynamic Secondary action link
val NeonPink: Color get() = ThemeSource.getNeonPink()     // Dynamic accent coral
val StellarWhite = Color(0xFFF1F5F9)  // Slate-100 crisp text values
val CyberGray = Color(0xFF94A3B8)     // Slate-400 description texts
val CoralRed = Color(0xFFEF4444)      // Risk warning red
val EasyGreen = Color(0xFF10B981)     // Success / realistic emerald green
val PremiumGold = Color(0xFFF59E0B)   // Gold subscription star


