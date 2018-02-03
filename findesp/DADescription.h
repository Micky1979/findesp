//
//  DADescription.h
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
#import <DiskArbitration/DiskArbitration.h>

@interface DADescription : NSObject
+ (NSDictionary *)getDescriptionsFrom:(NSString*)diskOrMountPoint;
+ (NSArray *)findEFIDisks;
@end
