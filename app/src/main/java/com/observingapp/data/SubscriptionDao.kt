package com.observingapp.data

import androidx.lifecycle.LiveData
import androidx.room.*

@Dao
interface SubscriptionDao {
    
    @Query("SELECT * FROM subscriptions ORDER BY payment_day ASC")
    fun getAllSubscriptions(): LiveData<List<Subscription>>
    
    @Query("SELECT * FROM subscriptions ORDER BY payment_day ASC")
    suspend fun getAllSubscriptionsList(): List<Subscription>
    
    @Query("SELECT * FROM subscriptions WHERE id = :id")
    suspend fun getSubscriptionById(id: Long): Subscription?
    
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertSubscription(subscription: Subscription): Long
    
    @Update
    suspend fun updateSubscription(subscription: Subscription)
    
    @Delete
    suspend fun deleteSubscription(subscription: Subscription)
    
    @Query("DELETE FROM subscriptions WHERE id = :id")
    suspend fun deleteSubscriptionById(id: Long)
    
    @Query("SELECT SUM(monthly_cost) FROM subscriptions")
    suspend fun getTotalMonthlyCost(): Double?
    
    @Query("SELECT COUNT(*) FROM subscriptions")
    suspend fun getSubscriptionCount(): Int
}
