//
//  UMBMainViewController.h
//  Umbrella
//
//  Created by {{YOUR_NAME_HERE}} on 9/12/12.
//  Copyright (c) 2013 {{YOUR_NAME_HERE}}. All rights reserved.
//

#import "UMBWeatherManagerDelegate.h"

@interface UMBMainViewController : UIViewController <UMBWeatherManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

// UMBWeatherManagerDelegate
// This method is called whenever the forecasts are updated
- (void)forecastsUpdated:(NSArray *)forecasts;

// Show/hide settings
- (void)showSettings;
- (void)hideSettings;

@end
