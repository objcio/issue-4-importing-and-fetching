//
//  StopSearch.m
//  TrafficSearch
//
//  Created by Daniel Eggert on 01/09/2013.
//  Copyright (c) 2013 Bödewadt. All rights reserved.
//

#import "StopSearch.h"

#import "StopTime.h"
#import "Stop.h"
#import "NSString+SearchNormalization.h"



@interface StopSearch ()

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSDateComponents *timeOfDay;
@property (nonatomic) CLLocationDistance distance;
@property (nonatomic, copy) NSString *namePrefix;
@property (nonatomic) BOOL useNaiveStringMatching;

@property (nonatomic, strong) NSArray *stopTimes;
@property (nonatomic, strong) NSArray *stops;

@end



@implementation StopSearch

+ (instancetype)stopSearchAtLocation:(CLLocation *)location timeOfDay:(NSDateComponents *)timeOfDay;
{
    StopSearch *stopSearch = [[StopSearch alloc] init];
    stopSearch.location = location;
    stopSearch.timeOfDay = timeOfDay;
    stopSearch.distance = 800; // meters
    return stopSearch;
}

+ (instancetype)naiveStopSearchWithString:(NSString *)namePrefix;
{
    StopSearch *stopSearch = [[StopSearch alloc] init];
    stopSearch.namePrefix = namePrefix;
    stopSearch.useNaiveStringMatching = YES;
    return stopSearch;
}

+ (instancetype)stopSearchWithString:(NSString *)namePrefix;
{
    StopSearch *stopSearch = [[StopSearch alloc] init];
    stopSearch.namePrefix = namePrefix;
    return stopSearch;
}

- (void)executeSearchInManagedObjectContext:(NSManagedObjectContext *)moc completionHandler:(dispatch_block_t)completionHandler;
{
    [moc performBlock:^{
        NSFetchRequest *request = [self createFetchRequest];
        NSError *error = nil;
        NSArray *stops = [moc executeFetchRequest:request error:&error];
        NSAssert(stops != nil, @"Failed to execute %@: %@", request, error);
        
        if (self.location != nil) {
            stops = [stops filteredArrayUsingPredicate:[self exactLatitudeAndLongitudePredicateForCoordinate:self.location.coordinate]];
        }
        self.stops = stops;
        
        if (completionHandler != nil) {
            if (self.handlerQueue != nil) {
                [self.handlerQueue addOperationWithBlock:completionHandler];
            } else {
                completionHandler();
            }
        }
    }];
}

- (NSFetchRequest *)createFetchRequest;
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[Stop entityName]];
    request.predicate = [self stopPredicate];
    request.fetchLimit = 200;
    request.returnsObjectsAsFaults = NO;
    return request;
}

- (NSPredicate *)stopPredicate;
{
    NSMutableArray *predicates = [NSMutableArray array];
    if (self.location != nil) {
        [predicates addObject:[self approximateLatitudeAndLongitudePredicateForCoordinate:self.location.coordinate]];
    }
    if (0 < [self.namePrefix length]) {
        [predicates addObject:[self namePrefixPredicate]];
    }
    NSPredicate *departureTimePredicate = [self departureTimePredicate];
    if (departureTimePredicate != nil) {
        [predicates addObject:departureTimePredicate];
    }
    return [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
}

- (NSPredicate *)approximateLatitudeAndLongitudePredicateForCoordinate:(CLLocationCoordinate2D)pointOfInterest;
{
    // Beware, this does not work close to the 180° meridian.
    
    double const D = self.distance * 1.1;
    double const R = 6371009.; // Earth readius in meters
	double meanLatitidue = pointOfInterest.latitude * M_PI / 180.;
	double deltaLatitude = D / R * 180. / M_PI;
	double deltaLongitude = D / (R * cos(meanLatitidue)) * 180. / M_PI;
	double minLatitude = pointOfInterest.latitude - deltaLatitude;
	double maxLatitude = pointOfInterest.latitude + deltaLatitude;
	double minLongitude = pointOfInterest.longitude - deltaLongitude;
	double maxLongitude = pointOfInterest.longitude + deltaLongitude;
    
    NSPredicate *result = [NSPredicate predicateWithFormat:
                           @"(%@ <= longitude) AND (longitude <= %@)"
                           @"AND (%@ <= latitude) AND (latitude <= %@)",
                           @(minLongitude), @(maxLongitude), @(minLatitude), @(maxLatitude)];
    
    return result;
}

- (NSPredicate *)exactLatitudeAndLongitudePredicateForCoordinate:(CLLocationCoordinate2D)pointOfInterest;
{
    return [NSPredicate predicateWithBlock:^BOOL(Stop *evaluatedStop, NSDictionary *bindings) {
        CLLocation *evaluatedLocation = [[CLLocation alloc] initWithLatitude:evaluatedStop.latitude longitude:evaluatedStop.longitude];
        CLLocationDistance distance = [self.location distanceFromLocation:evaluatedLocation];
        return (distance < self.distance);
    }];
}

- (NSPredicate *)namePrefixPredicate;
{
    if (self.useNaiveStringMatching) {
        return [NSPredicate predicateWithFormat:@"name BEGINSWITH[cd] %@", self.namePrefix];
    } else {
        return [NSPredicate predicateWithFormat:@"normalizedName BEGINSWITH %@", [self.namePrefix normalizedSearchString]];
    }
}

- (NSPredicate *)departureTimePredicate;
{
    if (self.timeOfDay == nil) {
        return nil;
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:0];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *startDate = [gregorian dateByAddingComponents:self.timeOfDay toDate:date options:0];
    NSDateComponents *window = [[NSDateComponents alloc] init];
    window.minute = 20;
    NSDate *endDate = [gregorian dateByAddingComponents:window toDate:startDate options:0];
    
    
    NSPredicate *result = [NSPredicate predicateWithFormat:
                           @"(SUBQUERY(stopTimes, $x, (%@ <= $x.departureTime) && ($x.departureTime <= %@)).@count != 0)",
                           startDate, endDate];
    return result;
    
    
}

@end
