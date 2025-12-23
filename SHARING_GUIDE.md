# 🔗 How to Share the Subscription Tracker Prototype

## Option 1: GitHub Pages (Recommended) ✨

Your subscription tracker can be deployed to GitHub Pages for free, making it accessible via a public URL.

### Setup Steps:

1. **Enable GitHub Pages in your repository:**
   - Go to your repository: https://github.com/dannioliver-lab/Test_Project_2025
   - Click on **Settings** → **Pages** (in the left sidebar)
   - Under "Build and deployment":
     - **Source**: Select "GitHub Actions"
   - Save the settings

2. **The app will auto-deploy when you push this branch!**
   - A GitHub Actions workflow has been added (`.github/workflows/deploy-webapp.yml`)
   - It will automatically deploy the `webapp/` folder

3. **Your shareable link will be:**
   ```
   https://dannioliver-lab.github.io/Test_Project_2025/
   ```

   You can share this link with anyone! They can:
   - Use the app immediately in their browser
   - Add their own subscriptions (stored in their browser)
   - Try the sample data feature

### Live Preview:

Once deployed, the app will be accessible at:
**https://dannioliver-lab.github.io/Test_Project_2025/**

---

## Option 2: Netlify Drop (Instant) 🚀

For an even faster share, use Netlify Drop:

1. Go to https://app.netlify.com/drop
2. Drag and drop the entire `webapp` folder
3. You'll get an instant shareable link like: `https://random-name.netlify.app`
4. Free, no account needed!

---

## Option 3: CodeSandbox (Interactive Demo) 💻

Share an interactive, editable version:

1. Go to https://codesandbox.io/
2. Create a new "Static" sandbox
3. Upload `webapp/index.html`
4. Share the CodeSandbox URL

People can then:
- View the app
- Edit the code
- Fork their own version

---

## Option 4: Direct File Sharing 📁

For offline use or private sharing:

1. **Email the file:**
   - Attach `webapp/index.html` to an email
   - Recipients can open it directly in their browser

2. **Cloud storage:**
   - Upload to Google Drive, Dropbox, or OneDrive
   - Share the file link
   - Recipients download and open locally

3. **QR Code:**
   - Once deployed to GitHub Pages or Netlify
   - Generate a QR code for the URL
   - Perfect for presentations!

---

## What Recipients Can Do:

When people access your prototype, they can:

✅ **Add subscriptions** - Track their Netflix, Spotify, etc.
✅ **See total costs** - Automatic monthly spending calculation
✅ **Track payment dates** - Visual indicators for upcoming payments
✅ **Try sample data** - Click "Add Sample Data" to see it populated
✅ **Full functionality** - Add, edit, delete subscriptions
✅ **Private data** - Everything stays in their browser (LocalStorage)

---

## Tips for Sharing:

### 📱 Mobile Friendly
The app is fully responsive - it works great on phones and tablets!

### 🔒 Privacy
Data is stored locally in the browser. Each user's data is private and never sent anywhere.

### 💾 Persistence
Subscriptions are saved automatically. Data persists across browser sessions.

### 🌐 No Installation
Just open the link in any modern browser - no downloads or installs needed!

---

## Example Share Messages:

### For Colleagues:
```
Hey team! Check out this subscription tracker prototype:
https://dannioliver-lab.github.io/Test_Project_2025/

It tracks monthly subscriptions like Netflix, Spotify, etc. with:
- Monthly costs
- Payment due dates  
- Credit card info

Try clicking "Add Sample Data" to see it in action!
```

### For Stakeholders:
```
Subscription Tracker Demo Live! 🎉

View the interactive prototype here:
https://dannioliver-lab.github.io/Test_Project_2025/

Key Features:
✅ Track all subscriptions in one place
✅ See total monthly costs
✅ Monitor payment due dates
✅ Store payment methods

The app is fully functional - feel free to add your own data!
```

---

## Troubleshooting:

**Q: The GitHub Pages link doesn't work yet**
- Wait a few minutes after pushing for the deployment to complete
- Check the "Actions" tab in GitHub to see deployment status
- Make sure GitHub Pages is enabled in repository settings

**Q: Can I use a custom domain?**
- Yes! In GitHub Pages settings, you can add a custom domain
- Follow GitHub's custom domain guide

**Q: How do I update the shared version?**
- Just push changes to the `webapp/` folder
- GitHub Actions will automatically redeploy
- Link stays the same!

---

## Next Steps:

1. **Merge this PR** to the main branch
2. **Enable GitHub Pages** in repository settings
3. **Share the link** with your team!

The URL will be live at:
**https://dannioliver-lab.github.io/Test_Project_2025/**

---

*Happy sharing! 🎉*
