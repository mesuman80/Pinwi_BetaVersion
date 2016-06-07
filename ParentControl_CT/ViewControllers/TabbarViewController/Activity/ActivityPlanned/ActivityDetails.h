//
//  DetailPlanOfActivity.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 16/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"
#import "ChildActivities_VC.h"
#import "InformToAllyViewController.h"
#import "AddAfterSchoolActivities.h"
#import "GetAfterSchoolActivityDetails.h"
#import "AddAllyInformationOnActivity.h"
#import "GetAllyInformationOnActivity.h"
@class TabBarViewController;
@interface ActivityDetails : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UrlConnectionDelegate>

//@property id<de>tableViewDelegate;
//@property ChildActivities_VC *rootViewController;
@property TabBarViewController *tabBarCtlr;
@property ChildProfileObject *afterSchoolChild;
@property NSString *SubName;
@property NSString *activityName;
@property int subjectID;

@property NSString *repeatDays;
@property NSString *parentClass;

@property NSString *childViewCtrl;
@property NSMutableDictionary *afterSchoolDataDict;

@property NSMutableArray *informAllyArray;
@property NSInteger iswhatToDoController;
@property NSString *activityName1;

@end
