package com.observingapp.data

import androidx.room.Entity
import androidx.room.PrimaryKey
import java.util.*

@Entity(tableName = "locations")
data class Location(
    @PrimaryKey
    val id: String = UUID.randomUUID().toString(),
    val name: String,
    val latitude: Double,
    val longitude: Double,
    val elevation: Double? = null, // in meters
    val timezone: String? = null,
    val notes: String? = null,
    val createdAt: Long = System.currentTimeMillis(),
    val updatedAt: Long = System.currentTimeMillis()
) {
    /**
     * Validates if the coordinates are within valid ranges
     */
    fun isValidCoordinates(): Boolean {
        return latitude in -90.0..90.0 && longitude in -180.0..180.0
    }
    
    /**
     * Returns formatted coordinates as a string
     */
    fun getFormattedCoordinates(format: CoordinateFormat = CoordinateFormat.DECIMAL_DEGREES): String {
        return when (format) {
            CoordinateFormat.DECIMAL_DEGREES -> {
                "${String.format("%.6f", latitude)}°, ${String.format("%.6f", longitude)}°"
            }
            CoordinateFormat.DEGREES_MINUTES_SECONDS -> {
                "${formatToDMS(latitude, true)}, ${formatToDMS(longitude, false)}"
            }
        }
    }
    
    private fun formatToDMS(coordinate: Double, isLatitude: Boolean): String {
        val abs = kotlin.math.abs(coordinate)
        val degrees = abs.toInt()
        val minutes = ((abs - degrees) * 60).toInt()
        val seconds = ((abs - degrees) * 60 - minutes) * 60
        
        val direction = when {
            isLatitude -> if (coordinate >= 0) "N" else "S"
            else -> if (coordinate >= 0) "E" else "W"
        }
        
        return "${degrees}° ${minutes}' ${String.format("%.2f", seconds)}\" $direction"
    }
}

enum class CoordinateFormat {
    DECIMAL_DEGREES,
    DEGREES_MINUTES_SECONDS
}
