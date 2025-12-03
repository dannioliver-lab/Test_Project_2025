# 💳 Subscription Tracker Web App

A beautiful, fully-functional web application to track all your online subscriptions in one place.

## Features

✅ **View all subscriptions** - See all your subscriptions organized by payment date
✅ **Monthly cost tracking** - Know exactly how much you're spending each month
✅ **Payment due dates** - Never miss a payment with clear due date tracking
✅ **Credit card information** - Track which card is being charged for each subscription
✅ **Visual indicators** - See at a glance which payments are coming up soon
✅ **Add/Edit/Delete** - Full CRUD functionality for managing subscriptions
✅ **Local storage** - Your data is saved in your browser (no server required!)
✅ **Responsive design** - Works perfectly on desktop, tablet, and mobile devices

## What You Can Track

For each subscription, you can record:
- 📝 **Service name** (e.g., Netflix, Disney+, Spotify)
- 💰 **Monthly cost** 
- 📅 **Payment day of the month**
- 💳 **Credit card type** (Visa, Mastercard, Amex, etc.)
- 🔢 **Last 4 digits of the card**

## How to Use

### Option 1: Open Directly
Simply open `index.html` in your web browser by double-clicking it.

### Option 2: Use a Local Server
For best results, serve it with a local HTTP server:

```bash
# Using Python 3
python3 -m http.server 8080

# Using Node.js (with http-server package)
npx http-server -p 8080

# Using PHP
php -S localhost:8080
```

Then navigate to `http://localhost:8080` in your browser.

## Quick Start

1. **Add Sample Data**: Click the "Add Sample Data" button to populate the app with example subscriptions (Netflix, Disney+, Spotify, Amazon Prime)

2. **Add Your Own Subscription**: Click "➕ Add New Subscription" and fill in the details

3. **View Your Total**: See your total monthly cost and number of active subscriptions at the top

4. **Track Payment Dates**: Each subscription card shows the next payment date and days until payment

5. **Delete Subscriptions**: Click the "Delete" button on any subscription card to remove it

## Screenshots

### Empty State
When you first open the app, you'll see a clean interface ready for your subscriptions.

### With Subscriptions
The app displays all your subscriptions in a beautiful card layout, sorted by payment day. Subscriptions due soon are highlighted in red.

### Add Form
A simple, intuitive form makes adding new subscriptions quick and easy.

## Technical Details

- **Pure HTML/CSS/JavaScript** - No frameworks or dependencies required
- **LocalStorage API** - Data persists across browser sessions
- **Responsive Grid Layout** - Adapts to any screen size
- **Modern CSS** - Beautiful gradient backgrounds and card designs
- **Accessible** - Semantic HTML and proper form labels

## Data Storage

All subscription data is stored locally in your browser using the LocalStorage API. This means:
- ✅ Your data never leaves your computer
- ✅ No internet connection required
- ✅ Works completely offline
- ⚠️ Clearing browser data will delete your subscriptions
- ⚠️ Data is specific to each browser on each device

## Browser Compatibility

Works on all modern browsers:
- Chrome/Edge 4+
- Firefox 3.5+
- Safari 4+
- Opera 10.5+

## Privacy

This application runs entirely in your browser. No data is sent to any server, and no analytics are collected. Your subscription information remains completely private on your device.

## Future Enhancements

Potential features for future versions:
- Export/import functionality
- Charts and visualizations
- Annual cost calculations
- Subscription renewal reminders
- Currency selection
- Dark mode

## License

This project is provided as-is for demonstration purposes. Feel free to modify and use as needed.

---

**Built with ❤️ using vanilla JavaScript**
