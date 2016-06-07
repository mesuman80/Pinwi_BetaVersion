//
//  ViewController.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 01/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"
#import "GetAllProfilesDetails.h"
#import "Constant.h"
#import <EventKit/EventKit.h>

@interface Settings: UIViewController<UITableViewDelegate,UITableViewDataSource,UrlConnectionDelegate>

@property UITableView *settingsTable;
@property EKEventStore *eventStore;
@property NSString *rootViewController;
@property BOOL isComingFromNatwork;

@end
