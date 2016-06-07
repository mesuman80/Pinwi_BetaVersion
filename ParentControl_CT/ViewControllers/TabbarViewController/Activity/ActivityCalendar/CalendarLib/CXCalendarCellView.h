//
//  CXCalendarCellView.h
//  Calendar
//
//  Created by Vladimir Grichina on 13.07.11.
//  Copyright 2011 Componentix. All rights reserved.
//
#import <UIKit/UIKit.h>


@interface CXCalendarCellView : UIButton

@property(nonatomic, assign) NSUInteger day;
@property(nonatomic, assign) NSUInteger *month;
@property(nonatomic, assign) NSUInteger *year;
@property(nonatomic, assign) UIColor *normalBackgroundColor;
@property(nonatomic, assign) UIColor *selectedBackgroundColor;
@property(nonatomic, assign) BOOL isTodayDate;
@property(nonatomic,assign) CAShapeLayer *currentDateLayer;
@property(nonatomic,assign) BOOL isSelected;
@property(nonatomic, assign) NSString *objectType;

@property (nonatomic,assign) CAShapeLayer *circleLayer;

- (NSDate *) dateWithBaseDate: (NSDate *) baseDate withCalendar: (NSCalendar *)calendar;

@end
