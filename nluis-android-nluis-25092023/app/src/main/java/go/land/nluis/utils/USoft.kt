package go.land.nluis.utils

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.IntentSender
import android.content.SharedPreferences
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.Settings
import android.telephony.TelephonyManager
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.fragment.app.FragmentActivity
import com.google.android.gms.common.api.GoogleApiClient
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.LocationSettingsRequest
import com.google.android.gms.location.LocationSettingsStatusCodes
import com.google.android.material.snackbar.Snackbar

/**
 * Created by ugali on 06/10/2022 18:18
 */
class USoft(activity: AppCompatActivity,vw:View) {
    init {
        cache = activity.getSharedPreferences("cache", 0)
        editor = cache.edit()
        perm(activity,vw)
    }

    companion object {
        private lateinit var editor: SharedPreferences.Editor
        private lateinit var cache: SharedPreferences


        operator fun get(name: String?): String? {
            return cache.getString(name, name)
        }

        operator fun set(name: String?, value: String?) {
            editor.putString(name, value)
            editor.commit()
        }

        fun clear() {
            editor.clear()
            editor.commit()
        }

        fun turnOnLocation(context: FragmentActivity):Boolean{
            var is_on = false
            val googleApiClient = GoogleApiClient.Builder(context)
                .addApi(LocationServices.API).build()
            googleApiClient.connect()

            val locationRequest = LocationRequest.create()
            locationRequest.priority = LocationRequest.PRIORITY_HIGH_ACCURACY
            locationRequest.interval = 1000
            locationRequest.fastestInterval = (1000 / 2).toLong()

            val builder = LocationSettingsRequest.Builder().addLocationRequest(locationRequest)
            builder.setAlwaysShow(true)

            val result = LocationServices.SettingsApi.checkLocationSettings(googleApiClient, builder.build())
            result.setResultCallback { result1 ->
                val status = result1.status
                when (status.statusCode) {
                    LocationSettingsStatusCodes.SUCCESS -> {
                        is_on = true
                    }
                    LocationSettingsStatusCodes.RESOLUTION_REQUIRED ->
                        try {
                            status.startResolutionForResult(context, 1)
                        } catch (e: IntentSender.SendIntentException) {
                            //Log.i(TAG, "PendingIntent unable to execute request.");
                        }
                    LocationSettingsStatusCodes.SETTINGS_CHANGE_UNAVAILABLE -> {
                    }
                }
            }
            return is_on
        }


        fun perm(context: Activity,vw: View): Boolean {
            val intnt = ContextCompat.checkSelfPermission(context, Manifest.permission.INTERNET)
            val camera = ContextCompat.checkSelfPermission(context, Manifest.permission.CAMERA)
            val rd = ContextCompat.checkSelfPermission(context, Manifest.permission.READ_EXTERNAL_STORAGE)
            val rd_phone = ContextCompat.checkSelfPermission(context, Manifest.permission.READ_PHONE_STATE)
            val wrt = ContextCompat.checkSelfPermission(context, Manifest.permission.WRITE_EXTERNAL_STORAGE)
            val loc1 = ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_COARSE_LOCATION)
            val loc2 = ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION)

            val lst = arrayListOf<String>()

            if (intnt != PackageManager.PERMISSION_GRANTED) {
                lst.add(Manifest.permission.INTERNET)
            }
            if (camera != PackageManager.PERMISSION_GRANTED) {
                lst.add(Manifest.permission.CAMERA)
            }
            if (rd != PackageManager.PERMISSION_GRANTED) {
                lst.add(Manifest.permission.READ_EXTERNAL_STORAGE)
            }
            if (wrt != PackageManager.PERMISSION_GRANTED) {
                lst.add(Manifest.permission.WRITE_EXTERNAL_STORAGE)
            }
            if (loc1 != PackageManager.PERMISSION_GRANTED) {
                lst.add(Manifest.permission.ACCESS_COARSE_LOCATION)
            }
            if (loc2 != PackageManager.PERMISSION_GRANTED) {
                lst.add(Manifest.permission.ACCESS_FINE_LOCATION)
            }
            if (rd_phone != PackageManager.PERMISSION_GRANTED) {
                lst.add(Manifest.permission.READ_PHONE_STATE)
            }

            if (lst.isNotEmpty()) {
                ActivityCompat.requestPermissions(context, lst.toTypedArray(), 1)
                return false
            }


            if (Build.VERSION.SDK_INT > Build.VERSION_CODES.Q){
                if (!Environment.isExternalStorageManager()) {
                    Snackbar.make(vw, "File Permission needed!", Snackbar.LENGTH_INDEFINITE).setAction("Settings"
                    ) {
                        val uri: Uri = Uri.parse("package:$context.packageName")
                        val intent = Intent(Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION, uri)
                        context.startActivity(intent)
                    }.show()
                }
            }

            return true
        }

        fun escape(txt:String): String {
            return txt.replace("'","--")
        }

        fun read(txt:String): String {
            return txt.replace("--","'")
        }

        fun getDeviceId(activity: Activity): String {
            var deviceId: String? = ""
            deviceId = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) { // Android 9
                Settings.Secure.getString(activity.contentResolver, Settings.Secure.ANDROID_ID)
            } else {
                val mTelephony =
                    activity.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
                if (mTelephony.deviceId != null) {
                    mTelephony.deviceId
                } else {
                    Settings.Secure.getString(activity.contentResolver, Settings.Secure.ANDROID_ID)
                }
            }
            return deviceId
        }


    }
}