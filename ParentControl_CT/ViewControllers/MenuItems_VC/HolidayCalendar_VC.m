//
//  HolidayCalendar_VC.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 28/08/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "HolidayCalendar_VC.h"
#import "CXMultidateCalendarView.h"
#import "PC_DataManager.h"
#import "Constant.h"
#import "CalendarData.h"
#import "AddHolidaysByChildID.h"
#import "HeaderView.h"
#import "RedLabelView.h"
#import "StripView.h"
#import "ShowActivityLoadingView.h"
#import "CalendarDateSelected.h"
#import "GetHolidaysByChildID.h"
#import "HolidayView.h"
#import "TutorialPlayView.h"
#import "ListOfChildHolidayController.h"
#import "GetListofHolidaysByChildIDService.h"
#import "GetHolidayDetailsByHolidayDescController.h"
#import "ListOfHolidayCell.h"




@interface HolidayCalendar_VC ()<CXMultidateCalendarViewDelegate,HeaderViewProtocol,UIScrollViewDelegate, HolidayViewDelegate>

@end

@implementation HolidayCalendar_VC
{
    UIScrollView *scrollView;
    BOOL pageControlBeingUsed;
    UIPageControl *pageControl;
    HeaderView *headerView ;
    int pageControlHeight;
    BOOL isViewAppear;
    int reduceYY;
    int initialY;
    int scrollXX;
    RedLabelView *label;
    NSMutableArray *calenderArray;
    NSMutableArray *holidayViewArray;
   
    NSMutableArray  *undoSelectionArray;
    
    NSDate *previousDate;
    NSDate *nextDate;
    int yy                                  ;
    GetListofHolidaysByChildIDService *getListOfholidayByChildId ;
    StripView *stripView;
    
    
}
@synthesize selectedDateArray;
#pragma mark ViewLifeCycleFucntion
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[PC_DataManager sharedManager]getWidthHeight];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    pageControlHeight = (ScreenWidthFactor*20);
    [self.view setBackgroundColor:appBackgroundColor];
    selectedDateArray = [[NSMutableArray alloc]init];
     isViewAppear = NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     self.navigationController.navigationBarHidden=YES;

    
    if(!isViewAppear)
    {
        reduceYY = 0;
        [self drawHeaderView];
        [self drawUI];
    }
    else {
        HolidayView *holidayView = [holidayViewArray objectAtIndex:pageControl.currentPage];
        [holidayView viewWillAppear];
      //[self listOfChildByChildId:child_id];
    }
    isViewAppear = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   // isViewAppear = NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark DrawingSpecific Functions
-(void)drawUI
{
    if(!scrollView)
    {
        NSMutableArray *array =[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles;
        scrollXX = 0;
        int i = 0 ;
        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,initialY, self.view.frame.size.width,self.view.frame.size.height-reduceYY/2-self.navigationController.navigationBar.frame.size.height/2)];
        [scrollView setBackgroundColor:appBackgroundColor];
        scrollView.pagingEnabled = YES;
        [scrollView setDelegate:self];
        [scrollView setUserInteractionEnabled:YES];
        [self.view addSubview:scrollView];
        scrollXX = 0;
        NSInteger count  = array.count;
        int scrollYY = 0;
        int centerCount  = 1;
        calenderArray  = [[NSMutableArray alloc]init];
        holidayViewArray = [[NSMutableArray alloc]init];
        
        
        while (i<count) {
          
            HolidayView *holidayView = [[HolidayView alloc]initWithFrame:CGRectMake(scrollXX, 0,scrollView.frame.size.width, scrollView.frame.size.height)];
            ChildProfileObject *childProfileObject =  [[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles objectAtIndex:i];
            RedLabelView *view = nil;
            if(![childProfileObject.lastName isEqualToString:@"(null)"])
            {
                view = [self drawChildName:[NSString stringWithFormat:@"%@",childProfileObject.nick_Name] withFrame:CGRectMake(0,0,0, 0) withInteger:centerCount];
                
                scrollYY =view.frame.origin.y + view.frame.size.height+7*ScreenHeightFactor;
                [holidayView addSubview:view];
            }
            else
            {
             
                view = [self drawChildName:childProfileObject.nick_Name withFrame:CGRectMake(0,0, 0, 0) withInteger:centerCount];
                scrollYY =view.frame.origin.y + view.frame.size.height+7*ScreenHeightFactor;
                scrollXX += view.frame.size.width;
                [holidayView addSubview:view];
                
                
                stripView = [[StripView alloc]initWithFrame:CGRectMake(0,scrollYY, self.view.frame.size.width,27*ScreenHeightFactor)];
                [stripView drawStrip:@"Holidays List" color:[UIColor clearColor]];
                [holidayView addSubview:stripView];
                [scrollView addSubview:holidayView];
                
            }
            [holidayView setDelegate:self];
            
            [holidayView setChildProfileObject:childProfileObject];
            [holidayView drawUI:stripView.frame.size.height+stripView.frame.origin.y];
            
            holidayView.userInteractionEnabled = YES;
            [holidayViewArray addObject:holidayView];
            centerCount += 2;
            i++;
           // scrollXX +=
        }
    }
        
        
        [scrollView setContentSize:CGSizeMake(scrollXX,scrollView.frame.size.height)];
        
    }


