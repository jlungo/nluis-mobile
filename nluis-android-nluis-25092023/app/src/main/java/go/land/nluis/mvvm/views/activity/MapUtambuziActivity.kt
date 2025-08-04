package go.land.nluis.mvvm.views.activity

import android.Manifest
import android.annotation.SuppressLint
import android.content.pm.PackageManager
import android.graphics.Color
import android.location.Criteria
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View
import android.view.WindowManager
import android.view.animation.AnimationUtils
import android.widget.Toast
import androidx.core.app.ActivityCompat
import androidx.databinding.DataBindingUtil
import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.OnMapReadyCallback
import com.google.android.gms.maps.SupportMapFragment
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.PolygonOptions
import go.land.nluis.R
import go.land.nluis.databinding.ActivityMapUtambuziBinding
import go.land.nluis.mvvm.sqlite.Db
import go.land.nluis.utils.UMapUtils
import go.land.nluis.utils.UgMap
import java.util.ArrayList

class MapUtambuziActivity : AppCompatActivity() , OnMapReadyCallback, LocationListener {

    private var mapFragment: SupportMapFragment? = null

    private lateinit var activityMapUtambuziBinding: ActivityMapUtambuziBinding
    private var uuid = ""
    private var qn_id = 0
    //private lateinit var utambuziData: UtambuziData

    private lateinit var db: Db

    @SuppressLint("MissingPermission")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        window.setFlags(WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE)
        window.addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN or WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        activityMapUtambuziBinding = DataBindingUtil.setContentView(this,R.layout.activity_map_utambuzi)

        mapFragment = supportFragmentManager.findFragmentById(R.id.map) as SupportMapFragment
        mapFragment!!.getMapAsync(this)

        setSupportActionBar(activityMapUtambuziBinding.tb)

        db = Db(this)
        uuid = intent.extras!!.getString("uuid")!!
        qn_id = intent.extras!!.getInt("qn_id")

        supportActionBar?.title=uuid

        try {
            val locationManager = getSystemService(LOCATION_SERVICE) as LocationManager
            val criteria = Criteria()
            val bestProvider = locationManager.getBestProvider(criteria, true)

            val location = bestProvider?.let { locationManager.getLastKnownLocation(it) }
            if (location != null) { onLocationChanged(location) }
            supportActionBar?.subtitle = "Accuracy = ${location?.accuracy}"
            bestProvider?.let { locationManager.requestLocationUpdates(it, 1, 0.001f, this) }
        } catch (e: Exception) {
            e.message?.let { Log.d("ZAKA Accuracy1", it) }
        }


        activityMapUtambuziBinding.btnNilipo.setOnClickListener {
            try{
                if (gmap!=null){
                    UMapUtils.drawPoly(LatLng(my_loc!!.latitude,my_loc!!.longitude))
                }
            }catch (e:Exception){
                Toast.makeText(this,"No Location", Toast.LENGTH_LONG).show()
            }
        }

        init()
    }


    private var tambua = false
    private fun init(){






       /* activityMapUtambuziBinding.btnChora.setOnClickListener {
            //tambuaKipande(true)
            activityMapUtambuziBinding.mnChukua.visibility= View.GONE
            activityMapUtambuziBinding.mnEdit.root.visibility= View.VISIBLE
            activityMapUtambuziBinding.btnNilipo.visibility= View.GONE
            tambua=true

        }
        activityMapUtambuziBinding.btnChukua.setOnClickListener {
            //tambuaKipande(false)
            tambua=false
            activityMapUtambuziBinding.mnChukua.visibility= View.GONE
            activityMapUtambuziBinding.mnEdit.root.visibility= View.VISIBLE
            activityMapUtambuziBinding.btnNilipo.visibility = View.VISIBLE
            activityMapUtambuziBinding.btnNilipo.startAnimation(AnimationUtils.loadAnimation(this,R.anim.anim_grow))

        }*/


        //tambuaKipande(false)
        tambua=false
        activityMapUtambuziBinding.mnChukua.visibility= View.GONE
        activityMapUtambuziBinding.mnEdit.root.visibility= View.VISIBLE
        activityMapUtambuziBinding.btnNilipo.visibility = View.VISIBLE
        activityMapUtambuziBinding.btnNilipo.startAnimation(AnimationUtils.loadAnimation(this,R.anim.anim_grow))
    }

    private lateinit var gmap: GoogleMap
    override fun onMapReady(gmap: GoogleMap) {
        this.gmap = gmap
        gmap.mapType = GoogleMap.MAP_TYPE_HYBRID
        gmap.uiSettings.isZoomControlsEnabled =true

        if (ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_COARSE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED
        ) {

            return
        }
        gmap.isMyLocationEnabled = true
        UMapUtils.map = gmap
        UMapUtils.initialize("polygon")

        if (my_loc!=null){
            gmap.moveCamera(
                CameraUpdateFactory.newLatLngZoom(
                    LatLng(
                my_loc!!.latitude,
                my_loc!!.longitude
            ), 19.0f))
        }

        gmap.setOnMapClickListener {

            if (tambua){
                if (gmap!=null){
                    UMapUtils.drawPoly(LatLng(it!!.latitude,it!!.longitude))
                }
            }
            //malizaEdit()
        }


        try {
            db.listGeom().forEach {ans->

                val list = UgMap.get_poly(ans.answer)
                val p = PolygonOptions().addAll(list).strokeWidth( if (ans.uuid==uuid){8f}else{4f}).strokeColor(
                    Color.parseColor(
                    if (ans.uuid==uuid){"#ffff00"}else{"#efefef"}))
                    .clickable(true)
                val pl = gmap.addPolygon(p)
                pl.tag = ans.id

                UgMap.addText(this,gmap, UgMap.getCentroid(p.points as ArrayList<LatLng>),ans.uuid)

                if (ans.uuid==uuid){



                    var i = 0
                    list.forEach {
                        if (i<list.size-1){ UMapUtils.drawPoly(it) }
                        i++
                    }

                    UMapUtils.listPolygons.add(pl)

                    mapFragment?.requireView()?.post {
                        UMapUtils.setExtent(gmap,list)
                    }

                }



            }
        }catch (e:Exception){}


    }

    private var my_loc: Location? = null
    override fun onLocationChanged(location: Location) {
        try {
            val latitude = location.latitude
            val longitude = location.longitude
            my_loc = location
            supportActionBar?.subtitle = "Accuracy = ${location.accuracy}"

            /*gmap.moveCamera(CameraUpdateFactory.newLatLngZoom(LatLng(
                my_loc!!.latitude,
                my_loc!!.longitude
            ), 20.0f))*/
        } catch (e: Exception) {
            e.message?.let { Log.d("ZAKA onLocationChanged", it) }
        }
    }

    fun undo(v: View){
        UMapUtils.undo()
    }
    fun redo(v: View){
        UMapUtils.redo()
    }
    fun done(v: View){
        UMapUtils.done()

        val out =UMapUtils.outputPolygon()

        if (out.split(",").size<3){
            Toast.makeText(this,"Invalid Polygon", Toast.LENGTH_LONG).show()
            return
        }

        Db(this).execSQL("update tb_answer set answer='$out' where uuid='${uuid}' and question_id=$qn_id")
        finish()

    }
    fun futa(v: View){
        UMapUtils.deleteMarker()
    }
    fun info(v: View){

    }

    override fun onStatusChanged(provider: String, status: Int, extras: Bundle) {}
    override fun onProviderEnabled(provider: String) {}
    override fun onProviderDisabled(provider: String) {}
}