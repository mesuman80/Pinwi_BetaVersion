//
//  InsightsStaticView.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 03/11/15.
//  Copyright © 2015 ImagineInteractive. All rights reserved.
//

#import "InsightsStaticView.h"
#import "Constant.h"
#import "PC_DataManager.h"
#import "ParentViewProfile.h"

#define gap 20*ScreenHeightFactor

@implementation InsightsStaticView
{
    int yy;
    UIScrollView *scrollView;
    UIButton *continueButton;
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
    if(self==[super initWithFrame:frame])
    {
        
    }
    return self;
}


-(void)drawStaticUI
{
    yy=10*ScreenHeightFactor;
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, self.frame.size.width, self.frame.size.height)];
    [scrollView setPagingEnabled:NO];
    [self addSubview:scrollView];
    [self drawImage];
    [self drawHeadLabel];
    [self drawText];
    [self drawDashBoardButton];
    
    [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width, yy)];
}

-(void)drawImage
{
    UIImageView *titleImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"timerInsight.png")]];
    titleImg.frame=CGRectMake(0, 0, ScreenHeightFactor*80,ScreenHeightFactor*80);
    titleImg.center=CGPointMake(screenWidth/2,yy+titleImg.frame.size.height/2);
    [scrollView addSubview:titleImg];

    yy+=titleImg.frame.size.height+gap;
}
-(void)drawText
{
    NSArray *testArray=@[@"Insights are generated using data we receive from you \nand your children - The more activities you add\nand your child rates, the more quickly Insights will be activated.\n\nWe recommend you add up to 5\nschool subjects and 3 after school activities for\nyour child to activate Insights in 7 days.\nRemember to encourage your child to rate\neveryday."];
    
    [self drawLabelWithText:[testArray objectAtIndex:0] andColor:[UIColor darkGrayColor] andFont:[UIFont fontWithName:RobotoLight size:9*ScreenFactor]];
    
}

-(void)drawHeadLabel
{
   UILabel *label=[[UILabel alloc]init];
    NSString *str=@"Activate Insights in 7 days";
   CGSize size = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:8*ScreenFactor]}];
    label.font=[UIFont fontWithName:RobotoBold size:8*ScreenFactor];
    label.numberOfLines=2;
    label.text=str;
    label.frame=CGRectMake(cellPadding,yy,screenWidth-cellPadding*2,size.height*2);
    [label setTextAlignment:NSTextAlignmentCenter];
   // [label sizeToFit];
    label.textColor=[UIColor blackColor];
    label.center=CGPointMake(screenWidth/2,label.center.y);
    [scrollView addSubview:label];
    
    yy+=label.frame.size.height+gap;
}

-(UILabel*)drawLabelWithText:(NSString*)title andColor:(UIColor*)color andFont:(UIFont*)font
{
    UILabel *label = [[UILabel alloc]init];
    //[label setText:title];
    [label setTextColor:color];
    [label setFont:font];
    [label setNumberOfLines:0];
    // CGSize size = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
    label.text=title;
    CGSize  size = {self.frame.size.width - 10*ScreenWidthFactor, 10000.0};
    CGRect frame = [label.text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                         attributes:@{NSFontAttributeName:label.font}
                                            context:nil];
    
    [label setFrame:CGRectMake(10*ScreenWidthFactor,yy, frame.size.width, frame.size.height)];
    // [label setFrame:CGRectMake(10*ScreenFactor,yCord, size.width, size.height)];
    [scrollView addSubview:label];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setCenter:CGPointMake(self.frame.size.width/2,yy+label.frame.size.height/2)];
    yy+=label.frame.size.height+gap;
    
    return label;
}

-(void)drawDashBoardButton
{
    continueButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [continueButton setTitle:@"Go back to Dashboard" forState:UIControlStateNormal];
    continueButton.tintColor=[UIColor blackColor];
    continueButton.backgroundColor=buttonGreenColor;
    [continueButton setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    continueButton.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.023*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    [continueButton sizeToFit];
    if (screenWidth>700) {
        continueButton.frame=CGRectMake(cellPaddingReg,yy+55, screenWidth-2*cellPaddingReg, .066*screenHeight);
        continueButton.center=CGPointMake(screenWidth*.5,continueButton.center.y);
    }
    else{
    continueButton.frame=CGRectMake(cellPaddingReg,yy+25, screenWidth-2*cellPaddingReg, .066*screenHeight);
    continueButton.center=CGPointMake(screenWidth*.5,continueButton.center.y);
    }
    [continueButton addTarget:self action:@selector(continueBtnTouched) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:continueButton];
    
    yy+=continueButton.frame.size.height+gap;
    if(screenWidth>700)
    {
        yy+=2*gap;
    }
   // [lineViewArray addObject:continueButton];
}

-(void)continueBtnTouched
{
    ParentViewProfile *access=[[ParentViewProfile alloc]init];
    UINavigationController *naviCtrl=[[UINavigationController alloc]initWithRootViewController:access];
    [[[UIApplication sharedApplication]keyWindow]setRootViewController:naviCtrl];
}
@end
