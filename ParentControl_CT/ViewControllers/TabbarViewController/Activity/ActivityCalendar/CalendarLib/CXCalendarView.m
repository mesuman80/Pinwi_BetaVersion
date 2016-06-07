//
//  CXCalendarView.m
//  Calendar
//
//  Created by Vladimir Grichina on 13.07.11.
//  Copyright 2011 Componentix. All rights reserved.
//

#import "CXCalendarView.h"
#import "Circle.h"
#import "ChildProfileObject.h"
#import <QuartzCore/QuartzCore.h>
#import "CXCalendarCellView.h"
#import "UIColor+CXCalendar.h"
#import "UILabel+CXCalendar.h"
#import "UIButton+CXCalendar.h"
#import "CalendarData.h"
#import "ShowActivityLoadingView.h"
static const CGFloat kGridMargin = 2;
static const CGFloat kDefaultMonthBarButtonWidth = 20;

@implementation CXCalendarView
{
    ChildActivities_VC *rootViewController;
    
    NSDictionary *dictionary;
    
     int count;
   
}

@synthesize delegate;



- (id) initWithFrame: (CGRect) frame withRootController:(ChildActivities_VC*)rootController
{
    if ((self = [super initWithFrame:frame]))
    {
        rootViewController = rootController;
        [self setDefaults];
         self.isCurrentMonth = YES;
        self.userInteractionEnabled=YES;
    }

    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [self setDefaults];
}

- (void) setDefaults {
    self.backgroundColor = [UIColor clearColor];

//    CGGradientRef gradient = CGGradientCreateWithColors(NULL,
//        (CFArrayRef)@[
//                      (id)[UIColor colorWithRed:188/255. green:200/255. blue:215/255. alpha:1].CGColor,
//                      (id)[UIColor colorWithRed:125/255. green:150/255. blue:179/255. alpha:1].CGColor], NULL);

    self.monthBarBackgroundColor = appBackgroundColor;
    // TODO: Merge default text attributes when given custom ones!
     self.monthLabelTextAttributes = @{
       UITextAttributeTextColor : [UIColor colorWithRed:72/255. green:72/255. blue:73/255. alpha:1],
       UITextAttributeFont : [UIFont systemFontOfSize:[UIFont buttonFontSize]],
      // UITextAttributeTextShadowColor : [UIColor grayColor],
       UITextAttributeTextShadowOffset : [NSValue valueWithCGSize:CGSizeMake(0, 1)]
   };
    
    
    self.weekdayLabelTextAttributes = @{
        UITextAttributeTextColor : radiobuttonSelectionColor,
        UITextAttributeFont : [UIFont systemFontOfSize:[UIFont systemFontSize]],
        UITextAttributeTextShadowOffset : [NSValue valueWithCGSize:CGSizeMake(0, 1)]
        };
    self.cellLabelNormalTextAttributes = @{
        UITextAttributeTextColor : [UIColor grayColor]
    };
    self.cellLabelSelectedTextAttributes = @{
        UITextAttributeTextColor : [UIColor whiteColor]
    };
    self.todaycellLabelNormalTextAttributes = @{
                                           UITextAttributeTextColor :[[UIColor redColor] colorWithAlphaComponent:0.7f]
                                           };
    self.todaycellLabelSelectedTextAttributes = @{
                                             UITextAttributeTextColor :  [[UIColor redColor] colorWithAlphaComponent:2.0f],
                                              UITextAttributeFont : [UIFont boldSystemFontOfSize:[UIFont buttonFontSize]]
                                             };

    self.cellNormalBackgroundColor = [UIColor clearColor];

    _dateFormatter = [NSDateFormatter new];
    _dateFormatter.locale = [NSLocale autoupdatingCurrentLocale];
    _calendar = [NSCalendar currentCalendar];

    _monthBarHeight = 50*ScreenHeightFactor;
    _weekBarHeight = 32*ScreenHeightFactor;

    self.selectedDate=nil;

    self.selectedDate = [NSDate date];
    self.displayedDate=nil;
    self.displayedDate = [NSDate date];
    
    
    self.cellSelectedBackgroundColor = radiobuttonSelectionColor; //[UIColor redColor];
}



