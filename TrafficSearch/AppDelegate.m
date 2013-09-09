//
//  AppDelegate.m
//  TrafficSearch
//
//  Created by Daniel Eggert on 08/09/2013.
//  Copyright (c) 2013 objc.io. All rights reserved.
//

#import "AppDelegate.h"



@interface AppDelegate ()

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end



@implementation AppDelegate

@synthesize window = _window;

+ (instancetype)sharedDelegate;
{
    return (id) [UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@synthesize managedObjectContext = _managedObjectContext;
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _managedObjectContext.persistentStoreCoordinator = coordinator;
    }
    return _managedObjectContext;
}

@synthesize managedObjectModel = _managedObjectModel;
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TrafficDataCommandLineImporter" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator == nil) {
        NSURL *storeURL = [[NSBundle mainBundle] URLForResource:@"transit-data" withExtension:@"sqlite"];
        
        if (! [[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]]) {
            NSLog(@"Run the TrafficDataCommandLineImporter to create the database.");
            abort();
        }
        
        NSError *error = nil;
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        
        NSDictionary *options = @{NSReadOnlyPersistentStoreOption: @YES};
        if (! [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
            NSLog(@"Unable to add store: %@", error);
            abort();
        }
    }
    return _persistentStoreCoordinator;
}

@end
