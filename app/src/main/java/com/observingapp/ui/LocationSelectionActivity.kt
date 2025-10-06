package com.observingapp.ui

import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import com.google.android.material.snackbar.Snackbar
import com.observingapp.R
import com.observingapp.data.Location
import com.observingapp.data.LocationDatabase
import com.observingapp.databinding.ActivityLocationSelectionBinding
import com.observingapp.repository.LocationRepository
import com.observingapp.utils.PreferencesManager
import com.observingapp.viewmodel.LocationViewModel
import com.observingapp.viewmodel.LocationViewModelFactory

class LocationSelectionActivity : AppCompatActivity() {
    
    private lateinit var binding: ActivityLocationSelectionBinding
    private lateinit var locationViewModel: LocationViewModel
    private lateinit var locationAdapter: LocationAdapter
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityLocationSelectionBinding.inflate(layoutInflater)
        setContentView(binding.root)
        
        setupViewModel()
        setupUI()
        observeViewModel()
    }
    
    private fun setupViewModel() {
        val database = LocationDatabase.getDatabase(this)
        val preferencesManager = PreferencesManager(this)
        val repository = LocationRepository(database.locationDao(), preferencesManager)
        val factory = LocationViewModelFactory(repository)
        locationViewModel = ViewModelProvider(this, factory)[LocationViewModel::class.java]
    }
    
    private fun setupUI() {
        setSupportActionBar(binding.toolbar)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        
        // Setup RecyclerView
        locationAdapter = LocationAdapter(
            onLocationClick = { location ->
                // Handle location selection
                showLocationDetails(location)
            },
            onSetPreferredClick = { location ->
                locationViewModel.setPreferredLocation(location)
            },
            onEditClick = { location ->
                showAddEditLocationDialog(location)
            },
            onDeleteClick = { location ->
                showDeleteConfirmation(location)
            },
            preferredLocationId = locationViewModel.getPreferredLocationId()
        )
        
        binding.recyclerViewLocations.apply {
            layoutManager = LinearLayoutManager(this@LocationSelectionActivity)
            adapter = locationAdapter
        }
        
        // Setup FAB
        binding.fabAddLocation.setOnClickListener {
            showAddEditLocationDialog(null)
        }
        
        // Setup empty state
        updateEmptyState()
    }
    
    private fun observeViewModel() {
        locationViewModel.allLocations.observe(this) { locations ->
            locationAdapter.submitList(locations)
            updateEmptyState(locations.isEmpty())
        }
        
        locationViewModel.isLoading.observe(this) { isLoading ->
            // Show/hide loading indicator if needed
        }
        
        locationViewModel.errorMessage.observe(this) { errorMessage ->
            errorMessage?.let {
                Snackbar.make(binding.root, it, Snackbar.LENGTH_LONG).show()
                locationViewModel.clearErrorMessage()
            }
        }
        
        locationViewModel.operationResult.observe(this) { result ->
            result?.let {
                Snackbar.make(binding.root, it, Snackbar.LENGTH_SHORT).show()
                locationViewModel.clearOperationResult()
                
                // Update adapter's preferred location ID
                locationAdapter.updatePreferredLocationId(locationViewModel.getPreferredLocationId())
            }
        }
    }
    
    private fun updateEmptyState(isEmpty: Boolean = true) {
        if (isEmpty) {
            binding.recyclerViewLocations.visibility = android.view.View.GONE
            binding.layoutEmptyState.visibility = android.view.View.VISIBLE
        } else {
            binding.recyclerViewLocations.visibility = android.view.View.VISIBLE
            binding.layoutEmptyState.visibility = android.view.View.GONE
        }
    }
    
    private fun showLocationDetails(location: Location) {
        // For now, just set as preferred. Could expand to show detailed view
        locationViewModel.setPreferredLocation(location)
    }
    
    private fun showAddEditLocationDialog(location: Location?) {
        val dialog = AddLocationDialog.newInstance(location)
        dialog.setOnLocationSavedListener { savedLocation ->
            if (location == null) {
                locationViewModel.addLocation(savedLocation)
            } else {
                locationViewModel.updateLocation(savedLocation)
            }
        }
        dialog.show(supportFragmentManager, "AddLocationDialog")
    }
    
    private fun showDeleteConfirmation(location: Location) {
        androidx.appcompat.app.AlertDialog.Builder(this)
            .setTitle("Delete Location")
            .setMessage("Are you sure you want to delete '${location.name}'?")
            .setPositiveButton("Delete") { _, _ ->
                locationViewModel.deleteLocation(location)
            }
            .setNegativeButton("Cancel", null)
            .show()
    }
    
    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        menuInflater.inflate(R.menu.location_selection_menu, menu)
        return true
    }
    
    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        return when (item.itemId) {
            android.R.id.home -> {
                finish()
                true
            }
            R.id.action_clear_preferred -> {
                locationViewModel.clearPreferredLocation()
                locationAdapter.updatePreferredLocationId(null)
                true
            }
            else -> super.onOptionsItemSelected(item)
        }
    }
}
