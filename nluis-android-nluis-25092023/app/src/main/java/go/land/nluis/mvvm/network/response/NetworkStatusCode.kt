package go.land.nluis.mvvm.network.response

import androidx.lifecycle.MutableLiveData

/**
 * Created by ugali on 05/12/2022 00:15
 */
class NetworkStatusCode {
    companion object{
        val statusCode by lazy { MutableLiveData<Int>() }
    }
}