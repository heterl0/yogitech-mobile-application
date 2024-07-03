package com.example.yogi_application.network

import com.example.yogi_application.BuildConfig
import okhttp3.Interceptor
import okhttp3.OkHttpClient
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

object ServiceBuilder {

    private const val URL = BuildConfig.API_URL;

    private val okHttp = OkHttpClient.Builder();

    private val builder = Retrofit.Builder()
        .baseUrl(BuildConfig.API_URL)
        .addConverterFactory(GsonConverterFactory.create())
        .client(okHttp.build())

//    private val retrofit = builder.build()

    fun<T>buildService(serviceType: Class<T>):T {
        return builder.build().create(serviceType)
    }

    fun setToken(accessToken: String?) {
        val authInterceptor = Interceptor { chain ->
            val originalRequest = chain.request()

            val newRequest = originalRequest.newBuilder()
                .header("Authorization", "Bearer $accessToken") // Add token to header
                .build()

            chain.proceed(newRequest)
        }

        okHttp.addInterceptor(authInterceptor);

        builder.client(okHttp.build())
    }
}



