//
//  RatingConfirmation_VC.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 05/05/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PC_DataManager.h"
#import "ChildDashboard.h"
#import "ChildProfileObject.h"
#import "AddPointsEarned.h"

@interface RatingConfirmation_VC : UIViewController<UrlConnectionDelegate>
@property ChildProfileObject *childObj;
@property NSString *earnedPoint;
@property BOOL isComingFormRating;
@property int daysagoValue;
@property NSString *parentClass;
@property(nonatomic,assign) int statusCount;
@end