//- (void) dealloc {
//    [_calendar release];
//    [_selectedDate release];
//    [_displayedDate release];
//    [_dateFormatter release];
//
//    [super dealloc];
//}

- (NSCalendar *) calendar {
    return _calendar;
}

- (void) setCalendar: (NSCalendar *) calendar {
    if (_calendar != calendar) {
       // [_calendar release];
        _calendar = calendar ;
        _dateFormatter.calendar = _calendar;
        

        [self setNeedsLayout];
    }
}

- (NSDate *) selectedDate {
  return _selectedDate;
}

- (void) updateSelectedDate
{
   for (CXCalendarCellView *cellView in self.dayCells)
   {
         cellView.selected = NO;
        [self cellForDate: self.selectedDate].selected = YES;
    
    }
}


- (void) setSelectedDate: (NSDate *) selectedDate {
        _selectedDate = selectedDate;
        [self updateSelectedDate];
        if ([self.delegate respondsToSelector:@selector(calendarView:didSelectDate:)]) {
            [self.delegate calendarView: self didSelectDate: _selectedDate];
        }
}


- (NSDate *) displayedDate {
    return _displayedDate;
}

- (void) setDisplayedDate: (NSDate *) displayedDate {
    if (_displayedDate != displayedDate) {
        //[_displayedDate release];
        _displayedDate = displayedDate;

        NSString *monthName = [[_dateFormatter standaloneMonthSymbols] objectAtIndex: self.displayedMonth - 1];
        self.currentMonth  = monthName;
        NSString *titleString = [NSString stringWithFormat: @"%@ %lu", monthName, (unsigned long)self.displayedYear];
        self.monthLabel.text = titleString;
        self.monthLabel.textColor=activityHeading1FontCode;//[[UIColor blackColor]colorWithAlphaComponent:0.8f];
        self.monthLabel.font=[UIFont fontWithName:RobotoRegular size:20*ScreenHeightFactor];
        [self updateSelectedDate];
        [self setNeedsLayout];
    }
}

- (NSUInteger) displayedYear {
    NSDateComponents *components = [self.calendar components: NSYearCalendarUnit
                                                    fromDate: self.displayedDate];
    return components.year;
}

- (NSUInteger) displayedMonth {
    if(!self.displayedDate)
    {
        self.displayedDate = [NSDate date];
    }
    NSDateComponents *components = [self.calendar components: NSMonthCalendarUnit
                                                    fromDate: self.displayedDate];
    NSLog(@"Value of components =%@",self.displayedDate);
    //return _monthLabel.text;
   return components.month;
}

- (CGFloat) monthBarHeight {
    return _monthBarHeight;
}

- (void) setMonthBarHeight: (CGFloat) monthBarHeight {
    if (_monthBarHeight != monthBarHeight) {
        _monthBarHeight = monthBarHeight;
        [self setNeedsLayout];
    }
}

- (CGFloat) weekBarHeight {
    return _weekBarHeight;
}

- (void) setWeekBarHeight: (CGFloat) weekBarHeight {
    if (_weekBarHeight != weekBarHeight) {
        _weekBarHeight = weekBarHeight;
        [self setNeedsLayout];
    }
}

- (void) touchedCellView: (CXCalendarCellView *) cellView
{
    self.selectedDate = [cellView dateWithBaseDate: self.displayedDate withCalendar: self.calendar];
    if(self.delegate)
    {
        @try {
            [delegate calenderViewDidSelect:cellView withRootView:self withSelectedDate:_selectedDate];
        }
        @catch (NSException *exception) {
            NSLog(@"Excception  = %@" , exception);
        }
        @finally {
            
        }
        
    }
}

