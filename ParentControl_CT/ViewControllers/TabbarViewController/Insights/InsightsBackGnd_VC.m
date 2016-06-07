//
//  NetworkViewController.m
//  ParentControl_CT
//
//  Created by Priyanka on 03/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "InsightsBackgnd_VC.h"
#import "PC_DataManager.h"
#import "HeaderView.h"
#import "RedLabelView.h"
#import "ParentViewProfile.h"
#import "MenuSettingsView.h"

@interface InsightsBackGnd_VC ()<HeaderViewProtocol>

@end

@implementation InsightsBackGnd_VC

{
    HeaderView *headerView;
    UIScrollView *scrollView;
    int yy;
    int yCord, xCord;
    UIButton *continueButton;
    MenuSettingsView *menu;
    BOOL isToggleMenu;
    //    UIButton *backButton;
    //    UIView *viewBack;
    //    UIGestureRecognizer *gestureRecognizer;
}
@synthesize initialY;
- (void)viewDidLoad {
    [super viewDidLoad];
    yy=0;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    //self.title=@"Insights";
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // [self drawUiWithHead];
    //[self drawHeaderView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //  [viewBack removeGestureRecognizer:gestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark headerViewSpecificFunction
-(void)drawHeaderView
{

    if(!headerView)
    {
        headerView  = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320,ScreenHeightFactor*64)];
        [headerView setBackgroundColor:[UIColor whiteColor]];
        [headerView setRootViewController:self];
        [headerView setHeaderViewdelegate:self];
        [headerView setCentreImgName:@"insightHeader.png"];
        [headerView drawHeaderViewWithTitle:@"Insights" isBackBtnReq:YES BackImage:@"homeBack.png"];
        [self.view bringSubviewToFront:headerView];
        [self.view addSubview:headerView];
    }
    initialY = 20*ScreenHeightFactor + headerView.frame.size.height;
}
#pragma mark BACK BUTTON DELEGATE
-(void)touchAtBackButton
{
    ParentViewProfile *access=[[ParentViewProfile alloc]init];
    UINavigationController *naviCtrl=[[UINavigationController alloc]initWithRootViewController:access];
    [[[UIApplication sharedApplication]keyWindow]setRootViewController:naviCtrl];
    
}

#pragma mark MENU BUTTON DELEGATE
-(void)getMenuTouches
{
    [self touchAtPinwiWheel];
}



-(void)touchAtPinwiWheel
{
    NSLog(@"Touch at pinwiWheel");
    if(!menu)
    {
        //        view1=[[UIView alloc]initWithFrame:CGRectMake(screenWidth,0-headerView.frame.size.height, screenWidth*.5, screenHeight)];
        //        view1.backgroundColor=appBackgroundColor;
        //        [self.view addSubview:view1];
        
        menu=[[MenuSettingsView alloc]initWithFrame:CGRectMake(screenWidth,headerView.frame.size.height, screenWidth*.5, screenHeight-headerView.frame.size.height)andViewCtrl:self];
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:menu.bounds];
        menu.layer.masksToBounds = NO;
        [menu.layer setShadowColor:[UIColor grayColor].CGColor];
        [menu.layer setShadowOpacity:0.8];
        [menu.layer setShadowRadius:10.0];
        [menu.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
        menu.layer.shadowPath = shadowPath.CGPath;
        [self.view addSubview:menu];
        
        
        
        
    }
    if(!isToggleMenu)
    {
        isToggleMenu=YES;
        [self slideIn];
    }
    else
    {
        isToggleMenu=NO;
        [self slideOut];
    }
}


-(void)slideIn
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //        [view1 setCenter:CGPointMake(view1.center.x-screenWidth*.5, view1.center.y)];
        [menu setCenter:CGPointMake(menu.center.x-screenWidth*.5, menu.center.y)];
        scrollView.alpha=0.5f;
        //[self.view setFrame:CGRectMake(0, 0, screenWidth*1.5, screenHeight)];
        //[self.view setCenter:CGPointMake(self.view.center.x-screenWidth*.5, self.view.center.y)];
    } completion:^(BOOL finished) {
        
    }];
    
}
-(void)slideOut
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [menu setCenter:CGPointMake(menu.center.x+screenWidth*.5, menu.center.y)];
        scrollView.alpha=1.0f;
        //        [view1 setCenter:CGPointMake(view1.center.x-screenWidth*.5, menu.center.y)];
        //        [self.view setCenter:CGPointMake(self.view.center.x+screenWidth*.5, self.view.center.y)];
        //        [self.view setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    } completion:^(BOOL finished) {
        
    }];
}



-(void)touchAtFlower:(id)sender
{
    NSLog(@"Touch at flower at insightViewController");
}
-(int)navigationBarHeight
{
    return screenWidth >700 ? -20 :0;
}



#pragma mark drawUI
//-(void)drawUiWithHead
//{
//
//    if(!scrollView)
//    {
//        yy = 64+20*ScreenFactor;
//
//        //        RedLabelView *label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight*.06)withChildStr:self.childObj.nick_Name];
//        //        label.center=CGPointMake(screenWidth/2,yy);
//        //        [self.view addSubview:label];
//        //
//        //        yy+=label.frame.size.height;
//
//
//        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,yy, self.view.frame.size.width, self.view.frame.size.height-yy)];
//        [scrollView setPagingEnabled:NO];
//        [scrollView setScrollEnabled:NO];
//        [scrollView setBackgroundColor:appBackgroundColor];
//        [self.view addSubview:scrollView];
//
//        yCord+=20*ScreenFactor;
//
//        [self  drawLabelWithText:@"Coming Soon" andColor:activityHeading1FontCode andFont:[UIFont fontWithName:RobotoRegular size:20*ScreenFactor]];
//
//        yCord+=20*ScreenFactor;
//
//    }
//}
//
//-(UILabel*)drawLabelWithText:(NSString*)title andColor:(UIColor*)color andFont:(UIFont*)font
//{
//    UILabel *label = [[UILabel alloc]init];
//    [label setText:title];
//    [label setTextColor:color];
//    [label setFont:font];
//    CGSize size = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
//    [label setFrame:CGRectMake(10*ScreenFactor,yCord, size.width, size.height)];
//    [scrollView addSubview:label];
//    [label setTextAlignment:NSTextAlignmentCenter];
//    [label setCenter:CGPointMake(scrollView.frame.size.width/2, scrollView.frame.size.height/2)];
//    yCord+=label.frame.size.height+2*ScreenFactor;
//    return label;
//}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
