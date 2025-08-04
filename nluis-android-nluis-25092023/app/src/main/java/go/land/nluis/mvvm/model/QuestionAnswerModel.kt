package go.land.nluis.mvvm.model

import go.land.nluis.mvvm.network.response.UserConfigResponse.Question

/**
 * Created by ugali on 05/11/2022 19:50
 */
data class QuestionAnswerModel(var qn:Question, var answer:String)