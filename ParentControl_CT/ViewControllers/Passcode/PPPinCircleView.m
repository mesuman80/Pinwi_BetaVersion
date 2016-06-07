//
//  VTPinCircleImageView.m
//  PinPad
//
//  Created by Aleks Kosylo on 1/16/14.
//  Copyright (c) 2014 Aleks Kosylo. All rights reserved.
//

#import "PPPinCircleView.h"

@implementation PPPinCircleView

+ (instancetype)circleView:(CGFloat)radius {
    
    PPPinCircleView * circleView = [[PPPinCircleView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, radius*2.0f, radius*2.0f)];
   
    circleView.layer.cornerRadius = radius;
    circleView.layer.borderColor = [UIColor lightGrayColor].CGColor;//[[UIColor colorWithRed:254.0f/255 green:94.0f/255 blue:58.0f/255 alpha:1] colorWithAlphaComponent:1].CGColor;
    circleView.layer.borderWidth = 2.0f;
    return circleView;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