-(void)multiDateSelected:(UIButton *)button
{
    CalendarData *calenderData  = [CalendarData sharedData];
    
    CXCalendarView *cxCalenderView = [calenderArray objectAtIndex:pageControl.currentPage];
   
    
    NSArray *dateArray = [calenderData getAllDatesBetweenTwoDates:previousDate endDate:nextDate];
    undoSelectionArray=[[NSMutableArray alloc]init];
    undoSelectionArray=[dateArray mutableCopy];
    for(NSDate *date in dateArray)
    {
        CalendarDateSelected *calenderDateSelected  =[calenderData addObjectInArray:date  withKey:cxCalenderView.childProfileObject.child_ID andFlag:@"0"];
        [selectedDateArray addObject:calenderDateSelected];
    }
     [cxCalenderView setNeedsLayout];
     [button setEnabled:NO];
     previousDate = nil;
     nextDate     = nil;
}

-(void)DateDeSelected:(UIButton *)button
{
    CalendarData *calenderData  = [CalendarData sharedData];
    
    CXCalendarView *cxCalenderView = [calenderArray objectAtIndex:pageControl.currentPage];
    
    for(NSDate *date in undoSelectionArray)
    {
        [calenderData removeObjectFromArray:date withKey:cxCalenderView.childProfileObject.child_ID];
    }
    [cxCalenderView setNeedsLayout];
    [button setEnabled:NO];
    [undoSelectionArray removeAllObjects];
    undoSelectionArray =nil;
    previousDate = nil;
    nextDate     = nil;
}


-(RedLabelView *)drawChildName:(NSString *)childName withFrame:(CGRect)rect withInteger:(int)i
{
    
    if(screenWidth>700)
    {
        label=[[RedLabelView alloc]initWithFrame:CGRectMake(0,rect.origin.y, ScreenWidthFactor*320, ScreenHeightFactor*15)withChildStr:childName];
    }
    else
    {
        label=[[RedLabelView alloc]initWithFrame:CGRectMake(0,rect.origin.y, ScreenWidthFactor*320, ScreenHeightFactor*12)withChildStr:childName];
    }
    //[label setBackgroundColor:[UIColor redColor]];
    [scrollView addSubview:label];
    
    return label;
}


