//
//  AcademicsRotation.h
//  ParentControl_CT
//
//  Created by Priyanka on 20/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"
#import "ChildProfileObject.h"
#import "GetActivitiesByCatID.h"
#import "ActivityDetails.h"

@class TabBarViewController;

@interface AcademicsRotation : UIViewController<UrlConnectionDelegate,UITableViewDelegate,UITableViewDataSource>
@property int index;
@property NSString *indexVal;
@property NSString *activityName;
@property NSString *categoryName;
@property NSString *categoryId;
@property NSString *subCategoryId;


@property NSString *childClassName;

-(void)onValueChange:(float)value;
@property TabBarViewController *tabBarCtlr;
@property  ChildProfileObject *child;
@property UITableView *activityListTable;
@end
