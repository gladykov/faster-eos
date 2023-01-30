# This may and will brake you system. Use at your own risk.
# Made for Endeavour OS Cassini 22.10
# ASSUMPTIONS: You use GRUB2
#
# LOGIC: User should not think when applying this script.
# Ex. Linux-lqx Kernel is nice, if you configure tlp,
# otherwise it will drain your battery.
#
# RESOURCES
# https://www.linkedin.com/pulse/how-make-your-archlinux-faster-sourav-goswami/
# https://github.com/Th3Whit3Wolf/Faster-Arch
# https://wiki.archlinux.org/title/improving_performance
# https://wiki.archlinux.org/title/Makepkg#Tips_and_tricks


# Repository of builds optimized for x86-64-v3 https://git.harting.dev/ALHP/ALHP.GO
if /lib/ld-linux-x86-64.so.2 --help | grep -q 'x86-64-v3 (supported, searched)'; then
  echo "x86-64-v3 supported, switching to alph.go repo"

  yay -S alhp-keyring alhp-mirrorlist

  sudo sed -i "1 i\\
  [core-x86-64-v3]\\
  Include = /etc/pacman.d/alhp-mirrorlist\\
  \\
  [extra-x86-64-v3]\\
  Include = /etc/pacman.d/alhp-mirrorlist\\
  \\
  [community-x86-64-v3]\\
  Include = /etc/pacman.d/alhp-mirrorlist\\
  \\
  " /etc/pacman.conf

fi

# Compiler adjustments
sudo sed -E -i 's/-march=(\S*)/-march=native/' /etc/makepkg.conf
sudo sed -E -i 's/-O2/-O3/' /etc/makepkg.conf
sudo sed -E -i 's/#RUSTFLAGS=(.*)$/RUSTFLAGS="-C opt-level=2 -C target-cpu=native"/' /etc/makepkg.conf
sudo sed -E -i 's/#MAKEFLAGS=(.*)$/MAKEFLAGS="-j$(nproc)"/' /etc/makepkg.conf

# Upgrade everything
yay

# https://wiki.archlinux.org/title/D-Bus
yay -S dbus-broker
sudo systemctl disable dbus.service
sudo systemctl enable --now dbus-broker.service

# Enable OS prober for GRUB
sudo sed -i "/#GRUB_DISABLE_OS_PROBER=/c\GRUB_DISABLE_OS_PROBER=false" /etc/default/grub

# Use ananicy, so programs behave nicer
yay -S ananicy-cpp ananicy-rules
sudo systemctl enable --now ananicy-cpp.service

# Disable CPU bugs mitigations, enable cgroups 1 for ananicy
sudo sed -E -i "s/^GRUB_CMDLINE_LINUX_DEFAULT='(.*)'/GRUB_CMDLINE_LINUX_DEFAULT='\1 mitigations=off systemd.unified_cgroup_hierarchy=0'/" /etc/default/grub

# Filesystem improvements (all and ext4):
sudo sed -E -i 's/(ext4\s+defaults)/\1,commit=60/' /etc/fstab

# Apply changes to grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "Finished. Now reboot and pray."
