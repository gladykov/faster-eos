# This may and will brake you system. Use at your own risk.
# Made for Endeavour OS Cassini 22.10
# ASSUMPTIONS: You use GRUB2, but will work for non grub systems also
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
  " /etc/pacman.conf

fi

# Compiler adjustments
# https://sunnyflunk.github.io/2023/01/29/GCCs-O3-Can-Transform-Performance.html
# https://old.reddit.com/r/archlinux/comments/oflged/alhp_archlinux_recompiled_for_x8664v3_experimental/
sudo sed -E -i 's/-march=(\S*)/-march=native/' /etc/makepkg.conf
sudo sed -E -i 's/-mtune=(\S*)//' /etc/makepkg.conf
sudo sed -E -i 's/-O2/-O3/' /etc/makepkg.conf
sudo sed -E -i 's/#RUSTFLAGS=(.*)$/RUSTFLAGS="-C opt-level=2 -C target-cpu=native"/' /etc/makepkg.conf
sudo sed -E -i 's/#MAKEFLAGS=(.*)$/MAKEFLAGS="-j$(nproc)"/' /etc/makepkg.conf
sudo sed -i 's/COMPRESSZST=(zstd/COMPRESSZST=(zstd -1/' /etc/makepkg.conf

# Upgrade everything
yay

# Enable OS prober for GRUB
sudo sed -i "/#GRUB_DISABLE_OS_PROBER=/c\GRUB_DISABLE_OS_PROBER=false" /etc/default/grub

# Use ananicy, so programs behave nicer
yay -S ananicy-cpp ananicy-rules
sudo systemctl enable --now ananicy-cpp.service

# Use better WiFi daemon
# https://wiki.archlinux.org/title/iwd
yay -S iwd
sudo printf "[device]\nwifi.backend=iwd\n" >> /etc/NetworkManager/conf.d/wifi_backend.conf

# Disable CPU bugs mitigations, enable cgroups 1 for ananicy
# https://old.reddit.com/r/linux/comments/9z0x58/how_dangerous_it_might_actually_be_to_just/
sudo sed -E -i "s/^GRUB_CMDLINE_LINUX_DEFAULT='(.*)'/GRUB_CMDLINE_LINUX_DEFAULT='\1 mitigations=off systemd.unified_cgroup_hierarchy=0'/" /etc/default/grub

# Filesystem improvements (all and ext4):
sudo sed -E -i 's/(ext4\s+defaults)/\1,commit=60/' /etc/fstab

# Apply changes to grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "Finished. Please reboot."
