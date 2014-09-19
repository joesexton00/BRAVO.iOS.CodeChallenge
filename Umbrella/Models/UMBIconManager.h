//
//  UMBIconManager.h
//  Umbrella
//
//  Created by Joe Sexton on 9/13/14.
//  Copyright (c) 2014 Umbrella Corp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMBIconManager : NSObject

// Completion handler to call when the icon fetch is complete.
// Success indicates if the fetch was successful.
// The icon is a UIImage for the icon.
typedef void (^IconManagerFetchCompletionBlock)(BOOL success, UIImage *icon);

// Fetch an icon by name.
// The completion handler will be called when the icon
// has been fethed.
- (void)fetchIcon:(NSString *)icon withCompletionHandler:(IconManagerFetchCompletionBlock)completionHandler;

@end
