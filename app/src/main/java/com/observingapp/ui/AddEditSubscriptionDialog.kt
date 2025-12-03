package com.observingapp.ui

import android.app.Dialog
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ArrayAdapter
import androidx.fragment.app.DialogFragment
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.observingapp.R
import com.observingapp.data.Subscription
import com.observingapp.databinding.DialogAddEditSubscriptionBinding

class AddEditSubscriptionDialog : DialogFragment() {

    private var _binding: DialogAddEditSubscriptionBinding? = null
    private val binding get() = _binding!!
    
    private var existingSubscription: Subscription? = null
    var onSubscriptionSaved: ((Subscription) -> Unit)? = null

    companion object {
        private const val ARG_SUBSCRIPTION = "subscription"

        fun newInstance(subscription: Subscription? = null): AddEditSubscriptionDialog {
            val fragment = AddEditSubscriptionDialog()
            subscription?.let {
                val args = Bundle()
                args.putLong("id", it.id)
                args.putString("name", it.name)
                args.putDouble("monthlyCost", it.monthlyCost)
                args.putInt("paymentDay", it.paymentDay)
                args.putString("creditCardLastFour", it.creditCardLastFour)
                args.putString("creditCardType", it.creditCardType)
                fragment.arguments = args
            }
            return fragment
        }
    }

    override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
        _binding = DialogAddEditSubscriptionBinding.inflate(layoutInflater)
        
        setupCardTypeSpinner()
        setupPaymentDaySpinner()
        
        arguments?.let { args ->
            existingSubscription = Subscription(
                id = args.getLong("id"),
                name = args.getString("name", ""),
                monthlyCost = args.getDouble("monthlyCost"),
                paymentDay = args.getInt("paymentDay"),
                creditCardLastFour = args.getString("creditCardLastFour", ""),
                creditCardType = args.getString("creditCardType", "Unknown")
            )
            populateFields(existingSubscription!!)
        }

        val title = if (existingSubscription != null) "Edit Subscription" else "Add Subscription"
        
        return MaterialAlertDialogBuilder(requireContext())
            .setTitle(title)
            .setView(binding.root)
            .setPositiveButton("Save") { _, _ ->
                saveSubscription()
            }
            .setNegativeButton("Cancel", null)
            .create()
    }

    private fun setupCardTypeSpinner() {
        val cardTypes = arrayOf("Visa", "Mastercard", "Amex", "Discover", "Other")
        val adapter = ArrayAdapter(requireContext(), android.R.layout.simple_spinner_item, cardTypes)
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        binding.spinnerCardType.adapter = adapter
    }

    private fun setupPaymentDaySpinner() {
        val days = (1..28).map { "Day $it" }.toTypedArray()
        val adapter = ArrayAdapter(requireContext(), android.R.layout.simple_spinner_item, days)
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        binding.spinnerPaymentDay.adapter = adapter
    }

    private fun populateFields(subscription: Subscription) {
        binding.editTextName.setText(subscription.name)
        binding.editTextCost.setText(subscription.monthlyCost.toString())
        binding.editTextCardLastFour.setText(subscription.creditCardLastFour)
        
        // Set payment day spinner
        binding.spinnerPaymentDay.setSelection(subscription.paymentDay - 1)
        
        // Set card type spinner
        val cardTypes = arrayOf("Visa", "Mastercard", "Amex", "Discover", "Other")
        val cardTypeIndex = cardTypes.indexOf(subscription.creditCardType)
        if (cardTypeIndex >= 0) {
            binding.spinnerCardType.setSelection(cardTypeIndex)
        }
    }

    private fun saveSubscription() {
        val name = binding.editTextName.text.toString().trim()
        val costStr = binding.editTextCost.text.toString().trim()
        val cardLastFour = binding.editTextCardLastFour.text.toString().trim()
        val paymentDay = binding.spinnerPaymentDay.selectedItemPosition + 1
        val cardType = binding.spinnerCardType.selectedItem.toString()

        if (name.isEmpty()) {
            return
        }

        val cost = costStr.toDoubleOrNull() ?: 0.0
        if (cost <= 0) {
            return
        }

        if (cardLastFour.length != 4 || !cardLastFour.all { it.isDigit() }) {
            return
        }

        val subscription = Subscription(
            id = existingSubscription?.id ?: 0,
            name = name,
            monthlyCost = cost,
            paymentDay = paymentDay,
            creditCardLastFour = cardLastFour,
            creditCardType = cardType
        )

        onSubscriptionSaved?.invoke(subscription)
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}
