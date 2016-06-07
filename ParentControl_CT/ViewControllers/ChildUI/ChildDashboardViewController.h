//
//  ChildDashboardViewController.h
//  ParentControl_CT
//
//  Created by Sakshi on 01/06/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sound.h"
#import "ChildProfileObject.h"

@interface ChildDashboardViewController : UIViewController

@property UIImageView * dashboardImageView;
@property UILabel *dashboardComponentLabel;
@property UIImageView *childImgview;
@property ChildProfileObject *childObj;
@property Sound *soundObject;

@end
