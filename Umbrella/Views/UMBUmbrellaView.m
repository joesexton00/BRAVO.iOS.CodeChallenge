//
//  UMBUmbrellaView.m
//  Umbrella
//
//  Created by Joe Sexton on 9/16/14.
//  Copyright (c) 2014 Umbrella Corp. All rights reserved.
//

#import "UMBUmbrellaView.h"
#import "UMBGradientView.h"

@implementation UMBUmbrellaView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque          = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // start vertically in the middle and 25% from left edge
    [path moveToPoint:CGPointMake(self.bounds.size.width * .05, self.bounds.size.height / 2)];
    [path addCurveToPoint:CGPointMake(self.bounds.size.width - (self.bounds.size.width * .05), self.bounds.size.height/2) controlPoint1:CGPointMake(self.bounds.size.width / 7, self.bounds.size.height * .01) controlPoint2:CGPointMake(self.bounds.size.width / 7 * 6, self.bounds.size.height * .01)];
    [path closePath];
    
    // Nub on top of umbrella
    [path moveToPoint:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height * .13)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height * .05)];
    
    // Umbrella handle
    [path moveToPoint:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 4 * 3)];
    [path addCurveToPoint:CGPointMake(self.bounds.size.width / 5, self.bounds.size.height / 4 * 3) controlPoint1:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height) controlPoint2:CGPointMake(self.bounds.size.width / 5, self.bounds.size.height)];
    
    // Line details
    path.lineWidth = 8;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    [[UIColor colorWithRed:1 green:0.588 blue:0 alpha:1] setStroke];

    [path stroke];
}

@end
