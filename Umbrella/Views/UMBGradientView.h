//
//  UMBGradientView.h
//  Umbrella
//
//  Created by Joe Sexton on 9/14/14.
//  Copyright (c) 2014 Umbrella Corp. All rights reserved.
//
//  This is a base class for a view with a gradient background.
//  To use, set the gradient to any of the Gradient enum values.

#import <UIKit/UIKit.h>

@interface UMBGradientView : UIView

// Possible gradient colors/hues.
typedef enum {
    GradientViewNoGradient   = 0,
    GradientViewWarmGradient = 1,
    GradientViewCoolGradient = 2
} Gradient;

// Gradient color/hue.
@property (nonatomic) Gradient gradient;

// Colors used.
- (UIColor *)warmGradientTopColor;
- (UIColor *)warmGradientBottomColor;

- (UIColor *)coolGradientTopColor;
- (UIColor *)coolGradientBottomColor;

- (UIColor *)neutralGradientTopColor;
- (UIColor *)neutralGradientBottomColor;
@end
