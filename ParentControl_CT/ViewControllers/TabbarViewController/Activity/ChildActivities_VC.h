//
//  ChildActivities_VC.h
//  ParentControl_CT
//
//  Created by Priyanka on 03/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"
#import "AddNewActivity.h"
#import "ChildProfileObject.h"

@class TabBarViewController;

@interface ChildActivities_VC : UIViewController<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UINavigationBarDelegate,UIScrollViewDelegate>

//@property UINavigationController *navCtrlActivity;
@property NSMutableArray *ActivityObjectArray;
@property ChildProfileObject *childObj;
@property TabBarViewController *tabBarCtlr;

@end
