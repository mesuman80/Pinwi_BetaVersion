//
//  HeaderView.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 02/09/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "HeaderView.h"
#import "PC_DataManager.h"
#import "PinWiRightSideButton.h"
#import "MenuSettingsView.h"
#import "GetHolidayDetailsByHolidayDescController.h"

@interface HeaderView() <PinWiRightSideButtonDelegate>

@end

@implementation HeaderView
{
    UIImageView *centerIcon;
    MenuSettingsView *menu;
    BOOL isToggleMenu;
    
    BOOL pageControlBeingUsed;
    UIPageControl *pageControl;
    int pageControlHeight;
    
    UIButton *backButton;
    UIGestureRecognizer *gestureRecognizer;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@synthesize viewBack;
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

    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"header_above.png")]];
    [imageView setFrame:CGRectMake(0, 0, self.frame.size.width,ScreenFactor*40)];
    [self addSubview:imageView];

    
    if([self.rightType isEqualToString:@"Menu"])
    {
        //UIImage *img = [UIImage imageNamed:isiPhoneiPad(@"Flower_pinwii.png")];
        PinWiRightSideButton *button = [[PinWiRightSideButton alloc]initWithFrame:CGRectMake(self.frame.size.width-60*ScreenWidthFactor, 0, ScreenHeightFactor*55,ScreenHeightFactor*55)];
        if(self.frame.size.width>700)
        {
            button.frame=CGRectMake(self.frame.size.width-40*ScreenWidthFactor-cellPadding/2, 0, ScreenHeightFactor*55,ScreenHeightFactor*55);
        }
        else
        {
            button.frame=CGRectMake(self.frame.size.width-60*ScreenWidthFactor, 0, ScreenHeightFactor*55,ScreenHeightFactor*55);
        }
        
//        button.frame=CGRectMake(self.frame.size.width-button.frame.size.width-10*ScreenWidthFactor, 0,img.size.width*1.5,img.size.height*1.5);
        [button setCenter:CGPointMake(button.center.x, self.frame.size.height/2+5*ScreenHeightFactor)];
        [button setDelegate:self];
        [button drawRightHandButton];
        //button.backgroundColor=cellWhiteColor_8;
        [self addSubview:button];

    }

   else if([self.rightType isEqualToString:@"Done"] || [self.rightType isEqualToString:@"Save"] || [self.rightType isEqualToString:@"Set Holiday"])
    {
        UIButton *button = nil;
        if([self.rightType isEqualToString:@"Set Holiday"]) {
            button  = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,89*ScreenWidthFactor,30*ScreenWidthFactor)];
            [button setCenter:CGPointMake(screenWidth-cellPadding-button.frame.size.width/2,self.frame.size.height/2+4)];
        }
        else {
             button  = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,40*ScreenWidthFactor,30*ScreenWidthFactor)];
            [button setCenter:CGPointMake(screenWidth-cellPadding-button.frame.size.width/2,self.frame.size.height/2+3)];

        }
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTitle:self.rightType forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont fontWithName:RobotoRegular size:10*ScreenFactor]];
            [button addTarget:self action:@selector(touchAtPinwiWheel) forControlEvents:UIControlEventTouchUpInside];
            if(_rightButtonDisable) {
                 [button setTintColor:[UIColor grayColor]];
                 [button setTitleColor:appBackgroundColor forState:UIControlStateNormal];
                 [button setAlpha:0.4f];
                 [button setEnabled:NO];
            }
            else {
                 [button setTintColor:[UIColor whiteColor]];
            }
            [self addSubview:button];
    
       
    }
   
if(title)
{
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
        [label setCenter:CGPointMake(self.frame.size.width/2.0f,self.frame.size.height/2.0f+3)];
    }
    else
    {
        [label setCenter:CGPointMake(self.frame.size.width/2.0f,self.frame.size.height/2.0f+8)];
    }
    
    [self addSubview:label];
    }
    
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
    


    
    
    if(backBtn && [backImageName isEqualToString:@"Cancel"])
    {
        [self addBackButton:backImageName];
    }
    else
    {
        if(backBtn)
        {
            [self addBackButton:backImageName];
        }
    }
}
    
   // initialY = centerIcon.frame.origin.y + centerIcon.frame.size.height;

-(void)touchAtPinwiWheel
{
    if(self.headerViewdelegate)[self.headerViewdelegate getMenuTouches];
    
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
    UIFont *font = [UIFont fontWithName:RobotoRegular size:12*ScreenFactor];
    [backButton.titleLabel setFont:font];
    backButton.tintColor=[UIColor whiteColor];
    [backButton setFrame:CGRectMake(0, 0,ScreenFactor*25,ScreenFactor*25)];
    UIImage *image  = [UIImage imageNamed:isiPhoneiPad(imageName)];
    if(image)
    {
        [backButton setImage:image forState:UIControlStateNormal];
    }
    else
    {
         //[backButton setFrame:CGRectMake(0, 0,ScreenFactor*25,ScreenFactor*25)];
        CGSize size = [imageName sizeWithAttributes:@{NSFontAttributeName:font}];
        [backButton setFrame:CGRectMake(20*ScreenWidthFactor, 0,size.width,size.height)];
        [backButton setTitle:imageName forState:UIControlStateNormal];
    }
    
    
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
    
    viewBack.center=CGPointMake(backButton.center.x, self.frame.size.height/2+3);
    backButton.center=CGPointMake(backButton.center.x, self.frame.size.height/2+3);
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
