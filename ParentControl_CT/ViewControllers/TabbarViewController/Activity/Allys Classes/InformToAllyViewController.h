//
//  InformAllyViewController.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 20/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//
#import "PC_DataManager.h"
#import <UIKit/UIKit.h>
#import "GetListOfAllys.h"
#import "AllyProfileObject.h"

@class  TabBarViewController;
@protocol InformAllyProtocol <NSObject>

-(void)sendAllyName:(NSString*)allyName andId:(NSString*)allyId andAllyObj:(NSMutableDictionary*)allyObj;

@end

@interface InformToAllyViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate,UISearchResultsUpdating,UISearchDisplayDelegate, UITextFieldDelegate,UrlConnectionDelegate>
@property id<InformAllyProtocol>informAllyDelegate;
@property TabBarViewController *tabBarCtlr;
@property UITableView *allyTable;
@property ChildProfileObject *child;
@property NSString *parentClass;
@property NSString* subjectName;
@property NSDictionary* activityDict;
@property AllyProfileObject *informAllyDict;

@end
