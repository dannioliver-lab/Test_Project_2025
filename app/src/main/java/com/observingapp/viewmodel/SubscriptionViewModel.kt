package com.observingapp.viewmodel

import androidx.lifecycle.LiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.observingapp.data.Subscription
import com.observingapp.repository.SubscriptionRepository
import kotlinx.coroutines.launch

class SubscriptionViewModel(private val repository: SubscriptionRepository) : ViewModel() {
    
    val allSubscriptions: LiveData<List<Subscription>> = repository.allSubscriptions
    
    fun insertSubscription(subscription: Subscription) = viewModelScope.launch {
        repository.insertSubscription(subscription)
    }
    
    fun updateSubscription(subscription: Subscription) = viewModelScope.launch {
        repository.updateSubscription(subscription)
    }
    
    fun deleteSubscription(subscription: Subscription) = viewModelScope.launch {
        repository.deleteSubscription(subscription)
    }
    
    suspend fun getSubscriptionById(id: Long): Subscription? {
        return repository.getSubscriptionById(id)
    }
    
    suspend fun getTotalMonthlyCost(): Double {
        return repository.getTotalMonthlyCost()
    }
    
    suspend fun getSubscriptionCount(): Int {
        return repository.getSubscriptionCount()
    }
}
