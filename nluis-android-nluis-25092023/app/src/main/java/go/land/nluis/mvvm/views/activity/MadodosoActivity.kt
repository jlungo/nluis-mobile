package go.land.nluis.mvvm.views.activity

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Color
import android.location.Location
import android.location.LocationListener
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.Menu
import android.view.MenuItem
import android.view.View
import android.view.WindowManager
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.core.widget.doAfterTextChanged
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.LinearLayoutManager
import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.OnMapReadyCallback
import com.google.android.gms.maps.SupportMapFragment
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.PolygonOptions
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.gson.Gson
import go.land.nluis.R
import go.land.nluis.databinding.ActivityMadodosoBinding
import go.land.nluis.mvvm.network.geo_reponse.GeoResponse
import go.land.nluis.mvvm.sqlite.Db
import go.land.nluis.mvvm.views.adapter.DodosoRecyAdapter
import go.land.nluis.utils.UFile
import go.land.nluis.utils.USoft
import go.land.nluis.utils.UgMap

import java.util.*


class MadodosoActivity : AppCompatActivity() , OnMapReadyCallback, LocationListener {

    private lateinit var activityMadodosoBinding: ActivityMadodosoBinding
    private var id = 0
    private var name = ""
    private lateinit var db: Db
    private val date = UFile.date.substring(0,10)

