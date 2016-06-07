//
//  CXCalendarView.h
//  Calendar
//
//  Created by Vladimir Grichina on 13.07.11.
//  Copyright 2011 Componentix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CXCalendarCellView.h"
#import "ChildActivities_VC.h"
#import "PC_DataManager.h"

@class CXCalendarView;
@class ChildProfileObject;
@class ShowActivityLoadingView;
@protocol CXCalendarViewDelegate <NSObject>

@optional

- (void) calendarView: (CXCalendarView *) calendarView
        didSelectDate: (NSDate *) selectedDate;
-(void)calenderMoveBack:(BOOL)isBack withCalenderView:(CXCalendarView *)cxCalenderView;
-(void)calenderViewDidSelect:(CXCalendarCellView *)cell withRootView:(CXCalendarView *)calenderView withSelectedDate: (NSDate *)date;
-(void)callCalendarByDate;

-(void)calendarView:(CXCalendarView *)calendarView didSelectRangeFrom:(NSDate *)startDate to:(NSDate *)endDate;

@end


@interface CXCalendarView : UIView {
@protected
    NSCalendar *_calendar;

    NSDate *_selectedDate;

    NSDate *_displayedDate;

    UIView *_monthBar;
    UILabel *_monthLabel;
    UIButton *_monthBackButton;
    UIButton *_monthForwardButton;
    UIView *_weekdayBar;
    NSArray *_weekdayNameLabels;
    UIView *_gridView;
    NSArray *_dayCells;

    CGFloat _monthBarHeight;
    CGFloat _weekBarHeight;
    
    NSDateFormatter *_dateFormatter;


}

@property(nonatomic, retain) NSCalendar *calendar;
@property(nonatomic, retain) NSString   *objectType;
@property(nonatomic, assign) IBOutlet id<CXCalendarViewDelegate> delegate;
@property ShowActivityLoadingView *showActivityLoadingView;
@property(nonatomic, retain) NSDate *selectedDate;

@property(nonatomic, retain) NSDate *displayedDate;

@property(nonatomic, readonly) NSUInteger displayedYear;
@property(nonatomic, readonly) NSUInteger displayedMonth;
@property(nonatomic, readonly) NSUInteger displayedDay;
@property (nonatomic ,retain) NSString *currentMonth;



- (void) monthForward;
- (void) monthBack;
-(void)resetVar;
- (void) reset;
-(void)updateCalenderView:(NSDictionary *)dictionary;


// UI
@property(readonly) UIView *monthBar;
@property(readonly) UILabel *monthLabel;
@property(readonly) UIButton *monthBackButton;
@property(readonly) UIButton *monthForwardButton;
@property(readonly) UIView *weekdayBar;
@property(readonly) NSArray *weekdayNameLabels;
@property(readonly) UIView *gridView;
@property(readonly) NSArray *dayCells;
@property BOOL isCurrentMonth;
@property(assign) CGFloat monthBarHeight;
@property(assign) CGFloat weekBarHeight;

- (CXCalendarCellView *) cellForDate: (NSDate *) date;


// Appearance
// TODO: UIAppearance support
@property ChildProfileObject *childProfileObject;
@property(nonatomic, retain) UIColor *monthBarBackgroundColor;
@property(nonatomic, retain) NSDictionary *monthLabelTextAttributes;
@property(nonatomic, retain) NSDictionary *weekdayLabelTextAttributes;
@property(nonatomic, retain) NSDictionary *cellLabelNormalTextAttributes;
@property(nonatomic, retain) NSDictionary *cellLabelSelectedTextAttributes;
@property(nonatomic, retain) NSDictionary *todaycellLabelNormalTextAttributes;
@property(nonatomic, retain) NSDictionary *todaycellLabelSelectedTextAttributes;
@property(nonatomic, retain) UIColor *cellNormalBackgroundColor;
@property(nonatomic, retain) UIColor *cellSelectedBackgroundColor;

- (id) initWithFrame: (CGRect) frame withRootController:(UIViewController*)rootController;
@end