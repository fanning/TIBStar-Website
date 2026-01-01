# Netlify Setup for TIBStar.com

Your website is now on GitHub at: https://github.com/fanning/TIBStar-Website

Follow these steps to connect it to Netlify for automatic deployment.

---

## Step 1: Sign Up / Log In to Netlify

1. Go to https://app.netlify.com/signup
2. Click **"Sign up with GitHub"** (recommended for easy integration)
3. Authorize Netlify to access your GitHub account

---

## Step 2: Import Your Repository

1. Once logged in, click **"Add new site"** → **"Import an existing project"**
2. Choose **"Deploy with GitHub"**
3. You may need to authorize Netlify to access your repositories (click "Configure the Netlify app on GitHub")
4. Search for **"TIBStar-Website"** and click on it
5. Configure build settings:
   - **Branch to deploy**: `main`
   - **Build command**: (leave empty)
   - **Publish directory**: `/` (or leave empty for root)
   - **Advanced settings**: No changes needed
6. Click **"Deploy TIBStar-Website"**

---

## Step 3: Wait for Initial Deployment

Netlify will automatically deploy your site. This takes about 30-60 seconds.

You'll see:
- "Site deploy in progress"
- Then "Site is live" with a random URL like `https://wonderful-cupcake-a1b2c3.netlify.app`

Click the URL to view your live website!

---

## Step 4: Add Custom Domain (tibstar.com)

### 4.1 Add Domain in Netlify

1. In your site dashboard, go to **"Domain settings"**
2. Click **"Add custom domain"**
3. Enter: `tibstar.com`
4. Click **"Verify"** → **"Add domain"**
5. Netlify may warn that you need to configure DNS - that's expected!

### 4.2 Optional: Add www Subdomain

1. Click **"Add domain alias"**
2. Enter: `www.tibstar.com`
3. Click **"Add alias"**

### 4.3 Configure DNS

You have two options:

#### Option A: Use Netlify DNS (Recommended - Easiest)

1. In Domain settings, click **"Set up Netlify DNS"**
2. Click **"Verify"** → **"Add domain"**
3. Netlify will show you 4 nameservers like:
   - dns1.p03.nsone.net
   - dns2.p03.nsone.net
   - dns3.p03.nsone.net
   - dns4.p03.nsone.net
4. **Go to your domain registrar** (where you bought tibstar.com)
5. **Change nameservers** to the 4 Netlify provided
6. **Wait** 24-48 hours for DNS propagation (usually much faster)

#### Option B: Keep Your Current DNS (Manual Configuration)

If you want to keep your current nameservers:

**For apex domain (tibstar.com):**
1. Go to your domain registrar's DNS settings
2. Add an **A record**:
   - Type: `A`
   - Name: `@` or leave blank
   - Value: `75.2.60.5` (Netlify's load balancer)
   - TTL: `3600` or automatic

**For www subdomain:**
1. Add a **CNAME record**:
   - Type: `CNAME`
   - Name: `www`
   - Value: `wonderful-cupcake-a1b2c3.netlify.app` (use YOUR Netlify URL)
   - TTL: `3600` or automatic

---

## Step 5: Enable HTTPS

Once DNS is configured and propagated:

1. Go to **"Domain settings"** → **"HTTPS"**
2. Netlify will automatically show **"Provision certificate"**
3. Click **"Verify DNS configuration"** (wait if DNS hasn't propagated yet)
4. Click **"Provision certificate"**
5. Wait 1-2 minutes for Let's Encrypt certificate to be issued

**HTTPS will be automatically enabled!**

You can also enable:
- **"Force HTTPS"** - redirects all HTTP to HTTPS (recommended)

---

## Step 6: Test Automatic Deployment

Now the magic happens! Let's test the automated deployment:

1. **On your computer**, make a small change to the website:
   ```bash
   cd C:\Projects\TIBStar-Website
   ```

2. **Edit a file** (example: update the version in index.html)

3. **Commit and push**:
   ```bash
   git add .
   git commit -m "Test automatic deployment"
   git push
   ```

4. **Watch Netlify deploy automatically!**
   - Go to your Netlify dashboard → **"Deploys"** tab
   - You'll see a new deploy trigger within seconds
   - It takes 30-60 seconds to build and deploy
   - Your live site updates automatically!

---

## Summary: What You Have Now

✅ **GitHub Repository**: https://github.com/fanning/TIBStar-Website
✅ **Automatic Deployments**: Push to GitHub → Auto-deploy to Netlify
✅ **Live Website**: https://your-site.netlify.app
✅ **Custom Domain Ready**: Configure DNS for tibstar.com
✅ **Free HTTPS**: Automatic SSL certificates

---

## Future Updates

To update your website:

```bash
cd C:\Projects\TIBStar-Website

# Make changes to files...

git add .
git commit -m "Description of changes"
git push

# Netlify automatically deploys within 1 minute!
```

To update the client download:
1. Replace `downloads/TIB-Recompiled.zip` with new version
2. Update version number in `index.html`
3. Commit and push
4. Automatic deployment happens!

---

## Troubleshooting

### "Deploy failed"
- Check the deploy log in Netlify dashboard
- Ensure all files are committed to GitHub
- Verify branch is `main`

### "Domain not working"
- DNS propagation can take 24-48 hours
- Use https://dnschecker.org to verify DNS records
- Clear browser cache (Ctrl+Shift+R)

### "HTTPS certificate fails"
- Ensure DNS is properly configured first
- Wait for DNS to propagate completely
- Try "Verify DNS configuration" again after waiting

### "Site not updating"
- Check that you pushed to GitHub: `git push`
- Check deploy log in Netlify for errors
- Verify you're on the correct branch: `git branch`

---

## Need Help?

- Netlify Documentation: https://docs.netlify.com
- Netlify Support: https://www.netlify.com/support/
- DNS Checker: https://dnschecker.org

---

**Your GitHub repository is live!**
Visit: https://github.com/fanning/TIBStar-Website

**Next step**: Follow the Netlify setup above to deploy your website!
