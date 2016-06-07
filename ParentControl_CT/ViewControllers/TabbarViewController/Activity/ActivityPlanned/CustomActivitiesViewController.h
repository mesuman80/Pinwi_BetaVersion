//
//  CustomActivitiesViewController.h
//  ParentControl_CT
//
//  Created by Priyanka on 27/05/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"
#import "ChildProfileObject.h"
#import "AddCustomActivity .h"
@class TabBarViewController;
@interface CustomActivitiesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UrlConnectionDelegate>
@property TabBarViewController *tabBarCtlr;
@property ChildProfileObject *child;
@property NSString  *catagoryID;
@property NSString  *subCatagoryID;
@property NSString  *categoryName;
@property NSString  *subCategoryName;
@end
