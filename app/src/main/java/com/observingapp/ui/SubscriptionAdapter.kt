package com.observingapp.ui

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.observingapp.data.Subscription
import com.observingapp.databinding.ItemSubscriptionBinding

class SubscriptionAdapter(
    private val onItemClick: (Subscription) -> Unit,
    private val onItemLongClick: (Subscription) -> Unit
) : ListAdapter<Subscription, SubscriptionAdapter.SubscriptionViewHolder>(SubscriptionDiffCallback()) {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): SubscriptionViewHolder {
        val binding = ItemSubscriptionBinding.inflate(
            LayoutInflater.from(parent.context),
            parent,
            false
        )
        return SubscriptionViewHolder(binding)
    }

    override fun onBindViewHolder(holder: SubscriptionViewHolder, position: Int) {
        holder.bind(getItem(position))
    }

    inner class SubscriptionViewHolder(
        private val binding: ItemSubscriptionBinding
    ) : RecyclerView.ViewHolder(binding.root) {

        fun bind(subscription: Subscription) {
            binding.textSubscriptionName.text = subscription.name
            binding.textSubscriptionCost.text = subscription.getFormattedCost()
            binding.textPaymentDate.text = "Next payment: ${subscription.getNextPaymentDate()}"
            binding.textCreditCard.text = "${subscription.creditCardType} ${subscription.getMaskedCardNumber()}"
            
            val daysUntil = subscription.getDaysUntilPayment()
            binding.textDaysUntil.text = when {
                daysUntil == 0 -> "Due today!"
                daysUntil == 1 -> "Due tomorrow"
                else -> "Due in $daysUntil days"
            }

            binding.root.setOnClickListener {
                onItemClick(subscription)
            }

            binding.root.setOnLongClickListener {
                onItemLongClick(subscription)
                true
            }
        }
    }

    class SubscriptionDiffCallback : DiffUtil.ItemCallback<Subscription>() {
        override fun areItemsTheSame(oldItem: Subscription, newItem: Subscription): Boolean {
            return oldItem.id == newItem.id
        }

        override fun areContentsTheSame(oldItem: Subscription, newItem: Subscription): Boolean {
            return oldItem == newItem
        }
    }
}
