//
//  ActivityDetailView.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 14/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "ActivityDetailView.h"
#import "PC_DataManager.h"
#import "ActivitySubjectPlanTable.h"
#import "AddNewActivity.h"
#import "GetActivityDaysByCalendarMonth.h"
#import "ShowActivityLoadingView.h"
#import "RedLabelView.h"
#import "SubjectCalenderList.h"
#import "AfterSchoolActivities.h"
#import "HolidayCalendar_VC.h"
#import "TutorialPlayView.h"
#import "ListOfChildHolidayController.h"
#import "HolidayCalendar_VC.h"

@implementation ActivityDetailView
{
    UISegmentedControl *segmentedControl;
    ActivitySubjectPlanTable *addActivityTable;
    ActivityAfterSchoolPlanTable *afterSchoolAct;
    
    AddNewActivity *addNewActivity;
    
    CXCalendarView *calender;
    
    UIButton *holidayBtn;
    ChildActivities_VC *rootController;
    ChildProfileObject *childObject;
    
    ShowActivityLoadingView *loaderView;
    CalenderTableByDate *calendarDateTable;
    
    RedLabelView *childName;
    UILabel *childLabel;
    
    int yy;
    
    RedLabelView *label;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(id)initWithRootController:(ChildActivities_VC *)rootViewController andChildData:(ChildProfileObject*)childObj
{
    if(self =[super init])
    {
        self.activityViewController = rootViewController;
        [[PC_DataManager sharedManager]getWidthHeight];
        
        childObject=childObj;
        
        //[self addButton];
        rootController = rootViewController;
        
        childLabel=[[UILabel alloc]init];
        [self addSubview:childLabel];
        
        //        childName=[[RedLabelView alloc]initWithFrame:CGRectMake(0, 22, screenWidth, 20) withChildStr:childObject.firstName];
        //        [self addSubview:childName];
        
        
        calender =[[CXCalendarView alloc]initWithFrame:CGRectZero withRootController:rootViewController];
        [self addSubview:calender];
        
        
        addActivityTable=[[ActivitySubjectPlanTable alloc]initWithFrame:CGRectZero andChild:childObject];
        // [self addSubview:addActivityTable];
        
        
        afterSchoolAct=[[ActivityAfterSchoolPlanTable alloc]initWithFrame:CGRectZero andChild:childObject];
        
        //[self addSubview:addActivityTable];
        
        
        return self;
    }
    return nil;
}

-(void)loadData
{
    [self childNameLabel];
    [self choseCalender];
    [self addCalView];
    [self addSubjectTable];
    [self addAfetrSchoolTable];
    [self addHolidayButton];
    [self GetActivityDaysByCalendarMonth:calender];
}


-(void)childNameLabel
{
    //    NSString *str=childObject.firstName;
    //     CGSize displayValueSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
    //    childLabel.text=str;
    //    childLabel.font=[UIFont fontWithName:RobotoRegular size:13.0f];
    //    childLabel.frame=CGRectMake(0,0,displayValueSize.width+screenWidth*.02,displayValueSize.height+screenHeight*.01);
    //    childLabel.textAlignment=NSTextAlignmentCenter;
    //    childLabel.center=CGPointMake(screenWidth/2,screenHeight*.06);
    //    childLabel.textColor=[UIColor whiteColor];
    //    childLabel.backgroundColor=labelBgColor;
    //    childLabel.layer.borderColor=labelBgColor.CGColor;
    //    childLabel.layer.shadowColor=labelBgColor.CGColor;
    //    childLabel.layer.shadowOpacity=0.0f;
    //    childLabel.layer.cornerRadius=childLabel.frame.size.height/2;
    //    childLabel.clipsToBounds=YES;
    //[childLabel sizeToFit];
    if(!label)
    {
        if(screenWidth>700)
        {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320, ScreenHeightFactor*15)withChildStr:childObject.nick_Name];
            label.center=CGPointMake(screenWidth/2,label.frame.size.height/2+4*ScreenHeightFactor);
        }
        else
        {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320, ScreenHeightFactor*12)withChildStr:childObject.nick_Name];
            label.center=CGPointMake(screenWidth/2,label.frame.size.height/2);
        }
        [self addSubview:label];
        
        yy += label.frame.size.height + label.frame.origin.y + ScreenHeightFactor*10;
    }
}

