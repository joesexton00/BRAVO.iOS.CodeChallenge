//
//  UMBNoResultsView.m
//  Umbrella
//
//  Created by Joe Sexton on 9/17/14.
//  Copyright (c) 2014 Umbrella Corp. All rights reserved.
//

#import "UMBNoResultsView.h"
#import "UMBUmbrellaView.h"

@implementation UMBNoResultsView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        // Umbrella view size is the smaller of height * .7 or width * .7 and is centered
        CGFloat umbrellaSize = self.bounds.size.width < self.bounds.size.height ? self.bounds.size.width * .7 : self.bounds.size.height * .7;
        CGFloat umbrellaX = (self.bounds.size.width / 2) - (umbrellaSize / 2);
        CGFloat umbrellaY = (self.bounds.size.height / 2) - (umbrellaSize / 2);
        
        UMBUmbrellaView *umbrellaView = [[UMBUmbrellaView alloc] initWithFrame:CGRectMake(umbrellaX, umbrellaY, umbrellaSize, umbrellaSize)];
        
        [self addSubview:umbrellaView];
        
        // Message label should be at bottom of the umbrella view with 10% padding left/right
        CGFloat umbrellaViewBottom = umbrellaView.frame.origin.y + umbrellaView.frame.size.height;
        self.messageLabel = [[UILabel alloc] initWithFrame: CGRectMake(self.bounds.size.width * 0.1, umbrellaViewBottom, self.bounds.size.width * 0.8, 40.0)];
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.font = [[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline] fontWithSize:20];
        [self addSubview:self.messageLabel];
    }
    
    return self;
}

@end
