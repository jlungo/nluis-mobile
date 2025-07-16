package go.land.nluis.mvvm.views.activity

import android.app.DatePickerDialog
import android.app.DatePickerDialog.OnDateSetListener
import android.content.Intent
import android.graphics.BitmapFactory

import android.graphics.Color

import android.os.Build
import android.os.Bundle
import android.text.InputType
import android.util.Log
import android.view.View
import android.widget.*
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AppCompatActivity
import androidx.core.widget.doAfterTextChanged
import androidx.databinding.DataBindingUtil
import com.google.gson.Gson
import go.land.nluis.R
import go.land.nluis.databinding.*
import go.land.nluis.mvvm.model.QuestionAnswerModel
import go.land.nluis.mvvm.network.response.UserConfigResponse
import go.land.nluis.mvvm.sqlite.Db
import go.land.nluis.utils.USoft
import go.land.nluis.utils.UgMap
import java.io.File


class AddPartyInfoActivity : AppCompatActivity() {
    private lateinit var activityAddPartyInfoBinding: ActivityAddPartyInfoBinding
    private lateinit var userConfig: UserConfigResponse
    private lateinit var uuid:String
    private lateinit var db: Db
    private lateinit var lst_answers:ArrayList<QuestionAnswerModel>
    private lateinit var imgUser:ImageView
    private var qnId:Int = 0

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        activityAddPartyInfoBinding= DataBindingUtil.setContentView(this,R.layout.activity_add_party_info)