-(void)choseCalender
{
    if(!segmentedControl)
    {
        NSArray *itemArray = [NSArray arrayWithObjects: @"Calendar",@"At School",@"After School", nil];
        segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
        segmentedControl.frame = CGRectMake(10*ScreenWidthFactor,yy, screenWidth- ScreenWidthFactor*20, ScreenHeightFactor*30);//set the size and placement
        segmentedControl.center = CGPointMake(screenWidth/2,segmentedControl.center.y);
        segmentedControl.selectedSegmentIndex = 0;
        segmentedControl.backgroundColor=[UIColor clearColor];
        segmentedControl.tintColor = radiobuttonSelectionColor;
        segmentedControl.layer.cornerRadius = 0.0f;
        
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont fontWithName:RobotoRegular size:9*ScreenFactor], NSFontAttributeName,
                                    radiobuttonSelectionColor, NSForegroundColorAttributeName, nil];
        
        [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
        
        segmentedControl.segmentedControlStyle = UISegmentedControlSegmentLeft;
        [segmentedControl addTarget:self
                             action:@selector(whichView:)
                   forControlEvents:UIControlEventValueChanged];
        [self addSubview:segmentedControl];
        yy+=segmentedControl.frame.size.height+10*ScreenHeightFactor;
    }
    //  [lineViewArray addObject:segmentedControl];
}

-(void)whichView:(UISegmentedControl *)paramSender
{
    if(segmentedControl.selectedSegmentIndex==0)    //// CALENDER
    {
        [addActivityTable removeFromSuperview];
        [afterSchoolAct removeFromSuperview];
        [self addSubview:calender];
        [self addSubview:holidayBtn];
        holidayBtn.userInteractionEnabled=YES;
        holidayBtn.alpha=1.0;
    }
    else if (segmentedControl.selectedSegmentIndex==2)  /// PLANNED after school
    {
        holidayBtn.userInteractionEnabled=NO;
        holidayBtn.alpha=0.0;
        [calender removeFromSuperview];
        [holidayBtn removeFromSuperview];
        [addActivityTable removeFromSuperview];
        [self addSubview:afterSchoolAct];
        [self addAfterSchoolTutorial];
    }
    
    else if (segmentedControl.selectedSegmentIndex==1)  /// PLANNED  school
    {
        holidayBtn.userInteractionEnabled=NO;
        holidayBtn.alpha=0.0;
        [calender removeFromSuperview];
        [holidayBtn removeFromSuperview];
        [afterSchoolAct removeFromSuperview];
        [self addSubview:addActivityTable];
        [self addSchoolTutorial];
    }
}

-(void)updateViewWithName:(NSString *)name{
    
    //    if([name isEqualToString:@"school"]){
    //
    //        [addActivityTable reloadData];
    //
    //    }
    //    else if([name isEqualToString:@"afterSchool"]){
    //          [addActivityTable reloadData];
    //    }
    [addActivityTable reloadData];
    [afterSchoolAct reloadData];
    
}

