//
//  AppMenuViewController.h
//  ParentControl_CT
//
//  Created by Priyanka on 30/03/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivitiesViewController.h"
#import "InsightViewController.h"
#import "NetworkViewController.h"
#import "NotificationViewController.h"
#import "RecommendationViewController.h"

@interface TabBarViewController : UITabBarController<UITabBarDelegate,UITabBarControllerDelegate>



@property NSMutableArray *tabViewControllers;
@property NotificationViewController *notificationViewCtrl;
@property RecommendationViewController *recommendationViewCtrl;
@property NetworkViewController *networkViewCtrl;
@property ActivitiesViewController *activityViewCtrl;
@property InsightViewController *insightViewCtrl;

@end
