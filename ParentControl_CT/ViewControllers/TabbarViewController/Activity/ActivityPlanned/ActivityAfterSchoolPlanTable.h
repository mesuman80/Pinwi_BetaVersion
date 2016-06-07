//
//  ActivityTableView.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 15/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityAfterSchoolPlanCell.h"
//#import "ActivityDetails.h"
#import "ChildActivities_VC.h"
#import "ActivitySubjectDetailCal.h"
#import "SubjectCalendarRotation.h"
#import "GetAfterSchoolActivitiesByChildID.h"
#import "AfterSchoolActivities.h"

@protocol AfterSchoolDelegate <NSObject>
-(void)clickOnCell:(NSMutableDictionary *)activityDict;
-(void)clickOnCancel;

@end



@interface ActivityAfterSchoolPlanTable : UITableView<UrlConnectionDelegate,UITableViewDelegate,UITableViewDataSource>
@property id<AfterSchoolDelegate>tableViewDelegate;
@property ChildActivities_VC *rootViewController;

@property ChildProfileObject *childObjectSubActivity;
-(id)initWithFrame:(CGRect)frame andChild:(ChildProfileObject*)childObject;
-(void)GetActivities;
@end
