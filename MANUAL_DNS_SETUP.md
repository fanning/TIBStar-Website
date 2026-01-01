# Manual DNS Setup for tibstar.com on eNom

## API Issue Detected

Your eNom account has **IP whitelisting** enabled for security. The current IP address (24.62.192.236) is not authorized to use the API.

**Two options to proceed:**

### Option A: Whitelist Current IP (For API Access)
1. Log in to your eNom account at https://www.enom.com
2. Go to **Account Settings** → **API Settings** → **IP Whitelist**
3. Add IP: **24.62.192.236**
4. Save changes
5. Let me know when done, and I'll configure DNS via API

### Option B: Manual DNS Configuration (Recommended - Faster)
Follow the simple steps below to add DNS records manually.

---

## Manual DNS Setup (5 Minutes)

### What You Need to Add

Add these **two DNS records** in your eNom account:

```
Record 1: A Record
├─ Host: @ (or blank)
├─ Address: 75.2.60.5
└─ TTL: 3600

Record 2: CNAME Record
├─ Host: www
├─ Points to: tibstar-website.netlify.app
└─ TTL: 3600
```

---

## Step-by-Step Instructions

### Step 1: Log In to eNom
1. Go to https://www.enom.com
2. Click **"Sign In"**
3. Enter username: **gninnaf**
4. Enter your password
5. Click **"Sign In"**

### Step 2: Navigate to DNS Settings
1. Click **"Domains"** in the top menu
2. Click **"My Domains"**
3. Find **tibstar.com** in your domain list
4. Click on **tibstar.com**
5. Look for **"Host Records"** or **"DNS Settings"**
6. Click **"Edit"** or **"Manage"**

### Step 3: Add A Record (Root Domain)

**This makes tibstar.com point to Netlify**

1. Click **"Add New Record"** or **"+"**
2. Fill in:
   - **Record Type**: **A (Address)**
   - **Host Name**: **@** (or leave blank if @ doesn't work)
   - **Address**: **75.2.60.5**
   - **TTL**: **3600**
3. Click **"Save"** or **"Add"**

### Step 4: Add CNAME Record (www Subdomain)

**This makes www.tibstar.com work too**

1. Click **"Add New Record"** or **"+"** again
2. Fill in:
   - **Record Type**: **CNAME (Alias)**
   - **Host Name**: **www**
   - **Points to**: **tibstar-website.netlify.app**
   - **TTL**: **3600**
3. Click **"Save"** or **"Add"**

### Step 5: Remove Old Records (If Any)

**Check for conflicting records:**
- If you see an old A record for @ pointing to a different IP, delete it
- If you see an old CNAME for www, delete it
- Keep only the new records you just added

### Step 6: Save All Changes

1. Look for a **"Save Changes"** or **"Submit"** button
2. Click it (some interfaces need this after adding records)
3. You should see a success message

---

## Verification

### Check DNS Propagation

DNS changes take time to propagate:
- **Minimum**: 5-10 minutes
- **Typical**: 1-2 hours
- **Maximum**: 24-48 hours

### Use Online Tools

**Check if DNS is working:**
- https://dnschecker.org/#A/tibstar.com
- Should show: **75.2.60.5**

**Check CNAME:**
- https://dnschecker.org/#CNAME/www.tibstar.com
- Should show: **tibstar-website.netlify.app**

### Command Line Check

```bash
# Check A record
nslookup tibstar.com

# Expected result: 75.2.60.5

# Check CNAME
nslookup www.tibstar.com

# Expected result: Points to tibstar-website.netlify.app
```

---

## After DNS is Working

### 1. Verify DNS Configuration

Once DNS shows as working on dnschecker.org, let me know and I'll verify it.

### 2. Enable HTTPS

I'll then configure HTTPS certificate in Netlify:
- Provision Let's Encrypt SSL certificate
- Enable force HTTPS redirect
- Your site will be accessible at https://tibstar.com

---

## Quick Visual Reference

```
eNom DNS Records Screen:
┌────────────────────────────────────────────────┐
│ Host Records for tibstar.com                   │
├────────────────────────────────────────────────┤
│                                                │
│ Type    Host    Address/Points To       TTL   │
│ ─────   ─────   ──────────────────────  ────  │
│ A       @       75.2.60.5               3600  │
│ CNAME   www     tibstar-website.netlify 3600  │
│                 .app                          │
│                                                │
│         [Save Changes]                         │
└────────────────────────────────────────────────┘
```

---

## Troubleshooting

### "Cannot use @ for host"
- Try leaving the host field **blank**
- Or use **"*"** instead of **"@"**

### "Record already exists"
- Delete the old record first
- Then add the new one

### "Changes not saving"
- Make sure to click **"Save Changes"** or **"Submit"**
- Try refreshing the page and checking again

### "DNS not updating"
- Wait longer (can take hours)
- Clear browser cache: Ctrl + Shift + R
- Check your nameservers are set to eNom defaults

---

## Summary

**What to do:**
1. Log in to eNom with username: gninnaf
2. Go to DNS settings for tibstar.com
3. Add A record: @ → 75.2.60.5
4. Add CNAME record: www → tibstar-website.netlify.app
5. Save changes
6. Wait 1-2 hours for DNS propagation
7. Let me know when DNS is working, and I'll enable HTTPS

**Target configuration:**
- tibstar.com → 75.2.60.5 (Netlify)
- www.tibstar.com → tibstar-website.netlify.app (Netlify)

---

## Need Help?

If you get stuck or see any errors:
1. Take a screenshot of the DNS interface
2. Share what error message you see
3. I'll help troubleshoot

**Once DNS is configured, your site will be live at https://tibstar.com!** 🚀
