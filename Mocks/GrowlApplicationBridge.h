//
//  GrowlApplicationBridge.h
//  Growler
//
//  Created by Jørgen P. Tjernø on 6/12/11.
//  Copyright 2011 devSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GrowlApplicationBridgeDelegate
@end

@interface NSObject (GrowlApplicationBridgeDelegate_InformalProtocol)
- (void) growlNotificationWasClicked:(id)clickContext;
- (void) growlNotificationTimedOut:(id)clickContext;
@end;

@interface GrowlApplicationBridge : NSObject {
@private
    
}

#pragma mark Mocked out API
+ (void) setGrowlDelegate:(id)inDelegate;
+ (void) notifyWithTitle:(NSString *)title
             description:(NSString *)description
        notificationName:(NSString *)notifName
                iconData:(NSData *)iconData
                priority:(int)priority
                isSticky:(BOOL)isSticky
            clickContext:(id)clickContext;
+ (void) notifyWithTitle:(NSString *)title
             description:(NSString *)description
        notificationName:(NSString *)notifName
                iconData:(NSData *)iconData
                priority:(int)priority
                isSticky:(BOOL)isSticky
            clickContext:(id)clickContext
              identifier:(NSString *)identifier;

#pragma mark  Interacting with mock
+ (void) clickLastNotification;
+ (void) dismissLastNotification;

#pragma mark State of mock
+ (id) delegate;

+ (NSString *) lastTitle;
+ (NSString *) lastDescription;
+ (NSString *) lastNotificationName;
+ (NSData *) lastIconData;
+ (int) lastPriority;
+ (BOOL) lastWasSticky;
+ (id) lastClickContext;
+ (NSString *) lastIdentifier;

@end
