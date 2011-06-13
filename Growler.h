//
//  Growler.h
//  Growler
//
//  Created by Jørgen P. Tjernø on 7/12/10.
//  Copyright 2010 devSoft. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#ifndef UNIT_TEST
# import <Growl/Growl.h>
#endif

#import "GrowlerGrowl.h"

typedef enum {
    GrowlerGrowlClicked,
    GrowlerGrowlIgnored
} GrowlerGrowlAction;

typedef void (^GrowlerCallback)(GrowlerGrowlAction);

@interface Growler : NSObject <GrowlApplicationBridgeDelegate>
{
    NSMutableDictionary *contexts;
}

+ (void) growl:(GrowlerGrowl *)aGrowl;
+ (void) growl:(GrowlerGrowl *)aGrowl withBlock:(GrowlerCallback)theBlock;

@end
