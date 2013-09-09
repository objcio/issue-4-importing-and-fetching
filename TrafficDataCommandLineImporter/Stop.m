//
//  Stop.m
//  TrafficDataCommandLineImporter
//
//  Created by Florian on 17.08.13.
//  Copyright (c) 2013 Florian. All rights reserved.
//

#import "Stop.h"

#import "NSString+SearchNormalization.h"



@interface Stop (CoreDataForward)

@property (nonatomic, strong) NSString *primitiveName;
@property (nonatomic, strong) NSString *primitiveNormalizedName;

@end



@implementation Stop

+ (NSString *)entityName;
{
    return @"Stop";
}

@dynamic identifier;
@dynamic name;
@dynamic normalizedName;
@dynamic latitude;
@dynamic longitude;
@dynamic stopTimes;

- (void)setName:(NSString *)name;
{
    [self willAccessValueForKey:@"name"];
    [self willAccessValueForKey:@"normalizedName"];
    self.primitiveName = name;
    self.primitiveNormalizedName = [name normalizedSearchString];
    [self didAccessValueForKey:@"normalizedName"];
    [self didAccessValueForKey:@"name"];
}

@end
