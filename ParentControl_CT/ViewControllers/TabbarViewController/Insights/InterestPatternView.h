//
//  InterestTraitsView.h
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 09/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChildProfileObject.h"
#import "GetInterestTraitsByChildIDOnInsight.h"
@interface InterestPatternView : UIView<UrlConnectionDelegate>
@property (nonatomic,weak)ChildProfileObject *childObj;
-(void)drawUi;
@end
