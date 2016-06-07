//
//  ActivitySubjectDetailCal.h
//  ParentControl_CT
//
//  Created by Priyanka on 19/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"
#import "ChildProfileObject.h"
#import "AddSubjectActivity.h"
#import "GetSchoolActivityDetails.h"
#import "ActivityData.h"

@class TabBarViewController;

@protocol repeatDaysProtocol <NSObject>
-(void)repeatDays:(NSString*)daysString;

@end


@interface ActivitySubjectDetailCal : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UrlConnectionDelegate>
@property id<repeatDaysProtocol>repeaDelegate;
@property int subjectID;
@property NSString *subject;
@property ChildProfileObject *child;
@property NSMutableDictionary *subjectDataDict;
@property TabBarViewController *tabBarCtlr;
@end
