//
//  NetworkViewController.h
//  ParentControl_CT
//
//  Created by Priyanka on 03/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"
#import "ChildProfileObject.h"

@class TabBarViewController;

@interface NetworkViewController : UIViewController

@property TabBarViewController *tabBarCtrl;
@property NSMutableArray *networkObjectArray;
@end