#pragma  mark HeaderViewSpecific Functions
-(void)drawHeaderView
{
    if(!headerView)
    {
        headerView  = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*330,ScreenHeightFactor*64)];
        [headerView setBackgroundColor:appBackgroundColor];
        [headerView setRootViewController:self];
        [headerView setHeaderViewdelegate:self];
        headerView.rightType = @"Set Holiday";
        [headerView setCentreImgName:@"insightHeader.png"];
        [headerView drawHeaderViewWithTitle:@"Scheduler" isBackBtnReq:YES BackImage:@"leftArrow.png"];
        [self.view addSubview:headerView];
        [self setupPageControl:[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles.count];
        
        if(screenWidth>700) {
            initialY+=headerView.frame.size.height+30*ScreenHeightFactor;
        }
        else {
            initialY+=headerView.frame.size.height+18*ScreenHeightFactor;
            
        }
    }
}


-(void)touchAtBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getMenuTouches
{
    
    GetHolidayDetailsByHolidayDescController *holidayDescController = [[GetHolidayDetailsByHolidayDescController alloc]init];
    ChildProfileObject *childProfileObject =  [[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles objectAtIndex:pageControl.currentPage];
   // child_id = childProfileObject.child_ID;
    [holidayDescController setNickName:childProfileObject.nick_Name];
    [holidayDescController setChildId :childProfileObject.child_ID];
    [holidayDescController setHolidayDescription:nil];
    [holidayDescController setIsTouchEnable:YES];
    [[self navigationController] pushViewController:holidayDescController animated:YES];
}

-(int)navigationBarHeight
{
    return screenWidth >700 ? 0 :0;
}


#pragma mark CalenderSpecific Functions
-(void)touchAtDone:(id)sender
{
  
    if([PC_DataManager sharedManager].parentObjectInstance.childrenProfiles.count>0)
    {
        CalendarData *calenderData = [CalendarData sharedData];
        NSString *dateString = @"";
        ChildProfileObject *childProfileObject =  [[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles objectAtIndex:pageControl.currentPage];
        
        NSMutableArray *arr = [calenderData getSelectedDatewithChildId:childProfileObject.child_ID];
        
        for(NSString *date in arr)
        {
            dateString = [dateString stringByAppendingString:date];
            dateString  = [dateString stringByAppendingString:@","];
        }
        
        if(dateString.length>1)
        {
            
            dateString = [dateString substringToIndex:[dateString length] - 1];
            
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
            [dictionary setValue:childProfileObject.child_ID forKey:@"ChildID"];
            [dictionary setValue:dateString forKey:@"HolidayDate"];
            [dictionary setValue:@"Not Added" forKey:@"Description"];
            
            AddHolidaysByChildID *addHolidayByChildId  = [[AddHolidaysByChildID alloc]init];
            [addHolidayByChildId  initService:dictionary];
            [addHolidayByChildId setDelegate:self];
            addHolidayByChildId.calenderArray = [[NSMutableArray alloc]init];
            
            for(CalendarDateSelected *dateSelected in selectedDateArray)
            {
                [addHolidayByChildId.calenderArray addObject:dateSelected];
            }
            
            addHolidayByChildId.childId = childProfileObject.child_ID;
            [addHolidayByChildId setServiceName:PinWiAddHolidaysByChildID];
            //[self addLoaderViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) WithView:self.view];
        }
        

    }
    
  
    
}
-(CXCalendarView *)drawCalendar:(CGRect)frame withChildObj:(ChildProfileObject *)childProfileObject
{
    CXCalendarView *calender = [[CXCalendarView alloc]initWithFrame:frame withRootController:self];
    calender.delegate = self;
    calender.childProfileObject = childProfileObject;
    calender.objectType  = PinWiCalenderHolidayObjectType;
    [calender setUserInteractionEnabled:YES];
    
    scrollXX += calender.frame.size.width;
  //  yy+=calender.frame.size.height;
    [calenderArray addObject:calender];
    return calender;
    
   
}

-(void) calendarView: (CXCalendarView *) calendarView
       didSelectDate: (NSDate *) date
{
}

-(void)calenderViewDidSelect:(CXCalendarCellView *)cell withRootView:(CXCalendarView *)calenderView11 withSelectedDate: (NSDate *)date
{
//    CalendarData *calenderData  =[CalendarData sharedData];
//    if(cell.isSelected)
//    {
//        @try {
//            CalendarDateSelected *calenderDateSelected = [calenderData removeObjectFromArray:date withKey:calenderView11.childProfileObject.child_ID];
//            if(selectedDateArray.count>0 && calenderDateSelected)
//            {
//                //
//                for(CalendarDateSelected *dateSelected in selectedDateArray)
//                {
////                    if([dateSelected.date isEqualToString:calenderDateSelected.date] && [dateSelected.childId isEqualToString:calenderDateSelected.childId] && [dateSelected.flag isEqualToString:@"1"])
////                    {
////                        return;
////                    }
////                    
//                    if([dateSelected.date isEqualToString:calenderDateSelected.date] && [dateSelected.childId isEqualToString:calenderDateSelected.childId] && ![dateSelected.flag isEqualToString:@"1"])
//                    {
//                        [selectedDateArray removeObject:dateSelected];
//                        break;
//                    }
//
//                    
//                }
//            }
//            
//            if(calenderDateSelected) {
//                cell.isSelected  = NO;
//                cell.circleLayer.opacity = 0.0f;
//                if(previousDate!= nil)
//                {
//                    if([previousDate isEqualToDate:date])
//                    {
//                        previousDate = nil;
//                        nextDate = nil;
//                    }
//                }
//                
//                
//                if(!previousDate || !nextDate)
//                {
//                    HolidayView *holidayView = [holidayViewArray objectAtIndex:pageControl.currentPage] ;
//                    [holidayView.selectButton setEnabled:NO];
//                }
//
//            }
//            
//        }
//        
//      
//        @catch (NSException *exception) {
//            NSLog(@"Exception in Calender = %@" , exception.debugDescription);
//        }
//        @finally {
//            
//        }
//        
//        
//    }
//    else
//    {
//        if(!previousDate)
//        {
//            previousDate = date;
//        }
//        else
//        {
//            if(previousDate && nextDate)
//            {
//                previousDate = nextDate;
//            }
//            
//            nextDate = date;
//            
//        }
//        if(previousDate && nextDate)
//        {
//            
//            if ([previousDate compare: nextDate] == NSOrderedDescending) {
//                NSLog(@"currentdate is later than getDate");
//                NSDate *localDate  = previousDate;
//                previousDate = nextDate;
//                nextDate = localDate;
//                
//            }
//            
//            HolidayView *holidayView = [holidayViewArray objectAtIndex:pageControl.currentPage] ;
//            [holidayView.selectButton setEnabled:YES];
//           
//        }
//       
//            CalendarDateSelected *calenderDateSelected  =[calenderData addObjectInArray:date  withKey:calenderView11.childProfileObject.child_ID andFlag:@"0"];
//            [selectedDateArray addObject:calenderDateSelected];
//        
//          cell.isSelected = YES;
//       
//        cell.circleLayer.opacity = 1.0f;
//        
//    }
 
}
-(void)getHolidayByChildId:(NSString *)childId withMonth:(NSString *)month year:(NSString *)year
{
    GetHolidaysByChildID *getHolidayByChildId  =  [[GetHolidaysByChildID alloc]init];
    [getHolidayByChildId setDelegate:self];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setValue:childId forKey:@"ChildID"];
    
    NSString *monthStr = month;
    NSString *yearString = year;
    [dictionary setValue:monthStr forKey:@"Month"];
    [dictionary setValue:yearString forKey:@"Year"];
    [getHolidayByChildId setServiceName:PinWiGetHolidayByChildID];
    [getHolidayByChildId initService:dictionary];
    

}
-(void)calenderMoveBack:(BOOL)isBack withCalenderView:(CXCalendarView *)cxCalenderView
{
    
    for(CalendarDateSelected *dateSeleted in selectedDateArray)
    {
        [[[CalendarData sharedData]allDateArray]removeObject:dateSeleted];
    }
    [selectedDateArray removeAllObjects];
    
    previousDate = nil;
    nextDate = nil;
    HolidayView *holidayView = [holidayViewArray objectAtIndex:pageControl.currentPage] ;
    [holidayView.selectButton setEnabled:NO];
    
    
    [self getHolidayByChildId:cxCalenderView.childProfileObject.child_ID withMonth:cxCalenderView.currentMonth year:[NSString stringWithFormat:@"%lu",(unsigned long)cxCalenderView.displayedYear]];
   // [self addLoaderViewWithFrame:CGRectMake(0, 0,self.view.frame.size.width,self.view.frame.size.height) WithView:self.view];
    
}
#pragma mark ADD / REMOVE LOADER
//-(ShowActivityLoadingView *)addLoaderViewWithFrame:(CGRect)frame WithView:(UIView *)view
//{
//    loaderView=[[ShowActivityLoadingView alloc]initWithFrame:frame];
//    [loaderView showLoaderViewWithText:@"Hold On..."];
//    [view addSubview:loaderView];
//    return loaderView;
//}

//-(void)removeLoaderView:(ShowActivityLoadingView *)loadingView
//{
//    [loadingView removeLoaderView];
//    [loadingView removeFromSuperview];
//    loadingView=nil;
//    
//    [loaderView removeLoaderView];
//    [loaderView removeFromSuperview];
//    loaderView = nil;
//}
#pragma mark alertSpecific Functions
-(void)showAlertMessage:(NSString *)title message:(NSString *)message
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alertView show];
    
}
#pragma mark ScrollViewSpecificFunctions
-(void)setupPageControl:(NSInteger)number_Of_Page
{
   // int height  = [self navigationBarHeight];
    if(screenWidth>700)
    {
        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0,ScreenHeightFactor*3,pageControlHeight,pageControlHeight)];
        pageControl.transform = CGAffineTransformMakeScale(2, 2);
    }
    else
    {
        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0,ScreenHeightFactor*12,pageControlHeight,pageControlHeight)];
    }
    
    [pageControl setCenter:CGPointMake(screenWidth/2, pageControl.center.y)];
    [pageControl setCenter:CGPointMake(screenWidth/2, pageControl.center.y)];
    pageControl.currentPage=0;
    pageControl.numberOfPages=number_Of_Page;
    [pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
    [self.view addSubview:pageControl];
}

