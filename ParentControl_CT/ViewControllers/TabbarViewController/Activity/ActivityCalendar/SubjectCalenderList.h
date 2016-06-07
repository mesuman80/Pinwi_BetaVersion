//
//  SubjectCalenderList.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 11/06/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"
#import "GetSubjectActivities.h"
#import "ActivitySubjectDetailCal.h"
@class TabBarViewController;
@interface SubjectCalenderList : UIViewController<UrlConnectionDelegate,UITableViewDataSource,UITableViewDelegate>
@property TabBarViewController *tabBarCtlr;
@property ChildProfileObject *child;
@property UITableView *subListTable;

@end
