//
// Created by chris on 6/17/13.
//

#import <Foundation/Foundation.h>

@interface NSData (EnumerateComponents)

- (void)obj_enumerateComponentsSeparatedBy:(NSData*)delimiter usingBlock:(void (^)(NSData*, BOOL finalBlock) )block;

@end
