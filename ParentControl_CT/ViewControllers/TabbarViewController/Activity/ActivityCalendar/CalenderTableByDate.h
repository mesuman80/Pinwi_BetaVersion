//
//  ActivityTableView.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 15/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityTableCell.h"
//#import "ActivityDetails.h"
#import "ChildActivities_VC.h"
#import "ActivitySubjectDetailCal.h"
#import "SubjectCalendarRotation.h"
#import "GetSchoolActivitiesByDate.h"
#import "GetAfterSchoolActivitiesByDate.h"
#import "CalenderByDateCell.h"

@class TabBarViewController;
@interface CalenderTableByDate : UIViewController<UITableViewDelegate,UITableViewDataSource,UrlConnectionDelegate>

@property ChildActivities_VC *rootViewController;
@property TabBarViewController *tabBarCtlr;
@property UITableView *calendarTable;
@property ChildProfileObject *childObjectCalActivity;
@property NSString *dateString;
@property NSDate *showDate;

@end
