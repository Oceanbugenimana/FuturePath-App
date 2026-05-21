package com.example.data

import android.content.Context
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.firstOrNull
import kotlin.random.Random

class CareerRepository(private val context: Context) {
    private val db = FuturePathDatabase.getDatabase(context)
    private val dao = db.dao()

    fun getUserProfile(): Flow<UserProfile?> = dao.getUserProfile()
    fun getChatMessages(): Flow<List<ChatMessage>> = dao.getChatMessages()
    fun getSimulation(): Flow<CareerSimulation?> = dao.getSimulation()

    suspend fun saveProfile(profile: UserProfile) {
        dao.insertUserProfile(profile)
    }

    suspend fun clearChat() {
        dao.clearChat()
    }

    suspend fun sendMessage(sender: String, messageText: String): String {
        // Save user message
        dao.insertChatMessage(ChatMessage(sender = sender, text = messageText))
        
        // Generate mentor response
        val response = try {
            val userProfile = dao.getUserProfileSync() ?: UserProfile()
            val systemContext = """
                You are "Alpha-9", an elite futuristic AI mentor on 'FuturePath AI'. 
                You are advising a ${userProfile.age}-year-old student from ${userProfile.country}.
                Interests: ${userProfile.interests}. Skills: ${userProfile.skills}.
                Grades: ${userProfile.grades}. Financial Budget: ${userProfile.budget}. 
                Internet: ${userProfile.internetAccess}.
                Role: Be highly motivational, strategically critical, clear, and actionable. 
                Answer questions about career roadmaps, skill gaps, salaries, automation threat, and study advice. 
                Keep it concise, friendly, futuristic, and highly informative.
            """.trimIndent()

            val rawAnswer = GeminiApiClient.callGemini(messageText, systemContext)
            if (rawAnswer.startsWith("API_NETWORK_ERROR") || rawAnswer.startsWith("Error")) {
                getProceduralAdvice(messageText, userProfile)
            } else {
                rawAnswer
            }
        } catch (e: Exception) {
            val userProfile = dao.getUserProfileSync() ?: UserProfile()
            getProceduralAdvice(messageText, userProfile)
        }

        // Save mentor response
        dao.insertChatMessage(ChatMessage(sender = "mentor", text = response))
        
        // Award XP for learning session
        val currentProfile = dao.getUserProfileSync() ?: UserProfile()
        val bonusXp = 15
        val newXp = currentProfile.xp + bonusXp
        val calcLevel = 1 + (newXp / 300)
        dao.insertUserProfile(currentProfile.copy(
            xp = newXp,
            level = calcLevel,
            lastUpdate = System.currentTimeMillis()
        ))

        return response
    }

    suspend fun runCareerSimulation(profile: UserProfile): CareerSimulation {
        // Award XP for simulation run
        val updatedProfile = profile.copy(
            xp = profile.xp + 50,
            level = 1 + ((profile.xp + 50) / 300),
            streak = profile.streak + 1,
            futureScore = (75 + Random.nextInt(15)),
            lastUpdate = System.currentTimeMillis()
        )
        dao.insertUserProfile(updatedProfile)

        val simulationText = try {
            val prompt = """
                Simulate 3 future career outcomes for a student with these details:
                - Age: ${profile.age}
                - Country: ${profile.country}
                - Interests: ${profile.interests}
                - Skills: ${profile.skills}
                - Academic Performance (Grades): ${profile.grades}
                - Financial Capacity / annual budget: ${profile.budget}
                - Internet levels: ${profile.internetAccess}
                - Preferred lifestyle/goals: ${profile.preferredLifestyle}

                Provide exactly 3 paths in your analysis:
                1. OPTIMISTIC (High growth, globally optimized, leveraging US/foreign remote pay)
                2. REALISTIC (Locally/regionally accessible, highly practical, strong local hub availability)
                3. HIGH-RISK/HIGH-REWARD (Entrepreneurship, startup, volatile freelancing, indie hacking)

                Also list:
                - Missing skills to analyze (Skill Gap Analyze)
                - A brief Dynamic Learning Roadmap over 6 months.

                Format requirement: Please keep it concise and descriptive. Do not repeat titles.
            """.trimIndent()

            val systemPrompt = "You are FuturePath AI, an advanced Career Strategy Engine designed for youth in emerging economies. Provide realistic, motivational advice."
            
            val aiAnswer = GeminiApiClient.callGemini(prompt, systemPrompt)
            if (aiAnswer.startsWith("API_NETWORK_ERROR") || aiAnswer.startsWith("Error")) {
                null
            } else {
                aiAnswer
            }
        } catch (e: Exception) {
            null
        }

        val finalSimulation = if (simulationText != null) {
            // Parse Gemini response or extract items
            parseAIPredictions(simulationText, updatedProfile)
        } else {
            getProceduralSimulation(updatedProfile)
        }

        dao.insertSimulation(finalSimulation)
        return finalSimulation
    }

