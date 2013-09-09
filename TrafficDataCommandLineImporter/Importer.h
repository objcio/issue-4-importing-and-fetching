//
// Created by Florian on 17.08.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface Importer : NSObject

@property (nonatomic) NSInteger const saveInterval;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (instancetype)initWithPersistentStoreURL:(NSURL *)storeURL managedObjectModel:(NSManagedObjectModel *)objectModel;

- (void)import;

@end