-(void)addHolidayButton
{
    if(!holidayBtn)
    {
        holidayBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    [holidayBtn setTitle:@"Set School Holidays" forState:UIControlStateNormal];
    holidayBtn.backgroundColor=[UIColor clearColor];
    [holidayBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    holidayBtn.tintColor=textBlueColor;
    holidayBtn.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.025*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    [holidayBtn sizeToFit];
    holidayBtn.center=CGPointMake(holidayBtn.frame.size.width/2+cellPadding,ScreenHeightFactor*410);
    [holidayBtn addTarget:self action:@selector(holidayButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:holidayBtn];
    
    holidayBtn.userInteractionEnabled=YES;
    holidayBtn.alpha=1.0;
    }
}

-(void)holidayButtonTouched {
//     ListOfChildHolidayController *listOfChildHolidayCalender  = [[ListOfChildHolidayController alloc]init];
//    [listOfChildHolidayCalender setNickName:childObject.nick_Name];
//    [listOfChildHolidayCalender setChildId :childObject.child_ID];
//    [rootController.navigationController pushViewController:listOfChildHolidayCalender
//                                                                            animated:YES];
    HolidayCalendar_VC *holidayCalendar_VC  = [[HolidayCalendar_VC alloc]init];
    [rootController.navigationController pushViewController:holidayCalendar_VC
                                                   animated:YES];
}

-(void)addCalView {
    [calender setFrame:CGRectMake(0, yy, screenWidth, self.frame.size.height-yy-50*ScreenHeightFactor)];
    [calender layoutSubviews];
    calender.backgroundColor=appBackgroundColor;
    calender.delegate = self;
    [self addSchedularTutorial];

}



- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation {
    return YES;
}



#pragma mark CXCalendarViewDelegate

-(void) calendarView: (CXCalendarView *) calendarView
       didSelectDate: (NSDate *) date {
    
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [[self.activityViewController navigationItem] setBackBarButtonItem:newBackButton];
    self.activityViewController.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    
    
    calendarDateTable =[[CalenderTableByDate alloc]init];
    //calendarDateTable.dateString=currentDate;
    [calendarDateTable setTabBarCtlr:self.tabBarCtlr];
    calendarDateTable.showDate=date;
    calendarDateTable.childObjectCalActivity=childObject;
    [rootController.navigationController pushViewController:calendarDateTable animated:YES];
    
    NSLog(@"Selected date: %@", date);
}
-(void)calenderViewDidSelect:(CXCalendarCellView *)cell withRootView:(CXCalendarView *)calenderView withSelectedDate:(NSDate *)date
{
    
}
-(void)calenderMoveBack:(BOOL)isBack withCalenderView:(CXCalendarView *)cxCalenderView
{
    
    NSLog(@"%lu %lu %lu",(unsigned long)cxCalenderView.displayedYear,(unsigned long)cxCalenderView.displayedMonth,(unsigned long)cxCalenderView.displayedDay);
    [self GetActivityDaysByCalendarMonth:cxCalenderView];
}
//-(void)callCalendarByDate
//{
//
//}

-(void)addSubjectTable
{
    [addActivityTable setFrame:CGRectMake(0, yy, screenWidth, self.frame.size.height-yy-self.activityViewController.tabBarController.tabBar.frame.size.height)];
    addActivityTable.rootViewController = self.activityViewController;
    [addActivityTable GetActivities];
}

-(void)addAfetrSchoolTable
{
    [afterSchoolAct setFrame:CGRectMake(0, yy, screenWidth, self.frame.size.height-yy-self.activityViewController.tabBarController.tabBar.frame.size.height)];
    afterSchoolAct.rootViewController = self.activityViewController;
    [afterSchoolAct GetActivities];
}

-(void)addNewActivity
{
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [[self.activityViewController navigationItem] setBackBarButtonItem:newBackButton];
    self.activityViewController.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    
    if(segmentedControl.selectedSegmentIndex == 0)
    {
        addNewActivity=[[AddNewActivity alloc]init];
        addNewActivity.child=childObject;
        [addNewActivity setTabBarCtlr:self.tabBarCtlr];
        [self.activityViewController.navigationController pushViewController:addNewActivity animated:YES];
    }
    else if (segmentedControl.selectedSegmentIndex==2)
    {
        AfterSchoolActivities *afterSchoolactivities=[[AfterSchoolActivities alloc]init];
        afterSchoolactivities.afterChild=childObject;
        [afterSchoolactivities setTabBarCtlr:self.tabBarCtlr];
        [self.activityViewController.navigationController pushViewController:afterSchoolactivities animated:YES];
    }
    else if (segmentedControl.selectedSegmentIndex==1)
    {
        SubjectCalenderList *subjectCalenderList=[[SubjectCalenderList alloc]init];
        subjectCalenderList.child=childObject;
        [subjectCalenderList setTabBarCtlr:self.tabBarCtlr];
        [self.activityViewController.navigationController pushViewController:subjectCalenderList animated:YES];
    }
}


-(void)GetActivityDaysByCalendarMonth:(CXCalendarView *)calenderView
{
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       GetActivityDaysByCalendarMonth *calenderMonthApi  = [[GetActivityDaysByCalendarMonth alloc] init];
                       [calenderMonthApi initService:@{@"ChildID":childObject.child_ID,
                                                       @"Year":[NSString stringWithFormat:@"%lu",(unsigned long)calenderView.displayedYear],
                                                       @"Month":[NSString stringWithFormat:@"%@",calenderView.currentMonth]
                                                       }];
                       
                       [calenderMonthApi setDelegate:self];
                       calenderMonthApi.serviceName=@"calenderMonthApi";
                       //  [self addLoaderView];
                   });
}


