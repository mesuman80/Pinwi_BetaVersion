//
//  NetworkViewController.m
//  ParentControl_CT
//
//  Created by Priyanka on 03/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "NotificationDetail_VC.h"
#import "PC_DataManager.h"
#import "RedLabelView.h"
#import "ParentViewProfile.h"
#import "MenuSettingsView.h"
#import "NotificationDetailView.h"


@implementation NotificationDetail_VC

{
    UIScrollView *scrollView;
    BOOL pageControlBeingUsed;
    UIPageControl *pageControl;
    int currentPage;
    int scrollXX;
    int reduceYY;
    int initialY;
    int pageControlHeight;
    BOOL isViewAppear;
    UIImageView *centerIcon;
    HeaderView *headerView ;
    MenuSettingsView *menu;
    UIView *view1;
    BOOL isToggleMenu;
    
    int yy;
    int yCord;
}
@synthesize dataDict;




- (void)viewDidLoad {
    [super viewDidLoad];
    yy=0;
    yCord=0;
    [self.view setBackgroundColor:appBackgroundColor];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    //self.title=@"Insights";
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self drawHeaderView];
    [self drawUiWithHead];

    
    [self.tabBarController.tabBar setSelectedImageTintColor:[UIColor redColor]];
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
        [headerView setBackgroundColor:appBackgroundColor];
        [headerView setRootViewController:self];
        [headerView setHeaderViewdelegate:self];
        //[headerView setRightType:@"Menu"];
        [headerView setCentreImgName:@"activityHeader.png"];
        [headerView drawHeaderViewWithTitle:@"Notifications" isBackBtnReq:YES BackImage:@"leftArrow.png"];
        [self.view bringSubviewToFront:headerView];
        [self.view addSubview:headerView];
        yy+=headerView.frame.size.height+10*ScreenHeightFactor;
//        if(screenWidth>700)
//        {
//            yy+=headerView.frame.size.height+30*ScreenHeightFactor;
//        }
//        else
//        {
//            yy+=headerView.frame.size.height+18*ScreenHeightFactor;
//            
//        }


    }
    
}

#pragma mark BACK BUTTON DELEGATE
-(void)touchAtBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark drawUI
-(void)drawUiWithHead
{
    
    if(!scrollView)
    {
        RedLabelView *label;
        if(screenWidth>700)
        {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, yy, ScreenWidthFactor*320, ScreenHeightFactor*15)withChildStr:[PC_DataManager sharedManager].parentObjectInstance.firstName];
            label.center=CGPointMake(ScreenWidthFactor*320/2,yy+label.frame.size.height/2+20*ScreenHeightFactor);
        }
        else
        {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, yy, ScreenWidthFactor*320, ScreenHeightFactor*12)withChildStr:[PC_DataManager sharedManager].parentObjectInstance.firstName];
            label.center=CGPointMake(ScreenWidthFactor*320/2,yy+label.frame.size.height/2+10*ScreenHeightFactor);
        }
        
        [self.view addSubview:label];
        yy+=label.frame.size.height+30*ScreenHeightFactor;

        
        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,yy, self.view.frame.size.width, self.view.frame.size.height-yy)];
        [scrollView setPagingEnabled:NO];
        [scrollView setScrollEnabled:NO];
        [scrollView setBackgroundColor:appBackgroundColor];
        [self.view addSubview:scrollView];
        
        NotificationDetailView *notiDetail=[[NotificationDetailView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, scrollView.frame.size.height)];
        [notiDetail drawUI:self.dataDict];
        [scrollView addSubview:notiDetail];
        //yy+=20*ScreenFactor;
    }
}

@end
