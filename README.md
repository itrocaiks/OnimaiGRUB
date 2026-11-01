# **Oniichan wa Oshimai!** GRUB theme v0.4.0

![Onimai (without option menu) theme preview](/themes/onimai/preview/preview.png)

<p align="right">— Only for true fans of <i>Oniichan wa Oshimai!</i></p>

## What's new?

- Formatted theme.txt
- Changed **terminal font** to Unifont which is easier to read (Anime font as **message font** preserved in boot menu)
- Added QEMU test script to preview the GRUB theme
- Merged themes with/without option menu together and unified the theme name

In 0.3.1:

- Enhanced robustness of install/uninstall scripts
- Formatted output
- Decapitalized topic key for consistency
- Moved all themes into `themes/` for varieties of themes to be accommodated in the future

In 0.3:

- Added Russian font
- Added option menu (can be installed by choice)

## Requirements

- `Git >= 1.6.6`
- `GRUB >= 2.00`

### `Git`

For Debian/Ubuntu:

``` bash
sudo apt-get install git
```

For Red Hat/Fedora:

``` bash
sudo yum install git
```

For Arch/Manjaro:

``` bash
sudo pacman -S git
```

For Gentoo:
``` bash
sudo emerge -av git
```

### `GRUB`

Make sure you're using GRUB as your bootloader.

``` bash
grub-install --version
```

## Installation

Clone this repository (pay attention to modified repo address if needed):

``` bash
git clone https://github.com/zenith-chan/OnimaiGRUB.git
```

Or if you use SSH protocol:

``` bash
git clone git@github.com:zenith-chan/OnimaiGRUB.git
```

Then run the install script:

``` bash
cd ~/OnimaiGRUB
sudo chmod +x ./install.sh ./uninstall.sh
sudo ./install.sh
```

## Uninstallation

``` bash
cd ~/OnimaiGRUB
sudo ./uninstall.sh
```

## Gnome-Look page

https://www.gnome-look.org/p/2136009