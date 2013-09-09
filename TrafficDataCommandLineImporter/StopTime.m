//
//  StopTime.m
//  TrafficDataCommandLineImporter
//
//  Created by Florian on 17.08.13.
//  Copyright (c) 2013 Florian. All rights reserved.
//

#import "StopTime.h"


@implementation StopTime

+ (NSString *)entityName;
{
    return @"StopTime";
}

@dynamic arrivalTime;
@dynamic departureTime;
@dynamic stop;
@dynamic pickupType;
@dynamic dropOffType;

@end
