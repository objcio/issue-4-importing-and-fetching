//
//  TimeIntervalFormatter.m
//  TrafficSearch
//
//  Created by Daniel Eggert on 08/09/2013.
//  Copyright (c) 2013 objc.io. All rights reserved.
//

#import "TimeIntervalFormatter.h"



@implementation TimeIntervalFormatter
{
    NSNumberFormatter *_numberFormatter;
}

- (NSString *)stringForObjectValue:(id)anObject
{
    if (! [anObject respondsToSelector:@selector(doubleValue)]) {
        return @"";
    }
    
    NSTimeInterval const interval = [anObject doubleValue];
    double value = 0;
    NSString *unit = nil;
    
    if (interval <= 500. * 1.e-9) {
        value = interval * 1.e9;
        unit = @"ns";
    } else if (interval <= 500. * 1.e-6) {
        value = interval * 1.e6;
        unit = @"µs";
    } else if (interval <= 500. * 1.e-3) {
        value = interval * 1.e3;
        unit = @"ms";
    } else if (interval <= 500.) {
        value = interval;
        unit = @"s";
    }
    
    if (unit != nil) {
        if (_numberFormatter == nil) {
            _numberFormatter = [[NSNumberFormatter alloc] init];
            _numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
            _numberFormatter.usesSignificantDigits = YES;
            _numberFormatter.minimumSignificantDigits = 2;
            _numberFormatter.maximumSignificantDigits = 3;
        }
        return [NSString stringWithFormat:@"%@ %@", [_numberFormatter stringFromNumber:@(value)], unit];
    }
    
    double const minutes = floor(interval / 60.);
    double const seconds = round(interval - 60. * minutes);
    return [NSString stringWithFormat:@"%d′ %d″", (int) minutes, (int) seconds];
}

@end
