//
//  JSNetworkActivityMonitor.h
//  Shutterbug
//
//  Created by Joe Sexton on 8/26/14.
//  Copyright (c) 2014 Nerdery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMBNetworkActivityIndicatorManager : NSObject


// Get class singleton
+ (UMBNetworkActivityIndicatorManager *)sharedManager;

// Show network activity indicator
// Each call adds an activity to the internal queue
- (void)startActivity;

// Hide network activity indicator
// Will not hide the indicator until all activities are complete
- (void)endActivity;

// Hide the network activity indicator
// This will hide the indicator regardless of how many activities have been started
- (void)allActivitiesComplete;

@end
