//
//  NSDate+Import.m
//  import500px
//
//  Created by Daniel Eggert on 14/05/2013.
//  Copyright (c) 2013 Bödewadt. All rights reserved.
//

#import "NSDate+Import.h"

#import <string.h>
#import <time.h>
//#import <xlocale.h>



@implementation NSDate (Import)

+ (instancetype)dateWithTimeString:(NSString *)timeString;
{
    if (![timeString isKindOfClass:[NSString class]]) {
        return nil;
    }
    if ([timeString length] != 8) {
        return nil;
    }

    // Parse "18:22:53"
    char const * const format = "%T";

    struct tm ctime = {};
    char const * const temp = [timeString UTF8String];

    if (NULL == strptime(temp, format, &ctime)) {
        return nil;
    }
    ctime.tm_year = 70;
    ctime.tm_mday = 1;
    
    long ts = mktime(&ctime);
    return [NSDate dateWithTimeIntervalSince1970:ts];
}

@end
