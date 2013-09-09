//
// Created by Florian on 17.08.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Importer.h"
#import "FileImporter.h"
#import "StopFileImporter.h"
#import "StopTimeFileImporter.h"


static const NSInteger DefaultSaveInterval = 12000;


@interface Importer ()

@property (nonatomic) NSInteger entityIndex;
@property (nonatomic, strong) NSArray *entityMapping;
@property (readonly, nonatomic, copy) NSURL *dataDirectoryURL;

@end



@implementation Importer

- (instancetype)initWithPersistentStoreURL:(NSURL *)storeURL managedObjectModel:(NSManagedObjectModel *)objectModel
{
    self = [super init];
    if (self) {
        self.entityMapping = @[@[@"stops", [StopFileImporter class]], @[@"stop_times", [StopTimeFileImporter class]]];
        [self setupCoreDataStackWithStoreURL:storeURL objectModel:objectModel];
        self.saveInterval = DefaultSaveInterval;
    }
    return self;
}

- (void)setupCoreDataStackWithStoreURL:(NSURL *)storeURL objectModel:(NSManagedObjectModel *)objectModel
{
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:objectModel];
    NSError *error;
    NSPersistentStore *newStore = [coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                            configuration:nil
                                                                      URL:storeURL
                                                                  options:nil
                                                                    error:&error];
    if (error || !newStore) {
        NSLog(@"Could not add persistent store: %@", error);
        abort(); // you should do something better than this
    }
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = coordinator;
    self.managedObjectContext.undoManager = nil;
}

@synthesize dataDirectoryURL = _dataDirectoryURL;
- (NSURL *)dataDirectoryURL
{
    if (_dataDirectoryURL == nil) {
        NSString *path = [[NSUserDefaults standardUserDefaults] stringForKey:@"InputPath"];
        _dataDirectoryURL = [NSURL fileURLWithPath:path isDirectory:YES];
        NSAssert(_dataDirectoryURL, @"Specify the input directory with -InputPath <path> on the command line.");
    }
    return _dataDirectoryURL;
}

- (void)import
{
    [self.managedObjectContext performBlockAndWait:^{    NSURL *stopsURL = [self.dataDirectoryURL URLByAppendingPathComponent:@"stops.txt" isDirectory:NO];
        StopFileImporter *stopFileImporter = [[StopFileImporter alloc] initWithFileURL:stopsURL managedObjectContext:self.managedObjectContext saveInterval:self.saveInterval];
        [stopFileImporter import];
        
        NSURL *stopTimesURL = [self.dataDirectoryURL URLByAppendingPathComponent:@"stop_times.txt" isDirectory:NO];
        StopTimeFileImporter *stopTimeFileImporter = [[StopTimeFileImporter alloc] initWithFileURL:stopTimesURL managedObjectContext:self.managedObjectContext saveInterval:self.saveInterval];
        stopTimeFileImporter.stopIdentifierToObjectID = stopFileImporter.stopIdentifierToObjectID;
        [stopTimeFileImporter import];
    }];
    
    self.managedObjectContext = nil;
}

@end
