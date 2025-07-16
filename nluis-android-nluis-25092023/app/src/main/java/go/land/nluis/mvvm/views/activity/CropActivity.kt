package go.land.nluis.mvvm.views.activity



import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.os.Environment
import android.util.Log
import android.view.Menu
import android.view.View
import androidx.core.app.ActivityCompat
import com.canhub.cropper.CropImage
import com.canhub.cropper.CropImageActivity
import com.canhub.cropper.CropImageView
import go.land.nluis.databinding.ExtendLayoutBinding
import go.land.nluis.utils.USoft

import java.io.File
import kotlin.properties.Delegates

internal class CropActivity : CropImageActivity() {

    companion object {
        //var myUri:Uri?=null
        var xx by Delegates.notNull<Int>()
        var yy by Delegates.notNull<Int>()
        var name = ""
        var cur_img = 0

        val main = File(
            Environment.getExternalStoragePublicDirectory(
                Environment.DIRECTORY_PICTURES), "zaka")

        fun start(activity: Activity,fullname:String,cur_im:Int, x:Int=0, y:Int=0) {
            xx = x
            yy = y
            cur_img = cur_im
            name =fullname.replace("'","")
            name = name.replace("/","__")



//            if (main.exists()){
//                main.deleteRecursively()
//            }
            if (!main.exists()){
                main.mkdirs()
            }

            ActivityCompat.startActivity(
                activity,
                Intent(activity, CropActivity::class.java),
                null
            )
        }
    }

    private lateinit var binding: ExtendLayoutBinding
    private var counter = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        binding = ExtendLayoutBinding.inflate(layoutInflater)

        if(xx >0){
            binding.cropImageView.setAspectRatio(xx, yy)
        }else{
            binding.cropImageView.setAspectRatio(1, 1)
        }

        binding.cropImageView.guidelines = CropImageView.Guidelines.ON
        binding.cropImageView.setMinCropResultSize(280,280)


        super.onCreate(savedInstanceState)
        updateRotationCounter(counter.toString())

        binding.saveBtn.setOnClickListener { cropImage() } // CropImageActivity.cropImage()
        binding.backBtn.setOnClickListener { onBackPressed() } // CropImageActivity.onBackPressed()
        binding.rotateText.setOnClickListener { onRotateClick() }

        setCropImageView(binding.cropImageView)
    }

    override fun showImageSourceDialog(openSource: (Source) -> Unit) {
        // Override this if you wanna a custom dialog layout
        super.showImageSourceDialog(openSource)
    }

    override fun setContentView(view: View) {
        // Override this to use your custom layout
        super.setContentView(binding.root)
    }

    private fun updateRotationCounter(counter: String) {
        //binding.rotateText.text = getString(R.string.rotation_value, counter)
    }

    override fun onPickImageResult(resultUri: Uri?) {
        super.onPickImageResult(resultUri)
        if (resultUri != null) binding.cropImageView.setImageUriAsync(resultUri)
    }

    // Override this to add more information into the intent
    override fun getResultIntent(uri: Uri?, error: java.lang.Exception?, sampleSize: Int): Intent {
        val result = super.getResultIntent(uri, error, sampleSize)
        return result.putExtra("EXTRA_KEY", "Extra data")
    }

    override fun setResult(uri: Uri?, error: Exception?, sampleSize: Int) {
        val result = CropImage.ActivityResult(
            originalUri = binding.cropImageView.imageUri,
            uriContent = uri,
            error = error,
            cropPoints = binding.cropImageView.cropPoints,
            cropRect = binding.cropImageView.cropRect,
            rotation = binding.cropImageView.rotatedDegrees,
            wholeImageRect = binding.cropImageView.wholeImageRect,
            sampleSize = sampleSize
        )

        binding.cropImageView.setImageUriAsync(result.uriContent)
        val f = File(main, "${name}_${System.currentTimeMillis()}.jpg")
        val myUri = Uri.fromFile(f)

        contentResolver.openInputStream(uri!!).use { `in` ->
            if (`in` == null) return
            contentResolver.openOutputStream(myUri!!).use { out ->
                if (out == null) return
                // Transfer bytes from in to out
                val buf = ByteArray(1024)
                var len: Int
                while (`in`.read(buf).also { len = it } > 0) {
                    out.write(buf, 0, len)
                }
            }
        }

        USoft["picturePath$cur_img"] = f.absolutePath

        finish()
    }

    override fun setResultCancel() {
        Log.i("extend", "User this override to change behaviour when cancel")
        super.setResultCancel()
    }

    override fun updateMenuItemIconColor(menu: Menu, itemId: Int, color: Int) {
        Log.i(
            "extend",
            "If not using your layout, this can be one option to change colours. Check README and wiki for more"
        )
        super.updateMenuItemIconColor(menu, itemId, color)
    }

    private fun onRotateClick() {
        counter += 90
        binding.cropImageView.rotateImage(90)
        if (counter == 360) counter = 0
        updateRotationCounter(counter.toString())
    }
}