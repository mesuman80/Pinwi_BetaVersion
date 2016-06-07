//
//  DelightTrendsView.h
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 09/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetDelightTraitsByChildIDOnInsight.h"
#import "MoreActivitiesInsight.h"
#import "ChildProfileObject.h"

@class TabBarViewController;
@protocol DelightTrendsProtocol ;

@interface DelightTrendsView : UIView<UrlConnectionDelegate,MoreActivitiesInsightDelegate>

-(void)drawUi;
@property TabBarViewController *tabBarCtlr;
@property id<DelightTrendsProtocol> delightTrendDelegate;
@property (nonatomic,weak)ChildProfileObject *childObj;
@property UIViewController *rootViewController;
@end

@protocol DelightTrendsProtocol <NSObject>

-(void)stripInfoBtnTouch:(NSString*)head andIndex:(int)tagNumber;

@end