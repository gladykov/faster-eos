# faster-eos
Tweaked defaults for EndeavourOS for speed.

* building packages build with optimisations for your processor - by default packages are build for all processors
* downloading optimized packages for newer processors (if your processor supports it)
* protection against processor bugs is turned off - as there is a small risk someone will execute harmful attack this way
* dbus service replaced for one build for performance
* ananicy installed so processes will not take too much processor power
* some filesystem improvement to decrease writes
* bonus: OS prober enabled by default - this is a common question coming from people switching from Win

Assumptions: You use GRUB. But will work without GRUB. Also aimed at desktop user. Read script before applying.


To run: Download faster-eos.sh , open terminal and run:

```
chmod +x faster-eos.sh
./faster-eos.sh
```
