//
//  Growler.h
//  GrabBox
//
//  Created by Jørgen P. Tjernø on 7/12/10.
//  Copyright 2010 devSoft. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Growl/Growl.h>

#import "GrowlerGrowl.h"

@protocol GrowlerDelegate
- (void) growlClicked;
- (void) growlIgnored;
@end

typedef enum {
    GrowlerGrowlClicked,
    GrowlerGrowlIgnored
} GrowlerGrowlAction;

typedef void (^GrowlerCallback)(GrowlerGrowlAction);

@interface Growler : NSObject <GrowlApplicationBridgeDelegate>

+ (id) sharedInstance;

- (void) growl:(GrowlerGrowl *)aGrowl;
- (void) growl:(GrowlerGrowl *)aGrowl withDelegate:(id<GrowlerDelegate>)theDelegate;
- (void) growl:(GrowlerGrowl *)aGrowl withBlock:(GrowlerCallback)theBlock;

@end
