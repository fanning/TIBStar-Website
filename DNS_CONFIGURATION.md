# DNS Configuration for tibstar.com

Your Netlify site is now deployed and configured! 🎉

---

## ✅ What's Been Set Up

- **Netlify Site**: https://tibstar-website.netlify.app
- **Admin Panel**: https://app.netlify.com/projects/tibstar-website
- **Custom Domain**: tibstar.com (configured in Netlify)
- **GitHub Integration**: Connected to https://github.com/fanning/TIBStar-Website
- **Auto-Deployment**: Enabled (push to GitHub → auto-deploy)
- **HTTPS**: Will auto-provision once DNS is configured

---

## 🌐 DNS Configuration Required

To make tibstar.com point to your Netlify site, you need to configure DNS at your domain registrar.

### Option 1: Use Netlify Load Balancer (Recommended)

Configure these DNS records at your domain registrar (where you bought tibstar.com):

#### For the main domain (tibstar.com):
```
Type: A
Name: @ (or leave blank for apex domain)
Value: 75.2.60.5
TTL: 3600 (or automatic)
```

#### For www subdomain (optional):
```
Type: CNAME
Name: www
Value: tibstar-website.netlify.app
TTL: 3600 (or automatic)
```

### Option 2: Use Netlify DNS (Easiest - Full Management)

1. Go to https://app.netlify.com/projects/tibstar-website/settings/domain
2. Click **"Set up Netlify DNS"**
3. Netlify will provide 4 nameservers like:
   - dns1.p03.nsone.net
   - dns2.p03.nsone.net
   - dns3.p03.nsone.net
   - dns4.p03.nsone.net
4. At your domain registrar, change nameservers to these 4 values
5. Wait for DNS propagation (usually 1-24 hours)

---

## 🔒 HTTPS Certificate

Once DNS is configured and propagated:

1. Go to https://app.netlify.com/projects/tibstar-website/settings/domain
2. Scroll to **"HTTPS"** section
3. Click **"Verify DNS configuration"**
4. Click **"Provision certificate"**
5. HTTPS will be automatically enabled via Let's Encrypt

**Note**: HTTPS provisioning will fail until DNS is properly configured and propagated.

---

## ✅ Testing DNS Propagation

Use these tools to check if DNS is working:

- **DNS Checker**: https://dnschecker.org/#A/tibstar.com
- **Dig Command**: `dig tibstar.com`
- **Nslookup**: `nslookup tibstar.com`

Expected result: Should resolve to **75.2.60.5** (Netlify's load balancer)

---

## 🚀 Your Automated Deployment Workflow

Now that everything is set up, updating your website is simple:

```bash
cd C:\Projects\TIBStar-Website

# Make changes to your files...

git add .
git commit -m "Description of changes"
git push

# Netlify automatically deploys within 30-60 seconds!
```

Watch deployments at: https://app.netlify.com/projects/tibstar-website/deploys

---

## 📊 Site Status

- **Current Deployment**: https://tibstar-website.netlify.app ✅
- **GitHub Repository**: https://github.com/fanning/TIBStar-Website ✅
- **Custom Domain**: tibstar.com (DNS configuration needed)
- **HTTPS**: Will enable after DNS is configured

---

## 🔧 Common Domain Registrars

### GoDaddy
1. Log in to GoDaddy
2. Go to **My Products** → **Domains**
3. Click **DNS** next to tibstar.com
4. Add the A record (Name: @, Value: 75.2.60.5)

### Namecheap
1. Log in to Namecheap
2. Go to **Domain List** → tibstar.com → **Manage**
3. Click **Advanced DNS**
4. Add the A record (Host: @, Value: 75.2.60.5)

### Cloudflare
1. Log in to Cloudflare
2. Select tibstar.com domain
3. Go to **DNS** → **Records**
4. Add the A record (Name: @, IPv4 address: 75.2.60.5, Proxy status: DNS only)

### Google Domains
1. Log in to Google Domains
2. Select tibstar.com
3. Go to **DNS**
4. Add custom record (Type: A, Name: @, Data: 75.2.60.5)

---

## ⚡ Quick Reference

| What | Value |
|------|-------|
| **Netlify Site URL** | https://tibstar-website.netlify.app |
| **Custom Domain** | tibstar.com |
| **Netlify Load Balancer IP** | 75.2.60.5 |
| **GitHub Repo** | https://github.com/fanning/TIBStar-Website |
| **Admin Panel** | https://app.netlify.com/projects/tibstar-website |

---

## 📝 Next Steps

1. **Configure DNS** at your domain registrar using Option 1 or 2 above
2. **Wait for propagation** (usually 1-24 hours, sometimes just minutes)
3. **Verify DNS** using dnschecker.org
4. **Enable HTTPS** in Netlify once DNS is working
5. **Test** by visiting https://tibstar.com

---

## 🎮 Update the Game Client

When you release a new version of the client:

```bash
# Build new client version
cd C:\Projects\TheInfiniteBlack\Build

# Copy to website downloads
cp TIB-Recompiled.zip C:\Projects\TIBStar-Website\downloads\

# Update website
cd C:\Projects\TIBStar-Website
# Edit index.html to update version number

git add downloads/TIB-Recompiled.zip index.html
git commit -m "Update client to version X.X.X"
git push

# Automatic deployment!
```

---

## 💡 Troubleshooting

### "Site not found" error
- DNS not configured yet
- DNS not propagated yet (check dnschecker.org)
- Clear browser cache

### "Not secure" warning
- HTTPS certificate not provisioned yet
- Verify DNS is working first
- Then provision certificate in Netlify

### Changes not deploying
- Check deploy log: https://app.netlify.com/projects/tibstar-website/deploys
- Verify git push succeeded: `git status`
- Check build status in Netlify dashboard

---

**Your site is ready!** Just configure DNS and you're live! 🚀
