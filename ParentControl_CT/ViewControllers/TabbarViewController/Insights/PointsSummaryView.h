//
//  PointsSummaryView.h
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 09/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetPointsInfoByChildIDOnInsights.h"
#import "ChildProfileObject.h"

@protocol PointsSummaryProtocol;

@interface PointsSummaryView : UIView<UrlConnectionDelegate>
@property id<PointsSummaryProtocol>pointsSummaryDelegate;
@property (nonatomic,weak)ChildProfileObject *childObj;
-(void)drawUi;
@end

@protocol PointsSummaryProtocol <NSObject>

-(void)stripInfoBtnTouch:(NSString*)head andIndex:(int)tagNumber;

@end