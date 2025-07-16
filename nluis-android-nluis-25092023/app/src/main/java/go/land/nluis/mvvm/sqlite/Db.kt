package go.land.nluis.mvvm.sqlite

import android.content.ContentValues
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import android.util.Log
import com.google.gson.Gson
import go.land.nluis.mvvm.model.AnswerModel
import go.land.nluis.mvvm.model.QuestionAnswerModel
import go.land.nluis.mvvm.network.response.UserConfigResponse
import go.land.nluis.utils.USoft
import kotlin.collections.ArrayList

class Db(val context: Context?) : SQLiteOpenHelper(context, "db_lims", null, 1) {

    override fun onCreate(db: SQLiteDatabase?) {
        db?.execSQL(Query.createTbQuestionnaire())

        try {
            //db?.execSQL("alter table tb_kiwanja add column wanufaika text")
        }catch (e:Exception){
            e.message?.let { Log.d("ZAKA", it) }
        }
    }

    override fun onUpgrade(db: SQLiteDatabase?, oldVersion: Int, newVersion: Int) {

    }

    fun saveQuestionnaires(uuid: String, lst_answers: ArrayList<QuestionAnswerModel>):Boolean {
        try {
            val db = writableDatabase

            var i = 0
            lst_answers.forEach {
                try {
                    if(it.answer.isNotEmpty()){
                        val cv = ContentValues()
                        cv.put("uuid",uuid)
                        cv.put("question_id",it.qn.id)
                        cv.put("answer",USoft.escape(it.answer))
                        //cv.put("tag",it.tag)
                        val last = db.insert("tb_answer",null,cv)

                        if (last<0){
                            db.update("tb_answer",  cv,"uuid=? and question_id=?", arrayOf(uuid,it.qn.id.toString()))
                        }
                    }
                    i++
                }catch (e:Exception){
                    e.message?.let { it1 -> Log.d("ZAKA", it1) }
                    return false
                }
            }

            return i == lst_answers.size

        }catch (e:Exception){
            e.message?.let { Log.d("ZAKA", it) }
        }
        return false
    }

    fun saveQuestionnaires(uuid: String, qn_id:Int,answer:String):Boolean {
        try {
            val db = writableDatabase
            return try {
                if (answer.isNotEmpty()){
                    val cv = ContentValues()
                    cv.put("uuid",uuid)
                    cv.put("question_id",qn_id)
                    cv.put("answer",USoft.escape(answer))
                    db.insert("tb_answer",null,cv)

                    try {
                        val last = db.insert("tb_answer",null,cv)
                        if (last<0){
                            db.update("tb_answer",  cv,"uuid=? and question_id=?", arrayOf(uuid,qn_id.toString()))
                        }
                    }catch (e:Exception){
                        db.update("tb_answer",  cv,"uuid=? and question_id=?", arrayOf(uuid,qn_id.toString()))
                    }



                    //Log.d("ZAKA","saving == $uuid -> $answer")

                }
                true
            }catch (e:Exception){
                e.message?.let { it1 -> Log.d("ZAKA", it1) }
                false
            }
        }catch (e:Exception){
            e.message?.let { Log.d("ZAKA", it) }
        }
        return false
    }

    fun listAnswers(search: String="all", date: String="all",haml:String=""):ArrayList<AnswerModel> {
        val lst =  arrayListOf<AnswerModel>()
        var totalQuestion = 0

        Gson().fromJson(USoft["userConfig"], UserConfigResponse::class.java).questionnaire.forEach { it.contents.forEach { c-> totalQuestion+=c.question.size }}

        try {
            val db = readableDatabase
            var sql = "select uuid,date_ from tb_answer where uuid not like '%_m%'"
            if (search!="all"){
                sql = "select uuid,date_ from tb_answer where uuid like '%$search%'"
            }
            if (date!="all"){
                sql+=" and date_ like '${date}%'"
            }

            if (haml!=""){
                sql="select uuid,date_ from tb_answer where uuid like '/$haml/' not like '%_m%'"
            }

            //Log.d("ZAKA",sql)

            val c = db.rawQuery("$sql group by uuid order by id desc",null)
            var count = 1
            if (c.moveToFirst()){
                do {
                    val uuid = c.getString(0)
                    var total = 0

                    val c2 = db.rawQuery("select count(*) from tb_answer where uuid='$uuid'",null)
                    if (c2.moveToFirst()){
                        do {
                            total=c.getInt(0)
                        }while (c2.moveToNext())
                    }

                    var valid = false

                    var countPercel = 0
                    val c4 = db.rawQuery("select count(*) from tb_answer where uuid ='${uuid}'",null)
                    if (c4.moveToFirst()){ do {countPercel = c4.getInt(0) }while (c4.moveToNext()) }

                    var countOwner = 0
                    val c3 = db.rawQuery("select count(*) from tb_answer where uuid like '%${uuid}_m%'",null)
                    if (c3.moveToFirst()){ do {countOwner = c3.getInt(0) }while (c3.moveToNext()) }

                    var countValid = countPercel+countOwner

                   // Log.d("ZAKA","${((countValid.toFloat()/totalQuestion.toFloat())*100)>70}%")
                    if (((countValid.toFloat()/totalQuestion.toFloat())*100)>70){
                        valid=true
                    }

                    val answer = AnswerModel(count, total,uuid,c.getString(1),valid,"${countValid}/${totalQuestion}")
                    if (search!="all"){
                        if (!uuid.contains("_m")){
                            lst.add(answer)
                        }
                    }else{
                        lst.add(answer)
                    }


                    count++
                }while (c.moveToNext())
            }
            c.close()
        }catch (e:Exception){
            e.message?.let { Log.d("ZAKA", it) }
        }
        return lst
    }

