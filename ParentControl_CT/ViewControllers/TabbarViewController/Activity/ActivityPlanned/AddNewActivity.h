//
//  AddNewActivity.h
//  ParentControl_CT
//
//  Created by Priyanka on 20/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChildActivities_VC.h"
#import "PC_DataManager.h"

#import "ChildProfileObject.h"

@class TabBarViewController;

@interface AddNewActivity : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property TabBarViewController *tabBarCtlr;
@property ChildProfileObject *child;
@end
