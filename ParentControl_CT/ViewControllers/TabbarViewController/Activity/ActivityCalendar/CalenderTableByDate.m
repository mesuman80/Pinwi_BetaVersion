//
//  SubjectCalenderTableView.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 14/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "CalenderTableByDate.h"
#import "PC_DataManager.h"
#import "ShowActivityLoadingView.h"
#import "RedLabelView.h"
#import "HeaderView.h"
#import "AddNewActivity.h"
#import "SubjectCalenderList.h"
#import "AfterSchoolActivities.h"
#import "TextAndDescTextCell.h"

@interface CalenderTableByDate() <HeaderViewProtocol>

@end

@implementation CalenderTableByDate
{
    NSMutableArray *subjectArray;
    NSArray *afterSchoolArray;
    NSMutableArray *daysPlannedArray;
    
    NSMutableArray *completeActivityArray;
    
    NSMutableDictionary *dict;
    ShowActivityLoadingView *loaderView;
    HeaderView *headerView;
    int yy;
    RedLabelView *label;
    UIButton *addBtn;
    NSString *noActivity;
    BOOL isExist;
}
@synthesize calendarTable;
-(void)viewDidLoad
{
    
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor=appBackgroundColor;
    [[PC_DataManager sharedManager] getWidthHeight];
    [self drawHeaderView];
    [self childNameLabel];
    [self addButton];
    [self calculatePreviousDay];
    [self callSchoolList];
    [self drawTableListView];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // [completeActivityArray removeAllObjects];
    [[PC_DataManager sharedManager].calTableActivitybyDateArray removeAllObjects];
    [self.tabBarController.tabBar setSelectedImageTintColor:[UIColor orangeColor]];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    // [calendarTable reloadData];
}


-(void)drawHeaderView
{
    if(!headerView)
    {
        headerView  = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320,ScreenHeightFactor*64)];
        [headerView setBackgroundColor:appBackgroundColor];
        [headerView setRootViewController:self];
        [headerView setHeaderViewdelegate:self];
        [headerView setCentreImgName:@"activityHeader.png"];
        //[headerView setRightType:@"Menu"];
        [headerView drawHeaderViewWithTitle:@"Scheduler" isBackBtnReq:YES BackImage:@"leftArrow.png"];
        [self.view bringSubviewToFront:headerView];
        [self.view addSubview:headerView];
        if(screenWidth>700)
        {
            yy+=headerView.frame.size.height+25*ScreenHeightFactor;
        }
        else
        {
            yy+=headerView.frame.size.height+18*ScreenHeightFactor;
            
        }
        
    }
}
#pragma mark BACK BUTTON DELEGATE
-(void)touchAtBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark child
-(void)childNameLabel
{
    if(!label)
    {
        if(screenWidth>700)
        {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, yy, ScreenWidthFactor*320, ScreenHeightFactor*15)withChildStr:self.childObjectCalActivity.nick_Name];
            label.center=CGPointMake(screenWidth/2,yy+label.frame.size.height/2+5*ScreenHeightFactor);
        }
        else
        {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, yy, ScreenWidthFactor*320, ScreenHeightFactor*12)withChildStr:self.childObjectCalActivity.nick_Name];
            label.center=CGPointMake(screenWidth/2,yy+label.frame.size.height/2);
        }
        
        [self.view addSubview:label];
        yy+=label.frame.size.height+15*ScreenHeightFactor;
    }
}

#pragma mark addButton
-(void) addButton
{
    if(!addBtn)
    {
        addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setBackgroundImage:[UIImage imageNamed:isiPhoneiPad(@"addActivity.png")] forState:UIControlStateNormal];
        addBtn.frame=CGRectMake(0, 0, ScreenHeightFactor*20, ScreenHeightFactor*20);
        addBtn.tintColor=radiobuttonSelectionColor;
        addBtn.center=CGPointMake(screenWidth-addBtn.frame.size.width, label.center.y);
        [self.view addSubview:addBtn];
        [addBtn addTarget:self action:@selector(addNewActivity) forControlEvents:UIControlEventTouchUpInside];
//        if(isExist)
//        {
//            addBtn.userInteractionEnabled=YES;
//        }
//        else
//        {
//            addBtn.userInteractionEnabled=NO;
//            addBtn.alpha=0.0f;
//        }
    }
}

