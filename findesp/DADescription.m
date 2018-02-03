//
//  DADescription.m
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

#import "DADescription.h"

@implementation DADescription
+ (NSDictionary *)getDescriptionsFrom:(NSString*)diskOrMountPoint {
  int                 err = 0;
  DADiskRef           disk = NULL;
  DASessionRef        session;
  CFDictionaryRef     descDict = NULL;
  CFURLRef            volURL = NULL;
  session = DASessionCreate(NULL);
  if (session == NULL) err = EINVAL;
  
  if (err == 0) {
    if (([diskOrMountPoint hasPrefix:@"/dev/disk"] || [diskOrMountPoint hasPrefix:@"disk"])) {
      NSString *bsd;
      if ([diskOrMountPoint hasPrefix:@"/dev/disk"] ) {
        bsd = [diskOrMountPoint stringByReplacingOccurrencesOfString:@"/dev/" withString:@""];
      } else {
        bsd = diskOrMountPoint;
      }
      disk = DADiskCreateFromBSDName(NULL,
                                     session,
                                     bsd.UTF8String);
    } else if ([[NSFileManager defaultManager] fileExistsAtPath:diskOrMountPoint]) {
      
      volURL = CFBridgingRetain([NSURL fileURLWithPath:diskOrMountPoint]);
      disk = DADiskCreateFromVolumePath(NULL,
                                        session,
                                        volURL);
      
      if (volURL) {
        CFRelease(volURL);
      }
    }
    
    if (session) {
      CFRelease(session);
    }
    
    if (disk != NULL) {
      descDict = DADiskCopyDescription(disk);
      CFRelease(disk);
      if (descDict != NULL) {
        return [NSDictionary dictionaryWithDictionary:(NSDictionary*)CFBridgingRelease(descDict)];
      }
    }
  }
  return nil;
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
      CFMutableDictionaryRef serviceDictionary = NULL;
      if (IORegistryEntryCreateCFProperties(serviceObject,
                                            &serviceDictionary,
                                            kCFAllocatorDefault,
                                            kNilOptions) != kIOReturnSuccess) {
        continue;
      }
      const void *bsd = CFDictionaryGetValue(serviceDictionary, @kIOBSDNameKey);
      
      if (serviceDictionary != NULL) {
        CFRelease(serviceDictionary);
      }
      
      if (bsd) {
        NSString *disk = CFBridgingRelease(bsd);
        NSDictionary *desc = [self getDescriptionsFrom:disk];
        if (desc != nil) {
          NSString *DAMediaName = [desc objectForKey:[NSString stringWithFormat:@"%@", kDADiskDescriptionMediaNameKey]];
          if ([DAMediaName.lowercaseString isEqualToString:@"efi system partition"]) {
            [esps addObject:disk];
          }
        }
      }
    }
  }
  return esps;
}

@end
