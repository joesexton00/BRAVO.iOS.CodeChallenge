//
//  UMBWeatherUndergroundManager.h
//  Umbrella
//
//  Created by Joe Sexton on 9/12/14.
//  Copyright (c) 2014 Umbrella Corp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMBForecast.h"
#import "UMBWeatherManagerDelegate.h"

@interface UMBWeatherManager : NSObject

// The delegate will be notified when the forecast is updated.
@property (strong, nonatomic) id <UMBWeatherManagerDelegate> delegate;

// This will be an array of UMBForecast objects.
// This is populated after calling fetchForecastForZipCode: forNumberOfDays: withCompletionHandler:
@property (strong, nonatomic, readonly) NSMutableArray *forecasts;

// This will contain the date/time of the last fetch request if one has been made.
@property (strong, nonatomic) NSDate *lastFetch;

// Completion handler to call when the weather fetch is complete.
// Success indicates if the fetch was successful.
typedef void (^WeatherManagerFetchCompletionBlock)(BOOL success);

// Get class singleton.  Singleton pattern used to prevent multiple sets of requests
// and because the manager stores all of the forecasts and fetching is called from multiple locations.
+ (UMBWeatherManager *)sharedManager;

// Fetch a forecast for a given zipcode.  The completion handler returns a success boolean.
// delegate method forecastsUpdated: will be called upon completion.
- (void)fetchForecastForZipCode:(NSString *)zipCode
          withCompletionHandler:(WeatherManagerFetchCompletionBlock)completionHandler;

// Fetch a forecast for a given zipcode.  Fetch is handled asynchronously,
// delegate method forecastsUpdated: will be called upon completion.
- (void)fetchForecastForZipCode:(NSString *)zipCode;

// Get the current conditions.  Must fetch forecasts first.
- (UMBForecast *)currentConditions;

// Get forecasts for a given date, sorted by time.
- (NSArray *)getForecastsForDate:(NSDate *)date;

@end
