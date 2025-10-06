package com.observingapp.viewmodel

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.observingapp.data.Location
import com.observingapp.repository.LocationRepository
import kotlinx.coroutines.launch

class LocationViewModel(private val repository: LocationRepository) : ViewModel() {
    
    private val _isLoading = MutableLiveData<Boolean>()
    val isLoading: LiveData<Boolean> = _isLoading
    
    private val _errorMessage = MutableLiveData<String?>()
    val errorMessage: LiveData<String?> = _errorMessage
    
    private val _operationResult = MutableLiveData<String?>()
    val operationResult: LiveData<String?> = _operationResult
    
    val allLocations: LiveData<List<Location>> = repository.getAllLocations()
    
    /**
     * Get the preferred location
     */
    suspend fun getPreferredLocation(): Location? {
        return repository.getPreferredLocation()
    }
    
    /**
     * Get the preferred location ID
     */
    fun getPreferredLocationId(): String? {
        return repository.getPreferredLocationId()
    }
    
    /**
     * Add a new location
     */
    fun addLocation(location: Location) {
        viewModelScope.launch {
            _isLoading.value = true
            _errorMessage.value = null
            
            repository.insertLocation(location).fold(
                onSuccess = {
                    _operationResult.value = "Location saved successfully"
                },
                onFailure = { exception ->
                    _errorMessage.value = exception.message ?: "Failed to save location"
                }
            )
            
            _isLoading.value = false
        }
    }
    
    /**
     * Update an existing location
     */
    fun updateLocation(location: Location) {
        viewModelScope.launch {
            _isLoading.value = true
            _errorMessage.value = null
            
            repository.updateLocation(location).fold(
                onSuccess = {
                    _operationResult.value = "Location updated successfully"
                },
                onFailure = { exception ->
                    _errorMessage.value = exception.message ?: "Failed to update location"
                }
            )
            
            _isLoading.value = false
        }
    }
    
    /**
     * Delete a location
     */
    fun deleteLocation(location: Location) {
        viewModelScope.launch {
            _isLoading.value = true
            _errorMessage.value = null
            
            repository.deleteLocation(location).fold(
                onSuccess = {
                    _operationResult.value = "Location deleted"
                },
                onFailure = { exception ->
                    _errorMessage.value = exception.message ?: "Failed to delete location"
                }
            )
            
            _isLoading.value = false
        }
    }
    
    /**
     * Set a location as preferred
     */
    fun setPreferredLocation(location: Location) {
        viewModelScope.launch {
            _isLoading.value = true
            _errorMessage.value = null
            
            repository.setPreferredLocation(location).fold(
                onSuccess = {
                    _operationResult.value = "Preferred location updated"
                },
                onFailure = { exception ->
                    _errorMessage.value = exception.message ?: "Failed to set preferred location"
                }
            )
            
            _isLoading.value = false
        }
    }
    
    /**
     * Clear the preferred location
     */
    fun clearPreferredLocation() {
        repository.clearPreferredLocation()
        _operationResult.value = "Preferred location cleared"
    }
    
    /**
     * Search locations
     */
    fun searchLocations(query: String): LiveData<List<Location>> {
        return repository.searchLocations(query)
    }
    
    /**
     * Get location by ID
     */
    suspend fun getLocationById(id: String): Location? {
        return repository.getLocationById(id)
    }
    
    /**
     * Clear error message
     */
    fun clearErrorMessage() {
        _errorMessage.value = null
    }
    
    /**
     * Clear operation result message
     */
    fun clearOperationResult() {
        _operationResult.value = null
    }
    
    /**
     * Import locations from a list
     */
    fun importLocations(locations: List<Location>) {
        viewModelScope.launch {
            _isLoading.value = true
            _errorMessage.value = null
            
            repository.importLocations(locations).fold(
                onSuccess = { count ->
                    _operationResult.value = "Imported $count locations successfully"
                },
                onFailure = { exception ->
                    _errorMessage.value = exception.message ?: "Failed to import locations"
                }
            )
            
            _isLoading.value = false
        }
    }
}
