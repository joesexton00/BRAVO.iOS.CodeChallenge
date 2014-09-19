//
//  UMBSettingsManager.m
//  Umbrella
//
//  Created by Joe Sexton on 9/13/14.
//  Copyright (c) 2014 Umbrella Corp. All rights reserved.
//

#import "UMBSettingsManager.h"

@interface UMBSettingsManager()

@property (strong, nonatomic) NSUserDefaults *userDefaults;

@end

@implementation UMBSettingsManager

static NSString * const kSettingsManagerKeyCelsius = @"celsius";
static NSString * const kSettingsManagerKeyZipCode = @"zip_code";

static NSString * const kSettingsManagerFahrenheit = @"fahrenheit";
static NSString * const kSettingsManagerCelsius    = @"celsius";

#pragma mark - Stters/Getters

- (NSUserDefaults *)userDefaults {
    
    if (!_userDefaults) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    
    return _userDefaults;
}

- (NSString *)zipCode {
    
    return [self.userDefaults objectForKey:kSettingsManagerKeyZipCode];
}

- (void)setZipCode:(NSString *)zipCode {
    
    [self.userDefaults setObject:zipCode forKey:kSettingsManagerKeyZipCode];
    [self.userDefaults synchronize];
}

- (BOOL)celsius {
    
    return [self.userDefaults boolForKey:kSettingsManagerKeyCelsius];
}

- (void)setCelsius:(BOOL)celsius {
    
    [self.userDefaults setBool:celsius forKey:kSettingsManagerKeyCelsius];
    [self.userDefaults synchronize];
}

@end
