# 🚀 Antigravity Installer for Arch / Garuda / Manjaro

![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)
![Shell Script](https://img.shields.io/badge/Shell_Script-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)
![Stars](https://img.shields.io/github/stars/ashishdevpandey/antigravity-installer?style=for-the-badge)

A simple one-shot script to install **Google Antigravity** on any Arch-based distro.  
No hunting for dependencies, no manual fixes — everything is automated.

---

## ✨ Features

| Feature | Description |
| :--- | :--- |
| 📦 **Automated Install** | Installs latest Antigravity from Google’s APT repo |
| 🛡️ **Sandbox Fix** | Auto-fixes `chrome-sandbox` permissions |
| 🧩 **Dependency Hell? Gone.** | Auto-installs missing libs (`libnotify`, `nss`, `libcups`, etc.) |
| 🔔 **Notification Fix** | Auto-installs + enables **dunst** to prevent UI freezes |
| 🖥️ **Desktop Integration** | Creates desktop entries + binary launcher |
| 🧹 **Clean Uninstall** | Built-in uninstaller to remove all traces |

---

##  Installation

### 1. Clone the repo
```bash
git clone https://github.com/ashishdevpandey/antigravity-installer.git
cd antigravity-installer
```

### 2. Make it executable
```bash
chmod +x antigravity-installer.sh
```

### 3. Run it 🚀
```bash
./antigravity-installer.sh
```

That's it! Antigravity will be available as:
```bash
antigravity
```

---

## ❌ Uninstall

Want to remove it? No problem.

```bash
./antigravity-installer.sh --uninstall
```

This will remove:
- `/opt/antigravity`
- `/usr/local/bin/antigravity`
- Desktop entries & Icons
- Dunst autostart entry

---

## 🔧 What does this script actually do?

1.  **Downloads** the latest Linux build from the official Google repo.
2.  **Fixes** sandbox (`chrome-sandbox`) permissions which often break Electron apps on Arch.
3.  **Installs** needed libraries: `libnotify`, `gtk3`, `nss`, `libcups`, `libxss`, etc.
4.  **Configures Dunst**: Without a notification daemon, Antigravity often freezes or hangs. This script ensures `dunst` is installed and autostarted.
5.  **Creates Launchers**: Sets up `~/.local/share/applications/antigravity.desktop` and a global binary.

---

## 🖥 Tested On

- ✅ **Garuda Linux**
- ✅ **Arch Linux**
- ✅ **Manjaro**
- ✅ **EndeavourOS**

---

## ⚡ Notes

> [!NOTE]
> Google does not provide official Arch packages, so this script bridges the gap.

> [!TIP]
> If you're on **Wayland** and see weird rendering issues, try launching with:
> ```bash
> antigravity --ozone-platform=x11
> ```

---

## 📦 AUR Package

*Coming soon!* You will be able to install it directly via `yay` or `paru`:

```bash
# Future support
yay -S antigravity-bin
```

---

## ⭐ Contribute

PRs and suggestions are always welcome!  
If you improve the script or add support for more environments, feel free to open a pull request.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## ❤️ Thanks

This installer exists so Arch users don’t have to manually extract `.deb` files or fight with Electron sandbox issues.  
**Enjoy using Antigravity the easy way!**
