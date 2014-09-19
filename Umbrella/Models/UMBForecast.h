//
//  UMBForecast.h
//  Umbrella
//
//  Created by Joe Sexton on 9/12/14.
//  Copyright (c) 2014 Umbrella Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMBForecast : NSObject

// Properties of a particular forecast.
@property NSInteger temperatureF;
@property NSInteger temperatureC;
@property (strong, nonatomic) NSString *condition;
@property (strong, nonatomic) UIImage *icon;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSDate *date;
@property BOOL isCurrentForecast;

// Used for ordering forecasts by date ascending
- (NSComparisonResult)compareDate:(UMBForecast *)otherObject;

@end
