package go.land.nluis.mvvm.views.activity

import android.content.Intent
import android.graphics.BitmapFactory
import android.graphics.Color
import android.os.Bundle
import android.text.InputType
import android.util.Log
import android.view.View
import android.widget.*
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.core.widget.doAfterTextChanged
import androidx.databinding.DataBindingUtil
import androidx.lifecycle.MutableLiveData
import com.google.gson.Gson
import go.land.nluis.R
import go.land.nluis.databinding.*
import go.land.nluis.mvvm.model.QuestionAnswerModel
import go.land.nluis.mvvm.network.response.UserConfigResponse
import go.land.nluis.mvvm.sqlite.Db
import go.land.nluis.utils.USoft
import go.land.nluis.utils.UStatic
import go.land.nluis.utils.UgMap
import java.io.File
import java.util.*
import kotlin.collections.ArrayList
import kotlin.random.Random


class AddDodosoActivity : AppCompatActivity() {

    private lateinit var activityDodosoBinding: ActivityDodosoBinding
    private lateinit var userConfig:UserConfigResponse
    private lateinit var lst_answers:ArrayList<QuestionAnswerModel>
    private lateinit var db:Db
    private val currentVillage by lazy { MutableLiveData<UserConfigResponse.Village>() }
    private lateinit var currentHamlet:UserConfigResponse.Hamlet
    private val noOfParty by lazy { MutableLiveData(1) }

