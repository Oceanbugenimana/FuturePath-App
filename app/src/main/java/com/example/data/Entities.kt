package com.example.data

import android.content.Context
import androidx.room.*
import com.squareup.moshi.Moshi
import com.squareup.moshi.Types
import com.squareup.moshi.kotlin.reflect.KotlinJsonAdapterFactory
import kotlinx.coroutines.flow.Flow

// --- Models & Entities ---

@Entity(tableName = "user_profiles")
data class UserProfile(
    @PrimaryKey val id: String = "current_user",
    val age: Int = 17,
    val country: String = "Nigeria",
    val interests: String = "Technology, Music, Problem Solving",
    val skills: String = "Coding (Python), Writing, Visual Design",
    val grades: String = "A in Math, B in English, A in Physics",
    val budget: String = "Under $1,000/year (Requires scholarships/free paths)",
    val internetAccess: String = "Mobile Data only, capped (Low Bandwidth)",
    val preferredLifestyle: String = "Remote Freelancer or Tech Entrepreneur",
    val strengths: String = "Analytical thinking, fast learner",
    val weaknesses: String = "Public speaking, procrastination",
    val learningHabits: String = "Self-paced tutorials, coding challenges",
    val timeCommitment: String = "15-20 hours/week part-time",
    val isPremium: Boolean = false,
    val xp: Int = 350,
    val level: Int = 2,
    val streak: Int = 5,
    val futureScore: Int = 84, // Career Readiness Score
    val lastUpdate: Long = System.currentTimeMillis()
)

@Entity(tableName = "chat_messages")
data class ChatMessage(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    val sender: String, // "user" or "mentor"
    val text: String,
    val timestamp: Long = System.currentTimeMillis()
)

@Entity(tableName = "simulations")
data class CareerSimulation(
    @PrimaryKey val id: String = "current_simulation",
    val profileId: String = "current_user",
    
    // Simulations (String serialized or direct text)
    val optimisticTitle: String = "Cloud Solutions Architect (Global Remote)",
    val optimisticBrief: String = "Highly demanded, global pay, resilient to automation.",
    val optimisticSalary: String = "$18,000 - $85,000/yr (Remote USD scaling)",
    val optimisticDetails: String = "Focus on AWS certificates, Kubernetes, Python & Terraform. Leverage low-bandwidth platforms.",
    
    val realisticTitle: String = "Full Stack developer (Regional Tech Hub)",
    val realisticBrief: String = "Strong regional demand in Lagos/Nairobi with outsourcing scope.",
    val realisticSalary: String = "₦400k - ₦1.8M/month locally or $12,000/yr outsourcing",
    val realisticDetails: String = "Deepen TypeScript, React, and Django. Build high-quality local client portfolios.",
    
    val riskTitle: String = "AI Micro-SaaS Solo Founder",
    val riskBrief: String = "High margin, direct global payment, but volatile and intensely competitive.",
    val riskSalary: String = "$0 - $120,000+/yr (Highly variable)",
    val riskDetails: String = "Focus on rapid no-code/low-code API wrapping, marketing, niche utility tools.",
    
    // Growth timelines (comma separated values mapped to coordinate arrays)
    val salariesOptimistic: String = "15,28,45,67,110", // in $k/yr
    val salariesRealistic: String = "8,14,22,32,48",
    val salariesRisk: String = "2,18,5,75,180",
    
    // Gaps and details
    val skillGaps: String = "Kubernetes, Docker, Advance Algorithms, Cloud FinOps",
    val skillRoadmap: String = "Month 1: AWS Cloud Practitioner (FreeCodeCamp) | Month 2-3: Docker & Linux Basics | Month 4-6: Construct 3 portfolios.",
    
    val timestamp: Long = System.currentTimeMillis()
)

// --- Type Converters ---

class Converters {
    private val moshi = Moshi.Builder().add(KotlinJsonAdapterFactory()).build()
    
    @TypeConverter
    fun stringToMap(value: String): Map<String, String>? {
        val type = Types.newParameterizedType(Map::class.java, String::class.java, String::class.java)
        return moshi.adapter<Map<String, String>>(type).fromJson(value)
    }

    @TypeConverter
    fun mapToString(map: Map<String, String>?): String {
        val type = Types.newParameterizedType(Map::class.java, String::class.java, String::class.java)
        return moshi.adapter<Map<String, String>>(type).toJson(map ?: emptyMap())
    }
}

// --- DAOs ---

@Dao
interface FuturePathDao {
    @Query("SELECT * FROM user_profiles WHERE id = 'current_user' LIMIT 1")
    fun getUserProfile(): Flow<UserProfile?>

    @Query("SELECT * FROM user_profiles WHERE id = 'current_user' LIMIT 1")
    suspend fun getUserProfileSync(): UserProfile?

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertUserProfile(profile: UserProfile)

    @Query("SELECT * FROM chat_messages ORDER BY timestamp ASC")
    fun getChatMessages(): Flow<List<ChatMessage>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertChatMessage(message: ChatMessage)

    @Query("DELETE FROM chat_messages")
    suspend fun clearChat()

    @Query("SELECT * FROM simulations WHERE id = 'current_simulation' LIMIT 1")
    fun getSimulation(): Flow<CareerSimulation?>

    @Query("SELECT * FROM simulations WHERE id = 'current_simulation' LIMIT 1")
    suspend fun getSimulationSync(): CareerSimulation?

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertSimulation(simulation: CareerSimulation)
}

// --- App Database ---

@Database(
    entities = [UserProfile::class, ChatMessage::class, CareerSimulation::class],
    version = 1,
    exportSchema = false
)
@TypeConverters(Converters::class)
abstract class FuturePathDatabase : RoomDatabase() {
    abstract fun dao(): FuturePathDao

    companion object {
        @Volatile
        private var INSTANCE: FuturePathDatabase? = null

        fun getDatabase(context: Context): FuturePathDatabase {
            return INSTANCE ?: synchronized(this) {
                val instance = Room.databaseBuilder(
                    context.applicationContext,
                    FuturePathDatabase::class.java,
                    "futurepath_database"
                )
                .fallbackToDestructiveMigration()
                .build()
                INSTANCE = instance
                instance
            }
        }
    }
}
