//
//  GrowlerGrowl.m
//  GrabBox
//
//  Created by Jørgen P. Tjernø on 6/11/11.
//  Copyright 2011 devSoft. All rights reserved.
//

#import "GrowlerGrowl.h"


@implementation GrowlerGrowl

@synthesize title, description;
@synthesize notificationName;
@synthesize icon;
@synthesize priority, sticky;

+ (id) growl
{
    return [[[self alloc] init] autorelease];
}

+ (id) growlWithName:(NSString *)theName
{
    return [[[self alloc] initWithName:theName] autorelease];
}

+ (id) growlWithName:(NSString *)theName
               title:(NSString *)theTitle
         description:(NSString *)theDescription
{
    return [[[self alloc] initWithName:theName
                                 title:theTitle
                           description:theDescription] autorelease];
}
+ (id) growlErrorWithTitle:(NSString *)theTitle
               description:(NSString *)theDescription
{
    return [[[self alloc] initErrorWithTitle:theTitle
                                 description:theDescription] autorelease];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setTitle:@""];
        [self setDescription:@""];
        [self setNotificationName:@"Default"];
        [self setIcon:nil];
        [self setPriority:GrowlNormalPriority];
        [self setSticky:NO];
    }
    
    return self;
}

- (id) initWithName:(NSString *)theName
{
    self = [self init];
    if (self) {
        [self setNotificationName:theName];
    }

    return self;
}
- (id) initWithName:(NSString *)theName
              title:(NSString *)theTitle
        description:(NSString *)theDescription
{
    self = [self initWithName:theName];
    if (self) {
        [self setTitle:theTitle];
        [self setDescription:theDescription];
    }
    
    return self;
}

- (id) initErrorWithTitle:(NSString *)theTitle
              description:(NSString *)theDescription
{
    self = [self initWithName:@"Error" title:theTitle description:theDescription];
    if (self) {
        [self setPriority:GrowlEmergencyPriority];
        [self setIcon:[NSImage imageNamed:NSImageNameCaution]];
    }
    
    return self;
}

- (void)dealloc
{
    [self setTitle:nil];
    [self setDescription:nil];
    [self setNotificationName:nil];
    [self setIcon:nil];

    [super dealloc];
}

@end