- (void) monthForward {
    self.isCurrentMonth = NO;
    count = 1;
    NSDateComponents *monthStep = [NSDateComponents new];
    monthStep.month = 1;
    self.displayedDate = [self.calendar dateByAddingComponents: monthStep toDate: self.displayedDate options: 0];
    if(self.delegate)
    {
        [self.delegate calenderMoveBack:NO withCalenderView:self];
    }
}

-(NSString *)dateString:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-yyyy"];
    return [formatter stringFromDate:date];
}

- (void) monthBack {
    self.isCurrentMonth = NO;
    count =  1;
   // NSDate *date = [NSDate date];
    //NSString *currentDate = [self dateString:date];
    NSDateComponents *monthStep = [NSDateComponents new];
    monthStep.month = -1;
    self.displayedDate = [self.calendar dateByAddingComponents: monthStep toDate: self.displayedDate options: 0];
    if(self.delegate)
    {
        [self.delegate calenderMoveBack:YES withCalenderView:self];
    }
}

- (void) reset {
    self.selectedDate = nil;
    //[circle removeFromSuperview];
}

- (NSDate *) displayedMonthStartDate {
    NSDateComponents *components = [self.calendar components: NSMonthCalendarUnit|NSYearCalendarUnit
                                                    fromDate: self.displayedDate];
    components.day = 1;
    return [self.calendar dateFromComponents: components];
}

- (CXCalendarCellView *) cellForDate: (NSDate *) date {
    if (!date) {
        return nil;
    }
    NSDateComponents *components = [self.calendar components: NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit
                                                        fromDate: date];
    if (components.month == self.displayedMonth &&
            components.year == self.displayedYear &&
            [self.dayCells count] >= components.day) {

        return [self.dayCells objectAtIndex: components.day - 1];
    }
    return nil;
}

- (void) applyStyles {
    _monthBar.backgroundColor = self.monthBarBackgroundColor;
}

