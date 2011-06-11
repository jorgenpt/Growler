//
//  Growler.m
//  GrabBox
//
//  Created by Jørgen P. Tjernø on 7/12/10.
//  Copyright 2010 devSoft. All rights reserved.
//

#import "Growler.h"

#ifndef DLog
# ifdef DEBUG
#    define DLog(fmt, ...) NSLog((@"%s, line %d: " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
# else
#    define DLog(...)
# endif
#endif

@interface Growler ()

@property (nonatomic, retain) NSMutableDictionary* contexts;

- (void) growl:(GrowlerGrowl *)aGrowl;
- (void) growl:(GrowlerGrowl *)aGrowl withBlock:(GrowlerCallback)theBlock;

- (NSNumber *) addBlock:(GrowlerCallback)block;
- (GrowlerCallback) retrieveBlockWithKey:(id)aKey;

@end

@implementation Growler

@synthesize contexts;
static Growler* sharedInstance = nil;

#pragma mark -
#pragma mark Singleton management code

/* "The runtime sends initialize to each class in a program exactly one time
 * just before the class, or any class that inherits from it, is sent its first
 * message from within the program. (Thus the method may never be invoked if the
 * class is not used.) The runtime sends the initialize message to classes in a
 * thread-safe manner. Superclasses receive this message before their
 * subclasses."
 */
+ (void)initialize
{
    if (sharedInstance == nil)
        sharedInstance = [[self alloc] init];
}

+ (id) sharedGrowler
{
    return sharedInstance;
}

+ (id) allocWithZone:(NSZone *)zone
{
    /* Make sure we're not allocated more than once. */
    @synchronized(self) {
        if (sharedInstance == nil) {
            return [super allocWithZone:zone];
        }
    }
    return sharedInstance;
}

- (id) init
{
    if (sharedInstance == nil)
    {
        sharedInstance = [super init];
        if (sharedInstance)
        {
            [GrowlApplicationBridge setGrowlDelegate:sharedInstance];
            [sharedInstance setContexts:[NSMutableDictionary dictionary]];
        }
    }

    return sharedInstance;
}

/* Make sure there is always one instance, and make sure it's never free'd. */
- (id) copyWithZone:(NSZone *)zone { return self; }
- (id) retain { return self; }
- (NSUInteger) retainCount { return UINT_MAX; }
- (void) release {}
- (id) autorelease { return self; }

#pragma mark -
#pragma mark Messaging

+ (void) growl:(GrowlerGrowl *)aGrowl
{
    [[self sharedGrowler] growl:aGrowl withBlock:nil];
}

+ (void) growl:(GrowlerGrowl *)aGrowl withBlock:(GrowlerCallback)theBlock
{
    [[self sharedGrowler] growl:aGrowl withBlock:theBlock];
}

- (void) growl:(GrowlerGrowl *)aGrowl
{
    [self growl:aGrowl withBlock:nil];
}

- (void) growl:(GrowlerGrowl *)aGrowl withBlock:(GrowlerCallback)theBlock
{
    NSData *iconData = nil;
    if (aGrowl.icon)
        iconData = [aGrowl.icon TIFFRepresentation];

    NSNumber *context = nil;
    if (theBlock)
        context = [self addBlock:theBlock];

    DLog(@"Growling '%@' with title '%@' (%@)", aGrowl.description, aGrowl.title, aGrowl.notificationName);
    [GrowlApplicationBridge notifyWithTitle:aGrowl.title
                                description:aGrowl.description
                           notificationName:aGrowl.notificationName
                                   iconData:iconData
                                   priority:aGrowl.priority
                                   isSticky:aGrowl.isSticky
                               clickContext:context];

}

#pragma mark -
#pragma mark Callback block management

- (NSNumber*) addBlock:(GrowlerCallback)block
{
    NSNumber* hash = [NSNumber numberWithInt:[block hash]];
    [contexts setObject:block forKey:hash];
    return hash;
}

- (GrowlerCallback) retrieveBlockWithKey:(id)aKey
{
    GrowlerCallback block = [[contexts objectForKey:aKey] retain];
    [contexts removeObjectForKey:aKey];
    return [block autorelease];
}

#pragma mark -
#pragma mark GrowlApplicationBridge delegate

- (NSDictionary *) registrationDictionaryForGrowl
{
    /*
     * We do this so that the .bundle can be completely independent.
     * Normally, this data is just put into "Growl Registration Ticket.growlRegDict" in the resources of the
     * main app bundle, but that means that the bundle we're building has to be "invasive". Using this approach,
     * if you load and use the bundle, it'll use its own resources' "Growl Registration Ticket.growlRegDict" and
     * return that to the Growl app bridge.
     */

    NSBundle *bundle = [NSBundle bundleWithIdentifier:BUNDLE_IDENTIFIER];
    if (!bundle)
    {
        NSLog(@"Could not locate bundle for PublishBox!");
        return nil;
    }

    NSString *path = [bundle pathForResource:@"Growl Registration Ticket"
                                      ofType:@"growlRegDict"];
    if (!path)
    {
        NSLog(@"Could not locate Growl registration ticket bundle for PublishBox!");
        return nil;
    }

    NSData *data = [NSData dataWithContentsOfFile:path];
    if (!data)
    {
        NSLog(@"Could not read Growl registration ticket from %@", path);
        return nil;
    }

    NSString *errorDescription;
    NSDictionary *dictionary = [NSPropertyListSerialization propertyListFromData:data
                                                                mutabilityOption:0
                                                                          format:NULL
                                                                errorDescription:&errorDescription];
    if (errorDescription)
    {
        NSLog(@"Could not parse the Growl registration ticket from %@: %@", path, errorDescription);
        [errorDescription release];
        return nil;
    }

    DLog(@"RegistrationDictionary: %@", dictionary);
    return dictionary;
}

- (void) growlNotificationWasClicked:(id)context
{
    GrowlerCallback callback = [self retrieveBlockWithKey:context];
    if (callback)
        callback(GrowlerGrowlClicked);
}

- (void) growlNotificationTimedOut:(id)context
{
    GrowlerCallback callback = [self retrieveBlockWithKey:context];
    if (callback)
        callback(GrowlerGrowlIgnored);
}

@end
