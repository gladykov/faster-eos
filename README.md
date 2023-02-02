# faster-eos
Tweaked defaults for EndeavourOS for speed.

Use optimized builds, build optimized builds, tweak some other "safe" properties.

https://sunnyflunk.github.io/2023/01/29/GCCs-O3-Can-Transform-Performance.html

Assumptions: You use GRUB. But will work without GRUB. Also aimed at desktop user. Read script before applying.

Warning: Enables O3 optimization for compiler, which may brake a package from time to time. If so, edit /etc/makepkg.conf
, set 02 and rebuild package.
