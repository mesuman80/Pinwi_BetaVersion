//
//  InformAllyDetailViewController.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 22/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"
#import "AddAllyInformationOnActivity.h"
@class TabBarViewController;
@protocol InformAllyDetailProtocol <NSObject>

-(void)sendAllyName:(NSString*)allyName andId:(NSString*)allyId andAllyObj:(AllyProfileObject*)allyObj;
-(void)sendAllyObject:(AllyProfileObject*)allyObj;
@end


@interface InformAllyDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UrlConnectionDelegate,UITextViewDelegate>

@property id<InformAllyDetailProtocol>informAllyDetailDelegate;

@property UITableView *allyDetailTable;
@property TabBarViewController *tabBarCtlr;
@property ChildProfileObject *child;
@property AllyProfileObject *detailAlly;
@property NSDictionary *activityDict;;
@property NSString *parentClass;

@end
