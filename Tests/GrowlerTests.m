//
//  GrowlerTests.m
//  GrowlerTests
//
//  Created by Jørgen P. Tjernø on 6/12/11.
//  Copyright 2011 devSoft. All rights reserved.
//

#import "GrowlerTests.h"

#import "Growler.h"
#import "GrowlApplicationBridge.h"

@implementation GrowlerTests

- (void)testDefaultConstructor
{
    GrowlerGrowl *myGrowl = [GrowlerGrowl growl];
    [Growler growl:myGrowl];

    STAssertEqualObjects([GrowlApplicationBridge lastTitle], @"",
                         @"- title should be empty");
    STAssertEqualObjects([GrowlApplicationBridge lastDescription], @"",
                         @"- description should be empty");
    STAssertEqualObjects([GrowlApplicationBridge lastNotificationName], @"Default",
                         @"- notification name should be Default");
    STAssertNil([GrowlApplicationBridge lastIconData],
                @"- icon should not be present.");
    STAssertEquals([GrowlApplicationBridge lastPriority], GrowlNormalPriority,
                   @"- priority should be default");
    STAssertFalse([GrowlApplicationBridge lastWasSticky],
                  @"- notification should not be sticky");
}

- (void)testAttributeSetters
{
    NSImage *icon = [NSImage imageNamed:NSImageNamePreferencesGeneral];

    GrowlerGrowl *myGrowl = [GrowlerGrowl growl];
    myGrowl.title = @"New title";
    myGrowl.description = @"New description";
    myGrowl.notificationName = @"Nondefault";
    myGrowl.icon = icon;
    myGrowl.priority = GrowlModeratePriority;
    myGrowl.sticky = YES;
    [Growler growl:myGrowl];

    STAssertEqualObjects([GrowlApplicationBridge lastTitle], @"New title",
                         @"- title should be assigned value");
    STAssertEqualObjects([GrowlApplicationBridge lastDescription], @"New description",
                         @"- description should be assigned value");
    STAssertEqualObjects([GrowlApplicationBridge lastNotificationName], @"Nondefault",
                         @"- notification name should be Nondefault");
    STAssertEqualObjects([GrowlApplicationBridge lastIconData], [icon TIFFRepresentation],
                @"- icon should be specified image.");
    STAssertEquals([GrowlApplicationBridge lastPriority], GrowlModeratePriority,
                   @"- priority should be moderate");
    STAssertTrue([GrowlApplicationBridge lastWasSticky],
                  @"- notification should be sticky");
}


- (void)testNameConstructor
{
    GrowlerGrowl *myGrowl = [GrowlerGrowl growlWithName:@"Operation completed"];
    [Growler growl:myGrowl];

    STAssertEqualObjects([GrowlApplicationBridge lastTitle], @"",
                         @"- title should be empty");
    STAssertEqualObjects([GrowlApplicationBridge lastDescription], @"",
                         @"- description should be empty");
    STAssertEqualObjects([GrowlApplicationBridge lastNotificationName], @"Operation completed",
                         @"- notification name should be the passed value");
    STAssertNil([GrowlApplicationBridge lastIconData],
                @"- icon should not be present.");
    STAssertEquals([GrowlApplicationBridge lastPriority], GrowlNormalPriority,
                   @"- priority should be default");
    STAssertFalse([GrowlApplicationBridge lastWasSticky],
                  @"- notification should not be sticky");
}

- (void)testNameTitleDescriptionConstructor
{
    GrowlerGrowl *myGrowl = [GrowlerGrowl growlWithName:@"Operation completed"
                                    title:@"Operation completed!"
                              description:@"The upload operation completed successfully"];
    [Growler growl:myGrowl];

    STAssertEqualObjects([GrowlApplicationBridge lastTitle], @"Operation completed!",
                         @"- title should be the passed value");
    STAssertEqualObjects([GrowlApplicationBridge lastDescription], @"The upload operation completed successfully",
                         @"- description should be the passed value");
    STAssertEqualObjects([GrowlApplicationBridge lastNotificationName], @"Operation completed",
                         @"- notification name should be the passed value");
    STAssertNil([GrowlApplicationBridge lastIconData],
                @"- icon should not be present.");
    STAssertEquals([GrowlApplicationBridge lastPriority], GrowlNormalPriority,
                   @"- priority should be default");
    STAssertFalse([GrowlApplicationBridge lastWasSticky],
                  @"- notification should not be sticky");
}

- (void)testErrorConstructor
{
    NSImage *caution = [NSImage imageNamed:NSImageNameCaution];
    GrowlerGrowl *myGrowl = [GrowlerGrowl growlErrorWithTitle:@"Operation failed"
                                    description:@"Could not complete the upload"];
    [Growler growl:myGrowl];

    STAssertEqualObjects([GrowlApplicationBridge lastTitle], @"Operation failed",
                         @"- title should be the passed value");
    STAssertEqualObjects([GrowlApplicationBridge lastDescription], @"Could not complete the upload",
                         @"- description should be the passed value");
    STAssertEqualObjects([GrowlApplicationBridge lastNotificationName], @"Error",
                         @"- notification name should be the default");
    STAssertEqualObjects([GrowlApplicationBridge lastIconData], [caution TIFFRepresentation],
                         @"- icon should be default caution image.");
    STAssertEquals([GrowlApplicationBridge lastPriority], GrowlEmergencyPriority,
                   @"- priority should be emergency");
    STAssertFalse([GrowlApplicationBridge lastWasSticky],
                  @"- notification should not be sticky");
}

- (void)testCallbackClicked
{
    __block BOOL gotCallback = NO;

    GrowlerGrowl *myGrowl = [GrowlerGrowl growl];
    [Growler growl:myGrowl
         withBlock:^(GrowlerGrowlAction action) {
             gotCallback = YES;
             if (action != GrowlerGrowlClicked)
                 STFail(@"Got non-click action %d", action);
         }];

    STAssertFalse(gotCallback, @"- callback should not be called before click event.");
    
    [GrowlApplicationBridge clickLastNotification];
    STAssertTrue(gotCallback, @"- callback should be called after click event.");
}

- (void)testCallbackDismissed
{
    __block BOOL gotCallback = NO;
    
    GrowlerGrowl *myGrowl = [GrowlerGrowl growl];
    [Growler growl:myGrowl
         withBlock:^(GrowlerGrowlAction action) {
             gotCallback = YES;
             if (action != GrowlerGrowlIgnored)
                 STFail(@"Got non-ignore action %d", action);
         }];
    
    STAssertFalse(gotCallback, @"- callback should not be called before click event.");
    
    [GrowlApplicationBridge dismissLastNotification];
    STAssertTrue(gotCallback, @"- callback should be called after click event.");
}

@end
