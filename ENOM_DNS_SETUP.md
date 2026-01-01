# eNom DNS Configuration for tibstar.com

Complete guide to configure tibstar.com DNS on eNom to point to Netlify.

---

## Quick Setup (What You Need to Add)

**Add these DNS records in eNom:**

| Type | Host | Address/Value | TTL |
|------|------|---------------|-----|
| A | @ | 75.2.60.5 | 3600 |
| CNAME | www | tibstar-website.netlify.app | 3600 |

---

## Step-by-Step Instructions for eNom

### Step 1: Log In to eNom

1. Go to https://www.enom.com
2. Click **"Sign In"** in the top right
3. Enter your username and password
4. Click **"Sign In"**

### Step 2: Access Domain Management

1. After logging in, click **"Domains"** in the top menu
2. Click **"My Domains"**
3. Find **tibstar.com** in your domain list
4. Click on **tibstar.com** to manage it

### Step 3: Access DNS Settings

1. Look for **"DNS Settings"** or **"Host Records"** section
2. Click **"Edit"** or **"Manage DNS"**

   **Alternative paths:**
   - Some eNom interfaces: **"DNS & Nameservers"** → **"Host Records"**
   - Or: **"DNS Host Records"** → **"Edit"**

### Step 4: Add A Record for Root Domain

1. In the Host Records section, find the option to **"Add New Record"** or similar
2. Configure the A record:
   - **Record Type**: Select **"A (Address)"**
   - **Host Name**: Enter **"@"** (this represents the root domain tibstar.com)
     - If there's no @ option, leave it blank or use **"*"**
   - **Address/IP**: Enter **"75.2.60.5"**
   - **TTL**: Enter **"3600"** (1 hour)
3. Click **"Save"** or **"Add Record"**

### Step 5: Add CNAME Record for www

1. Click **"Add New Record"** again
2. Configure the CNAME record:
   - **Record Type**: Select **"CNAME (Alias)"**
   - **Host Name**: Enter **"www"**
   - **Address/Alias**: Enter **"tibstar-website.netlify.app"**
     - **Important**: Do NOT include "http://" or "https://"
     - **Important**: Do NOT add a trailing dot (some systems add it automatically)
   - **TTL**: Enter **"3600"**
3. Click **"Save"** or **"Add Record"**

### Step 6: Remove Conflicting Records (If Needed)

**Check for existing records that might conflict:**

1. Look for any existing **A records** for **"@"** or blank host
2. Look for any existing **CNAME records** for **"www"**
3. If you find conflicting records:
   - Delete old A records pointing to different IPs
   - Delete old CNAME records for www
   - Keep only the new records you just added

### Step 7: Verify Nameservers

Make sure your domain is using eNom's nameservers (not external ones):

1. In domain management, look for **"Nameservers"** section
2. Verify nameservers are set to eNom default:
   - dns1.name-services.com
   - dns2.name-services.com
   - dns3.name-services.com
   - dns4.name-services.com
   - dns5.name-services.com

**If using custom nameservers:**
- You'll need to configure DNS at your nameserver provider instead
- Or change back to eNom nameservers

### Step 8: Save Changes

1. Click **"Save"** or **"Save Changes"**
2. Some interfaces require clicking **"Submit"** or **"Update"**
3. You should see a confirmation message

---

## Alternative: eNom DNS Templates (If Available)

Some eNom accounts have DNS templates:

1. In DNS settings, look for **"DNS Templates"**
2. Select **"Web Forwarding"** or **"Custom"**
3. Manually add the A and CNAME records as described above

---

## Verification

### Wait for DNS Propagation

DNS changes can take time:
- **Minimum**: 5-10 minutes
- **Typical**: 1-4 hours
- **Maximum**: 24-48 hours

### Check DNS Propagation

**Online tools:**
- https://dnschecker.org/#A/tibstar.com
- https://www.whatsmydns.net/#A/tibstar.com

**Command line:**
```bash
# Check A record
nslookup tibstar.com

# Check CNAME record
nslookup www.tibstar.com

# Alternative
dig tibstar.com
dig www.tibstar.com
```

**Expected results:**
- `tibstar.com` should resolve to **75.2.60.5**
- `www.tibstar.com` should show CNAME to **tibstar-website.netlify.app**

---

## After DNS is Working

### Enable HTTPS in Netlify

1. Go to https://app.netlify.com/projects/tibstar-website/settings/domain
2. Scroll to **"HTTPS"** section
3. Click **"Verify DNS configuration"**
   - If DNS isn't propagated yet, this will show an error
   - Wait and try again later
4. Once verified, click **"Provision certificate"**
5. Wait 1-2 minutes for Let's Encrypt certificate
6. HTTPS will be automatically enabled!

### Force HTTPS (Recommended)

After HTTPS is working:
1. In the same HTTPS section
2. Enable **"Force HTTPS"**
3. This redirects all HTTP traffic to HTTPS

---

## Troubleshooting eNom

### "Cannot add A record for @"
- Try using **"*"** instead of **"@"**
- Or leave the host field blank
- Or use **"tibstar.com"** as the host

### "Cannot add CNAME with same name as A record"
- This is normal - you want A for @ and CNAME for www
- They should NOT conflict
- If you see this error, you may have duplicate records

### "Changes not saving"
- Some eNom interfaces have two save buttons
- Look for **"Submit"** or **"Update"** after **"Save"**
- Try clearing browser cache and logging in again

### "DNS not propagating"
- Check your nameservers are set to eNom
- If using external nameservers, configure DNS there instead
- Some registrars take longer to propagate changes

### "Record already exists"
- Delete the old record first
- Then add the new one
- You cannot have duplicate records

---

## eNom API Option (Advanced)

If you have eNom API credentials, DNS can be configured programmatically.

**Required:**
- eNom Reseller Account
- API credentials (username, password, API token)

**Let me know if you have API access and want automated configuration.**

---

## Current Configuration Summary

**What to add in eNom:**

```
A Record:
  Host: @
  Points to: 75.2.60.5
  TTL: 3600

CNAME Record:
  Host: www
  Points to: tibstar-website.netlify.app
  TTL: 3600
```

**Why these values:**
- **75.2.60.5** = Netlify's load balancer IP
- **tibstar-website.netlify.app** = Your Netlify site URL
- **3600** = 1 hour cache time (standard)

---

## Quick Reference

| Item | Value |
|------|-------|
| **Domain** | tibstar.com |
| **Registrar** | eNom.com |
| **Target IP** | 75.2.60.5 |
| **Target CNAME** | tibstar-website.netlify.app |
| **Netlify Site** | https://tibstar-website.netlify.app |
| **DNS Checker** | https://dnschecker.org/#A/tibstar.com |

---

## Need Help?

If you encounter issues:
1. Take a screenshot of the eNom DNS interface
2. Check current DNS records: `nslookup tibstar.com`
3. Verify nameservers: `nslookup -type=NS tibstar.com`
4. Check eNom support: https://www.enom.com/help

---

**Once DNS is configured, your site will be live at https://tibstar.com!** 🚀
