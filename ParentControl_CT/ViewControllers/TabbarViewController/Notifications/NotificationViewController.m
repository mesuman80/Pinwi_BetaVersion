//
//  NetworkViewController.m
//  ParentControl_CT
//
//  Created by Priyanka on 03/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "NotificationViewController.h"
#import "PC_DataManager.h"
#import "HeaderView.h"
#import "RedLabelView.h"
#import "ParentViewProfile.h"
#import "MenuSettingsView.h"
#import "NotificationView.h"
#import "InsightData.h"
#import "ShowActivityLoadingView.h"
#import "GetNotificationListByParentID.h"


@interface NotificationViewController ()<HeaderViewProtocol,UIScrollViewDelegate>

@end

@implementation NotificationViewController

{
    HeaderView *headerView;
    UIScrollView *scrollView;
    int yy;
    int yCord, xCord;
    UIButton *continueButton;
    MenuSettingsView *menu;
    BOOL isToggleMenu;
    ShowActivityLoadingView *loaderView;
    UIPageControl *pageControl;
    BOOL pageControlBeingUsed;
    int pageControlHeight;
    
    UIView *loadElementView;
    UIView *removeMenuView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     yy=0;
     pageControlHeight = (ScreenWidthFactor*20);
    [[PC_DataManager sharedManager]getWidthHeight];
    if(!loadElementView)
    {
        loadElementView=[[UIView alloc]initWithFrame:CGRectMake(0,0, screenWidth*1.5, screenHeight)];
        [self.view addSubview:loadElementView];
    }
    if([[PC_DataManager sharedManager]badgeCount] && ![[[PC_DataManager sharedManager]badgeCount] isEqualToString:@"0"])
    {
        self.tabBarItem.badgeValue = [[PC_DataManager sharedManager]badgeCount];
    }
    // [self getNotificationCount];
   
}

-(void)viewDidAppear:(BOOL)animated
{
    //self.title=@"Insights";
    [super viewDidAppear:animated];
    [[PC_DataManager sharedManager]setBadgeCount:@"0"];
    if([[[PC_DataManager sharedManager]badgeCount] isEqualToString:@"0"])
    {
        self.tabBarItem.badgeValue = nil;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    [self drawHeaderView];
    [self drawUiWithHead];
   
    [self.tabBarController.tabBar setSelectedImageTintColor:[UIColor redColor]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
        [headerView setRightType:@"Menu"];
        [headerView setCentreImgName:@"activityHeader.png"];
        [headerView drawHeaderViewWithTitle:@"Notifications" isBackBtnReq:YES BackImage:@"homeBack.png"];
        [loadElementView bringSubviewToFront:headerView];
        [loadElementView addSubview:headerView];
        
        if(screenWidth>700)
        {
         yy+=headerView.frame.size.height+30*ScreenHeightFactor;
        }
        else
        {
            yy+=headerView.frame.size.height+20*ScreenHeightFactor;
 
        }
    }
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
//        menu=[[MenuSettingsView alloc]initWithFrame:CGRectMake(screenWidth,headerView.frame.size.height, screenWidth*.5, screenHeight-headerView.frame.size.height)andViewCtrl:self];
//        if(screenHeight<700)
//        {
//            [menu setFrame:CGRectMake(screenWidth,headerView.frame.size.height-7*ScreenHeightFactor, screenWidth*.5, screenHeight-headerView.frame.size.height)];
//        }

        removeMenuView=[[UIView alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height, screenWidth, screenHeight-headerView.frame.size.height)];
        removeMenuView.backgroundColor=[UIColor clearColor];
        
        UITapGestureRecognizer *removeMenuGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchToRemoveMenu:)];
        [removeMenuView addGestureRecognizer:removeMenuGesture];
        
        menu=[[MenuSettingsView alloc]initWithFrame:CGRectMake(screenWidth,20*ScreenHeightFactor, screenWidth*.5, screenHeight-headerView.frame.size.height)andViewCtrl:self];
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:menu.bounds];
        menu.layer.masksToBounds = NO;
        [menu.layer setShadowColor:[UIColor grayColor].CGColor];
        [menu.layer setShadowOpacity:0.8];
        [menu.layer setShadowRadius:10.0];
        [menu.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
        menu.layer.shadowPath = shadowPath.CGPath;
        [loadElementView addSubview:menu];
    }
    if(!isToggleMenu)
    {
        isToggleMenu=YES;
        [self slideIn];
    }
    else
    {
        [self touchToRemoveMenu:nil];
    }
}
-(void)touchToRemoveMenu:(id)sender
{
    isToggleMenu=NO;
    [self slideOut];
}