    fun listGeom(type:String = "POLYGON"):ArrayList<AnswerModel> {
        val lst =  arrayListOf<AnswerModel>()
        try {
            val db = readableDatabase
            val c = db.rawQuery("select id,question_id,answer,uuid from tb_answer where answer like '$type%'",null)
            var count = 1
            if (c.moveToFirst()){
                do {
                    val id = c.getInt(0)
                    val question_id = c.getInt(1)
                    val answe = c.getString(2)
                    val uuid = c.getString(3)

                    val answer = AnswerModel(id, question_id,answe,uuid)
                    lst.add(answer)

                    count++
                }while (c.moveToNext())
            }
            c.close()
        }catch (e:Exception){
            e.message?.let { Log.d("ZAKA", it) }
        }
        return lst
    }

    fun listData(sql:String):ArrayList<AnswerModel> {
        val lst =  arrayListOf<AnswerModel>()
        try {
            val db = readableDatabase
            val c = db.rawQuery(sql,null)
            var count = 1
            if (c.moveToFirst()){
                do {
                    val id = c.getInt(0)
                    val question_id = c.getInt(1)
                    val answe = c.getString(2)
                    val uuid = c.getString(3)

                    val answer = AnswerModel(id, question_id,answe,uuid)
                    lst.add(answer)

                    count++
                }while (c.moveToNext())
            }
            c.close()
        }catch (e:Exception){
            e.message?.let { Log.d("ZAKA", it) }
        }
        return lst
    }


    fun getAnswerByUuIdAndQnId(uuid: String, id: Int): String {
        return try {
            val db = readableDatabase
            val c = db.rawQuery("select answer from tb_answer where uuid='$uuid' and question_id=$id",null)
            var answ=""
            if (c.moveToFirst()){
                do {
                    answ=USoft.read(c.getString(0))
                }while (c.moveToNext())
            }
            c.close()
            answ
        }catch (e:Exception){
            e.message?.let { Log.d("ZAKA", it) }
            //Log.d("ZAKA",uuid)
            ""
        }
    }

    fun execSQL(sql:String):Boolean {
        return try {
            val db = writableDatabase
            db.execSQL(sql)
            //Log.d("ZAKA",sql)
            true
        }catch (e:Exception){
            e.message?.let { Log.d("ZAKA", it) }
            false
        }
    }

    fun lastDate(): String {
        var date = ""
        try {
            val db = readableDatabase
            val c = db.rawQuery("select date_ from tb_answer order by id desc limit 1",null)
            if (c.moveToFirst()){
                do {
                    date = c.getString(0)
                }while (c.moveToNext())
            }
            c.close()
        }catch (e:Exception){
            e.message?.let { Log.d("ZAKA", it) }
        }
        //Log.d("ZAKA","last==$date")
        return date
    }

    fun getPicture(uuid: String, id: Int): String {
        return try {
            // /storage/emulated/0/Pictures/zaka/17__0__5_mmiliki_1686108048112.jpg
            //Log.d("ZAKA",uuid+"....hapa")
            val new_uuid = uuid.replace("/","__")

            val db = readableDatabase
            val c = db.rawQuery("select answer from tb_answer where answer like '%$new_uuid%'",null)
            var answ=""
            if (c.moveToFirst()){
                do {
                    answ=USoft.read(c.getString(0))
                }while (c.moveToNext())
            }
            c.close()
            answ
        }catch (e:Exception){
            e.message?.let { Log.d("ZAKA", it) }
            //Log.d("ZAKA",uuid)
            ""
        }
    }

////    CREATED A DELETE FUNCTION
    fun deleteAnswers(uuid: String) {
        val db = writableDatabase
        db.execSQL("delete from tb_answer where uuid='$uuid'")
    }



}