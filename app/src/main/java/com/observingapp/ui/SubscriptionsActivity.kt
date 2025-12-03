package com.observingapp.ui

import android.content.DialogInterface
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import android.view.View
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import com.google.android.material.snackbar.Snackbar
import com.observingapp.R
import com.observingapp.data.LocationDatabase
import com.observingapp.data.Subscription
import com.observingapp.databinding.ActivitySubscriptionsBinding
import com.observingapp.repository.SubscriptionRepository
import com.observingapp.viewmodel.SubscriptionViewModel
import com.observingapp.viewmodel.SubscriptionViewModelFactory
import kotlinx.coroutines.launch
import java.text.NumberFormat
import java.util.*

class SubscriptionsActivity : AppCompatActivity() {

    private lateinit var binding: ActivitySubscriptionsBinding
    private lateinit var viewModel: SubscriptionViewModel
    private lateinit var adapter: SubscriptionAdapter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivitySubscriptionsBinding.inflate(layoutInflater)
        setContentView(binding.root)

        setupViewModel()
        setupRecyclerView()
        setupUI()
        observeSubscriptions()
    }

    private fun setupViewModel() {
        val database = LocationDatabase.getDatabase(this)
        val repository = SubscriptionRepository(database.subscriptionDao())
        val factory = SubscriptionViewModelFactory(repository)
        viewModel = ViewModelProvider(this, factory)[SubscriptionViewModel::class.java]
    }

    private fun setupRecyclerView() {
        adapter = SubscriptionAdapter(
            onItemClick = { subscription ->
                showEditSubscriptionDialog(subscription)
            },
            onItemLongClick = { subscription ->
                showDeleteConfirmation(subscription)
            }
        )

        binding.recyclerViewSubscriptions.layoutManager = LinearLayoutManager(this)
        binding.recyclerViewSubscriptions.adapter = adapter
    }

    private fun setupUI() {
        setSupportActionBar(binding.toolbar)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        supportActionBar?.title = "My Subscriptions"

        binding.fabAddSubscription.setOnClickListener {
            showAddSubscriptionDialog()
        }
    }

    private fun observeSubscriptions() {
        viewModel.allSubscriptions.observe(this) { subscriptions ->
            if (subscriptions.isEmpty()) {
                binding.emptyView.visibility = View.VISIBLE
                binding.recyclerViewSubscriptions.visibility = View.GONE
                binding.cardTotalCost.visibility = View.GONE
            } else {
                binding.emptyView.visibility = View.GONE
                binding.recyclerViewSubscriptions.visibility = View.VISIBLE
                binding.cardTotalCost.visibility = View.VISIBLE
                adapter.submitList(subscriptions)
                updateTotalCost()
            }
        }
    }

    private fun updateTotalCost() {
        lifecycleScope.launch {
            val total = viewModel.getTotalMonthlyCost()
            val formatter = NumberFormat.getCurrencyInstance(Locale.US)
            binding.textTotalCost.text = "Total: ${formatter.format(total)}/month"
            
            val count = viewModel.getSubscriptionCount()
            binding.textSubscriptionCount.text = "$count subscription${if (count != 1) "s" else ""}"
        }
    }

    private fun showAddSubscriptionDialog() {
        val dialog = AddEditSubscriptionDialog.newInstance()
        dialog.onSubscriptionSaved = { subscription ->
            viewModel.insertSubscription(subscription)
            Snackbar.make(binding.root, "Subscription added", Snackbar.LENGTH_SHORT).show()
        }
        dialog.show(supportFragmentManager, "AddSubscriptionDialog")
    }

    private fun showEditSubscriptionDialog(subscription: Subscription) {
        val dialog = AddEditSubscriptionDialog.newInstance(subscription)
        dialog.onSubscriptionSaved = { updatedSubscription ->
            viewModel.updateSubscription(updatedSubscription)
            Snackbar.make(binding.root, "Subscription updated", Snackbar.LENGTH_SHORT).show()
        }
        dialog.show(supportFragmentManager, "EditSubscriptionDialog")
    }

    private fun showDeleteConfirmation(subscription: Subscription) {
        AlertDialog.Builder(this)
            .setTitle("Delete Subscription")
            .setMessage("Are you sure you want to delete ${subscription.name}?")
            .setPositiveButton("Delete") { _, _ ->
                viewModel.deleteSubscription(subscription)
                Snackbar.make(binding.root, "Subscription deleted", Snackbar.LENGTH_SHORT).show()
            }
            .setNegativeButton("Cancel", null)
            .show()
    }

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        menuInflater.inflate(R.menu.subscriptions_menu, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        return when (item.itemId) {
            android.R.id.home -> {
                finish()
                true
            }
            R.id.action_add_sample_data -> {
                addSampleData()
                true
            }
            else -> super.onOptionsItemSelected(item)
        }
    }

    private fun addSampleData() {
        val sampleSubscriptions = listOf(
            Subscription(
                name = "Netflix",
                monthlyCost = 15.99,
                paymentDay = 1,
                creditCardLastFour = "4532",
                creditCardType = "Visa"
            ),
            Subscription(
                name = "Disney+",
                monthlyCost = 10.99,
                paymentDay = 15,
                creditCardLastFour = "8765",
                creditCardType = "Mastercard"
            ),
            Subscription(
                name = "Spotify",
                monthlyCost = 9.99,
                paymentDay = 10,
                creditCardLastFour = "4532",
                creditCardType = "Visa"
            ),
            Subscription(
                name = "Amazon Prime",
                monthlyCost = 14.99,
                paymentDay = 5,
                creditCardLastFour = "3210",
                creditCardType = "Amex"
            )
        )

        sampleSubscriptions.forEach { subscription ->
            viewModel.insertSubscription(subscription)
        }

        Snackbar.make(binding.root, "Sample data added", Snackbar.LENGTH_SHORT).show()
    }
}
