//
//  AppMenuViewController.h
//  ParentControl_CT
//
//  Created by Priyanka on 30/03/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "InsightViewController.h"
#import "NetworkViewController.h"
#import "NotificationViewController.h"
#import "WhatToDo.h"


@class NetworkViewController;
@class NotificationViewController;
@class InsightViewController;
@class ChildActivities_VC;
@class WhatToDo;

@interface TabBarViewController : UITabBarController<UITabBarDelegate,UITabBarControllerDelegate>
{
  
}

@property NSMutableArray *tabViewControllers;
@property NotificationViewController *notificationViewCtrl;
@property WhatToDo *recommendationViewCtrl;
@property NetworkViewController *networkViewCtrl;
@property InsightViewController *insightViewCtrl;

@property UINavigationController *activityNavViewCtrl ;
@property UINavigationController *notificationNavViewCtrl ;
@property UINavigationController *recommendationNavViewCtrl ;
@property UINavigationController *networkNavViewCtrl ;
@property UINavigationController *insightNavViewCtrl ;


@end
