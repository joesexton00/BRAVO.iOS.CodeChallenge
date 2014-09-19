//
//  NSDate+Extension.m
//  Umbrella
//
//  Created by Joe Sexton on 9/13/14.
//  Copyright (c) 2014 Umbrella Corp. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

+ (NSDate *)tomorrow {
    
    NSUInteger units = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:units fromDate:[NSDate date]];
    
    components.day++;

    components.hour   = 0;
    components.minute = 0;
    components.second = 0;
    
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

@end
