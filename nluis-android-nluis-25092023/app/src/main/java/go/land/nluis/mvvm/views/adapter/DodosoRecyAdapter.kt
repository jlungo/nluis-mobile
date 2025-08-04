package go.land.nluis.mvvm.views.adapter

import android.content.Intent
import android.graphics.Color
import android.util.Log
import android.view.LayoutInflater
import androidx.recyclerview.widget.RecyclerView
import go.land.nluis.mvvm.views.adapter.DodosoRecyAdapter.DodosoRecyViewHolder
import android.view.ViewGroup
import androidx.appcompat.app.AppCompatActivity
import go.land.nluis.databinding.VwListBinding
import go.land.nluis.mvvm.model.AnswerModel
import go.land.nluis.mvvm.views.activity.AddDodosoActivity

/**
 * Created by ugali on 05/11/2022 20:39
 */
class DodosoRecyAdapter(
    private val appCompatActivity: AppCompatActivity,
    private val data: ArrayList<AnswerModel>): RecyclerView.Adapter<DodosoRecyViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): DodosoRecyViewHolder {
        return DodosoRecyViewHolder(VwListBinding.inflate(LayoutInflater.from(parent.context),parent,false))
    }

    override fun onBindViewHolder(holder: DodosoRecyViewHolder, position: Int) {
        val current_data = data[position]
        holder.bind(current_data)
        holder.vw.lnRoot.setOnClickListener {
            appCompatActivity.startActivity(Intent(appCompatActivity,AddDodosoActivity::class.java)
                .putExtra("isNewData",false)
                .putExtra("uuid",current_data.answer))
        }


    }

    override fun getItemViewType(position: Int): Int {
        return position
    }

    override fun getItemCount(): Int {
        return data.size
    }

    inner class DodosoRecyViewHolder(itemView: VwListBinding) : RecyclerView.ViewHolder(itemView.root){
        var vw = itemView
        fun bind(answerModel: AnswerModel) {
            try {
                vw.txt1.text="${data.size+1-answerModel.id}."
                vw.txt2.text=answerModel.answer
                vw.txt3.text=answerModel.comment

                if (!answerModel.valid){ vw.lnRoot.setBackgroundColor(Color.parseColor("#ffcccc")) }

            }catch (e:Exception){
                e.message?.let { Log.d("ZAKA", it) }
            }
        }
    }
}