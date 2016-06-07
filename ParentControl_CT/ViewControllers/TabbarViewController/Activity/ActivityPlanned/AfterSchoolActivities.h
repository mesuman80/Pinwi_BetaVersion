//
//  AfterSchoolActivities.h
//  ParentControl_CT
//
//  Created by Priyanka on 20/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"
#import "ChildProfileObject.h"
#import "GetAfterSchoolCategoriesByOwnerID.h"
@class TabBarViewController;
@protocol AfterSchoolActivitiesProtocol <NSObject>

-(void)catagoryID:(NSString*)catID andName:(NSString*)catName;

@end

@interface AfterSchoolActivities : UIViewController<UITableViewDelegate,UITableViewDataSource,UrlConnectionDelegate>
@property id<AfterSchoolActivitiesProtocol>afterSchoolActivitiesDelegate;
@property ChildProfileObject *afterChild;
@property NSString *parentClass;
@property TabBarViewController *tabBarCtlr;
@end
