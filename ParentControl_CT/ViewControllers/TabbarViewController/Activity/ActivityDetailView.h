//
//  ActivityDetailView.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 14/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"
#import "SchoolTableViewController.h"
#import "CXCalendarView.h"
#import "ChildActivities_VC.h"
#import "ChildProfileObject.h"
#import "ActivityAfterSchoolPlanTable.h"
#import "CalenderTableByDate.h"

@class TabBarViewController;

@interface ActivityDetailView : UIView<CXCalendarViewDelegate,UrlConnectionDelegate>

-(id)initWithRootController:(ChildActivities_VC *)rootViewController andChildData:(ChildProfileObject*)childObj;
-(void)updateViewWithName:(NSString *)name;

-(void)loadData;
-(void)addNewActivity;
@property TabBarViewController *tabBarCtlr;
@property ChildActivities_VC *activityViewController;
@end
