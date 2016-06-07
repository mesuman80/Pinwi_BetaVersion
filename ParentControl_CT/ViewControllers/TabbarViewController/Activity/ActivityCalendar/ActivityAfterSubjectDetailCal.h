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
#import "AddAfterSchoolActivities.h"

#import "ActivityData.h"
@class TabBarViewController;
@protocol RepeatModeProtocol <NSObject>

-(void)repeatString:(NSString*)str andRepeatIndex:(NSString*)index;

@end

@interface ActivityAfterSubjectDetailCal : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UrlConnectionDelegate>
@property id<RepeatModeProtocol>repeatModeDelegate;
@property int subjectID;
@property NSString *subject;
@property NSString *activityName;
@property ChildProfileObject *child;
@property NSString *parentClass;
@property TabBarViewController *tabBarCtlr;
@end
