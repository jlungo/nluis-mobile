package go.land.nluis.mvvm.network

import android.util.Log
import retrofit2.http.GET
import go.land.nluis.mvvm.network.response.UserConfigResponse
import okhttp3.OkHttpClient
import okhttp3.Interceptor
import go.land.nluis.utils.USoft
import com.google.gson.GsonBuilder
import go.land.nluis.mvvm.model.UserLogin
import retrofit2.Retrofit
import go.land.nluis.mvvm.network.response.AuthTokenResponse
import go.land.nluis.mvvm.network.response.NetworkStatusCode
import go.land.nluis.mvvm.network.response.ServerResponse
import okhttp3.MultipartBody
import retrofit2.Call
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.Body
import retrofit2.http.Multipart
import retrofit2.http.POST
import retrofit2.http.Part
import retrofit2.http.Path
import java.util.concurrent.TimeUnit

/**
 * Created by ugali on 10/10/2022 11:52
 */
interface API {

    companion object {
        val client: OkHttpClient = OkHttpClient.Builder()
            .writeTimeout(30, TimeUnit.MINUTES)
            .readTimeout(30, TimeUnit.MINUTES)
            .connectTimeout(30, TimeUnit.SECONDS)
            .addInterceptor { chain: Interceptor.Chain ->

                val original = chain.request()
                val ongoing = original.newBuilder()
                    .addHeader("Authorization", USoft["token"]!!)
                    .addHeader("X-Auth", USoft["token"]!!)
                    .addHeader("Accept", "application/json;versions=1")
                    .addHeader("Content-Type", "application/json")
                    .build()


                val response =  chain.proceed(ongoing)
                Log.d("ZAKA", "Code : "+response.code())

                NetworkStatusCode.statusCode.postValue(response.code())

                response
            }
            .build()
        private val gson = GsonBuilder()
            .setLenient()
            .create()


        //val baseIP:String = "kopakwetu.co.tz"
        val baseIP:String = "nluis.nlupc.go.tz"
//        val baseIP:String = "154.118.227.140:8002"
        private val retrofit = Retrofit.Builder()
            .client(client)
            .baseUrl("https://$baseIP/api/v1/")
            .addConverterFactory(GsonConverterFactory.create(gson))
            .build()

        val ret: API = retrofit.create(API::class.java)

    }

    @POST("auth/login")
    fun authToken(@Body user: UserLogin):Call<AuthTokenResponse>

    @GET("collect/mobile/user/config/{deviceId}")
    fun configUser(@Path("deviceId") deviceId: String):Call<UserConfigResponse>

    @Multipart
    @POST("collect/upload/mobile/data")
    fun uploadToServer(
        @Part("sender") sender:Long,
        @Part("project") project:Long,
        @Part zipped: MultipartBody.Part
    ):Call<ServerResponse>
}
