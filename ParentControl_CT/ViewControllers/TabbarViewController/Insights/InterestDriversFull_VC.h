//
//  DelightTrendsFull_VC.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 01/09/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChildProfileObject;
@class TabBarViewController;

@interface InterestDriversFull_VC : UIViewController
@property TabBarViewController *tabBarCtlr;
@property (nonatomic,weak)ChildProfileObject *childObj;
@property NSDictionary *dataDictionary;
@property int tagVal;
@end
