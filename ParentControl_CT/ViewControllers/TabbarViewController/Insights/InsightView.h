//
//  InsightView.h
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 06/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChildProfileObject;
@class TabBarViewController;

@protocol InsightViewProtocol <NSObject>

-(void)delghtFullView;

@end


@interface InsightView : UIView
@property id<InsightViewProtocol>insightDelegate;
@property UIViewController *rootViewController;
@property ChildProfileObject *childObj;
@property TabBarViewController *tabBarCtlr;
-(void)drawUI:(ChildProfileObject *)childObj;
@end
