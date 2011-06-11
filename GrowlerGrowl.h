//
//  GrowlerGrowl.h
//  GrabBox
//
//  Created by Jørgen P. Tjernø on 6/11/11.
//  Copyright 2011 devSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

/* Based on http://growl.info/documentation/developer/introduction.php */
enum {
    GrowlVeryLowPriorty = -2,
    GrowlModeratePriorty = -1,
    GrowlNormalPriority = 0,
    GrowlHighPriority = 1,
    GrowlEmergencyPriority = 2
};

@interface GrowlerGrowl : NSObject {
@private
    NSString *title;
    NSString *description;
    NSString *notificationName;
    NSImage *icon;
    signed int priority;
    BOOL sticky;
}

@property (retain) NSString *title;
@property (retain) NSString *description;
@property (retain) NSString *notificationName;
@property (retain) NSImage *icon;
@property (assign) signed int priority;
@property (assign, getter=isSticky) BOOL sticky;

+ (id) growl;

+ (id) growlWithName:(NSString *)theName;
+ (id) growlWithName:(NSString *)theName
               title:(NSString *)theTitle
          description:(NSString *)theDescription;
+ (id) growlErrorWithTitle:(NSString *)theTitle
               description:(NSString *)theDescription;

- (id) initWithName:(NSString *)theName;
- (id) initWithName:(NSString *)theName
              title:(NSString *)theTitle
        description:(NSString *)theDescription;
- (id) initErrorWithTitle:(NSString *)theTitle
              description:(NSString *)theDescription;

@end
