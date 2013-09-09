//
// Created by Florian on 17.08.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "FileImporter.h"
#import "Reader.h"


@interface FileImporter ()

@property (nonatomic, strong) Reader *reader;
@property (nonatomic) NSInteger importCount;
@property (nonatomic) NSInteger saveInterval;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *lastSaveDate;

@end



@implementation FileImporter

- (id)initWithFileURL:(NSURL *)url managedObjectContext:(NSManagedObjectContext *)context saveInterval:(NSInteger)saveInterval
{
    self = [super init];
    if (self != nil) {
        self.reader = [[Reader alloc] initWithFileAtURL:url];
        self.managedObjectContext = context;
        self.saveInterval = saveInterval;
    }
    return self;
}

- (void)import;
{
    self.startDate = [NSDate date];
    self.importCount = 0;
    [self.reader enumerateLinesWithBlock:^(NSUInteger lineNumber, NSString *line) {
        if (lineNumber == 0) {
            return;
        }
        NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:self.entityName
                                                                inManagedObjectContext:self.managedObjectContext];
        [self configureObject:object forLine:line];
        if (self.importCount % self.saveInterval == 0) {
            [self saveAndResetContext];
        }
        self.importCount++;
    }];
    [self saveAndResetContext];
}

- (void)configureObject:(NSManagedObject *)object forLine:(NSString *)line
{
}

- (void)saveAndResetContext
{
    [self saveContext];
    [self.managedObjectContext reset];
}

- (void)saveContext
{
    NSDate *now = [NSDate date];
    if (self.lastSaveDate != nil) {
        double objectsPerSecond = self.saveInterval / [now timeIntervalSinceDate:self.lastSaveDate];
        double average = self.importCount / [now timeIntervalSinceDate:self.startDate];
        NSLog(@"%@ %7ld  %5g obj / s, average = %5g (%.3g%% done)", [self class], (long) self.importCount, objectsPerSecond, average, 100. * self.reader.relativeProgress);
    }
    self.lastSaveDate = now;
    NSError *error = nil;
    NSAssert([self.managedObjectContext save:&error], @"Saving failed: %@", error);
}

@end
