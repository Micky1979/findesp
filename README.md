# findesp
Command Line to find the associated EFI System Partition from a given disk object or mount point

## Usage
``` bash
findesp /
```
or
``` bash
findesp /dev/disk04s1
```
or
``` bash
findesp disk05s1
```
or
``` bash
findesp disk2
```

It returns the BSD Name of the ESP like "disk0s1"
Also support finding associated ESP of any apfs container or apfs partition.

I made this script for Clover Bootloader/Chameleon/Enoch if devs are intrested, may be used in the installer.

# How to build it from command line
``` bash
cd /folder/containing/findesp
xcodebuild -project findesp.xcodeproj -alltargets -configuration Release
```
...binary should be found at  ../findesp/build/Release/
