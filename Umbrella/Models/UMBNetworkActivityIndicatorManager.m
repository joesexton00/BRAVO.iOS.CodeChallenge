//
//  JSNetworkActivityMonitor.m
//  Shutterbug
//
//  Created by Joe Sexton on 8/26/14.
//  Copyright (c) 2014 Nerdery. All rights reserved.
//

#import "UMBNetworkActivityIndicatorManager.h"

@interface UMBNetworkActivityIndicatorManager()

@property (nonatomic) NSInteger tasks;
@property (strong, nonatomic) UIApplication *application;
@end

@implementation UMBNetworkActivityIndicatorManager

#pragma mark - Singleton

+ (UMBNetworkActivityIndicatorManager *)sharedManager {
    
    static UMBNetworkActivityIndicatorManager *sharedInstance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Actions

- (void)startActivity {
    
    @synchronized(self)
    {
        if (self.application.isStatusBarHidden) {
            return;
        }
    
        if (!self.application.isNetworkActivityIndicatorVisible) {
            self.application.networkActivityIndicatorVisible = YES;
            self.tasks = 0;
        }
    
        self.tasks++;
    }
}

- (void)endActivity {
    
    @synchronized(self)
    {
        if (self.application.isStatusBarHidden) {
            return;
        }
    
        self.tasks--;
        
        if (self.tasks <= 0) {
            self.application.networkActivityIndicatorVisible = NO;
            self.tasks = 0;
        }
    }
}

- (void)allActivitiesComplete {
    
    @synchronized(self)
    {
        if (self.application.isStatusBarHidden) {
            return;
        }
        
        self.application.networkActivityIndicatorVisible = NO;
        self.tasks = 0;
    }
}

#pragma mark - Getters/Setters

- (UIApplication *)application {
    
    if (!_application) {
        _application = [UIApplication sharedApplication];
    }
    
    return _application;
}

#pragma mark - Initializers

- (UMBNetworkActivityIndicatorManager *)init {
    
    self = [super init];
    
    self.tasks = 0;
    
    return self;
}

@end
