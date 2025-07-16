package go.land.nluis.mvvm.network.response

import com.google.gson.annotations.SerializedName
import com.google.gson.annotations.Expose

/**
 * Created by ugali on 03/11/2022 11:02
 */
class UserConfigResponse {
    @SerializedName("status")
    @Expose
    var status:Int = 0

    @SerializedName("message")
    @Expose
    var message:String = ""

    @SerializedName("user")
    @Expose
    var user: User = User()

    @SerializedName("project")
    @Expose
    var project: Project = Project()

    @SerializedName("questionnaire")
    @Expose
    var questionnaire: List<Questionnaire> = arrayListOf()

    @SerializedName("village")
    @Expose
    var village: List<Village> = arrayListOf()

    @SerializedName("land_use")
    @Expose
    var landUse: List<LandUse> = arrayListOf()

    @SerializedName("occupancy")
    @Expose
    var occupancy: List<Occupancy> = arrayListOf()

    inner class Hamlet {
        @SerializedName("id")
        @Expose
        var id: Int = 0

        @SerializedName("name")
        @Expose
        var name: String = ""

        @SerializedName("count")
        @Expose
        var count:Int = 0
    }

    inner class LandUse {
        @SerializedName("id")
        @Expose
        var id: Int = 0


        @SerializedName("swahili")
        @Expose
        var sw: String = ""

        @SerializedName("name")
        @Expose
        var en: String = ""
    }

    inner class Occupancy {
        @SerializedName("id")
        @Expose
        var id: Int = 0

        @SerializedName("quantity")
        @Expose
        var noOfParty: Int = 0



        @SerializedName("swahili")
        @Expose
        var sw: String = ""

        @SerializedName("name")
        @Expose
        var en: String = ""
    }

    inner class Output {
        @SerializedName("id")
        @Expose
        var id: Int = 0

        @SerializedName("code")
        @Expose
        var code: String = ""

        @SerializedName("name")
        @Expose
        var name: String = ""
    }

    inner class Project {
        @SerializedName("id")
        @Expose
        var id: Int = 0

        @SerializedName("name")
        @Expose
        var name: String = ""

        @SerializedName("output")
        @Expose
        var output: Output = Output()

        @SerializedName("location")
        @Expose
        var location: String = ""
    }

    inner class Question {
        @SerializedName("id")
        @Expose
        var id: Int = 0

        @SerializedName("form_field")
        @Expose
        var question: String = ""

        @SerializedName("data_type")
        @Expose
        var answer: String = ""

        @SerializedName("options")
        @Expose
        var options: String = ""

        @SerializedName("required")
        @Expose
        var required: Boolean = false

        @SerializedName("parent")
        @Expose
        var parentQuestion: Int = 0

        @SerializedName("parent_value")
        @Expose
        var parentValue: String = ""

        @SerializedName("hint")
        @Expose
        var hint: String = ""

        @SerializedName("error_message")
        @Expose
        var errorMessage: String = ""

        @SerializedName("flag")
        @Expose
        var tag: String = ""
    }

    inner class Questionnaire {
        @SerializedName("id")
        @Expose
        var id: Int = 0

        @SerializedName("name")
        @Expose
        var name: String = ""

        @SerializedName("contents")
        @Expose
        var contents: List<Content> = arrayListOf()

        @SerializedName("tag")
        @Expose
        var tag: String = ""

        @SerializedName("category")
        @Expose
        var category: String = ""
    }

    inner class User {
        @SerializedName("id")
        @Expose
        var id: Int = 0

        @SerializedName("name")
        @Expose
        var name: String = ""
    }

    class Village {
        @SerializedName("id")
        @Expose
        var id: Int = 0

        @SerializedName("name")
        @Expose
        var name: String = ""

        @SerializedName("hamlets")
        @Expose
        var hamlets: List<Hamlet> = arrayListOf()
    }

    inner class Content {
        @SerializedName("id")
        @Expose
        var id: Int = 0

        @SerializedName("name")
        @Expose
        var name: String = ""

        @SerializedName("question")
        @Expose
        var question: List<Question> = arrayListOf()
    }
}