    private fun parseAIPredictions(aiResponse: String, profile: UserProfile): CareerSimulation {
        // Try to divide the response strategically into optimistic, realistic, and risk
        val lines = aiResponse.split("\n")
        var optTitle = "Cloud & AI Architect"
        var optBrief = "Global cloud infrastructure optimization, highly automated resilience."
        var optSalary = "$24,000 - $90,000/yr (USD Remote)"
        var optDetails = "Focus on cloud computing, Kubernetes, and API integrations."

        var realTitle = "Full Stack Mobile Developer"
        var realBrief = "Regional application construction for commerce/mobile finance."
        var realSalary = "$8,000 - $25,000/yr (Outsource Hub)"
        var realDetails = "Learn Flutter, web-apps, SQL databases, and regional payment APIs."

        var riskTitle = "AI SaaS Indie Hacker"
        var riskBrief = "Building niche micro-software solutions targeting micro-businesses."
        var riskSalary = "$0 - $150,000+/yr (Subscriptions)"
        var riskDetails = "Focus on Rapid MVP building, no-code integrations, and viral growth."

        var gaps = "Cloud APIs, Docker containers, systems architecture, micro-billing"
        var roadmap = "Month 1: General coding practice | Month 2-3: Cloud basics & deployment | Month 4-6: Complete 3 mock client platforms."

        // Basic line crawling to extract blocks (highly resilient parsing)
        try {
            val optIndex = lines.indexOfFirst { it.contains("optimistic", ignoreCase = true) || it.contains("1.", ignoreCase = true) }
            val realIndex = lines.indexOfFirst { it.contains("realistic", ignoreCase = true) || it.contains("2.", ignoreCase = true) }
            val riskIndex = lines.indexOfFirst { it.contains("risk", ignoreCase = true) || it.contains("3.", ignoreCase = true) }

            if (optIndex != -1 && realIndex != -1) {
                val optBlock = lines.subList(optIndex, realIndex).joinToString("\n")
                optTitle = optBlock.lineSequence().firstOrNull { it.isNotBlank() }?.replace(Regex("[#*0-9.]"), "")?.trim() ?: optTitle
                optDetails = optBlock
                optBrief = optBlock.lineSequence().drop(1).firstOrNull { it.isNotBlank() }?.replace(Regex("[#*]"), "")?.trim()?.take(120) ?: optBrief
            }
            if (realIndex != -1 && riskIndex != -1) {
                val realBlock = lines.subList(realIndex, riskIndex).joinToString("\n")
                realTitle = realBlock.lineSequence().firstOrNull { it.isNotBlank() }?.replace(Regex("[#*0-9.]"), "")?.trim() ?: realTitle
                realDetails = realBlock
                realBrief = realBlock.lineSequence().drop(1).firstOrNull { it.isNotBlank() }?.replace(Regex("[#*]"), "")?.trim()?.take(120) ?: realBrief
            }
            if (riskIndex != -1) {
                val riskBlock = lines.subList(riskIndex, lines.size).joinToString("\n")
                riskTitle = riskBlock.lineSequence().firstOrNull { it.isNotBlank() }?.replace(Regex("[#*0-9.]"), "")?.trim() ?: riskTitle
                riskDetails = riskBlock
                riskBrief = riskBlock.lineSequence().drop(1).firstOrNull { it.isNotBlank() }?.replace(Regex("[#*]"), "")?.trim()?.take(120) ?: riskBrief
            }
            
            // Search for timeline / roadmap triggers
            val gapIndex = lines.indexOfFirst { it.contains("gap", ignoreCase = true) || it.contains("missing", ignoreCase = true) }
            if (gapIndex != -1) {
                gaps = lines.subList(gapIndex, minOf(gapIndex + 4, lines.size)).joinToString(", ").replace(Regex("[#*]"), "").trim().take(200)
            }
            val roadIndex = lines.indexOfFirst { it.contains("roadmap", ignoreCase = true) || it.contains("month", ignoreCase = true) }
            if (roadIndex != -1) {
                roadmap = lines.subList(roadIndex, minOf(roadIndex + 6, lines.size)).joinToString(" | ").replace(Regex("[#*]"), "").trim().take(500)
            }
        } catch (e: Exception) {
            // keep standard
        }

        return CareerSimulation(
            profileId = profile.id,
            optimisticTitle = optTitle,
            optimisticBrief = optBrief,
            optimisticSalary = optSalary,
            optimisticDetails = optDetails,
            realisticTitle = realTitle,
            realisticBrief = realBrief,
            realisticSalary = realSalary,
            realisticDetails = realDetails,
            riskTitle = riskTitle,
            riskBrief = riskBrief,
            riskSalary = riskSalary,
            riskDetails = riskDetails,
            salariesOptimistic = "18,34,55,80,120", // Mapped progression (USD '000s)
            salariesRealistic = "8,15,24,35,50",
            salariesRisk = "0,12,30,85,210",
            skillGaps = gaps,
            skillRoadmap = roadmap
        )
    }

