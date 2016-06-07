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
#import "GetCategoriesAndSubCategories.h"
@class TabBarViewController;
@protocol AfterSchoolActivitiesSubCatProtocol <NSObject>

-(void)subCatagoryID:(NSString*)catID andName:(NSString*)catName;

@end

@interface AfterSchoolActivitiesSubCat : UIViewController<UITableViewDelegate,UITableViewDataSource,UrlConnectionDelegate>

@property id<AfterSchoolActivitiesSubCatProtocol>AfterSchoolSubCatDelegate;
@property TabBarViewController *tabBarCtlr;
@property ChildProfileObject *afterChild;
@property NSString *catIndex;
@property NSString *catName;
@property NSString *parentClass;

@end
