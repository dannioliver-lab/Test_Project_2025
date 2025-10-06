package com.observingapp.repository

import androidx.lifecycle.LiveData
import com.observingapp.data.Location
import com.observingapp.data.LocationDao
import com.observingapp.utils.PreferencesManager
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

class LocationRepository(
    private val locationDao: LocationDao,
    private val preferencesManager: PreferencesManager
) {
    
    /**
     * Get all locations as LiveData
     */
    fun getAllLocations(): LiveData<List<Location>> {
        return locationDao.getAllLocations()
    }
    
    /**
     * Get all locations synchronously
     */
    suspend fun getAllLocationsSync(): List<Location> {
        return withContext(Dispatchers.IO) {
            locationDao.getAllLocationsSync()
        }
    }
    
    /**
     * Get a location by ID
     */
    suspend fun getLocationById(id: String): Location? {
        return withContext(Dispatchers.IO) {
            locationDao.getLocationById(id)
        }
    }
    
    /**
     * Get the preferred location
     */
    suspend fun getPreferredLocation(): Location? {
        return withContext(Dispatchers.IO) {
            val preferredId = preferencesManager.getPreferredLocationId()
            preferredId?.let { locationDao.getLocationById(it) }
        }
    }
    
    /**
     * Insert a new location
     */
    suspend fun insertLocation(location: Location): Result<Unit> {
        return withContext(Dispatchers.IO) {
            try {
                // Validate coordinates
                if (!location.isValidCoordinates()) {
                    return@withContext Result.failure(IllegalArgumentException("Invalid coordinates"))
                }
                
                // Check for duplicate names
                val existingLocation = locationDao.getLocationByName(location.name)
                if (existingLocation != null && existingLocation.id != location.id) {
                    return@withContext Result.failure(IllegalArgumentException("Location with this name already exists"))
                }
                
                locationDao.insertLocation(location)
                Result.success(Unit)
            } catch (e: Exception) {
                Result.failure(e)
            }
        }
    }
    
    /**
     * Update an existing location
     */
    suspend fun updateLocation(location: Location): Result<Unit> {
        return withContext(Dispatchers.IO) {
            try {
                // Validate coordinates
                if (!location.isValidCoordinates()) {
                    return@withContext Result.failure(IllegalArgumentException("Invalid coordinates"))
                }
                
                val updatedLocation = location.copy(updatedAt = System.currentTimeMillis())
                locationDao.updateLocation(updatedLocation)
                Result.success(Unit)
            } catch (e: Exception) {
                Result.failure(e)
            }
        }
    }
    
    /**
     * Delete a location
     */
    suspend fun deleteLocation(location: Location): Result<Unit> {
        return withContext(Dispatchers.IO) {
            try {
                // If this is the preferred location, clear the preference
                if (preferencesManager.getPreferredLocationId() == location.id) {
                    preferencesManager.setPreferredLocationId(null)
                }
                
                locationDao.deleteLocation(location)
                Result.success(Unit)
            } catch (e: Exception) {
                Result.failure(e)
            }
        }
    }
    
    /**
     * Set a location as preferred
     */
    suspend fun setPreferredLocation(location: Location): Result<Unit> {
        return withContext(Dispatchers.IO) {
            try {
                preferencesManager.setPreferredLocationId(location.id)
                Result.success(Unit)
            } catch (e: Exception) {
                Result.failure(e)
            }
        }
    }
    
    /**
     * Clear the preferred location
     */
    fun clearPreferredLocation() {
        preferencesManager.setPreferredLocationId(null)
    }
    
    /**
     * Get the preferred location ID
     */
    fun getPreferredLocationId(): String? {
        return preferencesManager.getPreferredLocationId()
    }
    
    /**
     * Search locations
     */
    fun searchLocations(query: String): LiveData<List<Location>> {
        return locationDao.searchLocations(query)
    }
    
    /**
     * Get location count
     */
    suspend fun getLocationCount(): Int {
        return withContext(Dispatchers.IO) {
            locationDao.getLocationCount()
        }
    }
    
    /**
     * Import locations from a list (useful for data backup/restore)
     */
    suspend fun importLocations(locations: List<Location>): Result<Int> {
        return withContext(Dispatchers.IO) {
            try {
                var importedCount = 0
                locations.forEach { location ->
                    if (location.isValidCoordinates()) {
                        locationDao.insertLocation(location)
                        importedCount++
                    }
                }
                Result.success(importedCount)
            } catch (e: Exception) {
                Result.failure(e)
            }
        }
    }
}