    private fun getProceduralSimulation(prof: UserProfile): CareerSimulation {
        // High quality generative algorithm based on user parameters when API is not configured
        val interestKeywords = prof.interests.lowercase()
        val hasTech = interestKeywords.contains("tech") || interestKeywords.contains("cod") || interestKeywords.contains("comput") || interestKeywords.contains("software")
        val hasDesign = interestKeywords.contains("design") || interestKeywords.contains("art") || interestKeywords.contains("photograph")
        val hasBusiness = interestKeywords.contains("busines") || interestKeywords.contains("sale") || interestKeywords.contains("finance") || interestKeywords.contains("market")

        val (optTitle, optBrief, optDetails, optSals) = if (hasTech) {
            Quad(
                "Global Remote Systems Engineer",
                "High-pay infrastructure specialist serving high-growth startup markets remotely.",
                "Build state-of-the-art container infrastructure (Kubernetes, AWS/GCP, Docker). Master microservices, security protocols, API pipelines, and high-concurrency systems.",
                "20,38,62,95,140"
            )
        } else if (hasDesign) {
            Quad(
                "UX Product Strategist (Global Agency)",
                "Elite digital designer engineering product architectures with advanced Figma/interactive layouts.",
                "Develop user journeys, clean component hierarchies, responsive frameworks, and UX-research databases. Highly resilient against basic image automation.",
                "15,26,42,65,95"
            )
        } else {
            Quad(
                "Emerging Market Fintech Consultant",
                "Strategic intelligence bridging local business commerce with global digital banking tracks.",
                "Establish micro-payment pipelines, regional wallet interfaces, cross-border digital contracts. Optimize local retail nodes for electronic currencies.",
                "18,32,50,78,115"
            )
        }

        val (realTitle, realBrief, realDetails, realSals) = if (hasTech) {
            Quad(
                "Full-Stack Web Developer (Regional Agency)",
                "Constructing scalable e-commerce portals, mobile engines, and enterprise dashboard databases.",
                "Establish proficiency in React/TypeScript, local databases like PostgreSQL, REST API management, and low-latency rendering for mobile devices.",
                "6,12,20,30,45"
            )
        } else if (hasDesign) {
            Quad(
                "Digital Branding & Ad Lead",
                "Crafting social narratives, advertising visuals, and brand assets for emerging companies.",
                "Coordinate vector designs, customized graphic frameworks, social-media marketing campaigns, and video assets optimized for low broadband consumption.",
                "5,9,15,22,32"
            )
        } else {
            Quad(
                "E-Commerce & Logisitic Operator",
                "Optimizing regional warehouse databases and local distribution networks.",
                "Coordinate inventory databases, optimize delivery route logs, handle customer database records and local supplier transactions.",
                "5,10,16,24,35"
            )
        }

        val (riskTitle, riskBrief, riskDetails, riskSals) = if (hasTech) {
            Quad(
                "AI Micro-SaaS Indie Creator",
                "Developing highly targeted web/mobile wrapping micro-tools powered by intelligent models.",
                "Extremely fast MVP launching. Use low-code, wrapper APIs, micro-billing, and organic visual marketing. Highly volatile, high rate of competition, immense upside.",
                "0,18,5,80,240"
            )
        } else {
            Quad(
                "Independent Digital Creator / agency founder",
                "Launching a solo branding studio leveraging global freelancer contracts.",
                "Requires high speed network client searching, active social presence, 3D interactive graphics, and competitive price outsourcing.",
                "0,12,25,60,150"
            )
        }

        val gapList = if (hasTech) {
            "Docker, Kubernetes, AWS/GCP, FastAPI backend structure, PostgreSQL schema design"
        } else if (hasDesign) {
            "UX prototyping, Interactive design systems, Typography structure, Framer web animations"
        } else {
            "Digital marketing, E-commerce APIs, Ledger entries, CRM databases"
        }

        val roadmapText = if (hasTech) {
            "Month 1: Command Line, Python & Git basics | Month 2-3: Complete clean API building with FastAPI & Postgres | Month 4-5: Master Docker & basic Cloud deployment (Render/Fly.io) | Month 6: Develop 3 highly polished Github portfolios."
        } else {
            "Month 1: Color theory, typography structure, visual hierarchy | Month 2-3: Advanced Figma, UI wireframing, component libraries | Month 4-5: Responsive web creation tools, client contract writing | Month 6: Serve 2 non-profit clients to record glowing testimonials."
        }

        return CareerSimulation(
            profileId = prof.id,
            optimisticTitle = optTitle,
            optimisticBrief = optBrief,
            optimisticSalary = "$${optSals.split(",").first()}k - $${optSals.split(",").last()}k/yr",
            optimisticDetails = optDetails,
            realisticTitle = realTitle,
            realisticBrief = realBrief,
            realisticSalary = "$${realSals.split(",").first()}k - $${realSals.split(",").last()}k/yr",
            realisticDetails = realDetails,
            riskTitle = riskTitle,
            riskBrief = riskBrief,
            riskSalary = "$${riskSals.split(",").first()}k - $${riskSals.split(",").last()}k/yr",
            riskDetails = riskDetails,
            salariesOptimistic = optSals,
            salariesRealistic = realSals,
            salariesRisk = riskSals,
            skillGaps = gapList,
            skillRoadmap = roadmapText
        )
    }

