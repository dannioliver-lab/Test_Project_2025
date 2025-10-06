package com.observingapp.data

import androidx.lifecycle.LiveData
import androidx.room.*

@Dao
interface LocationDao {
    
    @Query("SELECT * FROM locations ORDER BY name ASC")
    fun getAllLocations(): LiveData<List<Location>>
    
    @Query("SELECT * FROM locations ORDER BY name ASC")
    suspend fun getAllLocationsSync(): List<Location>
    
    @Query("SELECT * FROM locations WHERE id = :id")
    suspend fun getLocationById(id: String): Location?
    
    @Query("SELECT * FROM locations WHERE name = :name LIMIT 1")
    suspend fun getLocationByName(name: String): Location?
    
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertLocation(location: Location)
    
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertLocations(locations: List<Location>)
    
    @Update
    suspend fun updateLocation(location: Location)
    
    @Delete
    suspend fun deleteLocation(location: Location)
    
    @Query("DELETE FROM locations WHERE id = :id")
    suspend fun deleteLocationById(id: String)
    
    @Query("DELETE FROM locations")
    suspend fun deleteAllLocations()
    
    @Query("SELECT COUNT(*) FROM locations")
    suspend fun getLocationCount(): Int
    
    @Query("SELECT * FROM locations WHERE name LIKE '%' || :searchQuery || '%' OR notes LIKE '%' || :searchQuery || '%' ORDER BY name ASC")
    fun searchLocations(searchQuery: String): LiveData<List<Location>>
}
