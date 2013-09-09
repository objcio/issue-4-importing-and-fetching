//
//  Stop.h
//  TrafficDataCommandLineImporter
//
//  Created by Florian on 17.08.13.
//  Copyright (c) 2013 Florian. All rights reserved.
//

#import "ManagedObject.h"



@interface Stop : ManagedObject

@property (nonatomic) int64_t identifier;
@property (nonatomic, strong) NSString *name;
@property (readonly, nonatomic, strong) NSString *normalizedName;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

@property (nonatomic, retain) NSOrderedSet *stopTimes;

@end
