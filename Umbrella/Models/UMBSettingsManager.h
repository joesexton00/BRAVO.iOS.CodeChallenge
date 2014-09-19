//
//  UMBSettingsManager.h
//  Umbrella
//
//  Created by Joe Sexton on 9/13/14.
//  Copyright (c) 2014 Umbrella Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMBSettingsManager : NSObject

// Zip code to retrieve forecasts for.
@property (strong, nonatomic) NSString *zipCode;

// Setting to use celsius in the forecasts.
// If not saved in settings the default is NO.
@property BOOL celsius;

@end