- (void) layoutSubviews {
    [super layoutSubviews];

    [self applyStyles];

    CGFloat top = 0;

    if (self.monthBarHeight) {
        [[PC_DataManager sharedManager]getWidthHeight];
        self.monthBar.frame = CGRectMake(cellPadding, top, screenWidth-2*cellPadding, self.monthBarHeight);
        self.monthLabel.frame = CGRectMake(0,0,self.monthBar.bounds.size.width, self.monthBar.bounds.size.height);
        self.monthForwardButton.frame = CGRectMake(self.monthBar.bounds.size.width - kDefaultMonthBarButtonWidth*ScreenWidthFactor, top,
                                                   kDefaultMonthBarButtonWidth*ScreenWidthFactor, self.monthBar.bounds.size.height);
       
        self.monthBackButton.frame = CGRectMake(0, top, kDefaultMonthBarButtonWidth*ScreenWidthFactor, self.monthBar.bounds.size.height);
      //  [_monthBackButton setCenter:CGPointMake(_monthBackButton.frame.size.width/2+cellPadding,_monthBackButton.center.y)];
       
        top = self.monthBar.frame.origin.y + self.monthBar.frame.size.height;
    } else {
        self.monthBar.frame = CGRectZero;
    }

    if (self.weekBarHeight) {
        self.weekdayBar.frame = CGRectMake(0, top, self.bounds.size.width, self.weekBarHeight);
        CGRect contentRect = CGRectInset(self.weekdayBar.bounds, kGridMargin, 0);
        for (NSUInteger i = 0; i < [self.weekdayNameLabels count]; ++i) {
            UILabel *label = [self.weekdayNameLabels objectAtIndex:i];
            label.frame = CGRectMake((contentRect.size.width / 7) * (i % 7), 0,
                                     contentRect.size.width / 7, contentRect.size.height);
        }
        top = self.weekdayBar.frame.origin.y + self.weekdayBar.frame.size.height;
    } else {
        self.weekdayBar.frame = CGRectZero;
    }

    // Calculate shift
    NSDateComponents *components = [self.calendar components: NSWeekdayCalendarUnit
                                                    fromDate: [self displayedMonthStartDate]];
    NSInteger shift = components.weekday - self.calendar.firstWeekday;
    if (shift < 0) {
        shift = 7 + shift;
    }

    // Calculate range
    NSRange range = [self.calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit
                                       forDate:self.displayedDate];

    self.gridView.frame = CGRectMake(kGridMargin, top,
                                     self.bounds.size.width - kGridMargin * 4,
                                     self.bounds.size.height - top);
    CGFloat cellHeight = self.gridView.bounds.size.height / 7.0;
    CGFloat cellWidth = (self.bounds.size.width - kGridMargin * 2) / 7.0;
    NSDate *cellDate = nil;
    NSDate *currentDate =[NSDate date];
    currentDate = [currentDate dateByAddingTimeInterval:-1*24*60*60];
    for (NSUInteger i = 0; i < [self.dayCells count]; ++i) {
        CXCalendarCellView *cellView = [self.dayCells objectAtIndex:i];
        cellView.currentDateLayer.opacity = 0.0;
        cellView.isTodayDate = NO;
        cellView.isSelected = NO;
        cellDate = [cellView dateWithBaseDate: self.displayedDate withCalendar: self.calendar];
        cellView.frame = CGRectMake(cellWidth * ((shift + i) % 7), cellHeight * ((shift + i) / 7),
                                    cellWidth, cellHeight);
        cellView.hidden = i >= range.length;
        [cellView setEnabled:YES];
        
        CalendarData *calenderData  = [CalendarData sharedData];
        cellView.objectType  = PinWiCalenderHolidayObjectType;
        
        [cellView cx_setTitleTextAttributes:self.cellLabelNormalTextAttributes forState:UIControlStateNormal];
        [cellView cx_setTitleTextAttributes:self.cellLabelSelectedTextAttributes forState:UIControlStateSelected];

        
       
        if(!cellView.circleLayer)
        {
            CAShapeLayer *circleLayer = [CAShapeLayer layer];
            CGRect circleRect  = CGRectZero;
            if(screenWidth>700)
            {
                
//                 circleLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(cellView.frame.size.width/2.0f -15*ScreenHeightFactor,cellView.frame.size.height/2 -14*ScreenHeightFactor,30*ScreenHeightFactor,30*ScreenHeightFactor) cornerRadius:20].CGPath;
                
                circleRect  = CGRectMake(cellView.frame.size.width/2.0f -20*ScreenWidthFactor,cellView.frame.size.height/5.0f,40*ScreenHeightFactor,40*ScreenHeightFactor);
                 circleLayer.path = [UIBezierPath bezierPathWithRoundedRect:circleRect cornerRadius:20*ScreenHeightFactor].CGPath;
                
            }
            else
            {
                
                circleRect       = CGRectMake(cellView.frame.size.width/2.0f -20*ScreenWidthFactor,cellView.frame.size.height/5.0f,40*ScreenHeightFactor,40*ScreenHeightFactor);
                circleLayer.path = [UIBezierPath bezierPathWithRoundedRect:circleRect cornerRadius:20*ScreenHeightFactor].CGPath;
        
            }
            
            [circleLayer setStrokeColor:[[UIColor clearColor] CGColor]];
            [circleLayer setFillColor:radiobuttonSelectionColor.CGColor];
            circleLayer.lineWidth = 2.0f;
           circleLayer.position = CGPointMake(cellView.frame.size.width/2.0f-circleRect.size.width/2-3*ScreenWidthFactor, cellView.frame.size.height/2.0f-circleRect.size.height*2/3-2*ScreenHeightFactor);
             [cellView.layer addSublayer:circleLayer];
            [cellView.layer insertSublayer:circleLayer atIndex:0];
             cellView.circleLayer = circleLayer;
        }
        else
        {
            
        }
      
         cellView.circleLayer.opacity = 0.0f;
        cellView.isSelected = NO;
        [cellView setSelected:NO];
        if([self.objectType isEqualToString:PinWiCalenderHolidayObjectType])
        {
            [cellView setBackgroundColor:self.cellNormalBackgroundColor];
            if([calenderData isArraycontainsDate:cellDate withChildId:self.childProfileObject.child_ID])
            {
                cellView.isSelected = YES;
                [cellView setSelected:YES];
                [cellView cx_setTitleTextAttributes:self.cellLabelSelectedTextAttributes forState:UIControlStateSelected];
                 cellView.circleLayer.opacity = 1.0f;
            }
        }
           NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:cellDate];
                NSDateComponents *today = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
                if([today day] == [cellView day] &&
                   [today month] == [otherDay month] &&
                   [today year] == [otherDay year] &&
                   [today era] == [otherDay era])
                {
                    [cellView cx_setTitleTextAttributes:self.todaycellLabelNormalTextAttributes forState:UIControlStateNormal];
                    [cellView cx_setTitleTextAttributes:self.todaycellLabelSelectedTextAttributes forState:UIControlStateSelected];
                }
    }
}

