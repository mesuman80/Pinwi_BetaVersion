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
#import "GetSubjectActivitiesByChildID.h"
#import "SubjectCalenderList.h"

@protocol ActivityTableDelegate <NSObject>
-(void)clickOnCell:(NSMutableDictionary *)activityDict;
-(void)clickOnCancel;

@end

@interface ActivitySubjectPlanTable : UITableView<UITableViewDelegate,UITableViewDataSource,UrlConnectionDelegate>
@property id<ActivityTableDelegate>tableViewDelegate;
@property ChildActivities_VC *rootViewController;


@property ChildProfileObject *childObjectSubActivity;
-(void)GetActivities;

-(id)initWithFrame:(CGRect)frame andChild:(ChildProfileObject*)childObject;

@end
