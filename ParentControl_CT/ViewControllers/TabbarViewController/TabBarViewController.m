//
//  AppMenuViewController.m
//  ParentControl_CT
//
//  Created by Priyanka on 30/03/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "TabBarViewController.h"
#import "NotificationViewController.h"
#import "ChildActivities_VC.h"
//#import "WishListViewController.h"
#import "NetworkViewController.h"
//#import "MoreViewController.h"
#import "AppDelegate.h"
#import "ChildActivities_VC.h"


@interface TabBarViewController ()


@end

@implementation TabBarViewController
{
    CGSize frameSize;
    CGRect rect;
    ChildActivities_VC *activityViewCtrl;
//    UIImageView *navBgBar;
//    UINavigationBar *navBar;
}
@synthesize  tabViewControllers;
@synthesize networkViewCtrl,insightViewCtrl,recommendationViewCtrl,notificationViewCtrl;
@synthesize activityNavViewCtrl,networkNavViewCtrl,insightNavViewCtrl,recommendationNavViewCtrl,notificationNavViewCtrl;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    navBar=[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight*.05)];
//    [self.view addSubview:navBar];
//    navBar.tintColor=textBlueColor;
    self.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
       // self.view.backgroundColor=[UIColor whiteColor];
    [self addTabBarController];
   


    

    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor=appBackgroundColor;

   // [self addTabBarController];
}

-(void) addTabBarController
{
    activityViewCtrl        = [[ChildActivities_VC alloc] init];
    networkViewCtrl         = [[NetworkViewController alloc] init];
    insightViewCtrl         = [[InsightViewController alloc] init];
    recommendationViewCtrl  = [[WhatToDo alloc] init];
    notificationViewCtrl    = [[NotificationViewController alloc] init];
    
    
    [activityViewCtrl setTabBarCtlr:self];
    [networkViewCtrl setTabBarCtrl:self];
    [recommendationViewCtrl setTabBarCtrl:self];
    [notificationViewCtrl setTabBarCtrl:self];
    [insightViewCtrl setTabBarCtlr:self];
    
    activityNavViewCtrl = [[UINavigationController alloc] initWithRootViewController:activityViewCtrl];
    insightNavViewCtrl = [[UINavigationController alloc] initWithRootViewController:insightViewCtrl];
    notificationNavViewCtrl = [[UINavigationController alloc] initWithRootViewController:notificationViewCtrl];
    recommendationNavViewCtrl = [[UINavigationController alloc] initWithRootViewController:recommendationViewCtrl];
    networkNavViewCtrl = [[UINavigationController alloc] initWithRootViewController:networkViewCtrl];
   // activityNavViewCtrl.navigationItem.title=@"Scheduler";
    
    frameSize=CGSizeMake(50, 50);
    
    //can't set this until after its added to the tab bar
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor orangeColor]];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:RobotoRegular size:8*ScreenHeightFactor], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
//    CGRect viewFrame=self.tabBar.frame;
//    //change these parameters according to you.
//    
//    viewFrame.size.height=98*ScreenHeightFactor;
//    viewFrame.size.width=screenWidth;
//     [[UITabBar appearance]setFrame:viewFrame];
    
    UIImage *musicImage = [UIImage imageNamed:@"notificationTab.png"];
    UIImage *musicImageSel = [UIImage imageNamed:@"notificationTab_sel.png"];
    
    musicImage = [musicImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    musicImageSel = [musicImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    notificationViewCtrl.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Notifications" image:musicImage selectedImage:musicImageSel];

    
    notificationViewCtrl.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Notifications" image:[[UIImage imageNamed:isiPhoneiPad(@"notificationTab.png")]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  tag:1];
    notificationViewCtrl.tabBarItem.selectedImage=[[UIImage imageNamed:  isiPhoneiPad(@"notificationTab_sel.png") ]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //self.tabBarController.tabBar.tintColor = [UIColor orangeColor];
    //notificationViewCtrl.tabBarController.tabBar.selectedImageTintColor = [UIColor redColor];
    [notificationViewCtrl.view setBackgroundColor:[UIColor whiteColor]];
    
    
    
    
    activityViewCtrl.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Scheduler" image:[[UIImage imageNamed:isiPhoneiPad(@"activityTab.png")]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:2];
    activityViewCtrl.tabBarItem.selectedImage=[[UIImage imageNamed:  isiPhoneiPad(@"activityTab_sel.png") ]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [activityViewCtrl.view setBackgroundColor:[UIColor whiteColor]];
    //activityViewCtrl.tabBarController.tabBar.tintColor = [UIColor orangeColor];
    //activityViewCtrl.tabBarItem.se

    insightViewCtrl.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Insights" image:[[UIImage imageNamed: isiPhoneiPad(@"insightTab.png") ]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:3];
    insightViewCtrl.tabBarItem.selectedImage=[[UIImage imageNamed:  isiPhoneiPad(@"insightTab_sel.png") ]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [insightViewCtrl.view setBackgroundColor:[UIColor whiteColor]];
    
    recommendationViewCtrl.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"What to do" image:[[UIImage imageNamed:  isiPhoneiPad(@"what-to-doTab.png") ]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:4];
    recommendationViewCtrl.tabBarItem.selectedImage=[[UIImage imageNamed: isiPhoneiPad(@"what-to-doTab_sel.png") ]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [recommendationViewCtrl.view setBackgroundColor:[UIColor whiteColor]];
    

    networkViewCtrl.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Network" image:[[UIImage imageNamed:  isiPhoneiPad(@"networkTab.png") ]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]tag:5];
    networkViewCtrl.tabBarItem.selectedImage=[[UIImage imageNamed:  isiPhoneiPad(@"networkTab_sel.png") ]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [networkViewCtrl.view setBackgroundColor:[UIColor whiteColor]];

    
    
    if(!self.tabViewControllers)
    {
        tabViewControllers = [[NSMutableArray alloc] init];
        [tabViewControllers addObject:notificationNavViewCtrl];
        [tabViewControllers addObject:activityNavViewCtrl];
        [tabViewControllers addObject:insightNavViewCtrl];
        [tabViewControllers addObject:recommendationNavViewCtrl];
        [tabViewControllers addObject:networkNavViewCtrl];
    }
    
    [self setViewControllers:tabViewControllers animated:YES];
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.window setRootViewController:self];
    appDelegate.tabBarCtrl.delegate=self;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    switch (tabBarController.tabBarItem.tag) {
        case 0:
            //
            break;
            
        case 1:
           // <#statements#>
            break;

        case 2:
            //
            break;

        case 3:
            //
            break;

        case 4:
            //
            return;
            
            break;

            
        default:
            break;
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = 50*ScreenHeightFactor;
    tabFrame.origin.y = self.view.frame.size.height - 50*ScreenHeightFactor;
    self.tabBar.frame = tabFrame;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
