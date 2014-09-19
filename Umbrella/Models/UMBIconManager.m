//
//  UMBIconManager.m
//  Umbrella
//
//  Created by Joe Sexton on 9/13/14.
//  Copyright (c) 2014 Umbrella Corp. All rights reserved.
//

#import "UMBIconManager.h"
#import "NSURLRequest+Umbrella.h"
#import "UMBNetworkActivityIndicatorManager.h"

@implementation UMBIconManager

static NSString * const kIconManagerIconDirectory = @"WeatherIcons";

#pragma mark - Fetching

- (void)fetchIcon:(NSString *)icon withCompletionHandler:(IconManagerFetchCompletionBlock)completionHandler {
    
    dispatch_async(dispatch_queue_create("icon_manager_image_fetch", NULL), ^{
        
        UIImage *iconImage = [self getLocalImageForIcon:icon];
        
        // If an image exists on the file system then return it
        if (iconImage) {
        
            completionHandler(YES, iconImage);
            return;
        }
                             
        // Otherwise download image and save it
        [[UMBNetworkActivityIndicatorManager sharedManager] startActivity];
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
        NSURLRequest *request = [NSURLRequest weatherRequestForIcon:icon];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
                                                        completionHandler:^(NSURL *localFile, NSURLResponse *response, NSError *error) {
                                                            
                                                            [[UMBNetworkActivityIndicatorManager sharedManager] endActivity];
                                                            
                                                            if (error) {
                                                                
                                                                NSLog(@"Weather icon fetch failed: %@", error.localizedDescription);
                                                                
                                                                completionHandler(NO, nil);
                                                                
                                                            } else {
                                                                
                                                                UIImage *iconImage = [UIImage imageWithData: [NSData dataWithContentsOfURL: localFile]];
                                                                [self saveLocalImage:iconImage forIcon:icon];

                                                                completionHandler(YES, iconImage);
                                                            }
                                                        }];
        [task resume];
    });
}

// Get the icon local file path
- (NSString *)getIconLocalPath:(NSString *)icon {
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *directoryPath = [documentsPath stringByAppendingPathComponent:kIconManagerIconDirectory];
    NSString *filePath      = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", icon]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    return filePath;
}

// Get the icon from local file
- (UIImage *)getLocalImageForIcon:(NSString *)icon {
    
    return [UIImage imageWithData:[NSData dataWithContentsOfFile:[self getIconLocalPath:icon]]];
}

// Save icon to local file
- (void)saveLocalImage:(UIImage *)iconImage forIcon:(NSString *)icon {
    
    // Double-check icon hasn't been saved already
    UIImage *existingImage = [self getLocalImageForIcon:icon];
    if (!existingImage) {
        NSData *iconData = [NSData dataWithData:UIImagePNGRepresentation(iconImage)];
        [iconData writeToFile:[self getIconLocalPath:icon] atomically:YES];
    }
    
}

@end
