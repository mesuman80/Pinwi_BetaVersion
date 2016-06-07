//
//  PinwiWheel.h
//  CircleAnim
//
//  Created by Suman Bhattacharyya on 20/04/15.
//  Copyright (c) 2015 Suman Bhattacharyya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PinWiRotationViewController.h"
#import "AcademicsRotation.h"
#import "ChildSubjectRatingViewController.h"

@interface PinwiWheel : UIImageView<UIGestureRecognizerDelegate>


@property PinWiRotationViewController *mainVc;
@property AcademicsRotation *academicsVc;
@property ChildSubjectRatingViewController *childRateVc;

- (id)initWithFrame:(CGRect)frame andImage:(UIImage*)image1;

@end