- (UIView *) monthBar {
    if (!_monthBar) {
        _monthBar = [[UIView alloc] init];
        _monthBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview: _monthBar];
    }
    return _monthBar;
}

- (UILabel *) monthLabel {
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc] init];
        _monthLabel.textAlignment = NSTextAlignmentCenter;
        _monthLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        _monthLabel.backgroundColor = [UIColor clearColor];
        [self.monthBar addSubview: _monthLabel];
    }
    return _monthLabel;
}

- (UIButton *) monthBackButton {
    if (!_monthBackButton) {
        _monthBackButton = [[UIButton alloc] init];
      //  [_monthBackButton setTitle: @"<" forState:UIControlStateNormal];
         [_monthBackButton setImage:[UIImage imageNamed:isiPhoneiPad(@"grayArrowLeft.png")] forState:UIControlStateNormal];
         [_monthBackButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_monthBackButton addTarget: self action: @selector(monthBack) forControlEvents: UIControlEventTouchUpInside];
        
        [self.monthBar addSubview: _monthBackButton];
        
    }
    return _monthBackButton;
}

- (UIButton *) monthForwardButton {
    if (!_monthForwardButton) {
        _monthForwardButton = [[UIButton alloc] init];
        
       // [_monthForwardButton setTitle: @">" forState:UIControlStateNormal];
        [_monthForwardButton setImage:[UIImage imageNamed:isiPhoneiPad(@"grayArrow.png")] forState:UIControlStateNormal];
        [_monthForwardButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
       // _monthForwardButton.tintColor=[UIColor blackColor];
        
        [_monthForwardButton addTarget: self
                                action: @selector(monthForward)
                      forControlEvents: UIControlEventTouchUpInside];
        [self.monthBar addSubview: _monthForwardButton];
    }
    return _monthForwardButton;
}

- (UIView *) weekdayBar {
    if (!_weekdayBar) {
        _weekdayBar = [[UIView alloc] init];
        _weekdayBar.backgroundColor = [UIColor colorWithRed:239.0f/255 green:243.0f/255 blue:246.0f/255 alpha:1.0];
    }
    return _weekdayBar;
}

- (NSArray *) weekdayNameLabels {
    
    NSArray *arr=[[NSArray alloc]initWithObjects:@"S",@"M",@"T",@"W",@"TH",@"F",@"S", nil];
    if (!_weekdayNameLabels) {
        NSMutableArray *labels = [NSMutableArray array];

        for (NSUInteger i = self.calendar.firstWeekday; i < self.calendar.firstWeekday + 7; ++i) {
            NSUInteger index = (i - 1) < 7 ? (i - 1) : ((i - 1) - 7);

            UILabel *label = [[UILabel alloc] initWithFrame: CGRectZero];
            label.tag = i;
            [label cx_setTextAttributes:self.weekdayLabelTextAttributes];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = [arr objectAtIndex:index];//[[_dateFormatter shortWeekdaySymbols] objectAtIndex: index];

            [labels addObject:label];
            [_weekdayBar addSubview: label];
        }

        [self addSubview:_weekdayBar];
        _weekdayNameLabels = [[NSArray alloc] initWithArray:labels];
    }
    return _weekdayNameLabels;
}

- (UIView *) gridView {
    if (!_gridView) {
        
        
        _gridView = [[UIView alloc] init];
        _gridView.backgroundColor = [UIColor clearColor];
        _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview: _gridView];
    }
    return _gridView;
}

