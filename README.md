# 🚀 Antigravity Installation Guide

Official guide to install **Antigravity** on your Linux system.

---

## 📥 Step 1: Download & Extract

First, download the official package from the site below:

👉 **[Download Antigravity Official](https://antigravity.google/download)**

Once downloaded, extract the archive using the following command:

```bash
tar -xzf Antigravity.tar.gz
```

---

## 📂 Step 2: Move to Optimal Location

It is standard practice to store manually installed programs in `/opt` or `/usr/local`. This command moves the extracted folder to `/opt`:

```bash
sudo mv Antigravity /opt/antigravity
```

---

## 🔗 Step 3: Create a Global Command (Symlink)

To launch the app by simply typing `antigravity` in any terminal window, create a symbolic link to the binary:

```bash
sudo ln -sf /opt/antigravity/bin/antigravity /usr/local/bin/antigravity
```

---

## 🖥️ Step 4: Create a Desktop Entry (App Icon)

To add Antigravity to your application menu with an icon, create a desktop entry:

1. Open the editor:
   ```bash
   sudo nano /usr/share/applications/antigravity.desktop
   ```

2. Paste the following content:
   ```ini
    [Desktop Entry]
    Name=Antigravity
    Comment=AI-powered IDE
    Exec=/opt/antigravity/antigravity --no-sandbox %F
    Icon=/opt/antigravity/resources/app/out/vs/workbench/contrib/antigravityCustomAppIcon/browser/media/antigravity/antigravity.png
    Terminal=false
    Type=Application
    Categories=Development;IDE;
    StartupWMClass=antigravity
    ```

3. **Save and Update**:
   - In nano: Press `Ctrl+O`, then `Enter`, then `Ctrl+X` to exit.
   - Run the following command to update the application database:
   ```bash
   sudo update-desktop-database
   ```

---

## 🔄 How to Update

If you want to update **Antigravity** to a newer version, follow these steps to ensure a clean install:

1. **Remove Old Files**:
   Delete the existing installation folder:
   ```bash
   sudo rm -rf /opt/antigravity
   ```

2. **Redo Installation**:
   Follow **Step 2** and **Step 3** again with your new downloaded files. Since your `.desktop` file and symlinks are already set up, the app will start working immediately with the new version.

---

## ✨ Done!
You can now launch **Antigravity** from your application launcher or by typing `antigravity` in the terminal.
