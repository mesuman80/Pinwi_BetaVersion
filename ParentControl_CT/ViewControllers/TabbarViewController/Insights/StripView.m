//
//  StripView.m
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 10/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "StripView.h"
#import "Constant.h"
#import "PC_DataManager.h"
@implementation StripView
{
    NSString *information;
}
@synthesize StripLabel;
@synthesize infoImage;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)drawStrip:(NSString *)title color:(UIColor *)color
{
    [self setBackgroundColor:activityHeading1Code];
    StripLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    StripLabel.text = title;
    StripLabel.textColor = activityHeading1FontCode;//[UIColor blackColor];
    StripLabel.font = [UIFont fontWithName:RobotoRegular size:18.0f*ScreenHeightFactor];
    CGSize labelSize = [StripLabel.text sizeWithAttributes:@{NSFontAttributeName:StripLabel.font}];
    [StripLabel setFrame:CGRectMake(cellPadding,0, labelSize.width, labelSize.height)];
    [StripLabel setCenter:CGPointMake(StripLabel.center.x,self.frame.size.height/2.0f)];
    [self addSubview:StripLabel];
}


-(void)drawInfoIcon
{
    int ht=self.frame.size.height-6*ScreenHeightFactor;
    //information=info;
    infoImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"infoInsights.png")]];
    infoImage.frame=CGRectMake(0, 0, ht, ht);
    infoImage.center=CGPointMake(self.frame.size.width-infoImage.frame.size.width/2-cellPadding, self.frame.size.height/2);
    [self addSubview:infoImage];
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width-self.frame.size.width/3,0,self.frame.size.width/2, self.frame.size.height)];
    [view setBackgroundColor:[UIColor clearColor]];
    [view setUserInteractionEnabled:YES];
    [self addSubview:view];
    
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(infoButtonTouched:)];
    [view addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *tapGesture1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(infoButtonTouched1:)];
    [self addGestureRecognizer:tapGesture1];
}

-(void)infoButtonTouched:(id)sender
{
    [infoImage setAlpha:0.1];
    [self  performSelector:@selector(callDelegate:) withObject:sender afterDelay:0.1];
}

-(void)infoButtonTouched1:(id)sender
{
    [self setAlpha:0.1];
    [self  performSelector:@selector(callDelegate:) withObject:sender afterDelay:0.1];
}

-(void)callDelegate:(id)sender
{
    if(self.stripInfoDelegate)
    {
        [self.stripInfoDelegate stripInfoBtnTouch:self];
        [infoImage setAlpha:1.0f];
        [self setAlpha:1.0f];
    }
//
}


@end
