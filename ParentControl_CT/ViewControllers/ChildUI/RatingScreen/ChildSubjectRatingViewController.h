//
//  ChildSubjectRatingViewController.h
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 01/05/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneFingerRotationGestureRecognizer.h"
#import "PC_DataManager.h"
#import "StarsRating.h"
#import "RatingConfirmation_VC.h"
#import "ChildDashboard.h"
#import "ChildProfileObject.h"

@interface ChildSubjectRatingViewController : UIViewController<OneFingerRotationGestureRecognizerDelegate,UrlConnectionDelegate>

@property ChildProfileObject *rateChilObj;
@property NSMutableArray *allData;
@property int points;
@property BOOL isSoundPlaying;
@property NSString *parentClass;
@property int statusCount;
//@property int DaysAgoValue;


+(void)setDaysAgoValue:(int)daysAgo;
@end
