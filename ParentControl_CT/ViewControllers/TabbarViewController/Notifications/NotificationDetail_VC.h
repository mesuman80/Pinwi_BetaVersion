//
//  NotificationDetail_VC.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 07/09/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"

@class ChildProfileObject;
@class TabBarViewController;

@interface NotificationDetail_VC : UIViewController<HeaderViewProtocol>
@property NSDictionary *dataDict;
@property ChildProfileObject *childObj;
@property TabBarViewController *tabBarCtrl;

@end
