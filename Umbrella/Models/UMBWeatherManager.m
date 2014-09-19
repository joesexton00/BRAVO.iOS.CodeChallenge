//
//  UMBWeatherUndergroundManager.m
//  Umbrella
//
//  Created by Joe Sexton on 9/12/14.
//  Copyright (c) 2014 Umbrella Corp. All rights reserved.
//

#import "UMBWeatherManager.h"
#import "UMBWeatherUndergroundAPIKey.h"
#import "WeatherAPIClient.h"
#import "UMBIconManager.h"
#import "UMBNetworkActivityIndicatorManager.h"

@interface UMBWeatherManager()

@property (strong, nonatomic, readwrite) NSMutableArray *forecasts;
@property (strong, nonatomic) WeatherAPIClient *apiClient;
@property (strong, nonatomic) UMBIconManager *iconManager;
@property BOOL fetching;

@end

@implementation UMBWeatherManager

static NSString * const kWeatherManagerKeyError = @"response.error";

static NSString * const kWeatherManagerKeyLocationCity  = @"current_observation.display_location.city";
static NSString * const kWeatherManagerKeyLocationState = @"current_observation.display_location.state";

static NSString * const kWeatherManagerKeyCurrentTempF     = @"current_observation.temp_f";
static NSString * const kWeatherManagerKeyCurrentTempC     = @"current_observation.temp_c";
static NSString * const kWeatherManagerKeyCurrentIcon      = @"current_observation.icon";
static NSString * const kWeatherManagerKeyCurrentCondition = @"current_observation.weather";
static NSString * const kWeatherManagerKeyCurrentTimestamp = @"current_observation.local_epoch";

static NSString * const kWeatherManagerKeyHourlyForecast   = @"hourly_forecast";
static NSString * const kWeatherManagerKeyTempF            = @"temp.english";
static NSString * const kWeatherManagerKeyTempC            = @"temp.metric";
static NSString * const kWeatherManagerKeyIcon             = @"icon";
static NSString * const kWeatherManagerKeyCondition        = @"condition";
static NSString * const kWeatherManagerKeyMday             = @"FCTTIME.mday";
static NSString * const kWeatherManagerKeyTimestamp        = @"FCTTIME.epoch";

#pragma mark - Singleton

+ (UMBWeatherManager *)sharedManager {
    
    static UMBWeatherManager *sharedInstance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Getters/Setters

- (NSMutableArray *)forecasts {
    
    if (!_forecasts) {
        _forecasts = [[NSMutableArray alloc] init];
    }
    
    return _forecasts;
}

- (WeatherAPIClient *)apiClient {
    
    if (!_apiClient) {
        _apiClient = [WeatherAPIClient sharedClient];
        _apiClient.APIKey = kWeatherUndergroundAPIKey;
    }
    
    return _apiClient;
}

- (UMBIconManager *)iconManager {
    
    if (!_iconManager) {
        _iconManager = [[UMBIconManager alloc] init];
    }
    
    return _iconManager;
}

- (UMBForecast *)currentConditions {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isCurrentForecast = YES"];
    NSArray *filteredArray = [self.forecasts filteredArrayUsingPredicate:predicate];
    
    // There should only be 1 UMBForecast object that matches this property.
    // In the event that there are somehow more, just return the first.
    return [filteredArray firstObject];
}

- (NSArray *)getForecastsForDate:(NSDate *)date {

    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // Start date/time
    NSDateComponents *startComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    [startComponents setHour:0];
    [startComponents setMinute:0];
    [startComponents setSecond:0];
    NSDate *startDate = [calendar dateFromComponents:startComponents];
    
    // End date/time
    NSDateComponents *endComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    [endComponents setHour:23];
    [endComponents setMinute:59];
    [endComponents setSecond:59];
    NSDate *endDate = [calendar dateFromComponents:endComponents];
    
    // Filter
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date BETWEEN %@", [NSArray arrayWithObjects:startDate, endDate, nil]];
    NSMutableArray *filteredForecasts = [[self.forecasts filteredArrayUsingPredicate:predicate] mutableCopy];
    
    // Sort
    return [filteredForecasts sortedArrayUsingSelector:@selector(compareDate:)];
}

#pragma mark - Fetching

- (void)fetchForecastForZipCode:(NSString *)zipCode
          withCompletionHandler:(WeatherManagerFetchCompletionBlock)completionHandler  {
    
    // Only process one request at a time.
    if (self.fetching == YES) {
        return;
    }
    
    self.fetching = YES;
    self.lastFetch = [NSDate date];
    
    [[UMBNetworkActivityIndicatorManager sharedManager] startActivity];
    
    NSURLSessionDataTask *task = [self.apiClient getForecastAndConditionsForZipCode:zipCode withCompletionBlock:^(BOOL success, NSDictionary *result, NSError *error){
        
        [[UMBNetworkActivityIndicatorManager sharedManager] endActivity];
        
        if (!success || [result valueForKeyPath:kWeatherManagerKeyError]) {
            
            [self.forecasts removeAllObjects];
            
            if (completionHandler) {
                completionHandler(NO);
            }
            
        } else {
            
            // Update the forecasts
            [self.forecasts removeAllObjects];
            [self updateCurrentForecastFromAPIResults:result];
            [self updateHourlyForecastsFromAPIResults:result];
            
            if (completionHandler) {
                completionHandler(YES);
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate forecastsUpdated:self.forecasts];
            self.fetching = NO;
        });
        
    }];
    
    [task resume];
}