-(void)addNewActivity
{
    AddNewActivity *addNewActivity=[[AddNewActivity alloc]init];
    addNewActivity.child=self.childObjectCalActivity;
    [self.navigationController pushViewController:addNewActivity animated:YES];
}
-(void)calculatePreviousDay
{
    NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.showDate];
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    
    NSDate *date1 = [[NSCalendar currentCalendar] dateFromComponents:otherDay];
    NSDate *date2 = [[NSCalendar currentCalendar] dateFromComponents:today];
    
    NSComparisonResult result = [date2 compare:date1];
    if (result == NSOrderedAscending)
    {
        isExist=YES;
    } else if (result == NSOrderedDescending)
    {
        isExist=NO;
    }  else {
        isExist=YES;
        //the same
    }
}


#pragma mark draw Table
-(void)drawTableListView
{
    if(!calendarTable)
    {
        calendarTable = [[UITableView alloc]initWithFrame:CGRectMake(0,yy, screenWidth, self.view.frame.size.height-yy-self.tabBarController.tabBar.frame.size.height)];
        calendarTable.backgroundColor=appBackgroundColor;
        //  calendarTable.frame =;
        calendarTable .delegate=self;
        calendarTable.dataSource=self;
        calendarTable.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:calendarTable];
        
    }
}


-(void)callSchoolList
{
    NSLog(@"date: %@",self.dateString);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"EEE, MMM dd, yyyy"];
    NSString *currentDate=[formatter stringFromDate:self.showDate];
    
    if(completeActivityArray.count>0)
    {
        [completeActivityArray removeAllObjects];
        [[PC_DataManager sharedManager].calTableActivitybyDateArray removeAllObjects];
        
    }
    completeActivityArray=[[NSMutableArray alloc]init];
    
    [completeActivityArray addObject:@{
                                       @"Type"      :@"Date",
                                       @"Date"      :currentDate
                                       }];
    
    [completeActivityArray addObject:@{
                                       @"Type"      :@"Heading",
                                       @"Heading"   :@"AT SCHOOL"
                                       }];
    
    [formatter setDateFormat:@"dd/MM/yyyy"];
    currentDate=[formatter stringFromDate:self.showDate];
    self.dateString=currentDate;
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       GetSchoolActivitiesByDate *getAfterSchoolactivity = [[GetSchoolActivitiesByDate alloc] init];
                       [getAfterSchoolactivity initService:@{
                                                             @"ChildID":self.childObjectCalActivity.child_ID,
                                                             @"ActivityDate": self.dateString
                                                             }];
                       getAfterSchoolactivity.serviceName=@"GetSchoolActivitiesByDate";
                       [getAfterSchoolactivity setDelegate:self];
                       [self addLoaderView];
                   });
}

-(void)callAfterSchoolList
{
    [completeActivityArray addObject:@{
                                       @"Type"      :@"Heading",
                                       @"Heading"   :@"AFTER SCHOOL"
                                       }];
    [calendarTable reloadData];
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       GetAfterSchoolActivitiesByDate *getAfterSchoolactivity = [[GetAfterSchoolActivitiesByDate alloc] init];
                       [getAfterSchoolactivity initService:@{
                                                             @"ChildID":self.childObjectCalActivity.child_ID,
                                                             @"ActivityDate":self.dateString
                                                             }];
                       getAfterSchoolactivity.serviceName=@"GetAfterSchoolActivitiesByDate";
                       [getAfterSchoolactivity setDelegate:self];
                       [self addLoaderView];
                   });
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
    NSLog(@"error is: %@",errorMessage);
    [self removeLoaderView];
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection{
    
    NSLog(@"dictionary  %@", dictionary);
    [self removeLoaderView];
    NSDictionary * resultDict;
    if([connection.serviceName isEqualToString:@"GetAfterSchoolActivitiesByDate"])
    {
        resultDict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetAfterSchoolActivitiesByDateResponse" resultKey:@"GetAfterSchoolActivitiesByDateResult"];
        [self updateTableElement:resultDict ofType:@"AfterSchool"];
    }
    
    else  if([connection.serviceName isEqualToString:@"GetSchoolActivitiesByDate"])
    {
        resultDict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetSchoolActivitiesByDateResponse" resultKey:@"GetSchoolActivitiesByDateResult"];
        [self updateTableElement:resultDict ofType:@"School"];
    }
    
    
    
}
-(void)updateTableElement:(NSDictionary*)resultDict ofType:(NSString*)type
{
    
    // **************************ALERT TO SHOW NO ACTIVITIES FOUND******************************
    
    //    if([resultDict isKindOfClass:[NSArray class]])
    //    {
    //
    NSMutableArray *errDict= resultDict.mutableCopy;
    NSDictionary *dictionary  = [errDict firstObject];
    if([[dictionary valueForKey:@"ErrorDesc"]isEqualToString:@"No Record found."])
    {
        if([type isEqualToString:@"School"])
        {
            [self noActivityFillCell:@"No school activity scheduled.\n +  Tap to add new activity" andSubType:@"School"];
            [self callAfterSchoolList];
        }
        else
        {
            [self noActivityFillCell:@"No after school activity scheduled.\n +  Tap to add new activity" andSubType:@"After School"];
            [calendarTable reloadData];
        }
        return;
    }
    
    NSMutableArray *array=[[PC_DataManager sharedManager]updateCalendarTableByDate:resultDict ofType:type];
    
    
    
    //  [completeActivityArray removeAllObjects];
    
    for(NSMutableDictionary *dict1 in array)
    {
        [completeActivityArray addObject:dict1];
    }
    if([type isEqualToString:@"School"])
    {
        [self callAfterSchoolList];
    }
    [calendarTable reloadData];
}

