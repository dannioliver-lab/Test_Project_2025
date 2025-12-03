package com.observingapp.data

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey
import java.text.NumberFormat
import java.text.SimpleDateFormat
import java.util.*

@Entity(tableName = "subscriptions")
data class Subscription(
    @PrimaryKey(autoGenerate = true)
    val id: Long = 0,
    
    @ColumnInfo(name = "name")
    val name: String,
    
    @ColumnInfo(name = "monthly_cost")
    val monthlyCost: Double,
    
    @ColumnInfo(name = "payment_day")
    val paymentDay: Int, // Day of month (1-31)
    
    @ColumnInfo(name = "credit_card_last_four")
    val creditCardLastFour: String,
    
    @ColumnInfo(name = "credit_card_type")
    val creditCardType: String = "Unknown", // e.g., Visa, Mastercard, etc.
    
    @ColumnInfo(name = "created_at")
    val createdAt: Long = System.currentTimeMillis()
) {
    fun getFormattedCost(): String {
        val formatter = NumberFormat.getCurrencyInstance(Locale.US)
        return formatter.format(monthlyCost)
    }
    
    fun getNextPaymentDate(): String {
        val calendar = Calendar.getInstance()
        val today = calendar.get(Calendar.DAY_OF_MONTH)
        
        // If payment day hasn't occurred this month, use current month
        // Otherwise, use next month
        if (today >= paymentDay) {
            calendar.add(Calendar.MONTH, 1)
        }
        
        // Set the day
        calendar.set(Calendar.DAY_OF_MONTH, paymentDay)
        
        val dateFormat = SimpleDateFormat("MMM dd, yyyy", Locale.US)
        return dateFormat.format(calendar.time)
    }
    
    fun getDaysUntilPayment(): Int {
        val calendar = Calendar.getInstance()
        val today = calendar.get(Calendar.DAY_OF_MONTH)
        
        return if (today >= paymentDay) {
            // Payment is next month
            val daysInCurrentMonth = calendar.getActualMaximum(Calendar.DAY_OF_MONTH)
            (daysInCurrentMonth - today) + paymentDay
        } else {
            // Payment is this month
            paymentDay - today
        }
    }
    
    fun getMaskedCardNumber(): String {
        return "**** $creditCardLastFour"
    }
}
