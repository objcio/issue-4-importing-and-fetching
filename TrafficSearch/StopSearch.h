//
//  StopSearch.h
//  TrafficSearch
//
//  Created by Daniel Eggert on 01/09/2013.
//  Copyright (c) 2013 Bödewadt. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;
@import CoreData;



@interface StopSearch : NSObject

+ (instancetype)stopSearchAtLocation:(CLLocation *)location timeOfDay:(NSDateComponents *)timeOfDay;
+ (instancetype)naiveStopSearchWithString:(NSString *)namePrefix;
+ (instancetype)stopSearchWithString:(NSString *)namePrefix;

- (void)executeSearchInManagedObjectContext:(NSManagedObjectContext *)moc completionHandler:(dispatch_block_t)completionHandler;

@property (nonatomic, strong) NSOperationQueue *handlerQueue;
@property (readonly, nonatomic, strong) CLLocation *location;
@property (readonly, nonatomic, strong) NSDateComponents *timeOfDay;
@property (readonly, nonatomic, strong) NSArray *stopTimes;
@property (readonly, nonatomic, strong) NSArray *stops;

@end
