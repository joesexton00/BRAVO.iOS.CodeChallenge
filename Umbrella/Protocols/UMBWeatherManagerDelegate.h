//
//  UMBWeatherManagerDelegate.h
//  Umbrella
//
//  Created by Joe Sexton on 9/13/14.
//  Copyright (c) 2014 Umbrella Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UMBWeatherManagerDelegate <NSObject>

// This will be called when the forecasts have been updated.
// The forecasts parameter will be an array of UMBForecast objects.
- (void)forecastsUpdated:(NSArray *)forecasts;

@end
