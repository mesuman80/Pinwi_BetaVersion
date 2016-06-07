//
//  AllySelectionViewController.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 09/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetListOfAllys.h"
#import "Constant.h"
#import "AllyProfileObject.h"
#import "PC_DataManager.h"
#import "GetAllProfilesDetails.h"
#import "UpdateAllyProfile.h"
#import "AllyProfileController.h"
#import "DeleteAllyByAllyID.h"
#import "GetListofAllysByParentID.h"

@interface AllySelectionViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UrlConnectionDelegate,UISearchBarDelegate,UISearchControllerDelegate>


@property UITableView *allyTableSelection;

@end
