package go.land.nluis.mvvm.views.activity

import android.content.Intent
import android.os.Bundle
import android.os.Environment
import android.util.Log
import android.view.View
import android.view.animation.AnimationUtils
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.databinding.DataBindingUtil
import com.google.gson.Gson
import go.land.nluis.R
import go.land.nluis.databinding.ActivityLandingBinding
import go.land.nluis.databinding.RowTitleBinding
import go.land.nluis.mvvm.interfaces.FileBackup
import go.land.nluis.mvvm.model.Summary
import go.land.nluis.mvvm.model.UserLogin
import go.land.nluis.mvvm.network.API
import go.land.nluis.mvvm.network.ProgressRequestBody
import go.land.nluis.mvvm.network.response.AuthTokenResponse
import go.land.nluis.mvvm.network.response.ServerResponse
import go.land.nluis.mvvm.network.response.UserConfigResponse
import go.land.nluis.mvvm.sqlite.Db
import go.land.nluis.utils.UFile
import go.land.nluis.utils.UGeo
import go.land.nluis.utils.USoft
import go.land.nluis.utils.UgNet
import okhttp3.MultipartBody
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.File


class LandingActivity : AppCompatActivity() {

    private lateinit var activityLandingBinding: ActivityLandingBinding
    private lateinit var backedup:File
    private var sending = false
    private lateinit var db:Db
    private val date =UFile.date.substring(0,10)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        activityLandingBinding=DataBindingUtil.setContentView(this,R.layout.activity_landing)
        init()


    }

    private fun initSummary() {
        try {
            val jumla = db.listGeom().size.toString()


            var jumla_ = 0
            db.listAnswers().forEach { aa->
                if (aa.valid){
                    jumla_++
                }
            }

            val leo = db.listData("select * from tb_answer where answer like 'POLYGON%' and date_ like '$date%'").size.toString()
            val zimetumwa = db.listData("select * from tb_answer where answer like 'POLYGON%' and tag='sent'").size.toString()
            activityLandingBinding.lyTitle.summ = Summary(leo,"$jumla_/$jumla",zimetumwa)
            activityLandingBinding.lyTitle.executePendingBindings()

        }catch (_:Exception){}
    }

    private fun init(){
        db= Db(this)

        checkFilePermission()
        initSummary()

        val userConfig = Gson().fromJson(USoft["userConfig"], UserConfigResponse::class.java)

        try{
            USoft["user"] = userConfig.user.id.toString()
            USoft["zipname"]=userConfig.user.name
            USoft["project_id"] = userConfig.project.id.toString()

            userConfig.village.forEach {
                it.hamlets.forEach { hm->

                    //Log.d("ZAKA","${hm.name} = ${hm.count}")

                }
            }
        }catch (e:Exception){
            Log.d("ZAKA",e.message.toString())
        }


        activityLandingBinding.user=userConfig
        activityLandingBinding.executePendingBindings()

        activityLandingBinding.lnProject.removeAllViews()

        activityLandingBinding.btnUhakiki.setOnClickListener {
            startActivity(Intent(this,UhakikiActivity::class.java))
        }

        try {
            userConfig.questionnaire.forEach {

                if (it.tag!="party_info"){

                    if (it.category!="sub_question"){
                        val vw = RowTitleBinding.inflate(layoutInflater)
                        vw.txtNo.text="0"
                        vw.txtTitle.text=it.name
                        var desr=""
                        if (it.tag==""){
                            desr=it.tag
                        }else{
                            it.contents.forEach { cont->desr+=cont.name+", " }
                        }

                        vw.txtDescr.text=desr

                        vw.root.setOnClickListener {_->
                            startActivity(Intent(this,MadodosoActivity::class.java)
                                .putExtra("name",it.name)
                                .putExtra("id",it.id))
                        }
                        activityLandingBinding.lnProject.addView(vw.root)

                    }

                }

            }
        }catch (e:Exception){
            Log.d("ZAKA",e.message.toString())
        }

        initBottomButton()

        if (USoft["geo_boundary"]=="geo_boundary"){
            UGeo.cqlFilter("project_id in ("+USoft["project_id"]+") and map_type_id in (2) and deleted not in (true)","geo_boundary")
        }

        if (USoft["geo_feature"]=="geo_feature"){
            UGeo.cqlFilter("project_id in ("+USoft["project_id"]+") and map_type_id in (1) and deleted not in (true)","geo_feature")
        }

        if (USoft["geo_restricted"]=="geo_restricted"){
            UGeo.cqlFilter("project_id in ("+USoft["project_id"]+") and map_type_id not in (1,2) and deleted not in (true)","geo_restricted")
        }

    }


    private var is_backup = false
    private fun initBottomButton() {
        activityLandingBinding.btnBackup.setOnClickListener {


            activityLandingBinding.btnBack.text="Backup inaendelea ..."
            activityLandingBinding.btnBack.animation = AnimationUtils.loadAnimation(this,R.anim.blink)

            UFile.doBackup(this,activityLandingBinding.prog,object :FileBackup{

                override fun onBackupFinish(success: Boolean, backupPath: String) {
                    if (success){
                        backedup = File(backupPath)
                        val size = UFile.getFolderSizeLabel(backedup)
                        Toast.makeText(this@LandingActivity,size, Toast.LENGTH_LONG).show()
                        is_backup = true
                        activityLandingBinding.btnBack.text="Backup"
                    }else{
                        Toast.makeText(this@LandingActivity,backupPath,Toast.LENGTH_LONG).show()
                    }
                }

            })



        }

        activityLandingBinding.btnUpload.setOnClickListener {
            try {

                if (!UgNet.isNetworkAvailable(this)) {
                    Toast.makeText(this, "Not Network Connection", Toast.LENGTH_LONG).show()
                    return@setOnClickListener
                }

                if (!UgNet.isInternetAvailable()) {
                    Toast.makeText(this, "Not Internet Connection", Toast.LENGTH_LONG).show()
                    return@setOnClickListener
                }

                if (!is_backup){
                    //Toast.makeText(this,"Tangulia kufanya Backup",Toast.LENGTH_LONG).show()
                    UFile.doBackup(this,activityLandingBinding.prog,object :FileBackup{
                        override fun onBackupFinish(success:Boolean,backupPath: String) {
                            if(success){
                                sendFile()
                            }else{
                                Toast.makeText(this@LandingActivity,backupPath,Toast.LENGTH_LONG).show()
                            }
                        }

                    })
                }else{
                    sendFile()
                }

            }catch (e:Exception){
                e.message?.let { it1 -> Log.d("ZAKA", it1) }
            }
        }
    }

    private fun sendFile() {
        if (!UgNet.isNetworkAvailable(this)) {
            Toast.makeText(this, "Not Network Connection", Toast.LENGTH_LONG).show()
            return
        }

        if (!UgNet.isInternetAvailable()) {
            Toast.makeText(this, "Not Internet Connection", Toast.LENGTH_LONG).show()
            return
        }


        activityLandingBinding.lnLogin.visibility=View.VISIBLE
        activityLandingBinding.edtUsn.setText(USoft["username"])
        activityLandingBinding.btnSend.setOnClickListener {
            val psw = activityLandingBinding.edtPsw.text.toString()
            if (psw.isEmpty()){
                return@setOnClickListener
            }
            relogin(psw)
        }
    }

    private fun relogin(psw: String) {
        try {
            val user = UserLogin(USoft["username"]!!,psw)
            activityLandingBinding.btnSend.text="Tafadhali subiri...."
            API.ret.authToken(user).enqueue(object :Callback<AuthTokenResponse>{
                override fun onResponse(
                    call: Call<AuthTokenResponse>,
                    response: Response<AuthTokenResponse>
                ) {
                    try {
                        Log.d("ZAKA",response.body()?.access!!)
                        if (response.body()?.access!=null){
                            activityLandingBinding.btnSend.text="Tuma Data"
                            USoft["token"] = "uG@li "+response.body()?.access!!
                            finalSent()
                        }
                    }catch (e:Exception){
                        e.message?.let { it1 -> Log.d("ZAKA", it1) }
                    }
                }

                override fun onFailure(call: Call<AuthTokenResponse>, t: Throwable) {
                    activityLandingBinding.lnLogin.visibility=View.GONE
                }

            })

        }catch (_:Exception){ }
    }

    private fun finalSent() {
        try {

            activityLandingBinding.lnLogin.visibility=View.GONE

            activityLandingBinding.lyProg.progWait.max = 100
            activityLandingBinding.lyProg.root.visibility = View.VISIBLE
            activityLandingBinding.lyProg.btnClose.setOnClickListener {
                API.client.dispatcher().cancelAll()
                activityLandingBinding.lyProg.root.visibility = View.GONE
                sending = false
            }


            var out =
                "${this.getExternalFilesDir(null)!!.absoluteFile}/" + USoft["zipname"] + ".zip"
            out = out.replace("Android/data/" + this.packageName + "/files/", "")

            val fl = File(out)

            activityLandingBinding.lyProg.txtTitle.text = UFile.getFolderSizeLabel(fl)

            val fileBody = ProgressRequestBody(
                fl, "application/zip",
                object : ProgressRequestBody.UploadCallbacks {
                    override fun onProgressUpdate(percentage: Int) {
                        activityLandingBinding.lyProg.txtWait.text =
                            "Mfumo Unatuma .... $percentage%"
                        activityLandingBinding.lyProg.progWait.post {
                            activityLandingBinding.lyProg.progWait.progress = percentage
                        }
                        //Log.d("ZAKA", "Kanzidata Inatumwa ...$percentage%")
                    }

                    override fun onError() {
                        activityLandingBinding.lyProg.txtWait.text = "Imetumwa"
                        Toast.makeText(this@LandingActivity, "Error", Toast.LENGTH_LONG)
                            .show()
                        activityLandingBinding.lyProg.root.visibility = View.GONE
                    }

                    override fun onFinish() {
                        activityLandingBinding.lyProg.txtWait.text =
                            "Kanzidata Inamalizia..."
                        activityLandingBinding.lyProg.progWait.post {
                            activityLandingBinding.lyProg.progWait.progress = 100
                        }
                        activityLandingBinding.lyProg.root.visibility = View.GONE
                    }
                })

            val body = MultipartBody.Part.createFormData("zipped", fl.name, fileBody)


            sending = true

            API.ret.uploadToServer(
                USoft["user"]!!.toLong(),
                USoft["project_id"]!!.toLong(),
                body
            ).enqueue(object : Callback<ServerResponse> {
                override fun onFailure(call: Call<ServerResponse>, t: Throwable) {
                }

                override fun onResponse(
                    call: Call<ServerResponse>,
                    response: Response<ServerResponse>
                ) {
                    try {

                        if (response.isSuccessful) {
                            if (response.body()!!.ref_id == -1 || response.body()!!.status != 1) {
                                Toast.makeText(
                                    this@LandingActivity,
                                    response.body()!!.message,
                                    Toast.LENGTH_LONG
                                ).show()
                                return
                            }
                            Toast.makeText(this@LandingActivity, "Sent", Toast.LENGTH_LONG)
                                .show()

                            activityLandingBinding.lyProg.root.visibility=View.GONE

                            val back = File(
                                Environment.getExternalStoragePublicDirectory(
                                    Environment.DIRECTORY_PICTURES), "zaka")

                            try {

                                val deleteCmd = "rm -r " + back.absolutePath
                                val runtime = Runtime.getRuntime()
                                try {
                                    runtime.exec(deleteCmd)
                                } catch (_: Exception) {
                                }

                                db.execSQL("update tb_answer set tag='sent'")
                                sending = false
                            } catch (_: Exception) {

                            }
                        } else {

                            //Log.d("ZAKA", response.message().toString())

                            Toast.makeText(
                                this@LandingActivity,
                                "Failed",
                                Toast.LENGTH_LONG
                            ).show()
                        }
                    } catch (e: Exception) {


                        e.message?.let { it1 -> Log.d("ZAKA", it1) }
                        Toast.makeText(
                            this@LandingActivity,
                            e.message.toString(),
                            Toast.LENGTH_LONG
                        )
                            .show()
                    }
                }
            })

        } catch (e: Exception) {
            //dialog.dismiss()
            Log.d("ZAKA", "Fail ${e.message} - Here")
            Toast.makeText(this@LandingActivity, e.message.toString(), Toast.LENGTH_LONG)
                .show()
        }

        try {

            activityLandingBinding.lyProg.progWait.max = 100
            activityLandingBinding.lyProg.root.visibility = View.VISIBLE
            activityLandingBinding.lyProg.btnClose.setOnClickListener {
                API.client.dispatcher().cancelAll()
                activityLandingBinding.lyProg.root.visibility = View.GONE
                sending = false
            }


            var out =
                "${this.getExternalFilesDir(null)!!.absoluteFile}/" + USoft["zipname"] + ".zip"
            out = out.replace("Android/data/" + this.packageName + "/files/", "")

            val fl = File(out)

            activityLandingBinding.lyProg.txtTitle.text = UFile.getFolderSizeLabel(fl)

            val fileBody = ProgressRequestBody(
                fl, "application/zip",
                object : ProgressRequestBody.UploadCallbacks {
                    override fun onProgressUpdate(percentage: Int) {
                        activityLandingBinding.lyProg.txtWait.text =
                            "Mfumo Unatuma .... $percentage%"
                        activityLandingBinding.lyProg.progWait.post {
                            activityLandingBinding.lyProg.progWait.progress = percentage
                        }
                        //Log.d("ZAKA", "Kanzidata Inatumwa ...$percentage%")
                    }

                    override fun onError() {
                        activityLandingBinding.lyProg.txtWait.text = "Imetumwa"
                        Toast.makeText(this@LandingActivity, "Error", Toast.LENGTH_LONG)
                            .show()
                        activityLandingBinding.lyProg.root.visibility = View.GONE
                    }

                    override fun onFinish() {
                        activityLandingBinding.lyProg.txtWait.text =
                            "Kanzidata Inamalizia..."
                        activityLandingBinding.lyProg.progWait.post {
                            activityLandingBinding.lyProg.progWait.progress = 100
                        }
                        activityLandingBinding.lyProg.root.visibility = View.GONE
                    }
                })

            val body = MultipartBody.Part.createFormData("zipped", fl.name, fileBody)


            sending = true


        } catch (e: Exception) {
        }
    }


    private fun checkFilePermission() {

        USoft.perm(this,activityLandingBinding.root)
        USoft.turnOnLocation(this)



    }
}