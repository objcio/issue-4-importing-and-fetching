//
//  main.m
//  TrafficDataCommandLineImporter
//
//  Created by Florian on 17.08.13.
//  Copyright (c) 2013 Florian. All rights reserved.
//

#import "Importer.h"


static NSManagedObjectModel *managedObjectModel()
{
    static NSManagedObjectModel *model = nil;
    if (model != nil) {
        return model;
    }
    
    NSString *path = @"TrafficDataCommandLineImporter";
    NSURL *modelURL = [NSURL fileURLWithPath:path isDirectory:NO];
    modelURL = [modelURL URLByAppendingPathExtension:@"momd"];
    
    model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return model;
}

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        NSURL *desktopURL = [[NSFileManager defaultManager] URLForDirectory:NSDesktopDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:NULL];
        NSURL *storeURL = [desktopURL URLByAppendingPathComponent:@"transit-data.sqlite"];

        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:NULL];

        Importer *importer = [[Importer alloc] initWithPersistentStoreURL:storeURL managedObjectModel:managedObjectModel()];
        [importer import];
    }
    return 0;
}
