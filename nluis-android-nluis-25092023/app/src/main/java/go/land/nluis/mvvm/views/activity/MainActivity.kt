package go.land.nluis.mvvm.views.activity

import android.content.Intent
import android.os.Bundle
import android.os.Environment
import android.util.Log
import android.view.View
import android.view.animation.AnimationUtils
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.databinding.DataBindingUtil
import com.google.gson.Gson
import go.land.nluis.R
import go.land.nluis.databinding.ActivityMainBinding
import go.land.nluis.mvvm.interfaces.FileBackup
import go.land.nluis.mvvm.model.UserLogin
import go.land.nluis.mvvm.network.API
import go.land.nluis.mvvm.network.response.AuthTokenResponse
import go.land.nluis.mvvm.network.response.NetworkStatusCode
import go.land.nluis.mvvm.network.response.UserConfigResponse
import go.land.nluis.utils.UFile
import go.land.nluis.utils.USoft
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.File

class MainActivity : AppCompatActivity() {

    private lateinit var activityMainBinding: ActivityMainBinding
    private lateinit var backedup:File
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        activityMainBinding = DataBindingUtil.setContentView(this,R.layout.activity_main)

        USoft(this,activityMainBinding.root)

        NetworkStatusCode.statusCode.observeForever {
            if (it==401){
                activityMainBinding.prog.visibility=View.GONE
                activityMainBinding.btnLogin.text="Jaribu Tena"
                Toast.makeText(applicationContext,"Akaunti isiyoidhinishwa",Toast.LENGTH_LONG).show()
            }
        }

        init()


        /*startActivity(Intent(this,LandingActivity::class.java))
        finish()*/

    }

    private fun init(){

        if (USoft["username"]!="username"){
            activityMainBinding.txtUsername.setText(USoft["username"]!!)
        }


        activityMainBinding.btnLogin.setOnClickListener {
            try {
                val usn = activityMainBinding.txtUsername.text?.trim().toString()
                val psw = activityMainBinding.txtPassword.text?.trim().toString()

                activityMainBinding.btnLogin.text = "Ingia Tena"
                if(usn.isEmpty()){
                    activityMainBinding.txtUsername.error = "Invalid Username"
                    return@setOnClickListener
                }

                if(psw.isEmpty()){
                    activityMainBinding.txtPassword.error = "Invalid Password"
                    return@setOnClickListener
                }
                val user = UserLogin(usn,psw)
                if (USoft["userConfig"]!="userConfig"){
                    if (psw==USoft["password"]){
                        startActivity(Intent(this,LandingActivity::class.java))
                    }else{
                        activityMainBinding.txtPassword.error = "Invalid Password"
                    }
                    return@setOnClickListener
                }


                activityMainBinding.prog.visibility=View.VISIBLE
                activityMainBinding.btnLogin.text = "Tafadhali Subiri..."

                API.ret.authToken(user).enqueue(object :Callback<AuthTokenResponse>{
                    override fun onResponse(
                        call: Call<AuthTokenResponse>,
                        response: Response<AuthTokenResponse>
                    ) {
                        try {
                            //Log.d("ZAKA",response.body()?.access!!)
                            if (response.body()?.access!=null){
                                USoft["token"] = "uG@li "+response.body()?.access!!

                                USoft["username"] = usn
                                USoft["password"] = psw


                                authorize()
                            }
                        }catch (e:Exception){
                            e.message?.let { it1 -> Log.d("ZAKA", it1) }
                        }
                    }

                    override fun onFailure(call: Call<AuthTokenResponse>, t: Throwable) {
                        Log.d("ZAKA",t.message.toString())
                        activityMainBinding.prog.visibility=View.GONE
                    }

                })

            }catch (e:Exception){
                activityMainBinding.prog.visibility= View.GONE
                e.message?.let { Log.d("ZAKA", it) }
            }

        }



        activityMainBinding.btnClearCache.setOnClickListener {
            AlertDialog.Builder(this).setTitle("Data zote Zitafutika")
                .setIcon(R.drawable.ic_outline_warning_24)
                .setMessage("Je Una uhakika na hili jambo ?")
                .setPositiveButton("Ndiyo") { d, _ ->
                    USoft.clear()

                    var out = "${this.getExternalFilesDir(null)!!.absoluteFile}/"+USoft["zipname"]+".zip"
                    out = out.replace("Android/data/$packageName/files/","")

                    val back = File(
                        Environment.getExternalStoragePublicDirectory(
                            Environment.DIRECTORY_PICTURES), "zaka")

                    val inFileName = "/data/data/$packageName/databases/db_lims"
                    val dbFile = File(inFileName)

                    try { back.deleteRecursively() }catch (e:Exception){}
                    try { File(out).deleteRecursively() }catch (e:Exception){}
                    try { dbFile.deleteRecursively() }catch (e:Exception){}

                    d.dismiss()

                }
                .setNegativeButton("Hapana"){d,_->d.dismiss()}
                .show()
        }


        activityMainBinding.btnBackup.setOnClickListener {
            activityMainBinding.btnBackup.text="Backup inaendelea ..."
            activityMainBinding.btnBackup.animation = AnimationUtils.loadAnimation(this,R.anim.blink)

            UFile.doBackup(this,activityMainBinding.prog,object :FileBackup{
                override fun onBackupFinish(success: Boolean, backupPath: String) {
                    if (success){
                        backedup = File(backupPath)
                        val size = UFile.getFolderSizeLabel(backedup)

                        Toast.makeText(this@MainActivity,size, Toast.LENGTH_LONG).show()

                        activityMainBinding.btnBackup.text="Backup"
                    }else{
                        Toast.makeText(this@MainActivity,backupPath,Toast.LENGTH_LONG).show()
                    }
                }

            })



        }
    }

    private fun authorize() {
        try {
            activityMainBinding.prog.visibility= View.VISIBLE
            activityMainBinding.btnLogin.text="Inatambulisha..."
            API.ret.configUser(USoft.getDeviceId(this)).enqueue(object : Callback<UserConfigResponse>{
                override fun onResponse(
                    call: Call<UserConfigResponse>,
                    response: Response<UserConfigResponse>
                ) {
                    activityMainBinding.prog.visibility= View.GONE
                    activityMainBinding.btnLogin.text="Ingia Tena"
                    try {
                        val userConfig = Gson().toJson(response.body())
                        if (response.body()?.status==0){
                            Toast.makeText(this@MainActivity,response.body()?.message,Toast.LENGTH_LONG).show()
                            return
                        }
                        USoft["userConfig"] = userConfig
                        startActivity(Intent(this@MainActivity,LandingActivity::class.java))
                    }catch (e:Exception){
                        e.message?.let { Log.d("ZAKA", it) }
                    }
                }

                override fun onFailure(call: Call<UserConfigResponse>, t: Throwable) {
                    t.message?.let { Log.d("ZAKA", it) }
                    activityMainBinding.prog.visibility= View.GONE
                }

            })
        }catch (e:Exception){
            e.message?.let { Log.d("ZAKA", it) }
        }
    }
}