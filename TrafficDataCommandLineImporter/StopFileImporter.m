//
// Created by Florian on 17.08.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "StopFileImporter.h"
#import "Stop.h"


@interface StopFileImporter ()

@property (nonatomic, strong) NSMutableDictionary *mutableStopIdentifierToObjectID;

@end



@implementation StopFileImporter

- (id)initWithFileURL:(NSURL *)url managedObjectContext:(NSManagedObjectContext *)context saveInterval:(NSInteger)saveInterval
{
    self = [super initWithFileURL:url managedObjectContext:context saveInterval:saveInterval];
    if (self) {
        self.mutableStopIdentifierToObjectID = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSString *)entityName
{
    return @"Stop";
}

- (void)configureObject:(NSManagedObject *)object forLine:(NSString *)line
{
    Stop *stop = (Stop *) object;
    NSArray *fields = [line componentsSeparatedByString:@","];
    stop.identifier = [fields[0] integerValue];
    stop.name = [fields[2] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    stop.latitude = [fields[4] doubleValue];
    stop.longitude = [fields[5] doubleValue];
}

- (void)saveContext
{
    // Object IDs are temporary until saved. We save first, then store the object IDs:
    NSSet *insertedStops = self.managedObjectContext.insertedObjects;
    [super saveContext];
    for (Stop *stop in insertedStops) {
        self.mutableStopIdentifierToObjectID[@(stop.identifier)] = stop.objectID;
    }
}

- (NSDictionary *)stopIdentifierToObjectID;
{
    return [self.mutableStopIdentifierToObjectID copy];
}

@end