        init()
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun init(){
        db = Db(this)
        uuid = intent.extras?.getString("uuid")!!

        USoft["picturePath0"] = ""

        lst_answers = arrayListOf()

        try {
            activityAddPartyInfoBinding.lnQuestionnaire.removeAllViews()

            userConfig = Gson().fromJson(USoft["userConfig"], UserConfigResponse::class.java)
            userConfig.questionnaire.forEach {

                Log.d("ZAKA",it.tag)

                if(it.tag=="party_info"){

                    val vw = RowQuestionnaireBinding.inflate(layoutInflater)
                    vw.qn = it
                    vw.executePendingBindings()

                    vw.lnContents.removeAllViews()

                    it.contents.forEach {cont->
                        val vw_content = RowContentBinding.inflate(layoutInflater)
                        vw_content.content = cont
                        vw_content.executePendingBindings()

                        vw_content.lnQuestion.removeAllViews()

                        cont.question.forEach { qn->

                            val db_answer = db.getAnswerByUuIdAndQnId(uuid,qn.id)

                            if (db_answer.isNotEmpty()){
                                activityAddPartyInfoBinding.btnSave.text = "Update Changes"
                            }

                            val answer = QuestionAnswerModel(qn,db_answer)
                            lst_answers.add(answer)

                            val vw_qn = RowQuestionBinding.inflate(layoutInflater)
                            vw_qn.question=qn
                            vw_qn.executePendingBindings()

//                            when(qn.answer){
//                                "text","email","phone","number"->{
//                                    val txt = EditText(this)
//                                    vw_qn.lnAnswer.addView(txt)
//                                    txt.setText(db_answer)
//                                    txt.doAfterTextChanged { txt-> saveTextAnswerAt(qn,txt.toString()) }
//                                    txt.inputType = InputType.TYPE_TEXT_VARIATION_PERSON_NAME
//                                }

//                            MODIFIED FOR errorTextView message
                            when (qn.answer) {
                                "text", "phone", "number" -> {
                                    val txt = EditText(this)
                                    vw_qn.lnAnswer.addView(txt)
                                    txt.setText(db_answer)

                                    // Create errorTextView and initially hide it
                                    val errorTextView = TextView(this)
                                    errorTextView.text = "Tafadhali jaza taarifa hii"
                                    errorTextView.setTextColor(Color.RED)
                                    errorTextView.visibility = View.GONE
                                    vw_qn.lnAnswer.addView(errorTextView)

                                    txt.doAfterTextChanged { text ->
                                        saveTextAnswerAt(qn, text.toString())
                                        if (text.toString().isEmpty()) {
                                            errorTextView.visibility = View.VISIBLE
                                        } else {
                                            errorTextView.visibility = View.GONE
                                        }
                                    }
                                    txt.inputType = InputType.TYPE_TEXT_VARIATION_PERSON_NAME
                                }

                                "email" -> {
                                    val txt = EditText(this)
                                    vw_qn.lnAnswer.addView(txt)
                                    txt.setText(db_answer)
                                    txt.doAfterTextChanged { text ->
                                        saveTextAnswerAt(
                                            qn,
                                            text.toString()
                                        )
                                    }
                                    txt.inputType = InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS

                                    // No errorTextView for "email"
                                }


                                "date" -> {
                                    val btn = Button(this)
                                    btn.text = db_answer
                                    vw_qn.lnAnswer.addView(btn)


//                                    ADDING ERROR MESSAGE
                                    val errorTextView = TextView(this).apply {
                                        text = ""
                                        setTextColor(Color.RED)
                                    }
                                    vw_qn.lnAnswer.addView(errorTextView)
//                                    ======================================

                                    val myDateListener =
                                        OnDateSetListener { v, year, month, day ->
                                            // arg1 = year
                                            // arg2 = month
                                            // arg3 =
                                            val mwezi = month + 1
                                            val date = "$year-$mwezi-$day"
                                            saveTextAnswerAt(qn, date)
                                            btn.text = date

//                                      /========/
                                            errorTextView.text = ""
//                                            /=========/
                                            Toast.makeText(this, date, Toast.LENGTH_LONG).show()
                                        }
                                    val datePickerDialog = DatePickerDialog(
                                        this, myDateListener, 2023, 6, 1
                                    )

                                    btn.setOnClickListener { datePickerDialog.show() }

//                                  /====================/
                                    if (db_answer.isEmpty()) {
                                        errorTextView.text =
                                            "Tafadhali jaza tarehe ya kuzaliwa kutoka kwenye kitambulisho"
                                    }


                                    /*val day: Int = txt.dayOfMonth
                                    val month: Int = txt.month + 1
                                    val year: Int = txt.year*/

                                    /* txt.setOnDateChangedListener { view, year, monthOfYear, dayOfMonth ->

                                     }

                                     txt.setOnDateChangedListener { view, year, monthOfYear, dayOfMonth ->

                                     }*/
                                }


//                          FOR ZAKARIA
                                "radio" -> {

                                    //                                    ADDING ERROR MESSAGE
                                    val errorTextView = TextView(this).apply {
                                        text = ""
                                        setTextColor(Color.RED)
                                    }
                                    vw_qn.lnAnswer.addView(errorTextView)
//                                    ======================================

                                    val rd_group = RadioGroup(this)
                                    rd_group.orientation = RadioGroup.VERTICAL
                                    qn.options.split(",").forEach { s ->
                                        val rd = RadioButton(this)
                                        rd.text = s

                                        if (db_answer.lowercase().trim() == s.lowercase().trim()) {
                                            rd.isChecked = true
                                        }

                                        rd.setOnCheckedChangeListener { _, isChecked ->
                                            if (isChecked) {
                                                saveTextAnswerAt(qn, s)
                                                //                                      /========/
                                                errorTextView.text = ""
//                                            /=========/
                                            } else {
                                                errorTextView.text = "Tafadhali chagua jinsia"
                                            }
                                        }

                                        rd_group.addView(rd)
                                    }
                                    vw_qn.lnAnswer.addView(rd_group)
                                }

//                                "select"->{
//                                    val lst = arrayListOf("- Chagua Moja -")
//                                    qn.options.split(",").forEach { s-> lst.add(s) }
//
//                                    val sp = Spinner(this)
//                                    sp.adapter = ArrayAdapter(this,android.R.layout.simple_list_item_1,lst)
//                                    sp.setSelection(lst.indexOf(db_answer), true)
//
//
//                                    sp.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
//                                        override fun onItemSelected(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
//                                            if (position >0){
//                                                db.saveQuestionnaires(uuid,qn.id,lst[position])
//                                                saveTextAnswerAt(qn,lst[position])
//                                            }
//                                        }
//                                        override fun onNothingSelected(parent: AdapterView<*>) {}
//                                    }
//
//                                    vw_qn.lnAnswer.addView(sp)
//
//                                }

//modified to include errorTextView Message
                                "select" -> {
                                    val lst = arrayListOf("- Chagua Moja -")
                                    qn.options.split(",").forEach { s -> lst.add(s) }

                                    val sp = Spinner(this)
                                    sp.adapter =
                                        ArrayAdapter(this, android.R.layout.simple_list_item_1, lst)
                                    sp.setSelection(lst.indexOf(db_answer), true)

                                    // Create errorTextView and set its color to red
                                    val errorTextView = TextView(this)
                                    errorTextView.text = "Tafadhali chagua mojawapo"
                                    errorTextView.setTextColor(Color.RED)
                                    errorTextView.visibility = View.GONE // Initially hide the error message
                                    vw_qn.lnAnswer.addView(errorTextView)

                                    sp.onItemSelectedListener =
                                        object : AdapterView.OnItemSelectedListener {
                                            override fun onItemSelected(
                                                parent: AdapterView<*>?,
                                                view: View?,
                                                position: Int,
                                                id: Long
                                            ) {
                                                if (position > 0) {
                                                    db.saveQuestionnaires(
                                                        uuid,
                                                        qn.id,
                                                        lst[position]
                                                    )
                                                    saveTextAnswerAt(qn, lst[position])
                                                    errorTextView.visibility = View.GONE // Hide error message if a valid option is selected
                                                } else {
                                                    errorTextView.visibility = View.VISIBLE // Show error message if no valid option is selected
                                                }
                                            }

                                            override fun onNothingSelected(parent: AdapterView<*>) {
                                                errorTextView.visibility = View.VISIBLE // Show error message if nothing is selected
                                            }
                                        }
                                    vw_qn.lnAnswer.addView(sp)
                                }









//                                FOR IMAGE HANDLING & TAKING A PICTURE
                                "image"->{

                                    val ln = LinearLayout(this)
                                    //ln.weightSum=2f
                                    ln.orientation=LinearLayout.VERTICAL


                                    imgUser = ImageView(this)
//                                    //modified by gerald//
                                    imgUser.setOnClickListener {
                                        // Start the camera activity to recapture the image
                                        qnId = qn.id
                                        CropActivity.start(this, USoft.escape(uuid), 0)
                                    }

                                    ln.addView(imgUser)

                                    val btn1 = Button(this)
                                    btn1.layoutParams= LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT,LinearLayout.LayoutParams.WRAP_CONTENT)
                                    btn1.text="Piga Picha"

                                    btn1.setOnClickListener {
                                        //if (qn.tag=="person image")
                                        //imgUser =
                                        qnId = qn.id
                                        CropActivity.start(this,USoft.escape(uuid),0)
                                    }

                                    /* val btn2 = Button(this)
                                     btn2.layoutParams= LinearLayout.LayoutParams(0,LinearLayout.LayoutParams.WRAP_CONTENT,1f)
                                     btn2.text="Open Gallery"*/

                                    ln.addView(btn1)
                                    //ln.addView(btn2)


                                    try {
                                        val imgFile = File(db_answer)
                                        if (imgFile.exists()) {
                                            val myBitmap = BitmapFactory.decodeFile(imgFile.absolutePath)
                                            //val myImage: ImageView = findViewById<View>(R.id.imageviewTest) as ImageView
                                            imgUser.setImageBitmap(myBitmap)
                                        }
                                    }catch (e:Exception){}

                                    vw_qn.lnAnswer.addView(ln)

//                                    modified by gerald

                                }


                                "point","line","polygon"->{
                                    val btn = Button(this)
                                    btn.text="Open Map"

                                    if (db_answer.isNotEmpty()){
                                        vw_qn.txtQuestion.text="Eneo Limetambuliwa"
                                        vw_qn.txtHint.text = "Eneo lina ukubwa wa Mita za Mraba "+ UgMap.getSQM(db_answer)
                                        btn.text="View On Map"
                                    }

                                    btn.setOnClickListener {
                                        startActivity(
                                            Intent(this,MapActivity::class.java)
                                                .putExtra("geom",db_answer)
                                                .putExtra("uuid",uuid)
                                                .putExtra("qn_id",qn.id))
                                    }

                                    vw_qn.lnAnswer.addView(btn)
                                }
                            }
                            vw_content.lnQuestion.addView(vw_qn.root)
                        }
                        vw.lnContents.addView(vw_content.root)
                    }
                    activityAddPartyInfoBinding.lnQuestionnaire.addView(vw.root)

                }



            }

        }catch (e:Exception){
            e.message?.let { Log.d("ZAKA", it) }
        }

