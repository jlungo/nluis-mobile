package go.land.nluis.mvvm.interfaces

/**
 * Created by ugali on 24/03/2023 09:55
 */
interface FileBackup {
    fun onBackupFinish(success:Boolean, backupPath: String)
}