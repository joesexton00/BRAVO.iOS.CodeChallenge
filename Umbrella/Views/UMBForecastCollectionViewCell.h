//
//  UMBForecastCollectionViewCell.h
//  Umbrella
//
//  Created by Joe Sexton on 9/15/14.
//  Copyright (c) 2014 Umbrella Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMBGradientView.h"

@interface UMBForecastCollectionViewCell : UICollectionViewCell

// Image for the center icon.  The view will change
// the icon colors based on the gradient.
@property (strong, nonatomic) UIImage *icon;

// Top label for the cell.
@property (strong, nonatomic) NSString *topText;

// Bottom label for the cell.
@property (strong, nonatomic) NSString *bottomText;

// Gradient color/hue.
@property (nonatomic) Gradient gradient;

@end
