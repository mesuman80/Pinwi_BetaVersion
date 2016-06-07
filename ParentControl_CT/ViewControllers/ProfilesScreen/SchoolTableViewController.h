//
//  CountryTableViewController.h
//  ParentControl_CT
//
//  Created by Priyanka on 28/03/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"
#import "UrlConnection.h"


@protocol SchoolListDelegate<NSObject>
-(void)selectedSchool:(NSString*)schoolSelected andId:(NSString*)schoolIdSelected;

@end
@interface SchoolTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UrlConnectionDelegate,UISearchBarDelegate,UISearchControllerDelegate>

@property id<SchoolListDelegate>schoolListDelegate;

@end
