//
//  MoreActivitiesInsight.h
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 13/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MoreActivitiesInsightDelegate;

@interface MoreActivitiesInsight : UIView
-(void)drawUI;
@property id<MoreActivitiesInsightDelegate>delegate;
@property NSArray *insightArray;
@end

@protocol MoreActivitiesInsightDelegate <NSObject>
-(void)touchBegan:(MoreActivitiesInsight *)moreActivityInsight;
@end