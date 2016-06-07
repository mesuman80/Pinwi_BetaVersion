//
//  AppMenuViewController.m
//  ParentControl_CT
//
//  Created by Priyanka on 30/03/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "TabBarViewController.h"
#import "NotificationViewController.h"
#import "ActivitiesViewController.h"
//#import "WishListViewController.h"
#import "NetworkViewController.h"
//#import "MoreViewController.h"
#import "AppDelegate.h"

@interface TabBarViewController ()


@end

@implementation TabBarViewController
{
    CGSize frameSize;
    CGRect rect;
//    UIImageView *navBgBar;
//    UINavigationBar *navBar;
}
@synthesize  tabViewControllers;
@synthesize activityViewCtrl,networkViewCtrl,insightViewCtrl,recommendationViewCtrl,notificationViewCtrl;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    navBar=[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight*.05)];
//    [self.view addSubview:navBar];
//    navBar.tintColor=textBlueColor;
    
       // self.view.backgroundColor=[UIColor whiteColor];
    [self addTabBarController];
   


    

    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // [self addTabBarController];
}

-(void) addTabBarController
{
    
    activityViewCtrl        = [[ActivitiesViewController alloc] init];
    networkViewCtrl         = [[NetworkViewController alloc] init];
    insightViewCtrl         = [[InsightViewController alloc] init];
    recommendationViewCtrl  = [[RecommendationViewController alloc] init];
    notificationViewCtrl    = [[NotificationViewController alloc] init];
    
    
    frameSize=CGSizeMake(50, 50);
    
    //can't set this until after its added to the tab bar
    
    
    notificationViewCtrl.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Notification" image:[UIImage imageNamed:@"notificationTab.png"]  tag:1];
    notificationViewCtrl.tabBarItem.selectedImage=[UIImage imageNamed:@"notificationTab_sel.png"];
    [notificationViewCtrl.view setBackgroundColor:[UIColor whiteColor]];
    
    
    activityViewCtrl.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Activity" image:[UIImage imageNamed:@"activityTab.png"] tag:2];
    activityViewCtrl.tabBarItem.selectedImage=[UIImage imageNamed:@"activityTab_sel.png"]  ;
    [activityViewCtrl.view setBackgroundColor:[UIColor whiteColor]];
    
    recommendationViewCtrl.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Recommendation" image:[UIImage imageNamed:@"recommendationTab.png"] tag:3];
    recommendationViewCtrl.tabBarItem.selectedImage=[UIImage imageNamed:@"recommendationTab_sel.png"];
    [recommendationViewCtrl.view setBackgroundColor:[UIColor whiteColor]];
    
    networkViewCtrl.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Network" image:[UIImage imageNamed:@"networkTab.png"]tag:4];
    networkViewCtrl.tabBarItem.selectedImage=[UIImage imageNamed:@"networkTab_sel.png"];
    [networkViewCtrl.view setBackgroundColor:[UIColor whiteColor]];
    
    insightViewCtrl.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Insight" image:[UIImage imageNamed:@"insightTab_sel.png"] tag:5];
    insightViewCtrl.tabBarItem.selectedImage=[UIImage imageNamed:@"insightTab_sel.png"];
    [insightViewCtrl.view setBackgroundColor:[UIColor whiteColor]];
    
    
    if(!self.tabViewControllers)
    {
        tabViewControllers = [[NSMutableArray alloc] init];
        [tabViewControllers addObject:notificationViewCtrl];
        [tabViewControllers addObject:activityViewCtrl];
        [tabViewControllers addObject:recommendationViewCtrl];
        [tabViewControllers addObject:networkViewCtrl];
        [tabViewControllers addObject:insightViewCtrl];
    }
    
    
    
    [self setViewControllers:tabViewControllers animated:YES];
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.window setRootViewController:self];

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
            break;

            
        default:
            break;
    }
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
