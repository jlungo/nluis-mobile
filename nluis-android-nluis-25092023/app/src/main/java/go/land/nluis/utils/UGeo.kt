package go.land.nluis.utils

import android.util.Log
import com.google.gson.Gson
import go.land.nluis.mvvm.network.Geo
import go.land.nluis.mvvm.network.geo_reponse.GeoResponse
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

/**
 * Created by ugali on 12/11/2022 21:59
 */
class UGeo {
    companion object{
        fun cqlFilter(cql:String,saveAs:String){
            try {
                Geo.ret.cqlFilter(cql).enqueue(object :
                    Callback<GeoResponse> {
                    override fun onResponse(call: Call<GeoResponse>, response: Response<GeoResponse>) {
                        try {
                            Log.d("ZAKA-1234",response.body()!!.toString())
                            USoft[saveAs] = Gson().toJson(response.body()!!)
                        }catch (e:Exception){
                            e.message?.let { Log.d("ZAKA-eer", it) }
                        }
                    }

                    override fun onFailure(call: Call<GeoResponse>, t: Throwable) {
                        t.printStackTrace()
                        Log.d("ZAKA-eer23",t.message.toString())
                    }

                })

            }catch (e:Exception){
                e.message?.let { Log.d("ZAKA-1234er", it) }
            }

        }
    }
}