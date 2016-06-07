//
//  QualityBadgingView.h
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 09/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetInsightBatchDetailsByChildID.h"
#import "ChildProfileObject.h"

@protocol QualityBadgeProtocol;


@interface QualityBadgingView : UIView<UrlConnectionDelegate>
@property id<QualityBadgeProtocol> qualityBadgeDelegate;
@property (nonatomic,weak) UILabel *dateLabel;
@property (nonatomic,weak) ChildProfileObject *childProfileObj;
-(void)drawUi;

@end
@protocol QualityBadgeProtocol <NSObject>

-(void)stripInfoBtnTouch:(NSString*)head andIndex:(int)tagNumber;

@end