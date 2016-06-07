//
//  ChildSelectionViewController.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 09/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"
#import "GetAllProfilesDetails.h"
#import "Constant.h"
#import "ChildProfileObject.h"
#import "DeleteChildByChildID.h"
#import "GetListofChildsByParentID.h"

@interface ChildSelectionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UrlConnectionDelegate,UISearchControllerDelegate,UISearchBarDelegate>

@property UITableView *childSelectionTable;
@property BOOL isComingfromNetwork;

@end
