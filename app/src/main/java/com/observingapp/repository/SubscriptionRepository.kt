package com.observingapp.repository

import androidx.lifecycle.LiveData
import com.observingapp.data.Subscription
import com.observingapp.data.SubscriptionDao

class SubscriptionRepository(private val subscriptionDao: SubscriptionDao) {
    
    val allSubscriptions: LiveData<List<Subscription>> = subscriptionDao.getAllSubscriptions()
    
    suspend fun insertSubscription(subscription: Subscription): Long {
        return subscriptionDao.insertSubscription(subscription)
    }
    
    suspend fun updateSubscription(subscription: Subscription) {
        subscriptionDao.updateSubscription(subscription)
    }
    
    suspend fun deleteSubscription(subscription: Subscription) {
        subscriptionDao.deleteSubscription(subscription)
    }
    
    suspend fun getSubscriptionById(id: Long): Subscription? {
        return subscriptionDao.getSubscriptionById(id)
    }
    
    suspend fun getTotalMonthlyCost(): Double {
        return subscriptionDao.getTotalMonthlyCost() ?: 0.0
    }
    
    suspend fun getSubscriptionCount(): Int {
        return subscriptionDao.getSubscriptionCount()
    }
}