- (void)fetchForecastForZipCode:(NSString *)zipCode {
    
    [self fetchForecastForZipCode:zipCode withCompletionHandler:nil];
}

#pragma mark - Conversion

- (void)updateCurrentForecastFromAPIResults:(NSDictionary *)result {
    
    UMBForecast *currentForecast = [[UMBForecast alloc] init];
    [self.forecasts addObject:currentForecast];
    
    currentForecast.city              = [result valueForKeyPath:kWeatherManagerKeyLocationCity];
    currentForecast.state             = [result valueForKeyPath:kWeatherManagerKeyLocationState];
    currentForecast.temperatureF      = [self convertTemperature:[result valueForKeyPath:kWeatherManagerKeyCurrentTempF]];
    currentForecast.temperatureC      = [self convertTemperature:[result valueForKeyPath:kWeatherManagerKeyCurrentTempC]];
    currentForecast.condition         = [result valueForKeyPath:kWeatherManagerKeyCurrentCondition];
    currentForecast.date              = [self convertTimestampToDate:[result valueForKeyPath:kWeatherManagerKeyCurrentTimestamp]];
    currentForecast.isCurrentForecast = YES;
    
    // Load icon
    [self.iconManager fetchIcon:[result valueForKeyPath:kWeatherManagerKeyCurrentIcon]
          withCompletionHandler:^(BOOL success, UIImage *icon) {
              
              if (success) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      currentForecast.icon = icon;
                      [self.delegate forecastsUpdated:self.forecasts];
                  });
              }
          }];
}

- (void)updateHourlyForecastsFromAPIResults:(NSDictionary *)result {

    NSArray *hourlyResults = [result valueForKeyPath:kWeatherManagerKeyHourlyForecast];
    NSString *city         = [result valueForKeyPath:kWeatherManagerKeyLocationCity];
    NSString *state        = [result valueForKeyPath:kWeatherManagerKeyLocationState];
    
    for (NSDictionary *hourlyResult in hourlyResults) {
        
        [self updateHourlyForecastFromHourlyAPIResults:hourlyResult usingCity:city andState:state];
    }
}

- (void)updateHourlyForecastFromHourlyAPIResults:(NSDictionary *)result usingCity:(NSString *)city andState:(NSString *)state {
    
    UMBForecast *hourlyForecast = [[UMBForecast alloc] init];
    [self.forecasts addObject:hourlyForecast];
    
    hourlyForecast.city              = city;
    hourlyForecast.state             = state;
    hourlyForecast.temperatureF      = [self convertTemperature:[result valueForKeyPath:kWeatherManagerKeyTempF]];
    hourlyForecast.temperatureC      = [self convertTemperature:[result valueForKeyPath:kWeatherManagerKeyTempC]];
    hourlyForecast.condition         = [result valueForKeyPath:kWeatherManagerKeyCondition];
    hourlyForecast.date              = [self convertTimestampToDate:[result valueForKeyPath:kWeatherManagerKeyTimestamp]];
    hourlyForecast.isCurrentForecast = NO;
    
    [self.iconManager fetchIcon:[result valueForKeyPath:kWeatherManagerKeyIcon]
          withCompletionHandler:^(BOOL success, UIImage *icon) {
              
              if (success) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      hourlyForecast.icon = icon;
                      [self.delegate forecastsUpdated:self.forecasts];
                  });
              }
          }];
}

- (NSDate *)convertTimestampToDate:(NSString *)timestamp {
    
    return [NSDate dateWithTimeIntervalSince1970:[timestamp intValue]];
}

- (NSInteger)convertTemperature:(NSString *)temperature {
    
    return (NSInteger) round([temperature doubleValue]);
}

@end
