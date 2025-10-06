package com.observingapp.data

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import androidx.room.migration.Migration
import androidx.sqlite.db.SupportSQLiteDatabase

@Database(
    entities = [Location::class],
    version = 1,
    exportSchema = false
)
abstract class LocationDatabase : RoomDatabase() {
    
    abstract fun locationDao(): LocationDao
    
    companion object {
        @Volatile
        private var INSTANCE: LocationDatabase? = null
        
        fun getDatabase(context: Context): LocationDatabase {
            return INSTANCE ?: synchronized(this) {
                val instance = Room.databaseBuilder(
                    context.applicationContext,
                    LocationDatabase::class.java,
                    "location_database"
                )
                .addCallback(DatabaseCallback())
                .build()
                INSTANCE = instance
                instance
            }
        }
        
        private class DatabaseCallback : RoomDatabase.Callback() {
            override fun onCreate(db: SupportSQLiteDatabase) {
                super.onCreate(db)
                // Pre-populate database with sample locations if needed
                // This can be done in a background thread
            }
        }
    }
}
