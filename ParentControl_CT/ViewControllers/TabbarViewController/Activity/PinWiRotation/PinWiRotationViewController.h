//
//  ViewController.h
//  CircleAnim
//
//  Created by Suman Bhattacharyya on 19/04/15.
//  Copyright (c) 2015 Suman Bhattacharyya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneFingerRotationGestureRecognizer.h"
#import "PC_DataManager.h"
#import "GetSubjectActivities.h"
#import "ActivitySubjectDetailCal.h"

@interface PinWiRotationViewController : UIViewController<OneFingerRotationGestureRecognizerDelegate,UrlConnectionDelegate>

@property ChildProfileObject *child;

@end

