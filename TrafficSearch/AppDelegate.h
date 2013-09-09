//
//  AppDelegate.h
//  TrafficSearch
//
//  Created by Daniel Eggert on 08/09/2013.
//  Copyright (c) 2013 objc.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+ (instancetype)sharedDelegate;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