-(void)noActivityFillCell:(NSString*)str andSubType:(NSString*)subType
{
    [completeActivityArray addObject:@{
                                       @"Type"          :@"NoActivity",
                                       @"NoActivity"    :str,
                                       @"SubType"       :subType
                                       }];
    
}



-(void)fillCompleteArray
{
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return completeActivityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSDictionary *data = [completeActivityArray objectAtIndex:indexPath.row];
    
    if([[data valueForKey:@"Type"] isEqualToString:@"Date"])
    {
        return ScreenHeightFactor*30;
    }
    else if([[data valueForKey:@"Type"] isEqualToString:@"Heading"])
    {
        return ScreenHeightFactor*30;
    }
    else if([[data valueForKey:@"Type"] isEqualToString:@"NoActivity"])
    {
        return ScreenHeightFactor*70;
    }
    //    else if([[data valueForKey:@"Type"] isEqualToString:@"School"])
    //    {
    //        return ScreenHeightFactor*50;
    //    }
    else if ([[data valueForKey:@"Type"] isEqualToString:@"After School"] || [[data valueForKey:@"Type"] isEqualToString:@"School"])
    {
        if(screenWidth>700)
        {
            return ScreenHeightFactor*83;
        }
        return ScreenHeightFactor*73;
    }
    //    if([[data valueForKey:@"key"] isEqualToString:@"banner1"] )
    //    {
    //        return 30;
    //    }
    //    if([[data valueForKey:@"key"] isEqualToString:@"banner2"] )
    //    {
    //        return 40;
    //    }
    //
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *DateCellIdentifier         = @"DateCell";
    static NSString *NoActivityCellIdentifier   = @"NoActivityCell";
    static NSString *HeadingCellIdentifier      = @"HeadingCell";
    static NSString *SchoolCellIdentifier       = @"SchoolCell";
    static NSString *AfterSchoolCellIdentifier  = @"AfterSchoolCell";
    
    
    CalenderByDateCell *cell;
    TextAndDescTextCell *cell2;
    NSDictionary *data = [completeActivityArray objectAtIndex:indexPath.row];
    
    if([[data objectForKey:@"Type"] isEqualToString:@"Date"])
    {
        cell2=[tableView dequeueReusableCellWithIdentifier:DateCellIdentifier];
        if(cell2 == nil)
        {
            cell2 = [[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:DateCellIdentifier];
        }
        [cell2 addText:[data objectForKey:@"Date"] andDesc:@"" withTextColor:activityHeading1FontCode andDecsColor:cellTextColor andType:@"Banner"];
        //        cell.textLabel.text = [data objectForKey:@"Date"];
        //        cell.textLabel.font=[UIFont fontWithName:RobotoRegular size:16*ScreenHeightFactor];
        cell2.backgroundColor=activityHeading1Code;
        return cell2;
        // cell.textLabel.textColor=activityHeading1FontCode;
    }
    
    if([[data objectForKey:@"Type"] isEqualToString:@"Heading"])
    {
        cell2=[tableView dequeueReusableCellWithIdentifier:DateCellIdentifier];
        if(cell2 == nil)
        {
            cell2 = [[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:DateCellIdentifier];
        }
        [cell2 addText:[data objectForKey:@"Heading"] andDesc:@"" withTextColor:activityHeading2FontCode andDecsColor:cellTextColor andType:@"Banner"];
        
        //        cell.textLabel.text = [data objectForKey:@"Heading"];
        //        cell.textLabel.font=[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
        cell2.backgroundColor=activityHeading2Code;
        return cell2;
        //        cell.textLabel.textColor=activityHeading2FontCode;
    }
    
    if([[data objectForKey:@"Type"] isEqualToString:@"NoActivity"])
    {
        cell=[tableView dequeueReusableCellWithIdentifier:NoActivityCellIdentifier];
        if(cell == nil)
        {
            cell = [[CalenderByDateCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NoActivityCellIdentifier];
        }
        [cell addActivityHeading:data];
        //        cell.textLabel.text = [data objectForKey:@"NoActivity"];
        //        cell.backgroundColor=appBackgroundColor;
        //        cell.textLabel.textAlignment=NSTextAlignmentCenter;
        //        cell.textLabel.center = CGPointMake(screenWidth/2,cell.textLabel.center.y);
        //        cell.textLabel.textColor=[UIColor darkGrayColor];
    }
    
    if([[data objectForKey:@"Type"] isEqualToString:@"School"])
    {
        cell=[tableView dequeueReusableCellWithIdentifier:SchoolCellIdentifier];
        if(cell == nil)
        {
            cell = [[CalenderByDateCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SchoolCellIdentifier];
        }
        // [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell addSubject:data];
        [cell setBackgroundColor:[UIColor colorWithRed:222.0f/255 green:232.0f/255 blue:239.0f/255 alpha:1]];
    }
    
    if([[data objectForKey:@"Type"] isEqualToString:@"After School"])
    {
        cell=[tableView dequeueReusableCellWithIdentifier:AfterSchoolCellIdentifier];
        if(cell == nil)
        {
            cell = [[CalenderByDateCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:AfterSchoolCellIdentifier];
        }
        //[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell addSubject:data];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableDictionary *data = [completeActivityArray objectAtIndex:indexPath.row];
    
    
    if([[NSDate date] compare:self.showDate]<=NSOrderedDescending)
    {
        NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self.showDate];
        NSDateComponents *today = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
        if(isExist)
        {
            calendarTable.userInteractionEnabled=YES;
            if([[data objectForKey:@"Type"]isEqualToString:@"School"])
            {
                ActivitySubjectDetailCal *subDetail=[[ActivitySubjectDetailCal alloc]init];
                subDetail.child=self.childObjectCalActivity;
                [subDetail setTabBarCtlr:self.tabBarCtlr];
                subDetail.subjectDataDict=data;
                [self.navigationController pushViewController:subDetail animated:YES];
            }
            else  if([[data objectForKey:@"Type"]isEqualToString:@"After School"])
            {
                ActivityDetails *details=[[ActivityDetails alloc]init];
                details.afterSchoolChild=self.childObjectCalActivity;
                [details setTabBarCtlr:self.tabBarCtlr];
                details.afterSchoolDataDict=[[NSMutableDictionary alloc]init];
                details.parentClass=ParentIsAfetrSchoolPlan;
                details.afterSchoolDataDict=data;
                
                [self.navigationController pushViewController:details animated:YES];
            }
            else if([[data objectForKey:@"Type"]isEqualToString:@"NoActivity"])
            {
                
                if([[data objectForKey:@"SubType"]isEqualToString:@"School"])
                {
                    SubjectCalenderList *subjectCalenderList=[[SubjectCalenderList alloc]init];
                    subjectCalenderList.child=self.childObjectCalActivity;
                    [subjectCalenderList setTabBarCtlr:self.tabBarCtlr];
                    [self.navigationController pushViewController:subjectCalenderList animated:YES];
                }
                else  if([[data objectForKey:@"SubType"]isEqualToString:@"After School"])
                {
                    AfterSchoolActivities *afterSchoolactivities=[[AfterSchoolActivities alloc]init];
                    afterSchoolactivities.afterChild=self.childObjectCalActivity;
                    [afterSchoolactivities setTabBarCtlr:self.tabBarCtlr];
                    [self.navigationController pushViewController:afterSchoolactivities animated:YES];
                }
            }
            
        }
        else
        {
            // calendarTable.userInteractionEnabled=NO;
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Sorry, you can't edit activities in the past." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
//            addBtn.alpha=0;
//            [addBtn setUserInteractionEnabled:NO];
        }
        
    }
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if([tableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)])
    {
        tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
}
#pragma mark ADD / REMOVE LOADER
-(void)addLoaderView
{
    loaderView=[[ShowActivityLoadingView alloc]initWithFrame:CGRectMake(0, calendarTable.frame.origin.y,screenWidth, calendarTable.frame.size.height)];
    [loaderView showLoaderViewWithText:@"Hold On..."];
    [self.view addSubview:loaderView];
}

-(void)removeLoaderView
{
    [loaderView removeLoaderView];
    [loaderView removeFromSuperview];
    loaderView=nil;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


@end