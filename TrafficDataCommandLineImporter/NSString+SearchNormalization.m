//
//  NSString+SearchNormalization.m
//  TrafficDataCommandLineImporter
//
//  Created by Daniel Eggert on 08/09/2013.
//  Copyright (c) 2013 Daniel Eggert. All rights reserved.
//

#import "NSString+SearchNormalization.h"



@implementation NSString (SearchNormalization)

- (NSString *)normalizedSearchString;
{
    // C.f. <http://userguide.icu-project.org/transforms>
    NSString *mutableName = [self mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef) mutableName, NULL, (__bridge CFStringRef)@"NFD; [:Nonspacing Mark:] Remove; Lower(); NFC", NO);
    return mutableName;
}

@end