-(void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (!pageControlBeingUsed)
    {
        CGFloat pageWidth = sender.frame.size.width;
        int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        pageControl.currentPage = page;
        
    }
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)sender
{
    pageControlBeingUsed = NO;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender
{
    pageControlBeingUsed = NO;
    
}

#pragma mark WebServices related Functions
//-(void)listOfChildByChildId:(NSString *)childId {
//    
// //   [self addLoaderView];
//}

-(void)addLoaderView {
//    loaderView=[[ShowActivityLoadingView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height)];
//    [loaderView showLoaderViewWithText:@"Hold On..."];
//    [self.view addSubview:loaderView];
    
}


-(void)removeLoaderView {
//    [loaderView removeLoaderView];
//    [loaderView removeFromSuperview];
//    loaderView=nil;
}

-(void)drawTableLayout {
   // cellHeight  = 40 *ScreenHeightFactor ;
    //if(!table) {
    

   // }
    //[table reloadData];
}

#pragma mark TableView Specific Functions
-(void)goToNextController:(BOOL)isTouchEnable description:(NSString *)description {
    GetHolidayDetailsByHolidayDescController *holidayDescController = [[GetHolidayDetailsByHolidayDescController alloc]init];
    ChildProfileObject *childProfileObject =  [[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles objectAtIndex:pageControl.currentPage];
    [holidayDescController setNickName:childProfileObject.nick_Name];
    [holidayDescController setChildId :childProfileObject.child_ID];
    [holidayDescController setHolidayDescription:description];
    [holidayDescController setIsTouchEnable:isTouchEnable];
    [[self navigationController] pushViewController:holidayDescController animated:YES];
}

-(void)goTOController:(BOOL)isTouchEnable description:(NSString *)description {
    [self goToNextController:isTouchEnable description:description];
}

@end
