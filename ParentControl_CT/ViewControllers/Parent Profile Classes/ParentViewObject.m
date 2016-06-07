//
//  ParentViewObject.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 31/03/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "ParentViewObject.h"
#import "PC_DataManager.h"

@implementation ParentViewObject
{
    UIImageView *img;
    UILabel *imglabel;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame])
    {
         self.frame=frame;
        return self;
       
    }
    return nil;
}

-(void)implementViewWithImage:(NSString*)imageName withLabel:(NSString*)labelStr
{
    
    img=[[UIImageView alloc]initWithImage:[UIImage imageNamed: isiPhoneiPad(imageName)]];
    img.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    img.center=CGPointMake(self.frame.size.width/2, img.center.y);
    [self addSubview:img];
    
    
    imglabel=[[UILabel alloc]init];
    CGSize displayValueSize = [labelStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f * ScreenHeightFactor]}];
    imglabel.font=[UIFont fontWithName:RobotoRegular size:13.0f * ScreenHeightFactor];
    imglabel.text=labelStr;
    imglabel.frame=CGRectMake(0,0,displayValueSize.width,displayValueSize.height);
    [imglabel sizeToFit];
    imglabel.center=CGPointMake(self.frame.size.width/2, img.frame.size.height+imglabel.frame.size.height/2);
    imglabel.textColor=[[UIColor blackColor]colorWithAlphaComponent:0.8f];
    
    [imglabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:imglabel];
    
}
-(void)updateViewWithBadgeCount:(NSString *)badgeCount
{
    
   // badgeCount = @"13";
     float wid= 22*ScreenWidthFactor;;
    float width  = 0.0f;
    if(screenHeight>700)
    {
        width = 14*ScreenWidthFactor;
    }
    else
    {
        width = 18*ScreenWidthFactor;;
    }
   UIView *countView = [[UIView alloc] initWithFrame:CGRectMake(img.frame.size.width-width,8*ScreenHeightFactor,15*ScreenWidthFactor, 20*ScreenHeightFactor)];
   
    
    CAShapeLayer *circle1 = [CAShapeLayer layer];
    circle1.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,0,wid,wid) cornerRadius:8*ScreenWidthFactor].CGPath;
    circle1.position  = CGPointZero;
    circle1.fillColor=[UIColor redColor].CGColor;
    
    circle1.strokeColor = [UIColor clearColor].CGColor;
    [countView.layer addSublayer:circle1];
    [img addSubview:countView];
    
    
    NSString *messageVal= badgeCount;
    
    UILabel *userCounts = [[UILabel alloc] initWithFrame: CGRectMake(0,0, wid , wid)];
    userCounts.text = messageVal;
    userCounts.textColor=[UIColor whiteColor];//[UIColor whiteColor];
    userCounts.textAlignment= NSTextAlignmentCenter;
    [userCounts setFont:[UIFont fontWithName:RobotoRegular size:wid - 8.0f * ScreenFactor]];
    //[countView setCenter:CGPointMake(countView.center.x-4,64/2.0f)];
    [countView addSubview:userCounts];


}


@end
