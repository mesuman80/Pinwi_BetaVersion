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
@class  TabBarViewController;

@protocol InterestTraitsProtocol;

@interface InterestTraitsView : UIView<UrlConnectionDelegate>
@property (nonatomic,weak)ChildProfileObject *childObj;
@property id<InterestTraitsProtocol>interestTraitdelegate;
@property TabBarViewController *tabBarCtlr;
@property UIViewController *rootViewController;
-(void)drawUi;
@end

@protocol InterestTraitsProtocol <NSObject>

-(void)stripInfoBtnTouch:(NSString*)head andIndex:(int)tagNumber;

@end