    private var mapFragment: SupportMapFragment? = null
    private lateinit var gmap: GoogleMap

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        window.setFlags(WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE)
        window.addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN or WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)

        activityMadodosoBinding=DataBindingUtil.setContentView(this,R.layout.activity_madodoso)

        init()
    }

    private fun init(){

        db =Db(this)

        mapFragment = supportFragmentManager.findFragmentById(R.id.map) as SupportMapFragment
        mapFragment!!.getMapAsync(this)

        setSupportActionBar(activityMadodosoBinding.tb)

        try{
            //val userConfig = Gson().fromJson(USoft["userConfig"], UserConfigResponse::class.java)
            id=intent.extras?.getInt("id")!!
            name=intent.extras?.getString("name")!!

            supportActionBar?.title=name


        }catch (e:Exception){
            e.message?.let { Log.d("ZAKA", it) }
        }

        BottomSheetBehavior.from(activityMadodosoBinding.vwTable.root).apply {
            //peek height is default visible height
            peekHeight = 400
            this.state = BottomSheetBehavior.STATE_COLLAPSED
        }

        val preSearch = USoft["user"]+"/"
        activityMadodosoBinding.vwTable.edtSearch.setOnFocusChangeListener { v, hasFocus ->
            if (hasFocus){
                activityMadodosoBinding.vwTable.edtSearch.setText(preSearch)
                activityMadodosoBinding.vwTable.edtSearch.setSelection(preSearch.length)
            }
        }

        activityMadodosoBinding.vwTable.edtSearch.doAfterTextChanged {
            val search = it.toString()
            if (search.length>preSearch.length){
                showData(search,"all")
            }
            if (search.length<preSearch.length){
                showData("all", date)
            }
        }

        showData("all", date)
    }



    override fun onMapReady(p0: GoogleMap) {

        try{

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
            p0.isMyLocationEnabled = true
            my_loc = p0.myLocation
            gmap = p0
            gmap.mapType = GoogleMap.MAP_TYPE_HYBRID

            UgMap.updateMyLocation(this, gmap)

            loadMapData()
            loadGeoJson()

        }catch (e:Exception){
            e.message?.let { Log.d("ZAKA", it) }
        }

    }

    private fun loadMapData(search: String="all", date: String="all") {
        try {
            var poly = ""
            db.listGeom().forEach {ans->
                val p = PolygonOptions().addAll(UgMap.get_poly(ans.answer)).strokeWidth(6f).strokeColor(Color.parseColor("#ffffbb"))
                    .clickable(true)
                val pl = gmap.addPolygon(p)
                pl.tag = ans.id

                UgMap.addText(this,gmap,UgMap.getCentroid(p.points as ArrayList<LatLng>),ans.uuid)
                poly=ans.answer

            }
            //mapFragment?.requireView()?.post { UgMap.setExtent(gmap, UgMap.get_poly(poly)) }
        }catch (e:Exception){
            e.message?.let { Log.d("ZAKA", it) }
        }
    }

    private var my_loc: Location? = null
    private var first_zoom = false
    override fun onLocationChanged(location: Location) {
        try {
            //val latitude = location.latitude
            //val longitude = location.longitude
            my_loc = location
            supportActionBar?.subtitle = "Accuracy = ${location.accuracy}"

            if (first_zoom==false){
                gmap.moveCamera(CameraUpdateFactory.newLatLngZoom(LatLng(my_loc!!.latitude, my_loc!!.longitude), 20.0f))
                first_zoom=true
            }

        } catch (e: Exception) {
            e.message?.let { Log.d("ZAKA onLocationChanged", it) }
        }
    }


    @Deprecated("Deprecated in Java")
    override fun onStatusChanged(provider: String, status: Int, extras: Bundle) {}
    override fun onProviderEnabled(provider: String) {}
    override fun onProviderDisabled(provider: String) {}


    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        menuInflater.inflate(R.menu.mn_map,menu)
        return super.onCreateOptionsMenu(menu)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId){
            R.id.mn_add->{
                val uuid = UUID.randomUUID().toString()

                startActivity(Intent(this,AddDodosoActivity::class.java)
                    .putExtra("isNewData",true)
                    .putExtra("uuid",uuid))
            }
        }
        return super.onOptionsItemSelected(item)
    }



    private fun showData(search:String="all",date:String="all"){
        activityMadodosoBinding.vwTable.progress.visibility=View.VISIBLE
        Handler(Looper.getMainLooper()).postDelayed({

            runOnUiThread {
                try {
                    val data = db.listAnswers(search,date)

                    activityMadodosoBinding.vwTable.txt2.text = date
                    activityMadodosoBinding.vwTable.txt3.text = "${data.size} count"

                    activityMadodosoBinding.vwTable.txt3.setOnClickListener { showData() }

                    activityMadodosoBinding.vwTable.recy.layoutManager = LinearLayoutManager(applicationContext)
                    activityMadodosoBinding.vwTable.recy.setHasFixedSize(true)
//                    INCLUDING DELETE BUTTON IN THE VIEW


                    activityMadodosoBinding.vwTable.recy.adapter= DodosoRecyAdapter(this,data)

                    activityMadodosoBinding.vwTable.progress.visibility=View.GONE
                }catch (e:Exception){
                    e.message?.let { Log.d("ZAKA", it) }
                }
            }

        }, 1500)




    }


    override fun onResume() {
        super.onResume()
        showData("all", date)
    }












    private fun loadGeoJson() {
        try {
            if (USoft["geo_boundary"]=="geo_boundary"){
                if (!first_zoom){
                    gmap.moveCamera(CameraUpdateFactory.newLatLngZoom(LatLng(my_loc!!.latitude, my_loc!!.longitude), 20.0f))
                    first_zoom=true
                }
                return
            }

            Gson().fromJson(USoft["geo_boundary"],GeoResponse::class.java)?.features?.forEach {
                fillGeom(it,true)
            }

            Gson().fromJson(USoft["geo_feature"],GeoResponse::class.java)?.features?.forEach {
                fillGeom(it)
            }

            Gson().fromJson(USoft["geo_restricted"],GeoResponse::class.java)?.features?.forEach {
                fillGeom(it)
            }



        }catch (e:Exception){
            Log.d("ZAKA",e.message!!)
        }
        /**/
    }

    private fun fillGeom(it: GeoResponse.Feature,bound:Boolean=false) {
        try {
            val id = it.id
            val properties = it.properties

            val geom = it.geometry
            if(geom.type!!.lowercase().contains("polygon")){
                //geom.coordinates
                val coord = geom.coordinates as List<List<List<Double>>>
                fillPoly(properties,coord,bound)
            }

            if(geom.type!!.lowercase().contains("multipolygon")){
                //geom.coordinates
                val coord = geom.coordinates as List<List<List<List<Double>>>>
                coord.forEach {
                    fillPoly(properties,it,bound)
                }
            }

        }catch (e:Exception){}
    }

    private fun fillPoly(properties: GeoResponse.Properties, coord: List<List<List<Double>>>,bound:Boolean=false) {
        try {


            coord.forEach {geo->

                val lst = arrayListOf<LatLng>()

                geo.forEach { float->
                    val latlong = LatLng(float[1],float[0])
                    lst.add(latlong)
                }

                val color = if (properties.label=="boundary"){"#00ff00"}else{"#ffffff"}

                var p = PolygonOptions().addAll(lst).strokeWidth(8f).strokeColor(
                    Color.parseColor(color))

                if (properties.label=="restricted"){
                    p = PolygonOptions().addAll(lst)
                        .fillColor(Color.RED)
                        .strokeWidth(4f).strokeColor(Color.WHITE)
                        .clickable(true)
                }

                val pl = gmap.addPolygon(p)

                if(properties.label=="boundary"){
                    mapFragment?.requireView()?.post { UgMap.setExtent(gmap,lst) }
                }

                UgMap.addText(this@MadodosoActivity,gmap,
                    UgMap.getCentroid(lst),properties.description,0,18,"#ffffff")


                if(bound){
                    UgMap.setExtent(gmap,lst)
                }

            }
        }catch (e:Exception){}
    }


}