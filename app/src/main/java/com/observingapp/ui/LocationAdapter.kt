package com.observingapp.ui

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.observingapp.R
import com.observingapp.data.Location
import com.observingapp.databinding.ItemLocationBinding

class LocationAdapter(
    private val onLocationClick: (Location) -> Unit,
    private val onSetPreferredClick: (Location) -> Unit,
    private val onEditClick: (Location) -> Unit,
    private val onDeleteClick: (Location) -> Unit,
    private var preferredLocationId: String?
) : ListAdapter<Location, LocationAdapter.LocationViewHolder>(LocationDiffCallback()) {
    
    fun updatePreferredLocationId(newPreferredId: String?) {
        val oldPreferredId = preferredLocationId
        preferredLocationId = newPreferredId
        
        // Notify items that might have changed their preferred status
        currentList.forEachIndexed { index, location ->
            if (location.id == oldPreferredId || location.id == newPreferredId) {
                notifyItemChanged(index)
            }
        }
    }
    
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): LocationViewHolder {
        val binding = ItemLocationBinding.inflate(
            LayoutInflater.from(parent.context),
            parent,
            false
        )
        return LocationViewHolder(binding)
    }
    
    override fun onBindViewHolder(holder: LocationViewHolder, position: Int) {
        holder.bind(getItem(position))
    }
    
    inner class LocationViewHolder(
        private val binding: ItemLocationBinding
    ) : RecyclerView.ViewHolder(binding.root) {
        
        fun bind(location: Location) {
            binding.apply {
                textLocationName.text = location.name
                textLocationCoordinates.text = location.getFormattedCoordinates()
                
                // Show elevation if available
                if (location.elevation != null) {
                    textLocationElevation.text = root.context.getString(
                        R.string.elevation_format,
                        location.elevation.toInt()
                    )
                    textLocationElevation.visibility = android.view.View.VISIBLE
                } else {
                    textLocationElevation.visibility = android.view.View.GONE
                }
                
                // Show notes if available
                if (!location.notes.isNullOrBlank()) {
                    textLocationNotes.text = location.notes
                    textLocationNotes.visibility = android.view.View.VISIBLE
                } else {
                    textLocationNotes.visibility = android.view.View.GONE
                }
                
                // Highlight preferred location
                val isPreferred = location.id == preferredLocationId
                if (isPreferred) {
                    cardLocation.strokeColor = root.context.getColor(R.color.preferred_location_border)
                    cardLocation.strokeWidth = 4
                    layoutLocationContent.setBackgroundColor(
                        root.context.getColor(R.color.preferred_location_background)
                    )
                    textPreferredIndicator.visibility = android.view.View.VISIBLE
                } else {
                    cardLocation.strokeWidth = 0
                    layoutLocationContent.setBackgroundColor(
                        root.context.getColor(android.R.color.transparent)
                    )
                    textPreferredIndicator.visibility = android.view.View.GONE
                }
                
                // Set click listeners
                root.setOnClickListener { onLocationClick(location) }
                
                buttonSetPreferred.setOnClickListener { onSetPreferredClick(location) }
                buttonSetPreferred.isEnabled = !isPreferred
                
                buttonEdit.setOnClickListener { onEditClick(location) }
                buttonDelete.setOnClickListener { onDeleteClick(location) }
            }
        }
    }
    
    private class LocationDiffCallback : DiffUtil.ItemCallback<Location>() {
        override fun areItemsTheSame(oldItem: Location, newItem: Location): Boolean {
            return oldItem.id == newItem.id
        }
        
        override fun areContentsTheSame(oldItem: Location, newItem: Location): Boolean {
            return oldItem == newItem
        }
    }
}
