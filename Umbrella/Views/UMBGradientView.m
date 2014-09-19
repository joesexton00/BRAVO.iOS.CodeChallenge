//
//  UMBGradientView.m
//  Umbrella
//
//  Created by Joe Sexton on 9/14/14.
//  Copyright (c) 2014 Umbrella Corp. All rights reserved.
//

#import "UMBGradientView.h"

@interface UMBGradientView()

@property (strong, nonatomic) CAGradientLayer *gradientLayer;

@end

@implementation UMBGradientView

- (CAGradientLayer *)gradientLayer {
    
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        [self.layer insertSublayer:_gradientLayer atIndex:0];
    }
    
    return _gradientLayer;
}

- (void)setGradient:(Gradient)gradient {
    
    _gradient = gradient;
    
    [self updateViewGradient];

    [self setNeedsDisplay];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self updateViewGradient];
    }    
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self updateViewGradient];
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self updateViewGradient];
}

- (void)updateViewGradient {
 
    self.gradientLayer.frame = self.bounds;
    
    NSArray *colors;
    
    switch (self.gradient) {
        case GradientViewWarmGradient:
            colors = [self warmColors];
            break;
        case GradientViewCoolGradient:
            colors = [self coolColors];
            break;
        case GradientViewNoGradient:
        default:
            colors = [self neutralColors];
            break;
    }
    self.gradientLayer.colors = colors;
    
    [self setNeedsDisplay];
}

- (NSArray *)warmColors {
    
    return @[(id)[self warmGradientTopColor].CGColor,
             (id)[self warmGradientBottomColor].CGColor];
}

- (NSArray *)coolColors {
    
    return @[(id)[self coolGradientTopColor].CGColor,
             (id)[self coolGradientBottomColor].CGColor];
}

- (NSArray *)neutralColors {
    
    return @[(id)[UIColor whiteColor].CGColor,
             (id)[UIColor whiteColor].CGColor];
}

- (UIColor *)warmGradientTopColor {
    
    return [UIColor colorWithRed:1 green:0.588 blue:0 alpha:1]; /*#ff9600*/
}

- (UIColor *)warmGradientBottomColor {
    
    return [UIColor colorWithRed:1 green:0.235 blue:0.2 alpha:1]; /*#ff3c33*/
}

- (UIColor *)coolGradientTopColor {
    
    return [UIColor colorWithRed:0 green:0.478 blue:1 alpha:1]; /*#007aff*/
}

- (UIColor *)coolGradientBottomColor {
    
    return [UIColor colorWithRed:0.337 green:0.341 blue:0.824 alpha:1]; /*#5657d2*/
}

- (UIColor *)neutralGradientTopColor {
    
    return [UIColor whiteColor];
}

- (UIColor *)neutralGradientBottomColor {
    
    return [UIColor whiteColor];
}

@end
