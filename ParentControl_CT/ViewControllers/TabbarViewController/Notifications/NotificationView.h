//
//  NotificationView.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 07/09/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChildProfileObject;
@class TabBarViewController;

@interface NotificationView : UIView
@property NSDictionary *dataDict;
@property ChildProfileObject *childObj;
@property UIViewController *rootviewController;
@property TabBarViewController *tabBarCtlr;
-(void)drawScrollView;
@end
