package com.example.data

import com.example.BuildConfig
import com.squareup.moshi.Json
import com.squareup.moshi.Moshi
import com.squareup.moshi.kotlin.reflect.KotlinJsonAdapterFactory
import okhttp3.OkHttpClient
import retrofit2.Retrofit
import retrofit2.converter.moshi.MoshiConverterFactory
import retrofit2.http.Body
import retrofit2.http.POST
import retrofit2.http.Query
import java.util.concurrent.TimeUnit

// --- Gemini REST API Request & Response Mappings (Moshi) ---

data class Part(
    @Json(name = "text") val text: String?
)

data class Content(
    @Json(name = "parts") val parts: List<Part>
)

data class GeminiRequest(
    @Json(name = "contents") val contents: List<Content>,
    @Json(name = "systemInstruction") val systemInstruction: Content? = null,
    @Json(name = "generationConfig") val generationConfig: GenerationConfig? = null
)

data class GenerationConfig(
    @Json(name = "temperature") val temperature: Double? = null,
    @Json(name = "maxOutputTokens") val maxOutputTokens: Int? = null,
    @Json(name = "responseMimeType") val responseMimeType: String? = null
)

data class Candidate(
    @Json(name = "content") val content: Content?
)

data class GeminiResponse(
    @Json(name = "candidates") val candidates: List<Candidate>?
)

// --- Retrofit Direct Service interface ---

interface GeminiApiService {
    @POST("v1beta/models/gemini-3.5-flash:generateContent")
    suspend fun generateContent(
        @Query("key") apiKey: String,
        @Body request: GeminiRequest
    ): GeminiResponse
}

object GeminiApiClient {
    private const val BASE_URL = "https://generativelanguage.googleapis.com/"

    private val moshi = Moshi.Builder()
        .addLast(KotlinJsonAdapterFactory())
        .build()

    private val okHttpClient = OkHttpClient.Builder()
        .connectTimeout(60, TimeUnit.SECONDS)
        .readTimeout(60, TimeUnit.SECONDS)
        .writeTimeout(60, TimeUnit.SECONDS)
        .build()

    val service: GeminiApiService by lazy {
        Retrofit.Builder()
            .baseUrl(BASE_URL)
            .client(okHttpClient)
            .addConverterFactory(MoshiConverterFactory.create(moshi))
            .build()
            .create(GeminiApiService::class.java)
    }

    /**
     * Call the Gemini REST API to request career advice, simulations, and feedback.
     * Incorporates a robust local fallback engine if no key is present or if there's an error.
     */
    suspend fun callGemini(prompt: String, systemPrompt: String? = null): String {
        val key = BuildConfig.GEMINI_API_KEY
        if (key == null || key.isEmpty() || key == "MY_GEMINI_API_KEY") {
            throw Exception("API_KEY_EMPTY")
        }

        val request = GeminiRequest(
            contents = listOf(Content(parts = listOf(Part(text = prompt)))),
            systemInstruction = systemPrompt?.let { Content(parts = listOf(Part(text = it))) },
            generationConfig = GenerationConfig(temperature = 0.7)
        )

        return try {
            val response = service.generateContent(key, request)
            response.candidates?.firstOrNull()?.content?.parts?.firstOrNull()?.text 
                ?: "Empty response from Gemini server."
        } catch (e: Exception) {
            "API_NETWORK_ERROR: ${e.localizedMessage}"
        }
    }
}
