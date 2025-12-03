package com.observingapp

import android.content.Intent
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.lifecycleScope
import com.google.android.material.snackbar.Snackbar
import com.observingapp.data.LocationDatabase
import com.observingapp.databinding.ActivityMainBinding
import com.observingapp.repository.LocationRepository
import com.observingapp.ui.LocationSelectionActivity
import com.observingapp.ui.SettingsActivity
import com.observingapp.utils.PreferencesManager
import com.observingapp.viewmodel.LocationViewModel
import com.observingapp.viewmodel.LocationViewModelFactory
import kotlinx.coroutines.launch

class MainActivity : AppCompatActivity() {
    
    private lateinit var binding: ActivityMainBinding
    private lateinit var locationViewModel: LocationViewModel
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)
        
        setupViewModel()
        setupUI()
        observePreferredLocation()
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
        
        binding.buttonViewSubscriptions.setOnClickListener {
            startActivity(Intent(this, com.observingapp.ui.SubscriptionsActivity::class.java))
        }
        
        binding.buttonSelectLocation.setOnClickListener {
            startActivity(Intent(this, LocationSelectionActivity::class.java))
        }
        
        binding.buttonViewLocations.setOnClickListener {
            startActivity(Intent(this, LocationSelectionActivity::class.java))
        }
    }
    
    private fun observePreferredLocation() {
        lifecycleScope.launch {
            locationViewModel.getPreferredLocation()?.let { location ->
                binding.textCurrentLocation.text = getString(
                    R.string.preferred_location_format,
                    location.name,
                    location.getFormattedCoordinates()
                )
                binding.cardCurrentLocation.visibility = android.view.View.VISIBLE
            } ?: run {
                binding.textCurrentLocation.text = getString(R.string.no_preferred_location)
                binding.cardCurrentLocation.visibility = android.view.View.GONE
            }
        }
    }
    
    override fun onResume() {
        super.onResume()
        // Refresh the preferred location display when returning to this activity
        observePreferredLocation()
    }
    
    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        menuInflater.inflate(R.menu.main_menu, menu)
        return true
    }
    
    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        return when (item.itemId) {
            R.id.action_subscriptions -> {
                startActivity(Intent(this, com.observingapp.ui.SubscriptionsActivity::class.java))
                true
            }
            R.id.action_settings -> {
                startActivity(Intent(this, SettingsActivity::class.java))
                true
            }
            R.id.action_manage_locations -> {
                startActivity(Intent(this, LocationSelectionActivity::class.java))
                true
            }
            else -> super.onOptionsItemSelected(item)
        }
    }
}
