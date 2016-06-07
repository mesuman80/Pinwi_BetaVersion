//
//  AccessProfileViewController.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 29/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"
#import "ParentViewProfile.h"
#import "GetNamesByParentID.h"
#import "AccessProfileCell.h"
#import "ChildSubjectRatingViewController.h"
#import "AddPassCode.h"

@interface AccessProfileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UrlConnectionDelegate>

@property UITableView *accessTable;
-(void)addParentDetail:(NSString*)name image:(UIImage*)image earnedPoints:(NSString*)earned pendingPOints:(NSString*)pending;
-(void)tapGesture:(id)sender;

@end
