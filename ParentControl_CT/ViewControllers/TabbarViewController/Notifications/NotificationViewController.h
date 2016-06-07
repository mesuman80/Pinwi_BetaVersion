//
//  NotificationViewController.h
//  ParentControl_CT
//
//  Created by Priyanka on 03/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TabBarViewController;
@class ChildProfileObject;

@interface NotificationViewController : UIViewController
@property ChildProfileObject *childObj;
@property TabBarViewController *tabBarCtrl;

@end