- (NSArray *) dayCells
{
    if (!_dayCells) {
        
        NSDate *curdate=[NSDate date];
        NSDateComponents *component=[_calendar components:NSDayCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit fromDate:curdate];
        
        NSMutableArray *cells = [NSMutableArray array];
        for (NSUInteger i = 1; i <= 31; ++i)
        {
            CXCalendarCellView *cell = [CXCalendarCellView new];
            
            CAShapeLayer *circleLayer = [CAShapeLayer layer];
            [cell.layer addSublayer:circleLayer];
            cell.currentDateLayer = circleLayer;
            cell.currentDateLayer.opacity = 0.0f;
           
            cell.tag = i;
            cell.day = i;
            cell.month=(NSUInteger*)[component month];
            cell.year=(NSUInteger*)[component year];
            
            [cell addTarget: self
                     action: @selector(touchedCellView:)
           forControlEvents: UIControlEventTouchUpInside];
            
           cell.normalBackgroundColor = self.cellNormalBackgroundColor;
            [cell cx_setTitleTextAttributes:self.cellLabelNormalTextAttributes forState:UIControlStateNormal];
            [cell cx_setTitleTextAttributes:self.cellLabelSelectedTextAttributes forState:UIControlStateSelected];
            

            [cells addObject:cell];
            [self.gridView addSubview: cell];
        }
        
        _dayCells = [[NSArray alloc] initWithArray:cells];
    }
    
    return _dayCells;
}
-(void)updateCalenderView:(NSDictionary *)dict
{
    dictionary = dict;
    for(NSDictionary *resultDictionary in dict)
    {
        int arrayIndex = [[resultDictionary valueForKey:@"Day"]intValue]-1;
        CXCalendarCellView *cellView =[self.dayCells objectAtIndex:arrayIndex];
        [cellView.currentDateLayer setOpacity:1.0f];
        
        if(screenWidth>700)
        {
           cellView.currentDateLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(cellView.frame.size.width/2.0f -15*ScreenHeightFactor,cellView.frame.size.height/2 -14*ScreenHeightFactor,30*ScreenHeightFactor,30*ScreenHeightFactor) cornerRadius:20].CGPath;
        }
        else
        {
            //                circleLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(cellView.frame.size.width/2.0f -20,cellView.frame.size.height/5.0f,40,40) cornerRadius:20].CGPath;
            //
            cellView.currentDateLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(cellView.frame.size.width/2.0f -15*ScreenHeightFactor,cellView.frame.size.height/2 -14*ScreenHeightFactor,30*ScreenHeightFactor,30*ScreenHeightFactor) cornerRadius:20].CGPath;
        }
        

        
//        cellView.currentDateLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(cellView.frame.size.width/2.0f -15,cellView.frame.size.height/2 -14,30,30) cornerRadius:10].CGPath;
        [cellView.currentDateLayer setStrokeColor:[radiobuttonSelectionColor CGColor]];
        [cellView.currentDateLayer setFillColor:[[UIColor clearColor] CGColor]];
        cellView.currentDateLayer.lineWidth = 1.0f;
    }
}

-(void)resetVar
{
    if(self.isCurrentMonth)
    {
        count = 0;
    }
    
}

#pragma mark TouchEvents drag n drop
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //ss[super touchesBegan:touches withEvent:event];
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

#pragma mark updateView
-(void)setNeedsDisplay
{
    [super setNeedsDisplay];
}

@end
