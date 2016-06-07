//
//  HeaderView.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 02/09/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "ChildHeaderView.h"
#import "PC_DataManager.h"
#import "PinWiRightSideButton.h"
#import "MenuSettingsView.h"

@interface ChildHeaderView()

@end


@implementation ChildHeaderView
{
    UIImageView *centerIcon;
    MenuSettingsView *menu;
    BOOL isToggleMenu;
    
    BOOL pageControlBeingUsed;
    UIPageControl *pageControl;
    int pageControlHeight;
    
    UIButton *backButton;
    UIView *viewBack;
    UIGestureRecognizer *gestureRecognizer;
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
    if(self == [super initWithFrame:frame])
    {
        return self;
    }
    return nil;
}



#pragma mark headerViewSpecificFunction
-(void)drawHeaderViewWithTitle:(NSString*)title isBackBtnReq:(BOOL)backBtn BackImage:(NSString*)backImageName
{
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"child_headerBg.png")]];
    [imageView setFrame:CGRectMake(0, 0, self.frame.size.width,ScreenFactor*40)];
    [self addSubview:imageView];
    
    
    UIButton *button  = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,60*ScreenWidthFactor,30*ScreenWidthFactor)];
    [button setTintColor:[UIColor whiteColor]];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:RobotoRegular size:12*ScreenFactor]];
    [button addTarget:self action:@selector(touchAtPinwiWheel) forControlEvents:UIControlEventTouchUpInside];
    [button setCenter:CGPointMake(self.frame.size.width*.90f,self.frame.size.height/2+10)];
    [self addSubview:button];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    label.text = title;
    label.textColor = [UIColor whiteColor];
    if(screenWidth>700)
    {
        label.font = [UIFont fontWithName:RobotoRegular size:ScreenFactor*12];
    }
    else
    {
        label.font = [UIFont fontWithName:RobotoRegular size:ScreenFactor*12];
    }
    
    CGSize labelSize = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
    [label setFrame:CGRectMake(0,0, labelSize.width, labelSize.height)];
    if([self navigationBarHeight] == 0) // For Iphone
    {
        [label setCenter:CGPointMake(self.frame.size.width/2.0f,self.frame.size.height/2.0f)];
    }
    else
    {
        [label setCenter:CGPointMake(self.frame.size.width/2.0f,self.frame.size.height/2.0f+8)];
    }
    
    [self addSubview:label];
    
    centerIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(_centreImgName) ]];
    centerIcon.frame=CGRectMake(0,self.frame.size.height-12*ScreenHeightFactor, centerIcon.image.size.width, centerIcon.image.size.height);
    if(self.frame.size.width>700)
    {
        centerIcon.center=CGPointMake(ScreenWidthFactor*320/2,centerIcon.center.y);
    }
    else
    {
        centerIcon.center=CGPointMake(ScreenWidthFactor*320/2,centerIcon.center.y-4*ScreenHeightFactor );
    }
    [self addSubview:centerIcon];
    
    
    if(backBtn)
    {
        [self addBackButton:backImageName];
    }
}

// initialY = centerIcon.frame.origin.y + centerIcon.frame.size.height;

-(void)touchAtPinwiWheel
{
    //if(self.headerViewdelegate)[self.headerViewdelegate getMenuTouches];
}

-(void)touchAtFlower:(id)sender
{
    NSLog(@"Touch at flower at insightViewController");
}

-(int)navigationBarHeight
{
    return screenWidth >700 ? 0 :0;
}

-(void)setupPageControl:(NSInteger)number_Of_Page
{
    int height  = [self navigationBarHeight];
    if(height == 0)
    {
        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0,height+3,pageControlHeight,pageControlHeight)];
    }
    else
    {
        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0,height,pageControlHeight,pageControlHeight)];
    }
    
    [pageControl setCenter:CGPointMake(screenWidth/2, pageControl.center.y)];
    pageControl.currentPage=0;
    pageControl.numberOfPages=number_Of_Page;
    // pageControl.pageIndicatorTintColor=[UIColor blackColor];
    [pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
    [self addSubview:pageControl];
}

#pragma mark going back
-(void)addBackButton:(NSString*)imageName
{
    viewBack=[[UIView alloc]initWithFrame:CGRectMake(0, 0,ScreenFactor*25, ScreenFactor*25)];
    [viewBack setBackgroundColor:[UIColor clearColor]];
    [self addSubview:viewBack];
    gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goBack)];
    [viewBack addGestureRecognizer:gestureRecognizer];
    
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    // [backButton setTitle:@"<" forState:UIControlStateNormal];
    [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15*ScreenFactor]];
    backButton.tintColor=[UIColor whiteColor];
    [backButton setFrame:CGRectMake(0, 0,ScreenFactor*25,ScreenFactor*25)];
    [backButton setImage:[UIImage imageNamed:isiPhoneiPad(imageName)] forState:UIControlStateNormal];
    //    if(self.frame.size.width>700)
    //    {
    //        [backButton setFrame:CGRectMake(0, 0,ScreenFactor*10,ScreenFactor*10)];
    //
    //    }
    //    else
    //    {
    //        [backButton setFrame:CGRectMake(0, 0,screenWidth*.08,screenWidth*.08)];
    //        //  backButton.center=CGPointMake(.07*screenWidth ,.04*screenHeight);
    //    }
    
    viewBack.center=CGPointMake(backButton.center.x, self.frame.size.height/2+10);
    backButton.center=CGPointMake(backButton.center.x, self.frame.size.height/2+10);
    [self addSubview:backButton];
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
}

-(void)goBack
{
    if(self.headerViewdelegate)
    {
        [self.headerViewdelegate touchAtBackButton];
    }
}



@end
