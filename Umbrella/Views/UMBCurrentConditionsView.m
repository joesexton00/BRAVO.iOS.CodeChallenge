//
//  UMBCurrentConditionsView.m
//  Umbrella
//
//  Created by Joe Sexton on 9/14/14.
//  Copyright (c) 2014 Umbrella Corp. All rights reserved.
//

#import "UMBCurrentConditionsView.h"

@interface UMBCurrentConditionsView()

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;

@end

@implementation UMBCurrentConditionsView

- (void)setCondition:(NSString *)condition {
    
    _condition = condition;
    self.conditionLabel.text = condition;
}

- (void)setTemperature:(NSString *)temperature {
    
    _temperature = temperature;
    self.temperatureLabel.text = temperature;
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
    
    self.view = [[[NSBundle mainBundle] loadNibNamed:@"UMBCurrentConditionsView" owner:self options:nil] objectAtIndex:0];
    self.view.backgroundColor = [UIColor clearColor];
    [self addSubview:self.view];
}



@end
