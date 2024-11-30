# Linux Utility Scripts

This repository contains useful utility scripts for Linux systems.

<!-- vim-markdown-toc GFM -->

* [Scripts Included](#scripts-included)
    * [1. YouTube-DLP Downloader](#1-youtube-dlp-downloader)
        * [Features](#features)
        * [Prerequisites](#prerequisites)
        * [Installation](#installation)
    * [2. Oh My Posh Updater](#2-oh-my-posh-updater)
        * [Features](#features-1)
        * [Prerequisites](#prerequisites-1)
        * [Installation](#installation-1)
    * [3. Tmux-Sessionizer](#3-tmux-sessionizer)
        * [Features](#features-2)
        * [Prerequisites](#prerequisites-2)
        * [Installation](#installation-2)
        * [Usage](#usage)
        * [Notes](#notes)
        * [Troubleshooting](#troubleshooting)
    * [4. Battery Threshold Service Script](#4-battery-threshold-service-script)
        * [Features](#features-3)
        * [Prerequisites](#prerequisites-3)
        * [Compatibility Check](#compatibility-check)
        * [Installation](#installation-3)
        * [Usage](#usage-1)
        * [Modifying Threshold](#modifying-threshold)
        * [Monitoring](#monitoring)
        * [Troubleshooting](#troubleshooting-1)
        * [Notes](#notes-1)
        * [Safety Features](#safety-features)
    * [5. Simple System Update Script](#5-simple-system-update-script)
        * [Features](#features-4)
        * [Prerequisites](#prerequisites-4)
        * [Installation](#installation-4)
        * [What the Script Does](#what-the-script-does)
        * [Output Example](#output-example)
        * [Notes](#notes-2)
        * [Troubleshooting](#troubleshooting-2)
        * [Safety Features](#safety-features-1)
    * [Simple System Update Script](#simple-system-update-script)
        * [Features](#features-5)
        * [Prerequisites](#prerequisites-5)
        * [Installation](#installation-5)
        * [What the Script Does](#what-the-script-does-1)
        * [Output Example](#output-example-1)
        * [Notes](#notes-3)
        * [Troubleshooting](#troubleshooting-3)
        * [Safety Features](#safety-features-2)
* [Contributing](#contributing)
* [License](#license)
* [Disclaimer](#disclaimer)
* [Credits](#credits)

<!-- vim-markdown-toc -->

## Scripts Included

### 1. YouTube-DLP Downloader

A feature-rich script for downloading videos and audio from YouTube using yt-dlp.

#### Features

- Download videos in best quality
- Extract audio (MP3 format)
- Download entire playlists (video or audio)
- Download videos with subtitles
- Optimized vertical video download
- Built-in yt-dlp updater
- Flexible download location options:
  - Downloads folder
  - Videos folder
  - Music folder
  - Custom path

#### Prerequisites

```bash
sudo apt install yt-dlp
```

#### Installation

1. Download the script:

```bash
wget https://github.com/merkksgit/scripts/yt-dlp-download.sh
```

2. Make it executable:

```bash
chmod +x yt-dlp-download.sh
```

3. Run the script:

```bash
./yt-dlp-download.sh
```

---

### 2. Oh My Posh Updater

A script to safely update Oh My Posh to the latest version with error handling and version checking.

#### Features

- Network connectivity check before downloading
- Current version detection
- Safe installation with verification
- Version comparison after update
- Error handling for all operations
- Temporary file cleanup

#### Prerequisites

- Oh My Posh must be already installed
- Requires sudo privileges

#### Installation

1. Download the script:

```bash
wget https://github.com/merkksgit/scripts/ohmyposhupdate.sh
```

2. Make it executable:

```bash
chmod +x ohmyposhupdate.sh
```

3. Run the script with sudo:

```bash
sudo ./ohmyposhupdate.sh
```

---

### 3. Tmux-Sessionizer

A powerful tmux workflow enhancement script that allows quick navigation between project directories and manages tmux sessions efficiently.

#### Features

- Fuzzy search through your project directories
- Automatic tmux session creation and management
- Seamless switching between projects
- Supports both keyboard shortcut and tmux prefix key
- Works both inside and outside tmux sessions

#### Prerequisites

- tmux
- fzf (fuzzy finder)

```bash
sudo apt install tmux fzf
```

#### Installation

1. Create the scripts directory and save the script:

```bash
mkdir -p ~/.local/scripts/
touch ~/.local/scripts/tmux-sessionizer
chmod +x ~/.local/scripts/tmux-sessionizer
```

2. Add the script content:

```bash
#!/usr/bin/env bash
if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ~/projects ~/tests -mindepth 1 -maxdepth 1 -type d | fzf)
fi
if [[ -z $selected ]]; then
    exit 0
fi
selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)
if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c $selected
    exit 0
fi
if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c $selected
fi
if [[ -z $TMUX ]]; then
    tmux attach -t $selected_name
else
    tmux switch-client -t $selected_name
fi
```

3. Configure your project paths:

   - Open the script and modify line 6:
   - Replace `~/projects ~/tests` with your project directories
   - Example: `selected=$(find ~/work ~/personal-projects ~/github -mindepth 1 -maxdepth 1 -type d | fzf)`

4. Add the script to your PATH by adding this line to `~/.bashrc`:

```bash
PATH="$PATH:$HOME/.local/scripts"
```

5. Set up keyboard shortcut by adding to `~/.bashrc` or `~/.bash_profile`:

```bash
bind -x '"\C-f":"tmux-sessionizer"'
```

6. Configure tmux by adding to `~/.tmux.conf`:

```
bind-key -r f run-shell "tmux neww ~/.local/scripts/tmux-sessionizer"
```

7. Apply changes:

```bash
source ~/.bashrc
```

#### Usage

There are two ways to use tmux-sessionizer:

1. Using keyboard shortcut:

   - Press `Ctrl + f`
   - Use fuzzy finder to select project
   - Press Enter to switch to that project

2. Using tmux prefix:
   - Press `prefix + f` (default prefix is Ctrl + b)
   - Select project using fuzzy finder
   - Press Enter to switch to that project

#### Notes

- The script creates a new tmux session if one doesn't exist for the selected project
- Session names are automatically generated from directory names
- Works both inside and outside existing tmux sessions
- Projects must be direct subdirectories of the configured paths

#### Troubleshooting

If the script isn't working:

1. Check if script is executable: `ls -l ~/.local/scripts/tmux-sessionizer`
2. Verify PATH includes scripts directory: `echo $PATH`
3. Ensure tmux and fzf are installed: `which tmux fzf`

---

### 4. Battery Threshold Service Script

A script to manage the battery charging threshold service on Linux systems, helping to extend battery lifespan by preventing constant 100% charging. Particularly useful for ASUS laptops and other compatible devices.

#### Features

- Enables battery charge threshold service
- Starts the service automatically
- Error handling and status verification
- Root privilege verification
- Clear status feedback
- Service health check

#### Prerequisites

- Linux system with battery threshold service capability
- Sudo privileges
- Systemd-based system

#### Compatibility Check

Before installation, verify your laptop supports battery threshold control:

1. Find your battery name:

```bash
ls /sys/class/power_supply
```

The output might show `BAT0`, `BAT1`, or `BATT`.

2. Check threshold support:

```bash
ls /sys/class/power_supply/BAT*/charge_control_end_threshold
```

If this command returns a path, your laptop supports charging thresholds. If it returns "No such file or directory," your device isn't compatible.

#### Installation

1. Create the service file:

```bash
sudo nvim /etc/systemd/system/battery-charge-threshold.service
```

2. Add the following content (customize according to your system):

```ini
[Unit]
Description=Set the battery charge threshold
After=multi-user.target
StartLimitBurst=0

[Service]
Type=oneshot
Restart=on-failure
ExecStart=/bin/bash -c 'echo CHARGE_STOP_THRESHOLD > /sys/class/power_supply/BATTERY_NAME/charge_control_end_threshold'

[Install]
WantedBy=multi-user.target
```

Replace:

- `BATTERY_NAME` with your battery name (e.g., `BAT0`, `BAT1`, or `BATT`)
- `CHARGE_STOP_THRESHOLD` with your desired charging limit (1-100)

3. Download the management script:

```bash
wget https://github.com/merkksgit/scripts/battery-charge-threshold.sh
```

4. Make it executable:

```bash
chmod +x battery-charge-threshold.sh
```

#### Usage

1. Run the script with sudo:

```bash
sudo ./battery-charge-threshold.sh
```

2. The script will:
   - Enable the threshold service
   - Start the service
   - Display the current service status

#### Modifying Threshold

To change the battery charging threshold:

1. Edit the service file:

```bash
sudo nvim /etc/systemd/system/battery-charge-threshold.service
```

2. Change the number in the `ExecStart` line

3. Reload and restart the service:

```bash
sudo systemctl daemon-reload
sudo systemctl restart battery-charge-threshold.service
```

#### Monitoring

Check charging status:

```bash
cat /sys/class/power_supply/BATTERY_NAME/status
```

Replace `BATTERY_NAME` with your battery identifier.

#### Troubleshooting

If you encounter issues:

1. Verify battery support:

```bash
ls /sys/class/power_supply/BAT*/charge_control_end_threshold
```

2. Check service status:

```bash
systemctl status battery-charge-threshold.service
```

3. View service logs:

```bash
journalctl -u battery-charge-threshold.service
```

4. Verify service file permissions:

```bash
ls -l /etc/systemd/system/battery-charge-threshold.service
```

#### Notes

- Different laptop brands might have different battery identifiers
- The threshold value must be between 1 and 100
- Some systems might require a reboot for changes to take effect
- This is particularly well-tested on ASUS laptops but may work on other brands

#### Safety Features

- Privilege verification
- Service status verification
- Error handling
- Clear status feedback
- Battery identifier verification

---

### 5. Simple System Update Script

A straightforward script for handling system updates on Debian/Ubuntu-based systems with basic error handling and disk space verification.

#### Features

- Automated system update and upgrade
- Error handling and privilege checks
- Disk space verification
- Clear status messages
- Non-interactive upgrade mode (-y flag)

#### Prerequisites

- Debian/Ubuntu-based Linux system
- Sudo privileges

#### Installation

1. Download the script:

```bash
wget https://github.com/merkksgit/scripts/update-apt.sh
```

2. Make it executable:

```bash
chmod +x update-apt.sh
```

3. Run the script with sudo:

```bash
sudo ./update-apt.sh
```

#### What the Script Does

1. **System Update**

   - Updates package lists (`apt update`)
   - Upgrades installed packages (`apt upgrade -y`)

2. **System Status**

   - Displays available disk space after update
   - Shows update completion status

3. **Safety Features**
   - Checks for root privileges
   - Handles errors during update process
   - Verifies successful completion

#### Output Example

```
Updating package lists...
Package lists updated successfully

Upgrading packages...
System update completed successfully!

System status:
Available disk space:
Filesystem      Size  Used  Avail  Use%  Mounted on
/dev/sda1       100G   50G    50G   50%  /
```

#### Notes

- Non-interactive mode is enabled by default (-y flag)
- Script requires sudo privileges
- Basic error handling is implemented
- Disk space check included for verification

#### Troubleshooting

If you encounter issues:

1. Verify sudo privileges:

```bash
sudo whoami
```

2. Check internet connectivity:

```bash
ping -c 4 google.com
```

3. Verify sufficient disk space:

```bash
df -h /
```

#### Safety Features

- Root privilege verification
- Error handling for update and upgrade processes
- Status feedback after each operation

### Simple System Update Script

A straightforward script for handling system updates on Debian/Ubuntu-based systems with basic error handling and disk space verification.

#### Features

- Automated system update and upgrade
- Error handling and privilege checks
- Disk space verification
- Clear status messages
- Non-interactive upgrade mode (-y flag)

#### Prerequisites

- Debian/Ubuntu-based Linux system
- Sudo privileges

#### Installation

1. Download the script:

```bash
wget https://github.com/merkksgit/scripts/update-apt.sh
```

2. Make it executable:

```bash
chmod +x update-apt.sh
```

3. Run the script with sudo:

```bash
sudo ./update-apt.sh
```

#### What the Script Does

1. **System Update**

   - Updates package lists (`apt update`)
   - Upgrades installed packages (`apt upgrade -y`)

2. **System Status**

   - Displays available disk space after update
   - Shows update completion status

3. **Safety Features**
   - Checks for root privileges
   - Handles errors during update process
   - Verifies successful completion

#### Output Example

```
Updating package lists...
Package lists updated successfully

Upgrading packages...
System update completed successfully!

System status:
Available disk space:
Filesystem      Size  Used  Avail  Use%  Mounted on
/dev/sda1       100G   50G    50G   50%  /
```

#### Notes

- Non-interactive mode is enabled by default (-y flag)
- Script requires sudo privileges
- Basic error handling is implemented
- Disk space check included for verification

#### Troubleshooting

If you encounter issues:

1. Verify sudo privileges:

```bash
sudo whoami
```

2. Check internet connectivity:

```bash
ping -c 4 google.com
```

3. Verify sufficient disk space:

```bash
df -h /
```

#### Safety Features

- Root privilege verification
- Error handling for update and upgrade processes
- Status feedback after each operation

## Contributing

Feel free to submit issues and enhancement requests!

## License

[MIT License](LICENSE)

## Disclaimer

These scripts are provided as-is, without any warranty. Always review scripts before running them on your system.

## Credits

- [yt-dlp](https://github.com/yt-dlp/yt-dlp) for the YouTube downloader
- [Oh My Posh](https://ohmyposh.dev/) for the prompt engine
- [ThePrimeagen](https://github.com/ThePrimeagen/) for the Tmux-sessionizer
