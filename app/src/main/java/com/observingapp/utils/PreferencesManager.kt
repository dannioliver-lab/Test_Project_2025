package com.observingapp.utils

import android.content.Context
import android.content.SharedPreferences
import com.observingapp.data.CoordinateFormat

class PreferencesManager(context: Context) {
    
    private val sharedPreferences: SharedPreferences = context.getSharedPreferences(
        PREFS_NAME, Context.MODE_PRIVATE
    )
    
    companion object {
        private const val PREFS_NAME = "observing_app_prefs"
        private const val KEY_PREFERRED_LOCATION_ID = "preferred_location_id"
        private const val KEY_COORDINATE_FORMAT = "coordinate_format"
        private const val KEY_FIRST_LAUNCH = "first_launch"
        private const val KEY_LOCATION_PERMISSION_REQUESTED = "location_permission_requested"
    }
    
    /**
     * Get the preferred location ID
     */
    fun getPreferredLocationId(): String? {
        return sharedPreferences.getString(KEY_PREFERRED_LOCATION_ID, null)
    }
    
    /**
     * Set the preferred location ID
     */
    fun setPreferredLocationId(locationId: String?) {
        sharedPreferences.edit()
            .putString(KEY_PREFERRED_LOCATION_ID, locationId)
            .apply()
    }
    
    /**
     * Get the coordinate display format preference
     */
    fun getCoordinateFormat(): CoordinateFormat {
        val formatName = sharedPreferences.getString(KEY_COORDINATE_FORMAT, CoordinateFormat.DECIMAL_DEGREES.name)
        return try {
            CoordinateFormat.valueOf(formatName ?: CoordinateFormat.DECIMAL_DEGREES.name)
        } catch (e: IllegalArgumentException) {
            CoordinateFormat.DECIMAL_DEGREES
        }
    }
    
    /**
     * Set the coordinate display format preference
     */
    fun setCoordinateFormat(format: CoordinateFormat) {
        sharedPreferences.edit()
            .putString(KEY_COORDINATE_FORMAT, format.name)
            .apply()
    }
    
    /**
     * Check if this is the first app launch
     */
    fun isFirstLaunch(): Boolean {
        return sharedPreferences.getBoolean(KEY_FIRST_LAUNCH, true)
    }
    
    /**
     * Mark that the app has been launched before
     */
    fun setFirstLaunchCompleted() {
        sharedPreferences.edit()
            .putBoolean(KEY_FIRST_LAUNCH, false)
            .apply()
    }
    
    /**
     * Check if location permission has been requested before
     */
    fun hasLocationPermissionBeenRequested(): Boolean {
        return sharedPreferences.getBoolean(KEY_LOCATION_PERMISSION_REQUESTED, false)
    }
    
    /**
     * Mark that location permission has been requested
     */
    fun setLocationPermissionRequested() {
        sharedPreferences.edit()
            .putBoolean(KEY_LOCATION_PERMISSION_REQUESTED, true)
            .apply()
    }
    
    /**
     * Clear all preferences (useful for testing or reset functionality)
     */
    fun clearAll() {
        sharedPreferences.edit().clear().apply()
    }
}
