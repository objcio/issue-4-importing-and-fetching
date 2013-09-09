//
// Created by Florian on 17.08.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@class Reader;


@interface FileImporter : NSObject

@property (readonly, nonatomic, copy) NSString *entityName;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (id)initWithFileURL:(NSURL *)url managedObjectContext:(NSManagedObjectContext *)context saveInterval:(NSInteger)saveInterval;
- (void)import;
- (void)configureObject:(NSManagedObject *)object forLine:(NSString *)line;
- (void)saveContext;

@end
