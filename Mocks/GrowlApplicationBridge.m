//
//  GrowlApplicationBridge.m
//  Growler
//
//  Created by Jørgen P. Tjernø on 6/12/11.
//  Copyright 2011 devSoft. All rights reserved.
//

#import "GrowlApplicationBridge.h"

static id delegate = nil;

static NSString *lastTitle = nil;
static NSString *lastDescription = nil;
static NSString *lastNotificationName = nil;
static NSData *lastIconData = nil;
static int lastPriority = 0;
static BOOL lastWasSticky = NO;
static id lastClickContext = nil;
static NSString *lastIdentifier = nil;

@implementation GrowlApplicationBridge

#pragma mark Mocked out API
+ (void) setGrowlDelegate:(id)inDelegate {
    if (inDelegate != delegate) {
        [delegate release];
        delegate = [inDelegate retain];
    }
}

+ (void) notifyWithTitle:(NSString *)title
             description:(NSString *)description
        notificationName:(NSString *)notifName
                iconData:(NSData *)iconData
                priority:(int)priority
                isSticky:(BOOL)isSticky
            clickContext:(id)clickContext
{
    [GrowlApplicationBridge notifyWithTitle:title
                                description:description
                           notificationName:notifName
                                   iconData:iconData
                                   priority:priority
                                   isSticky:isSticky
                               clickContext:clickContext
                                 identifier:nil];    
}

+ (void) notifyWithTitle:(NSString *)title
             description:(NSString *)description
        notificationName:(NSString *)notifName
                iconData:(NSData *)iconData
                priority:(int)priority
                isSticky:(BOOL)isSticky
            clickContext:(id)clickContext
              identifier:(NSString *)identifier
{
    if (lastTitle) [lastTitle release];
    lastTitle = [title retain];

    if (lastDescription) [lastDescription release];
    lastDescription = [description retain];

    if (lastNotificationName) [lastNotificationName release];
    lastNotificationName = [notifName retain];

    if (lastIconData) [lastIconData release];
    lastIconData = [iconData retain];

    lastPriority = priority;

    lastWasSticky = isSticky;
    
    if (lastClickContext) [lastClickContext release];
    lastClickContext = [clickContext retain];
    
    if (lastIdentifier) [lastIdentifier release];
    lastIdentifier = [identifier retain];
}

#pragma mark Interacting with mock
+ (void) clickLastNotification
{
    if ([delegate respondsToSelector:@selector(growlNotificationWasClicked:)])
        [delegate growlNotificationWasClicked:lastClickContext];
}

+ (void) dismissLastNotification
{
    if ([delegate respondsToSelector:@selector(growlNotificationTimedOut:)])
        [delegate growlNotificationTimedOut:lastClickContext];
}

#pragma mark State of mock
+ (id) delegate { return delegate; }

+ (NSString *) lastTitle { return lastTitle; }
+ (NSString *) lastDescription { return lastDescription; }
+ (NSString *) lastNotificationName { return lastNotificationName; }
+ (NSData *) lastIconData { return lastIconData; }
+ (int) lastPriority { return lastPriority; }
+ (BOOL) lastWasSticky { return lastWasSticky; }
+ (id) lastClickContext { return lastClickContext; }
+ (NSString *) lastIdentifier { return lastIdentifier; }

@end