        activityAddPartyInfoBinding.btnSave.setOnClickListener {
            saveAnswersToDb()
        }

    }

    private fun saveTextAnswerAt(qn: UserConfigResponse.Question, answer: String) {
        lst_answers.forEach {
            if (it.qn.id==qn.id){
                it.answer=answer
            }
        }
        //Log.d("ZAKA",lst_answers.toString())
    }

    private fun saveAnswersToDb() {
        /*lst_answers.forEach {
            var error_msg = ""
            if (it.qn.answer.isNotEmpty()){
                if (it.qn.required){
                    if (it.qn.errorMessage.isNullOrBlank()){
                        error_msg = it.qn.question
                    }else{
                        error_msg = it.qn.errorMessage
                    }
                    Toast.makeText(this,error_msg,Toast.LENGTH_LONG).show()
                    return
                }
            }
        }*/

        if (db.saveQuestionnaires(uuid,lst_answers)){
            Toast.makeText(this,"Saved",Toast.LENGTH_LONG).show()
            finish()
        }

    }
    override fun onResume() {
        super.onResume()

        try {
            val imgFile = File(USoft["picturePath0"]!!)

            if (imgFile.exists()) {
                val myBitmap = BitmapFactory.decodeFile(imgFile.absolutePath)
                //val myImage: ImageView = findViewById<View>(R.id.imageviewTest) as ImageView
                imgUser.setImageBitmap(myBitmap)
            }

            db.saveQuestionnaires(uuid,qnId,USoft["picturePath0"]!!)

        }catch (_:Exception){}
    }

}