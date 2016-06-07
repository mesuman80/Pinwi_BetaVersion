//
//  Circle.m
//  ParentControl_CT
//
//  Created by Priyanka on 16/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "Circle.h"

@implementation Circle

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)drawRect:(CGRect)rect{
    CGContextRef context= UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
//    CGContextSetAlpha(context, 0.5);
//    CGContextFillEllipseInRect(context, CGRectMake(0,0,50,50));
//    [[UIColor blackColor]colorWithAlphaComponent:0.8f];
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextStrokeEllipseInRect(context, CGRectMake(0,0,50,50));
}
@end