    private var isNewData:Boolean = true
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        activityDodosoBinding=DataBindingUtil.setContentView(this,R.layout.activity_dodoso)


//        SETTING INITIAL STATE OF THE SAVE BUTTON
//        activityDodosoBinding.btnSave.isEnabled = USoft["hamlet"] != "hamlet"
        init()
    }

    var niuAidii = ""
    private fun init(){

        lst_answers = arrayListOf()
        UStatic.uuid = intent.extras?.getString("uuid")!!
        isNewData = intent.extras?.getBoolean("isNewData")!!

        db = Db(this)

        try {

            activityDodosoBinding.lnQuestionnaire.removeAllViews()

            userConfig = Gson().fromJson(USoft["userConfig"],UserConfigResponse::class.java)
            userConfig.questionnaire.forEach {



                if(it.tag=="party_info"){

                    Log.d("ZAKA",it.tag+"...."+isNewData)
                    if (!isNewData) {
                        val vw = RowPartyBinding.inflate(layoutInflater)

                        var id_mmiliki = 0
                        var id_picha = 0
                        it.contents.forEach { cont->
                            cont.question.forEach { qn->
                                if (qn.tag=="person_name"){
                                    id_mmiliki = qn.id
                                }
                                if (qn.tag=="person_picture"){
                                    id_picha=qn.id
                                }
                            }
                        }

                        if (niuAidii==""){ niuAidii = UStatic.uuid }

                        val mmiliki = db.getAnswerByUuIdAndQnId(niuAidii+"_mmiliki",id_mmiliki)
                        val msimamizi = db.getAnswerByUuIdAndQnId(niuAidii+"_msimamizi",id_mmiliki)

                        //val mmiliki_pic = db.getAnswerByUuIdAndQnId(niuAidii+"_mmiliki",id_picha)
                        //val msimamizi_pic = db.getAnswerByUuIdAndQnId(niuAidii+"_msimamizi",id_picha)

                        val mmiliki_pic = db.getPicture(niuAidii+"_mmiliki",id_picha)
                        val msimamizi_pic = db.getPicture(niuAidii+"_msimamizi",id_picha)

                        if (mmiliki.isNotEmpty()){ vw.txtNamePart1.text=mmiliki }
                        if (msimamizi.isNotEmpty()){ vw.txtNamePart2.text=msimamizi }

                        try {
                            val imgFile = File(mmiliki_pic)
                            if (imgFile.exists()) {
                                val myBitmap = BitmapFactory.decodeFile(imgFile.absolutePath)
                                vw.imgPart1.setImageBitmap(myBitmap)
                            }
                        }catch (_:Exception){}

                        try {
                            val imgFile = File(msimamizi_pic)
                            if (imgFile.exists()) {
                                val myBitmap = BitmapFactory.decodeFile(imgFile.absolutePath)
                                vw.imgPart2.setImageBitmap(myBitmap)
                            }
                        }catch (_:Exception){}

                        vw.imgPart1.setOnClickListener {

                            saveAnswersToDb(false)

                            saved = true

                            startActivity(Intent(this,AddPartyInfoActivity::class.java)
                                .putExtra("uuid",niuAidii+"_mmiliki")
                                .putExtra("category","mmiliki"))
                        }
                        vw.imgPart2.setOnClickListener {

                            saveAnswersToDb(false)

                            saved = true

                            startActivity(Intent(this,AddPartyInfoActivity::class.java)
                                .putExtra("uuid",niuAidii+"_msimamizi")
                                .putExtra("category","msimamizi"))
                        }

                        noOfParty.observeForever { no->
                            vw.vwPart2.visibility=if (no>1){
                               View.VISIBLE
                            }else{
                                View.GONE
                            }
                        }


                        activityDodosoBinding.lnQuestionnaire.addView(vw.root)
                    }


                }else{

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

                            val db_answer = db.getAnswerByUuIdAndQnId(UStatic.uuid,qn.id)

                            if (db_answer.isNotEmpty()){
                                activityDodosoBinding.btnSave.text = "Update Changes"
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
//                                    txt.inputType = InputType.TYPE_TEXT_VARIATION_PERSON_NAME
//                                    txt.doAfterTextChanged { changed-> saveTextAnswerAt(qn,changed.toString()) }
//                                }
//MODIFIED TO DISPLAY THE MESSAGE
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
                                    txt.doAfterTextChanged { text -> saveTextAnswerAt(qn, text.toString()) }
                                    txt.inputType = InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS

                                    // No errorTextView for "email"
                                }

                                "village"->{

                                    val lst = arrayListOf("- Chagua Kijiji -")
                                    var jibu = ""

                                    userConfig.village.forEach { vl->
                                        lst.add(vl.name)
                                        if (vl.id.toString()==db_answer){
                                            jibu=vl.name
                                        }
                                    }

                                    val sp = Spinner(this)
                                    sp.adapter = ArrayAdapter(this,android.R.layout.simple_list_item_1,lst)

                                    if (USoft["village"]!="village"){
                                        jibu=USoft["village"]!!
                                    }

                                    sp.setSelection(lst.indexOf(jibu), true)

                                    if (jibu!=""){
                                        db.saveQuestionnaires(UStatic.uuid,qn.id, userConfig.village[lst.indexOf(jibu)-1].id.toString())
                                        currentVillage.value =  userConfig.village[lst.indexOf(jibu)-1]
                                        sp.isEnabled=false
                                    }else{
                                        sp.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
                                            override fun onItemSelected(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
                                                if (position >0){

                                                    currentVillage.value = userConfig.village[position-1]

                                                    saveTextAnswerAt(qn,currentVillage.value?.id.toString())

                                                    USoft["village"]= userConfig.village[position-1].name
                                                    sp.isEnabled=false
                                                }
                                            }
                                            override fun onNothingSelected(parent: AdapterView<*>) {}
                                        }
                                    }

                                    vw_qn.lnAnswer.addView(sp)

                                }



                                "hamlet"->{

                                    val sp = Spinner(this)

//                                    ADDING USER PROMPT TO ACT AS REQUIRED FIELD
                                    val errorTextView = TextView(this).apply {
                                        setTextColor(Color.RED)
                                        text = "" // Initially no error message
                                    }

                                    currentVillage.observeForever { vil->
                                        if (vil!=null){
                                            val lst = arrayListOf("- Chagua Kitongoji -")
                                            var jibu = ""
                                            vil.hamlets.forEach { hm->
                                                lst.add(hm.name)
                                                if(hm.id.toString()==db_answer){
                                                    jibu=hm.name
                                                }
                                            }
                                            sp.adapter = ArrayAdapter(this,android.R.layout.simple_list_item_1,lst)

                                            /*if (USoft["hamlet"]!="hamlet"){
                                                jibu=USoft["hamlet"]!!
                                            }*/

                                            sp.setSelection(lst.indexOf(jibu), true)
                                            if (jibu!=""){
//                                                  ERROR CHECKING
                                                errorTextView.visibility = View.GONE
//                                               END OF ERROR CHECKING
//                                                sp.isEnabled=true
                                                USoft["hamlet"] = jibu


                                            }
                                        }
                                    }

                                    sp.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
                                        override fun onItemSelected(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
                                            if (position >0){
////                                                ERROR CHECKING
                                                errorTextView.visibility = View.GONE
////                                                END OF ERROR CHECKING

                                                currentHamlet = currentVillage.value?.hamlets!![position-1]
                                                saveTextAnswerAt(qn,currentHamlet.id.toString())

                                                USoft["hamlet"] = currentVillage.value?.hamlets!![position-1].id.toString()

                                                val lastUuid = UStatic.uuid
                                                val newUUd = generateUUID()

                                                Log.d("ZAKA", "$lastUuid...$newUUd")
                                                db.execSQL("update tb_answer set uuid='$newUUd' where uuid='$lastUuid'")

                                                UStatic.uuid=lastUuid
                                                niuAidii = newUUd
                                                sp.isEnabled=false

//                                                ENABLE THE SAVE BUTTON
                                                activityDodosoBinding.btnSave.isEnabled = true
                                            }else { //ERROR CHECKING MESSAGE ENABLED
//                                                errorTextView.visibility = View.VISIBLE
                                                errorTextView.text = "Tafadhali chagua kitongoji"  //
//                                                DISSABLE THE SAVE BUTTON
//                                                activityDodosoBinding.btnSave.isEnabled = false
                                            }
                                        //                                            END OF ERROR MSG
                                        }
                                        override fun onNothingSelected(parent: AdapterView<*>) {
                                            //ERROR CHECKING MESSAGE ENABLED
//                                            errorTextView.visibility = View.VISIBLE
                                            errorTextView.text = "Tafadhali chagua kitongoji"
//                                            activityDodosoBinding.btnSave.isEnabled = false
                                        //                                            END OF ERROR MSG
                                        }
                                    }

//                                    ADDING BOTH SPINER AND ERROR TEXT TO A VERTICAL LINEAR LAYOUT
//                                    val container = LinearLayout(this).apply {
//                                        orientation = LinearLayout.VERTICAL
//                                        addView(sp)
//                                        addView(errorTextView)
//                                    }

                                    vw_qn.lnAnswer.addView(sp)
                                    vw_qn.lnAnswer.addView(errorTextView)
                                }

//
//                                "land_use"->{
//
//                                    val lst = arrayListOf("- Chagua Matumizi -")
//                                    var jibu = ""
//                                    userConfig.landUse.forEach { use->
//                                        lst.add(use.sw)
//                                        if (use.id.toString()==db_answer){
//                                            jibu=use.sw
//                                        }
//                                    }
//                                    val sp = Spinner(this)
//
////                                    ADDING USER PROMPT
//                                    val errorTextView = TextView(this).apply {
//                                        setTextColor(Color.RED)
//                                        text = "" // Initially no error message
//                                    }
//
//                                    sp.adapter = ArrayAdapter(this,android.R.layout.simple_list_item_1,lst)
//                                    sp.setSelection(lst.indexOf(jibu), true)
//
//                                    sp.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
//                                        override fun onItemSelected(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
//                                            if (position >0){
//                                                val cur_use = userConfig.landUse[position-1]
//                                                saveTextAnswerAt(qn,cur_use.id.toString())
//                                                errorTextView.visibility = View.GONE //Hide error message if a valid option is selected
//                                            }else {
//                                                errorTextView.text = "Tafadhali chagua matumizi ya ardhi!" //Show error message
//                                                errorTextView.visibility = View.VISIBLE
//                                            }
//
//                                        }
//                                        override fun onNothingSelected(parent: AdapterView<*>) {}
//                                    }
//                                    vw_qn.lnAnswer.addView(sp)
//                                    vw_qn.lnAnswer.addView(errorTextView) //Add the error message view below the spinner
//
//                                }


                                "land_use" -> {
                                    // Sort the landUse list by id in ascending order
                                    val sortedLandUse = userConfig.landUse.sortedBy { it.id }

                                    val lst = arrayListOf("- Chagua Matumizi -")
                                    var jibu = ""
                                    sortedLandUse.forEach { use ->
                                        lst.add(use.sw)
                                        if (use.id.toString() == db_answer) {
                                            jibu = use.sw
                                        }
                                    }
                                    val sp = Spinner(this)

                                    // ADDING USER PROMPT
                                    val errorTextView = TextView(this).apply {
                                        setTextColor(Color.RED)
                                        text = "" // Initially no error message
                                    }

                                    sp.adapter = ArrayAdapter(this, android.R.layout.simple_list_item_1, lst)
                                    sp.setSelection(lst.indexOf(jibu), true)

                                    sp.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
                                        override fun onItemSelected(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
                                            if (position > 0) {
                                                val cur_use = sortedLandUse[position - 1]
                                                saveTextAnswerAt(qn, cur_use.id.toString())
                                                errorTextView.visibility = View.GONE // Hide error message if a valid option is selected
                                            } else {
                                                errorTextView.text = "Tafadhali chagua matumizi ya ardhi!" // Show error message
                                                errorTextView.visibility = View.VISIBLE
                                            }
                                        }

                                        override fun onNothingSelected(parent: AdapterView<*>) {}
                                    }
                                    vw_qn.lnAnswer.addView(sp)
                                    vw_qn.lnAnswer.addView(errorTextView) // Add the error message view below the spinner
                                }



                                "occupancy"->{
                                    val lst = arrayListOf("- Chagua Aina ya Umiliki -")
                                    var jibu = ""

                                    userConfig.occupancy.forEach { ocp->
                                        lst.add(ocp.sw)

                                        if (ocp.id.toString()==db_answer){
                                            jibu=ocp.sw
                                            noOfParty.value = ocp.noOfParty
                                        }
                                    }

                                    val sp = Spinner(this)

//                                    ADDING USER PROMPT
                                    val errorTextView = TextView(this).apply {
                                        setTextColor(Color.RED)
                                        text = "" // Initially no error message
                                    }

                                    sp.adapter = ArrayAdapter(this,android.R.layout.simple_list_item_1,lst)
                                    sp.setSelection(lst.indexOf(jibu), true)

                                    Log.d("ZAKA","occupancy = "+db_answer)

                                    sp.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
                                        override fun onItemSelected(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
                                            if (position >0){
                                                val curOcp = userConfig.occupancy[position-1]

                                                noOfParty.value = curOcp.noOfParty
                                                saveTextAnswerAt(qn,curOcp.id.toString())
                                                errorTextView.visibility = View.GONE

                                                if (!isNewData){
                                                    init()
                                                }
                                            }else {
                                                errorTextView.text = "Tafadhali chagua aina ya umiliki!" //Show error message
                                                errorTextView.visibility = View.VISIBLE
                                            }
                                        }
                                        override fun onNothingSelected(parent: AdapterView<*>) {}
                                    }

                                    vw_qn.lnAnswer.addView(sp)
                                    vw_qn.lnAnswer.addView(errorTextView) //Add the error message view below the spinner
                                }
                                "radio"->{
                                    val rd_group=RadioGroup(this)
                                    rd_group.orientation = RadioGroup.VERTICAL
                                    qn.options.split(",").forEach { s->
                                        val rd = RadioButton(this)
                                        rd.text=s

                                        if (db_answer==s){
                                            rd.isSelected=true
                                        }

                                        rd.setOnCheckedChangeListener { _, isChecked ->
                                            if (isChecked){
                                                saveTextAnswerAt(qn,s)
                                            }
                                        }

                                        rd_group.addView(rd)
                                    }
                                    vw_qn.lnAnswer.addView(rd_group)
                                }
                                "select"->{
                                    val lst = arrayListOf("- Chagua Moja -")
                                    qn.options.split(",").forEach { s-> lst.add(s) }

                                    val sp = Spinner(this)
                                    sp.adapter = ArrayAdapter(this,android.R.layout.simple_list_item_1,lst)
                                    sp.setSelection(lst.indexOf(db_answer), true)


                                    sp.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
                                        override fun onItemSelected(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
                                            if (position >0){
                                                saveTextAnswerAt(qn,lst[position])
                                            }
                                        }
                                        override fun onNothingSelected(parent: AdapterView<*>) {}
                                    }

                                    vw_qn.lnAnswer.addView(sp)

                                }
                                "image"->{

                                    val ln = LinearLayout(this)
                                    ln.weightSum=2f
                                    ln.orientation=LinearLayout.HORIZONTAL

                                    val btn1 = Button(this)
                                    btn1.layoutParams= LinearLayout.LayoutParams(0,LinearLayout.LayoutParams.WRAP_CONTENT,2f)
                                    btn1.text="Piga Picha"

                                    /*val btn2 = Button(this)
                                    btn2.layoutParams= LinearLayout.LayoutParams(0,LinearLayout.LayoutParams.WRAP_CONTENT,1f)
                                    btn2.text="Open Gallery"*/

                                    ln.addView(btn1)
                                    //ln.addView(btn2)

                                    vw_qn.lnAnswer.addView(ln)
                                }
                                "point","line","polygon"->{
                                    val btn = Button(this)
                                    btn.text="Fungua Ramani"

                                    var newRamana = true

                                    if (db_answer.isNotEmpty()){
                                        vw_qn.txtQuestion.text="Eneo Limetambuliwa"
                                        try{
                                            val sqm = UgMap.getSQM(db_answer).toDouble()
                                            vw_qn.txtHint.text = "Eneo lina ukubwa wa "+sqm+"SQM = "+UgMap.getAcres(sqm)+" Acres = "+UgMap.getHactor(sqm)+" Hactor"
                                        }catch (e:Exception){}
                                        btn.text="Tazama Kwenye Ramani"
                                        newRamana = false
                                    }

                                    btn.setOnClickListener {

                                        if (USoft["hamlet"]=="hamlet"){
                                            Toast.makeText(this,"Chagua Kitongoji",Toast.LENGTH_LONG).show()
                                            return@setOnClickListener
                                        }

                                        saveAnswersToDb(false)

                                        saved = true

                                        if (niuAidii==""){
                                           niuAidii=UStatic.uuid
                                        }

                                        startActivity(Intent(this,MapActivity::class.java)
                                            .putExtra("geom",db_answer)
                                            .putExtra("uuid",niuAidii)
                                            .putExtra("qn_id",qn.id)
                                            .putExtra("new_ramani",newRamana)
                                        )
                                    }

                                    vw_qn.lnAnswer.addView(btn)
                                }
                            }
                            vw_content.lnQuestion.addView(vw_qn.root)
                        }
                        vw.lnContents.addView(vw_content.root)
                    }
                    activityDodosoBinding.lnQuestionnaire.addView(vw.root)

                }
            }
        }catch (e:Exception){
            e.message?.let { Log.d("ZAKA", it) }
        }

        activityDodosoBinding.btnSave.setOnClickListener {
            saveAnswersToDb()
        }

