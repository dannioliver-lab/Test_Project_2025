package com.observingapp.ui

import android.os.Bundle
import androidx.preference.PreferenceFragmentCompat
import com.observingapp.R

class SettingsFragment : PreferenceFragmentCompat() {
    
    override fun onCreatePreferences(savedInstanceState: Bundle?, rootKey: String?) {
        setPreferencesFromResource(R.xml.preferences, rootKey)
    }
}
