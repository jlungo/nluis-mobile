package go.land.nluis.mvvm.views.activity

import android.annotation.SuppressLint
import android.content.Intent
import android.graphics.Color
import android.location.Criteria
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.Bundle
import android.util.Log
import android.view.View
import android.view.WindowManager
import android.view.animation.AnimationUtils
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.databinding.DataBindingUtil
import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.OnMapReadyCallback
import com.google.android.gms.maps.SupportMapFragment
import com.google.android.gms.maps.model.*
import com.google.gson.Gson
import go.land.nluis.R
import go.land.nluis.databinding.ActivityMapBinding
import go.land.nluis.mvvm.network.geo_reponse.GeoResponse
import go.land.nluis.mvvm.sqlite.Db
import go.land.nluis.utils.USoft
import go.land.nluis.utils.UgMap
import java.util.*


class MapActivity : AppCompatActivity() , OnMapReadyCallback, LocationListener {


    private lateinit var activityMapBinding: ActivityMapBinding
    private var geom=""
    private var new_ramani = true
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        window.setFlags(WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE)
        window.addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN or WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        activityMapBinding = DataBindingUtil.setContentView(this,R.layout.activity_map)
        init()

    }

    private lateinit var lst_all_poly:ArrayList<LatLng>
    override fun onMapReady(p0: GoogleMap) {
        mapReady(p0)
    }


    @SuppressLint("MissingPermission")
    private fun mapReady(p0: GoogleMap) {
        p0.clear()
        activityMapBinding.btnDoneEdit.visibility=View.GONE
        try {
            p0.isMyLocationEnabled = true
            my_loc = p0.myLocation
            gmap = p0
            gmap.mapType = GoogleMap.MAP_TYPE_HYBRID


            UgMap.updateMyLocation(this, gmap)

            activityMapBinding.btnBaadae.setOnClickListener {
                if (new_ramani){
                    try {
                        chukuaNilipo()
                        chukuaNilipo()

                        val poly = UgMap.set_poly(current_poly!!.points)

                        lst_cr_mk?.forEach { it.remove() }
                        last_cr_mk?.forEach { it.remove() }
                        lst_cr_mk = arrayListOf()
                        last_cr_mk = arrayListOf()

                        val polyg = UgMap.set_poly(current_poly!!.points)


                        if(Db(this).saveQuestionnaires(uuid,qn_id,polyg)){
                            Toast.makeText(this,"Saved",Toast.LENGTH_LONG).show()
                            finish()
                        }
                    }catch (e:Exception){

                    }
                }else{

                }
            }

            try {
                db.listGeom().forEach {ans->
                    val list = UgMap.get_poly(ans.answer)
                    val p = PolygonOptions().addAll(list).strokeWidth( if (ans.uuid==uuid){8f}else{4f}).strokeColor(Color.parseColor(
                        if (ans.uuid==uuid){"#ffff00"}else{"#efefef"}))
                        .clickable(true)
                    val pl = gmap.addPolygon(p)
                    pl.tag = ans.id

                    UgMap.addText(this,gmap,UgMap.getCentroid(p.points as ArrayList<LatLng>),ans.uuid)

                    if (ans.uuid==uuid){

                        new_ramani=false
                        list.forEach {
                            val mk = gmap.addMarker(MarkerOptions()
                                .draggable(true)
                                .icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_YELLOW))
                                .position(it))
                            lst_cr_mk!!.add(mk!!)

                        }

                        mapFragment?.requireView()?.post {
                            UgMap.setExtent(gmap,list)
                        }

                    }

                }
            }catch (e:Exception){}


            activityMapBinding.mnChukua.visibility = View.VISIBLE
            activityMapBinding.mnEdit.root.visibility = View.GONE
            activityMapBinding.lnNilipoBaadae.visibility = View.GONE
            activityMapBinding.mnChukua.startAnimation(AnimationUtils.loadAnimation(this,R.anim.anim_grow))

            configMap()
            showSurveys()
        }catch (e:Exception){
            Log.d("ZAKA - onMapReady",e.message.toString())
        }



        if (new_ramani==false){
            activityMapBinding.btnChora.text="Futa Umbo"
            activityMapBinding.btnChukua.text="Endelea Nilipoishia"

            activityMapBinding.btnChora.setOnClickListener {
                AlertDialog.Builder(this)
                    .setTitle("Futa "+uuid)
                    .setMessage("Umbo hili litafutika, Je unauhakika?")
                    .setPositiveButton("Futa") { d, _->
                        run {
                            d.dismiss()
                            db.execSQL("delete from tb_answer where uuid='${uuid}' and question_id=$qn_id")
                            finish()
                        }
                    }
                    .setNegativeButton("Hapana") { d, _->
                        run {
                            d.dismiss()
                        }
                    }.show()
            }


            activityMapBinding.btnChukua.setOnClickListener {
                startActivity(Intent(this,MapUtambuziActivity::class.java)
                    .putExtra("uuid",uuid)
                    .putExtra("qn_id",qn_id)
                )
                finish()
            }

        }
    }

    private var first_zoom = false


    private fun showSurveys(isChecked: Boolean = true) {
        try {

            if (USoft["geo_boundary"]=="geo_boundary"){
                if (!first_zoom){
                    gmap.moveCamera(CameraUpdateFactory.newLatLngZoom(LatLng(my_loc!!.latitude, my_loc!!.longitude), 20.0f))
                    first_zoom=true
                }
                return
            }
            loadGeoJson()
        }catch (e:Exception){
            Log.d("ZAKA",e.message!!)
        }

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
                fillGeom(it)
                Log.d("ZAKA",it.type)
            }

            Gson().fromJson(USoft["geo_feature"],GeoResponse::class.java)?.features?.forEach {
                fillGeom(it)
                Log.d("ZAKA",it.type)
            }

            Gson().fromJson(USoft["geo_restricted"],GeoResponse::class.java)?.features?.forEach {
                fillGeom(it)
                Log.d("ZAKA",it.type)
            }

        }catch (e:Exception){
            Log.d("ZAKA",e.message!!)
        }
        /**/
    }

    private fun fillGeom(it: GeoResponse.Feature) {
        try {
            val id = it.id
            val properties = it.properties

            val geom = it.geometry
            if(geom.type!!.lowercase().contains("polygon")){
                //geom.coordinates
                val coord = geom.coordinates as List<List<List<Double>>>
                fillPoly(properties,coord)
            }

            if(geom.type!!.lowercase().contains("multipolygon")){
                //geom.coordinates
                val coord = geom.coordinates as List<List<List<List<Double>>>>
                coord.forEach {
                    fillPoly(properties,it)
                }
            }

        }catch (e:Exception){}
    }

    private fun fillPoly(properties: GeoResponse.Properties, coord: List<List<List<Double>>>) {
        try {


            coord.forEach {geo->

                val lst = arrayListOf<LatLng>()

                geo.forEach { float->
                    val latlong = LatLng(float[1],float[0])
                    lst.add(latlong)
                }

                val color = if (properties.layer=="boundary"){"#00ff00"}else{"#ffffff"}

                var p = PolygonOptions().addAll(lst).strokeWidth(8f).strokeColor(
                    Color.parseColor(color))

                if (properties.layer=="restricted"){
                    p = PolygonOptions().addAll(lst)
                        .fillColor(Color.RED)
                        .strokeWidth(4f).strokeColor(Color.WHITE)
                        .clickable(true)
                }

                val pl = gmap.addPolygon(p)


                /*if(properties.layer=="boundary"){
                    mapFragment?.requireView()?.post { UgMap.setExtent(gmap,lst) }
                }*/

                UgMap.addText(this,gmap,
                    UgMap.getCentroid(lst),properties.label,0,18,"#ffffff")


            }
        }catch (e:Exception){}
    }





    private var current_poly:Polygon? = null
    private var pre_poly:Polygon? = null
    private var current_poly_id = ""
    private var lst_cr_mk:ArrayList<Marker>? = null
    private var last_cr_mk:ArrayList<Marker>? = null
    private var bound = 0
    private var aim = ""


    override fun onBackPressed() {
        try {
            if (lst_cr_mk!!.size > 0){
                malizaEdit()
                return
            }
        }catch (_:Exception){}

        super.onBackPressed()
    }


    fun malizaEdit(){

        if (edit_poly){
            try {
                val poly = UgMap.set_poly(current_poly!!.points)
                if (poly.split(",").size<4){
                    Toast.makeText(this,"Invalid Polygon",Toast.LENGTH_LONG).show()
                    return
                }
                /*Db(this).update("tb_parcel",current_poly_id.toInt(),
                    "polygon", poly)*/
                lst_cr_mk?.forEach { it.remove() }
                lst_cr_mk?.clear()
                current_poly = null
                edit_poly = false
                tambua = false

            }catch (e:Exception){
                e.message?.let { it1 -> Log.d("ZAKA - malizaEdit", it1) }
            }
        }
    }
    private fun configMap() {
        lst_cr_mk = arrayListOf()
        last_cr_mk = arrayListOf()

        lst_cr_mk!!.forEach { it.remove() }
        gmap.setOnMapClickListener {

            if (tambua) {
                pimaAt(it)
            }

            //malizaEdit()
        }

        gmap.setOnMarkerDragListener(object :GoogleMap.OnMarkerDragListener{
            override fun onMarkerDragEnd(p0: Marker) {
                try {
                    Log.d("ZAKA","onMarkerDragEnd...${current_poly_id}")
                    val lst = arrayListOf<LatLng>()
                    lst_cr_mk!!.forEach { lst.add(it.position) }
                    current_poly?.remove()


                    current_poly = gmap.addPolygon(PolygonOptions()
                        .strokeWidth(4f)
                        .clickable(true)
                        .strokeColor(Color.YELLOW)
                        .addAll(lst))

                    current_poly!!.tag = current_poly_id


                    pre_poly!!.remove()
                    val poly = UgMap.set_poly(current_poly!!.points)

                    if (poly.split(",").size<4){
                        return
                    }
                    db.execSQL("update tb_answer set answer='$poly' where id=$current_poly_id")

                }catch (e:Exception){
                    e.message?.let { Log.d("ZAKA - err onMarkerEdn", it) }
                }
            }

            override fun onMarkerDragStart(p0: Marker) {
                Log.d("ZAKA","Starting...")
            }

            override fun onMarkerDrag(p0: Marker) {
                try {
                    Log.d("ZAKA","onMarkerDrag...")
                    val lst = arrayListOf<LatLng>()
                    lst_cr_mk!!.forEach { lst.add(it.position) }
                    current_poly?.remove()


                    current_poly = gmap.addPolygon(PolygonOptions()
                        .strokeWidth(4f)
                        .strokeColor(Color.YELLOW)
                        .addAll(lst))

                }catch (e:Exception){
                    e.message?.let { Log.d("ZAKA", it) }
                }
            }
        })

        gmap.setOnPolygonClickListener {

            try {
                if (!tambua){
                    pre_poly = it

                    try {
                        lst_cr_mk?.forEach { it.remove() }
                        lst_cr_mk?.clear()
                        current_poly = null
                    }catch (e:Exception){}

                    current_poly_id = it.tag!!.toString()
                    edit_poly = true
                    lst_cr_mk = arrayListOf()
                    current_poly = it
                    it.points.forEach {lat->
                        val mk = gmap.addMarker(MarkerOptions()
                            .draggable(true)
                            .icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_YELLOW))
                            .position(lat))
                        lst_cr_mk!!.add(mk!!)
                    }

                    activityMapBinding.btnDoneEdit.visibility=View.VISIBLE
                    activityMapBinding.btnDoneEdit.setOnClickListener { mapReady(gmap) }
                }
            }catch (e:Exception){
                e.message?.let { it1 -> Log.d("ZAKA - OnPolygonClick", it1) }
            }
            Log.d("ZAKA","Tag ${it.tag}")
            //it.remove()
        }
    }

    private fun pimaAt(it: LatLng) {
        current_poly?.remove()
        val mk = gmap.addMarker(MarkerOptions()
            .draggable(true)
            .icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_YELLOW))
            .position(it))
        lst_cr_mk!!.add(mk!!)
        val lst = arrayListOf<LatLng>()
        lst_cr_mk!!.forEach { lst.add(it.position) }
        current_poly = gmap.addPolygon(PolygonOptions()
            .strokeWidth(4f)
            .strokeColor(Color.YELLOW)
            .addAll(lst))
    }

    private var mapFragment: SupportMapFragment? = null
    private lateinit var gmap: GoogleMap
    private var tambua = false
    private var edit_poly = false
    private var uuid = ""
    private var qn_id=0

    private lateinit var db:Db


    override fun onResume() {
        super.onResume()
        init()

        Log.d("ZAKA","Resuming...")
    }

    @SuppressLint("MissingPermission")
    private fun init() {
        uuid = intent.extras?.getString("uuid")!!
        qn_id = intent.extras?.getInt("qn_id")!!
        geom = intent.extras?.getString("geom")!!
        new_ramani = intent.extras?.getBoolean("new_ramani")!!

        db = Db(this)

        try {

            mapFragment = supportFragmentManager.findFragmentById(R.id.map) as SupportMapFragment
            mapFragment!!.getMapAsync(this)

            setSupportActionBar(activityMapBinding.tb)
            supportActionBar?.title = uuid

            activityMapBinding.btnChora.setOnClickListener {
                Toast.makeText(this,"Uchaguzi Huu Umezuiliwa Kwa sasa",Toast.LENGTH_LONG).show()
                //tambuaKipande(true)
            }

            activityMapBinding.btnChukua.setOnClickListener { nasaUmboKwaGPS() }



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


            /*activityMapBinding.chkBound.setOnCheckedChangeListener { _, isChecked -> showBoundary(isChecked) }
            activityMapBinding.chkSurveys.setOnCheckedChangeListener { _, isChecked -> showSurveys(isChecked) }
            activityMapBinding.chkParcel.setOnCheckedChangeListener { _, isChecked -> showCurrentData(isChecked) }
            activityMapBinding.chkClaimed.setOnCheckedChangeListener { _, isChecked -> showClaimed(isChecked) }*/

        }catch (e:Exception){
            e.message?.let { Log.d("ZAKA Accuracy2", it) }
        }
    }

    private fun nasaUmboKwaGPS() {
        tambuaKipande(false)
        activityMapBinding.lnNilipoBaadae.visibility = View.VISIBLE
        activityMapBinding.lnNilipoBaadae.startAnimation(AnimationUtils.loadAnimation(this,R.anim.anim_grow))
        activityMapBinding.btnNilipo.setOnClickListener {
            chukuaNilipo()
        }
    }

    private fun chukuaNilipo(){
        try {
            USoft.turnOnLocation(this)

            if (gmap!=null){
                if (my_loc!=null){
                    if (my_loc?.accuracy!!<500){
                        pimaAt(LatLng(my_loc!!.latitude,my_loc!!.longitude))
                    }else{
                        Toast.makeText(this,"Accuracy = "+my_loc?.accuracy+" ni Kubwa kwa 5",Toast.LENGTH_LONG).show()
                    }
                }else{
                    Toast.makeText(this,"Mfumo unatafuta Ulipo...",Toast.LENGTH_LONG).show()
                }
            }else{
                Toast.makeText(this,"Ramani inaendelea Kukaa sawa..",Toast.LENGTH_LONG).show()
            }
        }catch (e:Exception){
            e.message?.let { it1 -> Log.d("ZAKA", it1) }
            Toast.makeText(this@MapActivity,e.message,Toast.LENGTH_LONG).show()
        }
    }

    fun tambuaKipande(chora:Boolean){

        activityMapBinding.mnChukua.visibility = View.GONE
        activityMapBinding.mnEdit.root.visibility = View.VISIBLE

        activityMapBinding.mnEdit.root.startAnimation(AnimationUtils.loadAnimation(this,R.anim.anim_grow))

        try {
            if (gmap!=null){
                if (my_loc!=null){
                    gmap.moveCamera(CameraUpdateFactory.newLatLngZoom(LatLng(my_loc!!.latitude, my_loc!!.longitude), 20.0f))
                }
                tambua = chora
            }else{ Toast.makeText(this,"Ramani Haijatambuliwa",Toast.LENGTH_LONG).show() }
        }catch (e:Exception){
            Toast.makeText(this,"Ramani Haijatambuliwa - "+e.message,Toast.LENGTH_LONG).show()
        }

    }

    fun redo(v:View){
        if (last_cr_mk!!.size>0){
            current_poly?.remove()
            val last_mk = last_cr_mk!![last_cr_mk!!.size-1]

            val mk = gmap.addMarker(MarkerOptions()
                .draggable(true)
                .icon(BitmapDescriptorFactory.defaultMarker(BitmapDescriptorFactory.HUE_YELLOW))
                .position(last_mk.position))

            lst_cr_mk?.add(mk!!)
            last_cr_mk!!.remove(last_mk)
            last_mk.remove()

            val lst = arrayListOf<LatLng>()
            lst_cr_mk!!.forEach { lst.add(it.position) }
            current_poly = gmap.addPolygon(PolygonOptions()
                .strokeWidth(4f)
                .strokeColor(Color.YELLOW)
                .addAll(lst))
        }
    }

    fun undo(v:View){
        try {
            val mk = lst_cr_mk
            if (mk!!.size>0){
                current_poly?.remove()
                val last_mk = mk[mk.size-1]
                last_cr_mk?.add(last_mk)
                last_mk.remove()
                lst_cr_mk?.remove(last_mk)
                lst_cr_mk = mk
                val lst = arrayListOf<LatLng>()
                lst_cr_mk!!.forEach { lst.add(it.position) }
                current_poly = gmap.addPolygon(PolygonOptions()
                    .strokeWidth(4f)
                    .strokeColor(Color.YELLOW)
                    .addAll(lst))
            }
        }catch (e:Exception){
            e.message?.let { Log.d("ZAKA", it) }
        }
    }


