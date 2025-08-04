package go.land.nluis.utils

import android.content.Context
import android.os.Environment
import android.os.Handler
import android.os.Looper
import android.os.StrictMode
import android.os.StrictMode.VmPolicy
import android.util.Base64
import android.util.Log
import android.view.View
import android.widget.ProgressBar
import android.widget.Toast
import go.land.nluis.mvvm.interfaces.FileBackup
import java.io.*
import java.math.RoundingMode
import java.text.DecimalFormat
import java.text.SimpleDateFormat
import java.util.*
import java.util.zip.ZipEntry
import java.util.zip.ZipOutputStream

object UFile {
    val date: String
        get() {
            val df = SimpleDateFormat("yyyy-MM-dd-hh")
            return df.format(Date(System.currentTimeMillis()))
        }

    val dateNow: String
        get() {
            val df = SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
            return df.format(Date(System.currentTimeMillis()))
        }

    fun doBackup(cntx: Context,prog:ProgressBar,fileBackup: FileBackup): String {
        
        val builder = VmPolicy.Builder()
        StrictMode.setVmPolicy(builder.build())

        Toast.makeText(cntx,"Backup On Process",Toast.LENGTH_LONG).show()
        return try {
            prog.visibility = View.VISIBLE
            var out = "${cntx.getExternalFilesDir(null)!!.absoluteFile}/"+USoft["zipname"]+".zip"
            out = out.replace("Android/data/"+cntx.packageName+"/files/","")

            Handler(Looper.getMainLooper()).postDelayed({
                //val back = File("${cntx.getExternalFilesDir(null)!!.absoluteFile}/Ugalisoft")
                val back = File(
                    Environment.getExternalStoragePublicDirectory(
                        Environment.DIRECTORY_PICTURES), "zaka")

                if (!back.exists()) {
                    back.mkdirs()
                }
               /* if (File(out).exists()){
                    try {
                        File(out).deleteRecursively()
                    }catch (e:Exception){}
                }*/

                val inFileName = "/data/data/" + cntx.packageName + "/databases/db_lims"
                val dbFile = File(inFileName)
                val fis = FileInputStream(dbFile)

                val outFileName = back.absolutePath+ "/" + USoft["user"] + "_.SQLITE3"
                val output: OutputStream = FileOutputStream(outFileName)
                val buffer = ByteArray(1024)
                var length: Int
                while (fis.read(buffer).also { length = it } > 0) {
                    output.write(buffer, 0, length)
                }

                output.flush()
                output.close()
                fis.close()


                if (compress(back.absolutePath, out)){
                    //Db(cntx).update("update tb_parcel set visible=11 where visible!=9")
                    //back.deleteRecursively()
                    fileBackup.onBackupFinish(true,out)
                }else{
                    Toast.makeText(cntx,"Not Done",Toast.LENGTH_LONG).show()
                    fileBackup.onBackupFinish(true,"Fail to compress")
                }
                prog.visibility = View.GONE

            }, 100)

            out
        } catch (e: Exception) {
            fileBackup.onBackupFinish(false,e.message.toString())
            ""
        }
    }

    private fun compress(inputFolderPath: String, outZipPath: String) :Boolean{
        return try {
            val fos = FileOutputStream(outZipPath)
            val zos = ZipOutputStream(fos)
            val srcFile = File(inputFolderPath)
            val files = srcFile.listFiles()
            for (file in files) {
                try {
                    Log.d("ZAKA", "Adding file: " + file.name)
                    val buffer = ByteArray(1024)
                    val fis = FileInputStream(file)
                    zos.putNextEntry(ZipEntry(file.name))
                    var length: Int
                    while (fis.read(buffer).also { length = it } > 0) {
                        zos.write(buffer, 0, length)
                    }
                    zos.closeEntry()
                    fis.close()
                }catch (e:Exception){
                    Log.d("ZAKA",e.message!!)
                }
            }
            zos.close()
            true
        } catch (ioe: Exception) {
            Log.d("ZAKA", ioe.message!!)
            false
        }
    }

    fun getFolderSizeLabel(file: File): String {
        val size = getFolderSize(file)
            .toDouble() / 1000.0 // Get size and convert bytes into KB.
        val df = DecimalFormat("#.##")
        df.roundingMode = RoundingMode.CEILING
        return if (size >= 1024) {
            df.format(size / 1024) + " MB"
        } else {
            df.format(size) + " KB"
        }
    }

    private fun getFolderSize(file: File): Long {
        var size: Long = 0
        if (file.isDirectory) {
            for (child in file.listFiles()) {
                size += getFolderSize(child)
            }
        } else {
            size = file.length()
        }
        return size
    }

    fun removeBackup(activity: Context) {
        try {

            File("${activity.getExternalFilesDir(null)!!.absoluteFile}/"+USoft["zipname"]+".zip"
                .replace("Android/data/"+activity.packageName+"/files/","")).deleteRecursively()
        }catch (e:Exception){
            e.message?.let { Log.d("ZAKA", it) }
        }


    }



    fun saveBase64StringToFile(
        base64Str: String,
        filePath: String, fileName: String
    ) {
        var bos: BufferedOutputStream? = null
        var fos: FileOutputStream? = null
        var file: File? = null
        try {
            val dir = File(filePath)
            if (!dir.exists() && dir.isDirectory) {
                dir.mkdirs()
            }
            file = File(filePath, fileName)
            fos = FileOutputStream(file)
            bos = BufferedOutputStream(fos)
            val bfile: ByteArray = Base64.decode(base64Str, Base64.DEFAULT)
            bos.write(bfile)
        } catch (e: FileNotFoundException) {
            throw e
        } catch (e: IOException) {
            throw e
        } finally {
            if (bos != null) {
                try {
                    bos.close()
                } catch (e1: IOException) {
                    e1.printStackTrace()
                }
            }
            if (fos != null) {
                try {
                    fos.close()
                } catch (e1: IOException) {
                    e1.printStackTrace()
                }
            }
        }
    }
}