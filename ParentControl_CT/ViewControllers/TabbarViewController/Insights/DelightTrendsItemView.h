//
//  DelightTrendsItemView.h
//  ParentControl_CT
//
//  Created by Yogesh Gupta on 12/07/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TabBarViewController;
@protocol DelightTrendsProtocol;
@interface DelightTrendsItemView : UIView
-(void)drawUI:(NSDictionary *)dataDictionary;
@property NSDictionary *dataDict;
@property TabBarViewController *tabBarCtlr;
@property id<DelightTrendsProtocol>delightTrendDelegate;
@end

@protocol DelightTrendsProtocol<NSObject>
-(void)delightTrendtouched:(DelightTrendsItemView*)delight;

@end