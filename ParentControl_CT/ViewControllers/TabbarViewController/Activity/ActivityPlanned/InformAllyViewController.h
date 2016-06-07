//
//  InformAllyViewController.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 20/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//
#import "PC_DataManager.h"
#import <UIKit/UIKit.h>
#import "ChildProfileObject.h"

@interface InformAllyVabckjdkiewController : UIViewController<UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>

@property UITableView *allyTable;
@property ChildProfileObject *child;

@end
