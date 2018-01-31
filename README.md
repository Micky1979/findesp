# findesp
Command Line to find the associated EFI System Partition from a given disk object or mount point

## Usage
``` bash
findesp /
```
or
``` bash
findesp /dev/disk04s3
```
or
``` bash
findesp disk05s2
```
or
``` bash
findesp disk2
```

It returns the BSD Name of the ESP like "disk0s1"

Also support finding associated ESP of the phisycal disk of any apfs container/apfs partition, corestorage/file vault and so on.

I made this script for Clover Bootloader/Chameleon/Enoch if devs are intrested, may be used in the installer.

# How to build it from command line
``` bash
cd /folder/containing/findesp/findesp.xcodeproj
xcodebuild -project findesp.xcodeproj -alltargets -configuration Release
```
...binary should be found at  ../findesp/build/Release/


# how to use in a script
Bashers can found easy to check for the output this way:

``` bash
#!/bin/bash
disk="disk2" # suppose is an apfs container

esp=`findesp $disk`

if [[ -n $esp ]] && [[ $esp == disk* ]] ; then
  echo "EFI System Partition for $disk is $esp"
else
  echo "ESP not found.."
fi
```