-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
{
    
    NSLog(@"dictionary calendar %@",dictionary);
    
    if([connection.serviceName isEqualToString:@"calenderMonthApi"])
    {
        NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetActivityDaysByCalendarMonthResponse" resultKey:@"GetActivityDaysByCalendarMonthResult"];
        if(dict)
        {
            if([dict isKindOfClass:[NSArray  class]])
            {
                NSArray *resultArray = (NSArray *)dict;
                NSDictionary *resultDictionary = [resultArray firstObject];
                NSString *errorCode = [resultDictionary valueForKey:@"ErrorCode"];
                if(![errorCode isEqualToString:@"0"])
                {
                    [calender updateCalenderView:dict];
                    
                }
            }
            else{
                
            }
        }
    }
    [self removeLoaderView];
}
-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
    [self removeLoaderView];
}
-(void)addLoaderView
{
    loaderView=[[ShowActivityLoadingView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [loaderView showLoaderViewWithText:@"Hold On..."];
    [calender addSubview:loaderView];
}

-(void)removeLoaderView
{
    [loaderView removeLoaderView];
    [loaderView removeFromSuperview];
    loaderView=nil;
}

#pragma mark Add tutorials
-(void)addSchedularTutorial
{
    if(![[[NSUserDefaults standardUserDefaults]objectForKey:@"Schedular5"]isEqualToString:@"1"])
    {
        TutorialPlayView *tutorial=[[TutorialPlayView alloc]init];
        tutorial.tutorialName=@"Schedular";
        tutorial.loadIndexVal=schedularIndex;
        [rootController presentViewController:tutorial animated:YES completion:nil];
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"Schedular5"];
    }
}

-(void)addAfterSchoolTutorial
{
    if(![[[NSUserDefaults standardUserDefaults]objectForKey:@"AfterSchool5"]isEqualToString:@"1"])
    {
        TutorialPlayView *tutorial=[[TutorialPlayView alloc]init];
        tutorial.tutorialName=@"AfterSchool";
        tutorial.loadIndexVal=afterSchoolIndex;
        [rootController presentViewController:tutorial animated:YES completion:nil];
         [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"AfterSchool5"];
    }
}

-(void)addSchoolTutorial
{
    if(![[[NSUserDefaults standardUserDefaults]objectForKey:@"School5"]isEqualToString:@"1"])
    {
        TutorialPlayView *tutorial=[[TutorialPlayView alloc]init];
        tutorial.tutorialName=@"School";
        tutorial.loadIndexVal=schoolIndex;
        [rootController presentViewController:tutorial animated:YES completion:nil];
         [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"School5"];
    }
}

@end
