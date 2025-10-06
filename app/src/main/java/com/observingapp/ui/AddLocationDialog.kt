package com.observingapp.ui

import android.app.Dialog
import android.os.Bundle
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.fragment.app.DialogFragment
import com.observingapp.R
import com.observingapp.data.Location
import com.observingapp.databinding.DialogAddLocationBinding

class AddLocationDialog : DialogFragment() {
    
    private var _binding: DialogAddLocationBinding? = null
    private val binding get() = _binding!!
    
    private var existingLocation: Location? = null
    private var onLocationSavedListener: ((Location) -> Unit)? = null
    
    companion object {
        private const val ARG_LOCATION = "location"
        
        fun newInstance(location: Location? = null): AddLocationDialog {
            val dialog = AddLocationDialog()
            val args = Bundle()
            location?.let { args.putSerializable(ARG_LOCATION, it) }
            dialog.arguments = args
            return dialog
        }
    }
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        existingLocation = arguments?.getSerializable(ARG_LOCATION) as? Location
    }
    
    override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
        _binding = DialogAddLocationBinding.inflate(layoutInflater)
        
        setupUI()
        
        val title = if (existingLocation != null) {
            getString(R.string.edit_location)
        } else {
            getString(R.string.add_location)
        }
        
        return AlertDialog.Builder(requireContext())
            .setTitle(title)
            .setView(binding.root)
            .setPositiveButton(R.string.save) { _, _ ->
                saveLocation()
            }
            .setNegativeButton(R.string.cancel, null)
            .create()
    }
    
    private fun setupUI() {
        existingLocation?.let { location ->
            binding.editTextLocationName.setText(location.name)
            binding.editTextLatitude.setText(location.latitude.toString())
            binding.editTextLongitude.setText(location.longitude.toString())
            location.elevation?.let { 
                binding.editTextElevation.setText(it.toString())
            }
            binding.editTextNotes.setText(location.notes ?: "")
        }
        
        binding.buttonUseCurrentLocation.setOnClickListener {
            // TODO: Implement GPS location detection
            Toast.makeText(context, "GPS location feature coming soon!", Toast.LENGTH_SHORT).show()
        }
    }
    
    private fun saveLocation() {
        val name = binding.editTextLocationName.text.toString().trim()
        val latitudeText = binding.editTextLatitude.text.toString().trim()
        val longitudeText = binding.editTextLongitude.text.toString().trim()
        val elevationText = binding.editTextElevation.text.toString().trim()
        val notes = binding.editTextNotes.text.toString().trim()
        
        // Validate input
        if (name.isEmpty()) {
            Toast.makeText(context, R.string.error_location_name_required, Toast.LENGTH_SHORT).show()
            return
        }
        
        val latitude = latitudeText.toDoubleOrNull()
        val longitude = longitudeText.toDoubleOrNull()
        
        if (latitude == null || longitude == null) {
            Toast.makeText(context, R.string.error_invalid_coordinates, Toast.LENGTH_SHORT).show()
            return
        }
        
        if (latitude < -90 || latitude > 90 || longitude < -180 || longitude > 180) {
            Toast.makeText(context, R.string.error_invalid_coordinates, Toast.LENGTH_SHORT).show()
            return
        }
        
        val elevation = elevationText.toDoubleOrNull()
        
        val location = existingLocation?.copy(
            name = name,
            latitude = latitude,
            longitude = longitude,
            elevation = elevation,
            notes = notes.ifEmpty { null },
            updatedAt = System.currentTimeMillis()
        ) ?: Location(
            name = name,
            latitude = latitude,
            longitude = longitude,
            elevation = elevation,
            notes = notes.ifEmpty { null }
        )
        
        onLocationSavedListener?.invoke(location)
    }
    
    fun setOnLocationSavedListener(listener: (Location) -> Unit) {
        onLocationSavedListener = listener
    }
    
    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}