-(void)slideIn
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [loadElementView addSubview:removeMenuView];
        [loadElementView setUserInteractionEnabled:NO];
        scrollView.alpha=0.5f;
        scrollView.userInteractionEnabled=NO;
        [loadElementView setCenter:CGPointMake(loadElementView.center.x-screenWidth*.5, loadElementView.center.y)];
    } completion:^(BOOL finished) {
        [loadElementView setUserInteractionEnabled:YES];
    }];

    
}
-(void)slideOut
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [removeMenuView removeFromSuperview];
        [loadElementView setUserInteractionEnabled:NO];
        scrollView.alpha=1.0f;
        scrollView.userInteractionEnabled=YES;
        [loadElementView setCenter:CGPointMake(loadElementView.center.x+screenWidth*.5, loadElementView.center.y)];
    } completion:^(BOOL finished) {
        [loadElementView setUserInteractionEnabled:YES];
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
-(void)drawUiWithHead
{
   
     [self.view setBackgroundColor:appBackgroundColor];
    if(!scrollView)
    {
         //[self setupPageControl:[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles.count];
        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,yy, self.view.frame.size.width, self.view.frame.size.height-yy)];
        [scrollView setPagingEnabled:YES];
        [scrollView setDelegate:self];
        [scrollView setScrollEnabled:YES];
        [scrollView setBackgroundColor:appBackgroundColor];
        [loadElementView addSubview:scrollView];
        
        xCord=0;
//        for(int i=0; i<[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles.count; i++)
//        {
            NotificationView *notiView=[[NotificationView alloc]initWithFrame:CGRectMake(xCord, 0, self.view.frame.size.width, scrollView.frame.size.height)];
            [notiView setBackgroundColor:appBackgroundColor];
            notiView.rootviewController = self;
            
            
            NSLog(@"notiView.rootviewController  %@", notiView.rootviewController);
            
            //[notiView setRootviewController:self];
           // [notiView setChildObj:[[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles objectAtIndex:i]];
            [notiView drawScrollView];
            [notiView setTabBarCtlr:self.tabBarCtrl];
            [scrollView addSubview:notiView];
             xCord+=notiView.frame.size.width;
//        }
        [scrollView setContentSize:CGSizeMake(xCord, scrollView.contentSize.height)];
        
    }
    
}

-(void)setupPageControl:(NSInteger)number_Of_Page
{
    if(screenWidth>700)
    {
        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0,ScreenHeightFactor*3,pageControlHeight,pageControlHeight)];
        pageControl.transform = CGAffineTransformMakeScale(2, 2);
    }
    else
    {
        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0,ScreenHeightFactor*12,pageControlHeight,pageControlHeight)];
    }
    
    [pageControl setCenter:CGPointMake(screenWidth/2, pageControl.center.y)];
    pageControl.currentPage=0;
    pageControl.numberOfPages=number_Of_Page;
    // pageControl.pageIndicatorTintColor=[UIColor blackColor];
    [pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
    
    [loadElementView addSubview:pageControl];
}
-(void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (!pageControlBeingUsed)
    {
        CGFloat pageWidth = sender.frame.size.width;
        int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        pageControl.currentPage = page;
        
    }
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)sender
{
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender
{
    pageControlBeingUsed = NO;
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

}



@end
