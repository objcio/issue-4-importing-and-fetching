//
// Created by Florian on 17.08.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "StopTimeFileImporter.h"
#import "StopTime.h"
#import "NSDate+Import.h"
#import "Stop.h"


@interface StopTimeFileImporter ()
@end



@implementation StopTimeFileImporter

- (NSString *)entityName
{
    return @"StopTime";
}

- (void)configureObject:(NSManagedObject *)object forLine:(NSString *)line
{
    StopTime *stopTime = (StopTime *) object;
    NSArray *fields = [line componentsSeparatedByString:@","];
    stopTime.arrivalTime = [NSDate dateWithTimeString:fields[1]];
    stopTime.departureTime = [NSDate dateWithTimeString:fields[2]];
    
    NSInteger stopIdentifier = [fields[3] integerValue];
    NSManagedObjectID *moid = self.stopIdentifierToObjectID[@(stopIdentifier)];
    if (moid != nil) {
        Stop *stop = (id) [self.managedObjectContext objectWithID:moid];
        stopTime.stop = stop;
    }
}

@end
