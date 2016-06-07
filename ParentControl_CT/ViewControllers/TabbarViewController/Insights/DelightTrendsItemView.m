//
//  DelightTrendsItemView.m
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 12/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "DelightTrendsItemView.h"
#import "Constant.h"
#import "PC_DataManager.h"

@implementation DelightTrendsItemView
-(void)drawUI:(NSDictionary *)dataDictionary
{
    NSString *avgRating =[NSString stringWithFormat:@"%@",[dataDictionary valueForKey:@"Rating"]];;
    NSString *change = [NSString stringWithFormat:@"%@",[dataDictionary valueForKey:@"Change"]];
    NSString *name =[NSString stringWithFormat:@"%@",[dataDictionary valueForKey:@"Name"]];
    
    UILabel *subjectName=[self drawLabel:name withFont:[UIFont systemFontOfSize:10.0f*ScreenFactor] withColor:[UIColor colorWithRed:92.0f/255 green:92.0f/255 blue:92.0f/255 alpha:1]];//colorWithAlphaComponent:1.0f]];
    int intialXForCircle = cellPadding;
    
    
    UILabel *ratingLabel = [self drawLabel:avgRating withFont:[UIFont systemFontOfSize:8.0f*ScreenFactor] withColor:[[UIColor blackColor]colorWithAlphaComponent:0.5f]];
    [ratingLabel setFrame:CGRectMake(self.frame.size.width-ratingLabel.frame.size.width-25*ScreenFactor,4*ScreenFactor,ratingLabel.frame.size.width,ratingLabel.frame.size.height)];
    
//    NSString *imageName= nil;
//    if([change isEqualToString:@"2"])
//    {
//        imageName = @"downArrow.png";
//    }
//    else if([change isEqualToString:@"1"])
//    {
//        imageName = @"upArrow.png";
//    }
//    else
//    {
//        imageName = @"normalArrow.png";
//    }
//    UIImageView *imageView = [[UIImageView alloc]init];
//    [imageView setFrame:CGRectMake(0, 0,self.frame.size.height/3.0f,self.frame.size.height/3.0f)];
//    imageView.center = CGPointMake(self.frame.size.width-imageView.frame.size.width/2-cellPadding,ratingLabel.center.y);
//    [self addSubview:imageView];
    
    [ratingLabel setTextAlignment:NSTextAlignmentRight];
    [ratingLabel setFrame:CGRectMake(0, 0,self.frame.size.height/2.0f,self.frame.size.height/3.0f)];
    [ratingLabel setCenter:CGPointMake(self.frame.size.width-ratingLabel.frame.size.width-cellPadding,ratingLabel.center.y)];
    
    int endXForCircle = ratingLabel.frame.origin.x + ratingLabel.frame.size.width+7*ScreenWidthFactor ;
    float circleX = (((endXForCircle - intialXForCircle)/10)*avgRating.floatValue);
    
    float circleWidth = self.frame.size.height/4.0f;
    
    [self drawLine:intialXForCircle withLineYPosition:subjectName.frame.origin.y+subjectName.frame.size.height+(7 *ScreenHeightFactor) withCircleXPosition:circleX circleWidth:circleWidth maxLength:screenWidth-cellPadding];
    
    [self drawCircle:CGRectMake(circleX,subjectName.frame.origin.y+subjectName.frame.size.height+2*ScreenHeightFactor,circleWidth, circleWidth)];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchAtDelight:)];
    [self addGestureRecognizer:gesture];
    
    self.dataDict=dataDictionary;
    
}
-(UILabel *)drawLabel:(NSString *)labelStr withFont:(UIFont *)font withColor:(UIColor*)color
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0,0,0,0)];
    label.textColor=color;
    [label setText:labelStr];
    label.font = font ;
    CGSize displayValueSize = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
    [label setFrame:CGRectMake(cellPadding,4*ScreenFactor,displayValueSize.width, displayValueSize.height)];
    [self addSubview:label];
    return label;
    
}
-(void)drawLine:(int)initialX  withLineYPosition:(int)lineYPosition withCircleXPosition:(float)circleX circleWidth:(float)circleWidth maxLength:(float)maxLength
{
    UIView *lineView1= [[UIView alloc]initWithFrame:CGRectMake(cellPadding,lineYPosition,circleX-initialX,1*ScreenHeightFactor)];
    [lineView1 setBackgroundColor: [UIColor colorWithRed:109.0f/255 green:109.0f/255 blue:109.0f/255 alpha:1]];
    [self addSubview:lineView1];
    
    initialX+= lineView1.frame.size.width+circleWidth;
    
    if(initialX<maxLength)
    {
        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(initialX,lineYPosition,maxLength-initialX,1*ScreenHeightFactor)];
        [lineView2 setBackgroundColor:[UIColor colorWithRed:216.0f/255 green:216.0f/255 blue:216.0f/255 alpha:1]];
        [self addSubview:lineView2];
        
    }
}
-(void)drawCircle:(CGRect)frame
{
    CAShapeLayer *circle1 = [CAShapeLayer layer];
    circle1.path = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:4*ScreenHeightFactor].CGPath;
    circle1.fillColor=[UIColor clearColor].CGColor;
    circle1.strokeColor = [UIColor grayColor].CGColor;
    [self.layer addSublayer:circle1];
}

-(void)touchAtDelight:(id)sender
{
    if(self.delightTrendDelegate)
    {
       self.alpha=0.4f;
        [self performSelector:@selector(callDelegate) withObject:nil afterDelay:0.2];
    }
}
-(void)callDelegate
{
     self.alpha=1.0f;
     [self.delightTrendDelegate delightTrendtouched:self];
}




@end
