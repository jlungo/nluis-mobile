package go.land.nluis.mvvm.sqlite

class Query {
    companion object {

        fun createTbQuestionnaire():String{
            return "create table if not exists tb_answer(" +
                    "id INTEGER PRIMARY KEY AUTOINCREMENT," +
                    "date_ DATETIME DEFAULT (datetime('now','localtime'))," +
                    "uuid varchar(50) not null," +
                    "question_id integer," +
                    "answer text,tag varchar(50),unique(uuid,question_id))"
        }


    }
}