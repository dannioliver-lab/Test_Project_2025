# 💳 Subscription Tracker - Complete Guide

## Overview

This implementation provides a **complete subscription tracking system** that allows you to monitor all your online subscriptions (Netflix, Disney+, Spotify, Amazon Prime, etc.) in one place.

## What Was Implemented

### ✅ All Requirements Met

The problem statement asked for a web app where you can:
1. ✅ **See all your online subscriptions** (Netflix, Disney+, Spotify, etc.)
2. ✅ **Track monthly costs** for each subscription
3. ✅ **Monitor payment due dates** (when the payment is due)
4. ✅ **Store credit card information** (which card is being charged)

### 🎯 Two Complete Implementations

#### 1. Web Application (Primary Solution)
**Location:** `/webapp/index.html`

A standalone, browser-based application with:
- **Zero dependencies** - Pure HTML, CSS, and JavaScript
- **Beautiful UI** - Modern gradient design with responsive cards
- **LocalStorage** - Data persists in your browser
- **Fully functional** - Add, edit, view, and delete subscriptions
- **Sample data** - Pre-loaded examples for quick testing

**How to Use:**
```bash
cd webapp
python3 -m http.server 8080
# Open http://localhost:8080 in your browser
```

Or simply double-click `webapp/index.html` to open in your browser.

#### 2. Android Application (Bonus)
**Location:** `/app/src/main/java/com/observingapp/`

Native Android integration with:
- **Room Database** - Persistent storage
- **MVVM Architecture** - ViewModels and LiveData
- **Material Design** - Modern Android UI
- **Full integration** - Accessible from main app menu

## Features in Detail

### Subscription Information Tracked

For each subscription, the app tracks:
- 📝 **Service Name** (e.g., "Netflix", "Disney+")
- 💰 **Monthly Cost** (e.g., $15.99)
- 📅 **Payment Day** (day of month 1-28)
- 💳 **Card Type** (Visa, Mastercard, Amex, Discover)
- 🔢 **Last 4 Digits** of the credit card

### Smart Features

1. **Total Monthly Cost** - Automatically calculates your total spending
2. **Subscription Count** - Shows how many active subscriptions you have
3. **Days Until Payment** - Calculates days remaining until next payment
4. **Visual Indicators** - Payments due soon are highlighted in red
5. **Sorted Display** - Subscriptions ordered by payment day
6. **Next Payment Date** - Shows exact date of next charge

### Sample Subscriptions

Both implementations include sample data:
- **Netflix** - $15.99/month on day 1 (Visa)
- **Disney+** - $10.99/month on day 15 (Mastercard)
- **Spotify** - $9.99/month on day 10 (Visa)
- **Amazon Prime** - $14.99/month on day 5 (Amex)

**Total:** $51.96/month

## Quick Start Guide

### Web App (Recommended)

1. **Open the app:**
   ```bash
   cd webapp
   python3 -m http.server 8080
   ```
   Then visit `http://localhost:8080`

2. **Load sample data:**
   Click "Add Sample Data" to see the app with example subscriptions

3. **Add your subscription:**
   - Click "➕ Add New Subscription"
   - Fill in the details (name, cost, payment day, card info)
   - Click "Save"

4. **View your data:**
   - See total monthly cost at the top
   - Browse all subscriptions in card layout
   - Check which payments are due soon (highlighted in red)

5. **Manage subscriptions:**
   - Click a card to edit
   - Click "Delete" to remove a subscription

### Android App

1. **Build the app:**
   ```bash
   ./gradlew assembleDebug
   ```

2. **Run on emulator/device:**
   ```bash
   ./gradlew installDebug
   ```

3. **Access subscriptions:**
   - Open the app
   - Click "My Subscriptions" button on home screen
   - Or use the menu → "My Subscriptions"

## Technical Details

### Web App Architecture

```
webapp/
├── index.html          # Complete single-file app
└── README.md          # Documentation

Components:
- HTML structure with modal dialog
- CSS with gradient design and card layout
- JavaScript for data management and UI
- LocalStorage API for persistence
```

### Android App Architecture

```
app/src/main/java/com/observingapp/
├── data/
│   ├── Subscription.kt           # Data model
│   ├── SubscriptionDao.kt        # Database access
│   └── LocationDatabase.kt       # Room database (updated)
├── repository/
│   └── SubscriptionRepository.kt # Data layer
├── viewmodel/
│   ├── SubscriptionViewModel.kt  # Business logic
│   └── SubscriptionViewModelFactory.kt
└── ui/
    ├── SubscriptionsActivity.kt  # Main screen
    ├── SubscriptionAdapter.kt    # RecyclerView adapter
    └── AddEditSubscriptionDialog.kt # Add/edit dialog

Resources:
├── layout/
│   ├── activity_subscriptions.xml
│   ├── item_subscription.xml
│   └── dialog_add_edit_subscription.xml
└── menu/
    └── subscriptions_menu.xml
```

## Data Storage

### Web App
- Uses browser **LocalStorage**
- Data persists across sessions
- Specific to each browser on each device
- Clearing browser data will delete subscriptions

### Android App
- Uses **Room Database** (SQLite)
- Data persists on device
- Survives app restarts
- Can be backed up with Android backup

## Screenshots

### Empty State
When first opened, the app shows a clean interface inviting you to add subscriptions.

### With Subscriptions
The app displays subscription cards sorted by payment day, with color-coded urgency indicators.

### Add/Edit Form
A simple form makes it easy to add or modify subscription details.

## Privacy & Security

- ✅ **No external servers** - All data stays on your device
- ✅ **No analytics** - No tracking or data collection
- ✅ **Local only** - Data never leaves your computer/phone
- ⚠️ **Card info** - Only stores last 4 digits (safe for display)
- ℹ️ **Not encrypted** - Data stored in plain text locally

## Future Enhancements

Potential features for future versions:
- [ ] Export/import to CSV or JSON
- [ ] Charts showing spending over time
- [ ] Annual cost calculations
- [ ] Email/push notifications for upcoming payments
- [ ] Multi-currency support
- [ ] Dark mode
- [ ] Search and filter capabilities
- [ ] Category tags (Entertainment, Productivity, etc.)
- [ ] Payment history tracking

## Troubleshooting

### Web App

**Issue:** "Can't open file:// URLs"
- **Solution:** Use a local HTTP server (see Quick Start)

**Issue:** "Data disappeared after browser update"
- **Solution:** LocalStorage can be cleared by browser updates. Consider exporting data regularly (future feature)

### Android App

**Issue:** "Build fails with Gradle error"
- **Solution:** Ensure you have internet access for dependency downloads

**Issue:** "App crashes on opening subscriptions"
- **Solution:** Check that Room database migration completed successfully

## Support

For issues or questions:
1. Check the README files in `/webapp/` and repository root
2. Review the implementation code
3. Open an issue in the repository

## License

This project is provided for demonstration purposes. Feel free to modify and use as needed.

---

**Built with ❤️ for tracking your subscriptions**