//    ADDED BY GEERALD FOR POLYGON AREA SIZE CALCULATIONS
    private fun calculatePolygonArea(polygon: List<LatLng>): Double {
        var area = 0.0
        if (polygon.size < 3) return 0.0 //Not a polygon

        for (i in polygon.indices) {
            val p1 = polygon[i]
            val p2 = polygon[(i + 1) % polygon.size]
            area += Math.toRadians(p2.longitude - p1.longitude) * (2 + Math.sin(Math.toRadians(p1.latitude)) + Math.sin(Math.toRadians(p2.latitude)))
        }

        area = area * 6378137.0 * 6378137.0 / 2.0 //Radius of Earth in meters
        return Math.abs(area) // Area in square meters

    }


//    FOR TOAST BG COLOR
private fun showToast(message: String) {
    val toast = Toast.makeText(this, message, Toast.LENGTH_LONG)

    // Create a custom TextView
    val textView = TextView(this)
    textView.text = message
    textView.setTextColor(Color.WHITE) // Set the text color to white for better contrast
    textView.setBackgroundColor(Color.RED) // Set the background color to red
    textView.setPadding(20, 10, 20, 10) // Add some padding for better appearance
    textView.textSize = 16f // Set the text size

    // Set the custom TextView as the Toast view
    toast.view = textView

    toast.show()
}



    fun done(v:View){
        try {
            val poly = UgMap.set_poly(current_poly!!.points)

            if (poly.split(",").size<4){
                Toast.makeText(this,"Invalid Polygon",Toast.LENGTH_LONG).show()
                return
            }

            lst_cr_mk?.forEach { it.remove() }
            last_cr_mk?.forEach { it.remove() }
            lst_cr_mk = arrayListOf()
            last_cr_mk = arrayListOf()
//            setting the polygon using the  current_poly points again
            val polyg = UgMap.set_poly(current_poly!!.points)
//            calculate the area of the polygon in square meters
            val areaSqMeters = calculatePolygonArea(current_poly!!.points)
//            converts the area to acres (1 acre = 4046.86 sq meters)
            val areaAcres = areaSqMeters / 4046.86

//            check if the plot is grater than 50 acres
            if (areaAcres > 50) {
//                Toast.makeText(this, "Plot is too large (>50 acres)", Toast.LENGTH_LONG).show()
                showToast("Eneo ni kubwa kuzidi Ekari 50!")
                return
            }
//            Display area in acres
            Toast.makeText(this, "Ukubwa wa eneo ni Ekari %.2f".format(areaAcres), Toast.LENGTH_LONG).show()


            if(Db(this).saveQuestionnaires(uuid,qn_id,polyg)){
                Toast.makeText(this,"Saved",Toast.LENGTH_LONG).show()
                finish()
            }

            tambua = false
        }catch (e:Exception){
//            Toast.makeText(this,"Umbo Halijakamilika",Toast.LENGTH_LONG).show()
            showToast("Umbo halijakamilika, tafadhali rudia upimaji")
        }
    }

    fun futa(v:View){
        lst_cr_mk?.forEach { it.remove() }
        last_cr_mk?.forEach { it.remove() }
        lst_cr_mk = arrayListOf()
        last_cr_mk = arrayListOf()

        current_poly?.remove()
        current_poly = null
        tambua = false
    }

    fun info(v:View){
        futa(v)
        activityMapBinding.mnEdit.root.visibility = View.GONE
        activityMapBinding.mnChukua.visibility = View.GONE
        activityMapBinding.lnNilipoBaadae.visibility = View.GONE
    }


    private var my_loc:Location? = null
    override fun onLocationChanged(location: Location) {
        try {
            val latitude = location.latitude
            val longitude = location.longitude
            my_loc = location
            supportActionBar?.subtitle = "Accuracy = ${location.accuracy}"
        } catch (e: Exception) {
            e.message?.let { Log.d("ZAKA onLocationChanged", it) }
        }
    }


    private lateinit var lst_claimed_poly:ArrayList<Polygon>
    private lateinit var lst_claimed_marker:ArrayList<Marker>
    fun showClaimed(isChecked: Boolean) {
        try {
            //activityMapBinding.prog.visibility = View.VISIBLE

            if (isChecked){

                Toast.makeText(this,"Tafadhali Subiri...",Toast.LENGTH_LONG).show()

                /*val lst = Gson().fromJson(USoft["claimedStreet"],MdStreets.Street::class.java)
                lst_claimed_poly = arrayListOf()
                lst_claimed_marker = arrayListOf()

                lst.claimed?.forEach {

                    Handler(Looper.getMainLooper()).postDelayed({
                        runOnUiThread {
                            try {
                                val lst_poy3 = arrayListOf<LatLng>()
                                it.poly!![0].forEach {pp-> lst_poy3.add(LatLng(pp[0],pp[1])) }

                                val p =gmap.addPolygon(PolygonOptions()
                                    .strokeColor(Color.parseColor("#ffffff"))
                                    .addAll(lst_poy3)
                                    .fillColor(Color.parseColor("#ff0000"))
                                    .strokeWidth(2f))

                                //p.fillColor = Color.parseColor("#ff0000")
                                //val mk = UgMap.addText(this,gmap,UgMap.getCentroid(p!!.points as ArrayList<LatLng>),it.claimNo,0,14,"#cccccc")

                                lst_claimed_poly.add(p)
                                lst_all_poly.addAll(p.points)
                                //lst_claimed_marker.add(mk!!)

                            }catch (e:Exception){
                                e.message?.let { it1 -> Log.d("ZAKA claimed", it1) }
                            }
                        }
                    }, 100)
                }*/



            }else{
                lst_claimed_poly.forEach { it.remove() }
                lst_claimed_marker.forEach { it.remove() }
            }

        }catch (e:Exception){
            e.message?.let { Log.d("ZAKA claimed2", it) }
        }
    }

    override fun onStatusChanged(provider: String, status: Int, extras: Bundle) {}
    override fun onProviderEnabled(provider: String) {}
    override fun onProviderDisabled(provider: String) {}



}

