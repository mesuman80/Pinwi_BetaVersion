//
//  ActivityTableView.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 15/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ActivityDetails.h"
@class ChildProfileObject;
@class TabBarViewController;

@interface ScheduledAllyTable : UIViewController<UITableViewDelegate,UITableViewDataSource>



@property ChildProfileObject *childObjectSubActivity;
@property TabBarViewController *tabBarCtrl;
@property NSDictionary *activityDict;
@end
