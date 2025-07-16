package go.land.nluis.mvvm.network.geo_reponse;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

/**
 * Created by ugali on 12/11/2022 20:18
 */
public class GeoResponse {

    @SerializedName("type")
    @Expose
    public String type;
    @SerializedName("features")
    @Expose
    public List<Feature> features = null;
    @SerializedName("totalFeatures")
    @Expose
    public Integer totalFeatures;
    @SerializedName("numberMatched")
    @Expose
    public Integer numberMatched;
    @SerializedName("numberReturned")
    @Expose
    public Integer numberReturned;
    @SerializedName("timeStamp")
    @Expose
    public String timeStamp;
    @SerializedName("crs")
    @Expose
    public Crs crs;



    public class Crs {

        @SerializedName("type")
        @Expose
        public String type;
        @SerializedName("properties")
        @Expose
        public Properties__1 properties;

    }

    public class Feature {

        @SerializedName("type")
        @Expose
        public String type;
        @SerializedName("id")
        @Expose
        public String id;
        @SerializedName("geometry")
        @Expose
        public Geometry geometry;
        @SerializedName("geometry_name")
        @Expose
        public String geometryName;
        @SerializedName("properties")
        @Expose
        public Properties properties;

    }

    public class Geometry {

        @SerializedName("type")
        @Expose
        public String type;


        @SerializedName("coordinates")
        @Expose
        public Object coordinates = null;

    }


    public class Properties {

        @SerializedName("created_date")
        @Expose
        public String createdDate;
        @SerializedName("created_time")
        @Expose
        public String createdTime;
        @SerializedName("deleted")
        @Expose
        public Boolean deleted;
        @SerializedName("layer")
        @Expose
        public String layer;
        @SerializedName("label")
        @Expose
        public String label;
        @SerializedName("description")
        @Expose
        public String description;
        @SerializedName("srid")
        @Expose
        public Integer srid;
        @SerializedName("created_by_id")
        @Expose
        public Integer createdById;
        @SerializedName("project_id")
        @Expose
        public Integer projectId;
        @SerializedName("updated_by_id")
        @Expose
        public Integer updatedById;
        @SerializedName("village_id")
        @Expose
        public Integer villageId;

    }


    public class Properties__1 {

        @SerializedName("name")
        @Expose
        public String name;

    }

}
