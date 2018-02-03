//
//  main.m
//  findesp
//
//  Created by Micky1979 on 27/01/18.
//  Copyright © 2018 Micky1979. All rights reserved.
//
// This code comes from Clover Configurator Pro.app (https://github.com/Micky1979/Clover-Configurator-Pro)
// converted back from Swift 4
// Released under GPLv3 (https://www.gnu.org/licenses/gpl-3.0.en.html)
// (i.e. must be used only in free sowftware with opensourced code)
//

#import <Foundation/Foundation.h>
#import "DADescription.h"

#define cmdVersion "1.1"

int main(int argc, const char * argv[]) {
  @autoreleasepool {
    if (argc == 2) {
      if (strcmp(argv[1], "-v") == 0) {
        printf("findesp version %s\n", cmdVersion);
        return 0;
      }
      
      NSDictionary *desc = [DADescription getDescriptionsFrom:[NSString stringWithFormat:@"%s", argv[1]]];

      if (desc == nil) {
        exit(EXIT_FAILURE); // that means user given as argument an invalid or not existing disk or mount point
      }
      
      NSString *DABusPath = [desc objectForKey:[NSString stringWithFormat:@"%@", kDADiskDescriptionBusPathKey]];
      NSArray *esps = [DADescription findEFIDisks];
  
      for (NSString *disk in esps) {
        NSDictionary *espDesc = [DADescription getDescriptionsFrom:disk];
        NSString *espBusPath = [espDesc objectForKey:[NSString stringWithFormat:@"%@", kDADiskDescriptionBusPathKey]];
        if ([DABusPath isEqualToString:espBusPath]) {
          printf("%s\n", disk.UTF8String);
          break;
        }
      }
    }
  }
  return 0;
}
