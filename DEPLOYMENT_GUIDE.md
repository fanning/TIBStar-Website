# TIBStar.com Deployment Guide

## Automated GitHub → Netlify Deployment

This guide will help you set up automatic deployment from GitHub to Netlify.

---

## Step 1: Create GitHub Repository

### Option A: Using GitHub Website (Easiest)

1. Go to https://github.com/new
2. Fill in the repository details:
   - **Repository name**: `TIBStar-Website` (or your preferred name)
   - **Description**: "Download website for The Infinite Black recompiled client"
   - **Visibility**: Public (required for free Netlify)
   - **DO NOT** initialize with README, .gitignore, or license (we already have these)
3. Click **Create repository**
4. Copy the repository URL (should look like: `https://github.com/yourusername/TIBStar-Website.git`)

### Option B: Using GitHub CLI

If you have `gh` CLI installed:

```bash
cd C:\Projects\TIBStar-Website
gh repo create TIBStar-Website --public --source=. --remote=origin --description="Download website for The Infinite Black recompiled client"
```

---

## Step 2: Push to GitHub

Once you have created the repository, run these commands:

```bash
cd C:\Projects\TIBStar-Website

# Add GitHub as remote (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/TIBStar-Website.git

# Push to GitHub
git branch -M main
git push -u origin main
```

**Note**: You may be prompted for GitHub credentials. Use a Personal Access Token (PAT) instead of your password.

To create a PAT:
1. Go to https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Select scope: `repo` (full control of private repositories)
4. Copy the token and use it as your password when pushing

---

## Step 3: Connect Netlify to GitHub

### 3.1 Create Netlify Account

1. Go to https://netlify.com
2. Click **Sign up** and choose **GitHub** to sign in
3. Authorize Netlify to access your GitHub account

### 3.2 Deploy from GitHub

1. Click **Add new site** → **Import an existing project**
2. Choose **GitHub** as your Git provider
3. Authorize Netlify to access your repositories if prompted
4. Search for and select **TIBStar-Website** repository
5. Configure build settings:
   - **Branch to deploy**: `main`
   - **Build command**: (leave empty - static site)
   - **Publish directory**: `/` (root directory)
6. Click **Deploy site**

### 3.3 Configure Custom Domain

1. Once deployed, go to **Site settings** → **Domain management**
2. Click **Add custom domain**
3. Enter: `tibstar.com`
4. Click **Verify**
5. Netlify will provide DNS records to configure

### 3.4 Update DNS Records

Go to your domain registrar (where you bought tibstar.com) and add these records:

**For apex domain (tibstar.com):**
- Type: `A`
- Name: `@`
- Value: `75.2.60.5` (Netlify's load balancer IP)

**For www subdomain:**
- Type: `CNAME`
- Name: `www`
- Value: `your-site-name.netlify.app`

**Or use Netlify DNS (recommended):**
1. In Netlify, click **Set up Netlify DNS**
2. Follow the instructions to change nameservers at your registrar
3. Update nameservers to Netlify's provided values

---

## Step 4: Enable HTTPS

1. In Netlify **Domain management**, scroll to **HTTPS**
2. Click **Verify DNS configuration**
3. Once verified, click **Provision certificate**
4. HTTPS will be automatically enabled (usually takes a few minutes)

---

## Automated Deployment

Now that everything is connected:

1. Make changes to your website locally
2. Commit changes: `git add . && git commit -m "Update website"`
3. Push to GitHub: `git push`
4. **Netlify automatically detects the push and deploys!** ✨

You can watch the deployment progress at: `https://app.netlify.com/sites/YOUR_SITE_NAME/deploys`

---

## Quick Reference Commands

```bash
# Navigate to website directory
cd C:\Projects\TIBStar-Website

# Check status
git status

# Add changes
git add .

# Commit changes
git commit -m "Description of changes"

# Push to GitHub (triggers Netlify deployment)
git push

# View commit history
git log --oneline

# View remote URL
git remote -v
```

---

## Updating the Client

To update the client download:

1. Replace `downloads/TIB-Recompiled.zip` with new version
2. Edit `index.html` and update:
   - Version number in the download section
   - "Updated" date
3. Commit and push:
   ```bash
   git add downloads/TIB-Recompiled.zip index.html
   git commit -m "Update client to version X.X.X"
   git push
   ```
4. Netlify will automatically deploy the update within 1-2 minutes

---

## Troubleshooting

### Build fails on Netlify
- Check the deploy log in Netlify dashboard
- Ensure all files are committed and pushed to GitHub
- Verify publish directory is set to `/`

### Domain not working
- DNS changes can take up to 48 hours to propagate
- Use https://dnschecker.org to verify DNS records
- Ensure you're using Netlify's correct IP or CNAME

### HTTPS certificate fails
- Ensure DNS is properly configured and propagated
- CAA records (if any) must allow Let's Encrypt
- Contact Netlify support if issue persists

### Changes not appearing
- Check Netlify deploy log to see if deployment succeeded
- Clear browser cache (Ctrl+Shift+R)
- Verify you pushed to the correct branch (`main`)

---

## Current Setup Status

- [x] Git repository initialized
- [x] Initial commit created
- [ ] GitHub repository created
- [ ] Pushed to GitHub
- [ ] Netlify connected
- [ ] Custom domain configured
- [ ] HTTPS enabled

---

## Next Steps

1. Create GitHub repository using instructions in Step 1
2. Run the commands in Step 2 to push to GitHub
3. Follow Step 3 to connect Netlify
4. Configure your domain in Step 3.3 and 3.4

**Your local repository is ready!** Just follow the steps above to complete the deployment.
