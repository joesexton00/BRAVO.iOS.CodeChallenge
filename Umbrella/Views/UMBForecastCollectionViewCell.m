//
//  UMBForecastCollectionViewCell.m
//  Umbrella
//
//  Created by Joe Sexton on 9/15/14.
//  Copyright (c) 2014 Umbrella Corp. All rights reserved.
//

#import "UMBForecastCollectionViewCell.h"

@interface UMBForecastCollectionViewCell()

@property (strong, nonatomic) UMBGradientView *gradientView;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation UMBForecastCollectionViewCell

- (UMBGradientView *)gradientView {
    
    if (!_gradientView) {
        _gradientView = [[UMBGradientView alloc] initWithFrame:self.bounds];
        [self addSubview:_gradientView];
        [self sendSubviewToBack:_gradientView];
    }
    
    return _gradientView;
}

- (void)setGradient:(Gradient)gradient {
    
    _gradient = gradient;
    
    self.gradientView.gradient = gradient;
    [self updateColors];
}

- (void)setTopText:(NSString *)topText {
    
    _topText = topText;
    
    self.topLabel.text = topText;
}

- (void)setBottomText:(NSString *)bottomText {
    
    _bottomText = bottomText;
    
    self.bottomLabel.text = bottomText;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    
    self.gradientView.gradient = self.gradient;
    
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 1.0f;
    
    [self updateColors];
}

- (void)updateColors {
    
    // Labels
    self.topLabel.textColor    = [self getTintColor];
    self.bottomLabel.textColor = [self getTintColor];

    // Icon
    CGRect rect = CGRectMake(0, 0, self.icon.size.width, self.icon.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToMask(context, rect, self.icon.CGImage);
    CGContextSetFillColorWithColor(context, [[self getTintColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *flippedIcon = [UIImage imageWithCGImage:img.CGImage
                                               scale:1.0 orientation: UIImageOrientationDownMirrored];
    
    self.iconImageView.image = flippedIcon;
}

- (UIColor *)getTintColor {
    
    UIColor *color = [UIColor blackColor];
    
    if (self.gradient == GradientViewWarmGradient || self.gradient == GradientViewCoolGradient) {
        
        color = [UIColor whiteColor];
    }
    
    return color;
}

@end
