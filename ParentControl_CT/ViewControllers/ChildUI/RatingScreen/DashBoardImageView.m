//
//  DashBoardImageView.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 02/05/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "DashBoardImageView.h"

@implementation DashBoardImageView
{
    UILabel *today;
    UILabel *todayDate;
    
    int hh, mm;
}




- (id)initWithFrame:(CGRect)frame andDate:(NSString *)dateString andStatus:(int)statusIndex
{
    if ((self = [super initWithFrame:frame]))
    {
        self.frame=frame;
        [self drawHeader1:dateString andStatusCount:statusIndex];
       
    }
    return self;
}

-(void)drawHeader1:(NSString*)dateString andStatusCount:(int)statusIndex
{
    UIView *rectView=[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width*.8, self.frame.size.height)];
    rectView.backgroundColor=[UIColor whiteColor];
    rectView.alpha=0.1f;
    [self addSubview:rectView];
    
    
    today = [[UILabel alloc] initWithFrame:CGRectMake(10*ScreenWidthFactor,0,self.frame.size.width*.8-10*ScreenWidthFactor,self.frame.size.height)];
    today.textColor= cellWhiteColor_8;
    [today setFont:[UIFont fontWithName:Gotham size:10*ScreenFactor]];
    //[today sizeToFit];
    today.textAlignment=NSTextAlignmentLeft;
    [self addSubview:today];
    
    UIView *view2= [[UIView alloc]initWithFrame:CGRectMake(rectView.frame.size.width,0,self.frame.size.width-today.frame.size.width, self.frame.size.height)];
    view2.backgroundColor= [UIColor whiteColor];
    view2.alpha=0.2f;
//    view2.layer.borderWidth=1.0f;
//    view2.layer.borderColor=[UIColor colorWithRed:255.0f/255 green:255.0f/255 blue:255.0f/255 alpha:0.3f].CGColor;
//    [view2 setUserInteractionEnabled:YES];
    [self addSubview:view2];
    
    todayDate= [[UILabel alloc] initWithFrame:CGRectMake(today.frame.size.width+5*ScreenWidthFactor,0,self.frame.size.width-today.frame.size.width, self.frame.size.height)];
    todayDate.textColor= cellWhiteColor_8;
   //dateString= [dateString uppercaseString];
    todayDate.text=dateString;
    [todayDate setFont:[UIFont fontWithName:RobotoRegular size:8*ScreenFactor]];
    //[todayDate sizeToFit];
    todayDate.textAlignment=NSTextAlignmentCenter;
 //   [self addSubview:todayDate];
    
    UIImageView  *imageView ;
     hh=[[dateString substringToIndex:2] intValue];
     mm=[[dateString substringWithRange:NSMakeRange(4,2)] intValue];
    if(statusIndex==1 || statusIndex==2)
    {
        today.text = @"Great! You earned 70 points.";
        imageView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"earnedPointsCup.png")]];
    }
    else if(statusIndex == 0)
    {
        today.text = @"You had no activities today!";
        imageView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"lazyBoy.png")]];
    }
    else if(statusIndex==3 || statusIndex==4 || statusIndex==5)
    {
        today.text=[NSString stringWithFormat:@"Rate for today in %ih %im", hh,mm];
        imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"dashBoardClock.png")]];
        
        [self performSelector:@selector(updateTime) withObject:nil afterDelay:60.0];
    }
    
    imageView.frame=CGRectMake(self.frame.size.width-self.frame.size.height-cellPadding,3*ScreenHeightFactor, self.frame.size.height-4*ScreenHeightFactor,  self.frame.size.height-8*ScreenHeightFactor);
    imageView.center=CGPointMake(screenWidth*.79, self.frame.size.height/2);
    [self addSubview:imageView];
    
  
}


-(void)updateTime
{
    mm-=1;
    
    if(mm==0 && hh==0)
    {
        if(self.delegate)
        {
            [self.delegate rateAgain];
        }
    }
    
    
    if(mm==0)
    {
        hh-=1;
        mm=59;
    }
    if(mm>=0 && hh>=0)
    {
        today.text=nil;
        today.text=[NSString stringWithFormat:@"Rate for today in %ih %im", hh,mm];
     [self performSelector:@selector(updateTime) withObject:nil afterDelay:60];
    }
}


-(void)setNeedsDisplay
{
    [super setNeedsDisplay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
