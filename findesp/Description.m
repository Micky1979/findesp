//
//  Description.m
//  findesp
//
//  Created by Micky1979 on 27/01/18.
//  Copyright © 2018 Micky1979. All rights reserved.
//
// This code comes from Clover Configurator Pro.app (https://github.com/Micky1979/Clover-Configurator-Pro)
// converted back from Swift 4.
// Released under GPLv3 (https://www.gnu.org/licenses/gpl-3.0.en.html)
// (i.e. must be used only in free sowftware with opensourced code)
//

#import "Description.h"

@implementation Description
+ (NSDictionary *)getDescriptionsFrom:(NSString*)diskOrMountPoint {
  NSString *device;
  NSDictionary *dict;
  int                 err = 0;
  DADiskRef           disk = NULL;
  DASessionRef        session;
  CFDictionaryRef     descDict = NULL;
  CFURLRef            volURL;
  
  session = DASessionCreate(NULL);
  if (session == NULL) err = EINVAL;
  
  if ([diskOrMountPoint hasPrefix:@"/"] &&
      ![diskOrMountPoint hasPrefix:@"/dev/disk"] &&
      ![diskOrMountPoint hasPrefix:@"disk"] &&
      [[NSFileManager defaultManager] fileExistsAtPath:diskOrMountPoint] &&
      (err == 0)) {
    volURL = (CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:diskOrMountPoint]);
    disk = DADiskCreateFromVolumePath(NULL, session, volURL);
  }
  else if (([diskOrMountPoint hasPrefix:@"/dev/disk"] || [diskOrMountPoint hasPrefix:@"disk"])
           && (err == 0)) {
    if ([diskOrMountPoint hasPrefix:@"/dev/disk"]) {
      device = [diskOrMountPoint stringByReplacingOccurrencesOfString:@"/dev/" withString:@""];
    } else {
      device = diskOrMountPoint;
    }
    disk = DADiskCreateFromBSDName(NULL, session, [device UTF8String]);
  } else {
    // too bad!!
    return NULL;
  }
  
  if (session == NULL) err = EINVAL;
  
  if (err == 0) {
    descDict = DADiskCopyDescription(disk);
    if (descDict == NULL) err = EINVAL;
    
    dict = [NSDictionary dictionaryWithDictionary:(NSDictionary*)CFBridgingRelease(descDict)];
    return dict;
  }
  return NULL;
}

+ (NSArray *)findEFIDisks {
  CFMutableDictionaryRef match_dictionary = IOServiceMatching("IOMedia");
  io_iterator_t entry_iterator;
  NSMutableArray *esps = [NSMutableArray array];
  if (IOServiceGetMatchingServices(kIOMasterPortDefault,
                                   match_dictionary,
                                   &entry_iterator) == kIOReturnSuccess) {
    io_registry_entry_t serviceObject;
    while ((serviceObject = IOIteratorNext(entry_iterator))) {
      CFMutableDictionaryRef serviceDictionary;
      if (IORegistryEntryCreateCFProperties(serviceObject,
                                            &serviceDictionary,
                                            kCFAllocatorDefault,
                                            kNilOptions) != kIOReturnSuccess) {
        continue;
      }
      const void *bsd = CFDictionaryGetValue(serviceDictionary, @kIOBSDNameKey);
      if (bsd) {
        NSString *disk = CFBridgingRelease(bsd);
        
        NSDictionary *desc = [self getDescriptionsFrom:disk];
        NSString *DAMediaName = [desc objectForKey:[NSString stringWithFormat:@"%@", kDADiskDescriptionMediaNameKey]];
        
        if ([DAMediaName.lowercaseString isEqualToString:@"efi system partition"]) {
          [esps addObject:disk];
        }
      }
    }
  }
  return esps;
}

@end
