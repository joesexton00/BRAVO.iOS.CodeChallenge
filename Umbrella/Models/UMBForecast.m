//
//  UMBForecast.m
//  Umbrella
//
//  Created by Joe Sexton on 9/12/14.
//  Copyright (c) 2014 Umbrella Corp. All rights reserved.
//

#import "UMBForecast.h"

@implementation UMBForecast

// Compare by date for sorting
- (NSComparisonResult)compareDate:(UMBForecast *)otherObject {
    
    return [self.date compare:otherObject.date];
}

@end
