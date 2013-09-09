//
//  ManagedObject.h
//  TrafficDataCommandLineImporter
//
//  Created by Daniel Eggert on 01/09/2013.
//  Copyright (c) 2013 Daniel Eggert. All rights reserved.
//

#import <CoreData/CoreData.h>



@interface ManagedObject : NSManagedObject

+ (NSString *)entityName;

@end
