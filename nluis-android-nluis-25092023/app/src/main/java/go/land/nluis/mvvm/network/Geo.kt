package go.land.nluis.mvvm.network

import retrofit2.http.GET
import okhttp3.OkHttpClient
import okhttp3.Interceptor
import go.land.nluis.utils.USoft
import com.google.gson.GsonBuilder
import retrofit2.Retrofit
import go.land.nluis.mvvm.network.geo_reponse.GeoResponse
import retrofit2.Call
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.converter.scalars.ScalarsConverterFactory
import retrofit2.http.Query
import java.util.concurrent.TimeUnit

/**
 * Created by ugali on 10/10/2022 11:52
 */
interface Geo {


    companion object {
        private val client: OkHttpClient = OkHttpClient.Builder()
            .writeTimeout(30, TimeUnit.MINUTES)
            .readTimeout(30, TimeUnit.MINUTES)
            .connectTimeout(30, TimeUnit.SECONDS)
            .addInterceptor { chain: Interceptor.Chain ->
                val ongoing = chain.request().newBuilder()
                    .addHeader("Authorization", USoft["token"]!!)
                    .addHeader("X-Auth", USoft["token"]!!)
                    .addHeader("Accept", "application/json;versions=1")
                    .addHeader("Content-Type", "application/json")
                chain.proceed(ongoing.build())
            }
            .build()
        private val gson = GsonBuilder()
            .setLenient()
            .create()
        private val retrofit = Retrofit.Builder()
            .client(client)
            .baseUrl("https://nluis.nlupc.go.tz/geoserver/nluis/")
            //.baseUrl("http://${API.baseIP}:8080/geoserver/nluis/")
            .addConverterFactory(ScalarsConverterFactory.create())
            .addConverterFactory(GsonConverterFactory.create(gson))
            .build()

        val ret: Geo = retrofit.create(Geo::class.java)

    }

    @GET("ows?&service=WFS&version=1.0.0&request=GetFeature&typeName=project_layers_spatial&outputFormat=application/json")
    fun cqlFilter(@Query("cql_filter")cql_filter:String):Call<GeoResponse>



}