//  CONTROLING THE DELETE BUTTON
        activityDodosoBinding.btnDelete.setOnClickListener {
            android.app.AlertDialog.Builder(this)
                .setTitle("Thibitisha")
                .setMessage("Taarifa za kipande "+UStatic.uuid+" zitafutika")
                .setPositiveButton("Nina Hakika") { d, _ ->
                    db.deleteAnswers(UStatic.uuid)
                    d.dismiss()
                    finish()
                }
                .setNegativeButton("Hapana") { d, _ ->
                    d.dismiss()
                }
                .show()
        }


    }

    private fun kitongoji(): Boolean {
        return try {
            val claim = UStatic.uuid.split("/")[2]
            Log.d("ZAKA",claim)
            true
        }catch (e:Exception){
            Toast.makeText(this,"Hakuna Kitongoji",Toast.LENGTH_LONG).show()
            false
        }
    }
    
    private fun generateUUID(): String {


        /*try {
            val sdf = SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.ENGLISH)

            val last=Db(this).lastDate()
            Log.d("ZAKA",last)

            val firstDate: Date = sdf.parse(last)
            val secondDate: Date = sdf.parse(UFile.dateNow)


            val diffInMillies: Long = abs(secondDate.time - firstDate.time)
            val diff: Long = TimeUnit.MINUTES.convert(diffInMillies, TimeUnit.MILLISECONDS)

            Log.d("ZAKA","diff=$diff")
            if (diff<1){
                return UStatic.uuid
            }
            Log.d("ZAKA", "$diff...diffence")
        }catch (e:Exception){
            e.message?.let { Log.d("ZAKA", it) }
        }*/




//        val size = db.listAnswers("all","all","${currentHamlet.id}").size+ currentHamlet.count

//        val size = USoft["size"]
//        val size = "${System.currentTimeMillis()}-${Random.nextInt(1000, 9999)}"

//      FUNCTION YA KUTOFAUTISHA CLAIM NUMBER
//        val truncatedTime = System.currentTimeMillis().toString().takeLast(5)
        val truncatedTime = System.nanoTime().toString().takeLast(6)
        val randomPart = Random.nextInt(10, 99) // Generate a 2-digit random number
        val size = "$truncatedTime$randomPart"
//        MWISHO WA FUNCTION
        val uuid = "${userConfig.user.id}/${currentHamlet.id}/${size}"
        return if (isNewData){
            uuid
        }else{
           if (  UStatic.uuid.contains("/")){
               UStatic.uuid
           }else{
               UStatic.uuid
           }
        }
    }


    private fun saveTextAnswerAt(qn: UserConfigResponse.Question, answer: String) {
        lst_answers.forEach {
            if (it.qn.id==qn.id){
                it.answer=answer
            }
        }

        if (niuAidii==""){
            niuAidii = UStatic.uuid
        }
        db.saveQuestionnaires(niuAidii,qn.id,answer)
    }

    private var saved = false
    private fun saveAnswersToDb(close:Boolean=true) {

        if (USoft["hamlet"] == "hamlet") {
            Toast.makeText(this, "Tafadhali chagua kitongoji", Toast.LENGTH_LONG).show()
            return
        }

        lst_answers.forEach {

            if (it.qn.answer.isEmpty()){
                if (it.qn.required){

                    if (it.qn.errorMessage.isNotEmpty()){
                        Toast.makeText(this,it.qn.question,Toast.LENGTH_LONG).show()
                    }else{
                        Toast.makeText(this, it.qn.errorMessage,Toast.LENGTH_LONG).show()
                    }
                    return
                }
            }
        }

        if (db.saveQuestionnaires(UStatic.uuid,lst_answers)){
            if (close){
                Toast.makeText(this,"Saved",Toast.LENGTH_LONG).show()
                saved = true
                finish()
            }
        }
    }

    override fun onResume() {
        super.onResume()
        init()
    }

    override fun onDestroy() {
        super.onDestroy()
        if (isNewData){
            if (!saved){
                if (niuAidii==""){
                    niuAidii=UStatic.uuid
                }
                db.execSQL("delete from tb_answer where uuid='$niuAidii'")
            }
        }
        USoft["hamlet"] = "hamlet"
        db.execSQL("delete from tb_answer where uuid not like '%/%/%'")
    }
}