    private fun getProceduralAdvice(userPrompt: String, profile: UserProfile): String {
        val promptClean = userPrompt.lowercase()
        return when {
            promptClean.contains("streak") || promptClean.contains("xp") || promptClean.contains("level") -> {
                "Alpha-9 Mentorship: 🌟 Every learning interaction, simulation quiz, and roadmap query rewards you with XP. Streaks double your multiplier! Maintain your daily learning habit to keep your Career Readiness Score rising. Consistent strategic planning is the foundation of high-growth tech entrepreneurs!"
            }
            promptClean.contains("salary") || promptClean.contains("money") || promptClean.contains("income") -> {
                "Alpha-9 Mentorship: 📈 Salary trajectory in modern times is about arbitrage. As a learner in ${profile.country}, your peak leverage is learning global skills (like Systems Engineering, Full-Stack Node/Kotlin, or UX design) and charging in global currencies (USD/EUR) while living locally. Remote freelancing is the fastest way to boost income!"
            }
            promptClean.contains("automation") || promptClean.contains("ai") || promptClean.contains("threat") || promptClean.contains("replace") -> {
                "Alpha-9 Mentorship: 🛡️ AI is a strong accelerator, not a simple replacement. Standard repetitive coders will be marginalized, but systems architects, UX designers, and prompt-integrated engineers will be 10x more valuable. Keep your skills creative, highly integrated, and focus on end-to-end solutions."
            }
            promptClean.contains("start") || promptClean.contains("begin") || promptClean.contains("how to") -> {
                "Alpha-9 Mentorship: 🚀 Start with your 6-month roadmap! Focus on building small, working public projects and sharing your progress on GitHub or LinkedIn. Do not try to learn everything at once. Pick *one* primary stack (like Dart/Flutter or Kotlin/Compose for frontend, or Python/FastAPI for backend) and master it."
            }
            promptClean.contains("budget") || promptClean.contains("fee") || promptClean.contains("money") || promptClean.contains("cost") -> {
                "Alpha-9 Mentorship: 💡 Wealth is not a prerequisite for tech proficiency. Platforms like FreeCodeCamp, Coursera Financial Aid, YouTube archives, and GitHub provide peerless, comprehensive curricula completely free. Optimize for low-bandwidth visual lessons, and focus on coding on paper or Android phone IDEs (like Replit) if laptop access is slow!"
            }
            else -> {
                "Alpha-9 Mentorship: Excellent strategic question. In ${profile.country}, digital transformation is opening unprecedented opportunities. In the ${profile.interests} workspace, combining logical strategy with rapid prototyping will make you globally competitive. Focus on mastering ${profile.skills.split(",").firstOrNull() ?: "core engineering"}, build local portfolios, and target remote outsourcing networks!"
            }
        }
    }

    // Helper holder
    data class Quad<A, B, C, D>(val first: A, val second: B, val third: C, val fourth: D)
}
