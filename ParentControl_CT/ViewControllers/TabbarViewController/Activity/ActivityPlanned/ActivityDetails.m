//
//  DetailPlanOfActivity.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 16/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "ActivityDetails.h"
#import "ActivityAfterSubjectDetailCal.h"
#import "ShowActivityLoadingView.h"
#import "InformAllyDetailViewController.h"
#import "RedLabelView.h"
#import "HeaderView.h"
#import "TextAndDescTextCell.h"
#import "DeleteScheduledActivityByActChildID.h"
#import "ScheduledAllyTable.h"


@interface ActivityDetails()<RepeatModeProtocol, InformAllyProtocol, InformAllyDetailProtocol,HeaderViewProtocol>

@end

@implementation ActivityDetails
{
    
    NSMutableArray *completeActivityArray;
    NSMutableArray *allyFillArray;
    
    UITableView *detailTableView;
    // UIScrollView *scrollView;
    UITextView *notes;
    
    NSString *placeholderText;
    UIView *pickerView;
    UIButton *doneBtn;
    UIButton *doneButton, *cancelButton ,*customButton;
    UIDatePicker *picker;
    TextAndDescTextCell *tableCell;
    
    NSString *Startdate;
    NSString *Enddate;
    NSString *Specialdate;
    NSString *examdate;
    NSString *isSpcl;
    NSString *isPrivate;
    NSString *startTime;
    NSString *endTime;
    NSString *repeatIndex;
    NSString *remarks;
    
    int tagVal;
    
    BOOL isStartTimeFilled;
    BOOL isStartDateFilled;
    NSDate *startTimeValidate;
    NSDate *startDateValidate;
    
    AddAfterSchoolActivities *addAfterSchoolActivities;
    ShowActivityLoadingView *loaderView;
    
    int rowNumber;

    
    NSDate *startdateForActivity;
    NSDate *enddateForActivity;
    
    HeaderView *headerView;
    RedLabelView *label;
    int yy;
    //int head2index;
    
    BOOL updateAlly1;
    BOOL updateAlly2;
}

@synthesize afterSchoolDataDict;
@synthesize afterSchoolChild;
@synthesize parentClass;
@synthesize informAllyArray;
@synthesize iswhatToDoController;
@synthesize activityName;
@synthesize activityName1;

-(void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    completeActivityArray = [[NSMutableArray alloc]init];
    informAllyArray=[[NSMutableArray alloc]init];
    self.view.backgroundColor=appBackgroundColor;
    tagVal=0;
    [[PC_DataManager sharedManager] getWidthHeight];
    
   
    isPrivate=@"0";
    isSpcl=@"0";
    [self drawHeaderView];
    [self childNameLabel];
    
    [self drawTableListView];
    [self selectDataToFill];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        [self addKeyBoardNotification];
    notes.delegate=self;
   [self.navigationController setNavigationBarHidden:YES];
    [self.tabBarController.tabBar setSelectedImageTintColor:[UIColor orangeColor]];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    if([[PC_DataManager sharedManager].repeatDaysString isEqualToString:@""] || [[PC_DataManager sharedManager].repeatDaysString isEqualToString:@"(null)"])
    {
        [PC_DataManager sharedManager].repeatDaysString = @"1,2,3,4,5,6,7".mutableCopy;
    }
    if([self.childViewCtrl isEqualToString:@"RepeatCtrl"])
    {
        if([[PC_DataManager sharedManager].repeatDaysString isEqualToString:@""] || [[PC_DataManager sharedManager].repeatDaysString isEqualToString:@"(null)"])
        {
            [PC_DataManager sharedManager].repeatDaysString = @"1,2,3,4,5,6,7".mutableCopy;
        }
        
        NSLog(@"[[PC_DataManager sharedManager].repeatDaysString ==%@",[PC_DataManager sharedManager].repeatDaysString);
        
        NSMutableDictionary *dict=[completeActivityArray objectAtIndex:rowNumber];
        if([[PC_DataManager sharedManager].repeatDaysString isEqualToString:@"1,7"])
        {
            [dict setObject:@"Weekend" forKey:@"Days Of Week"];
        }
        else if([[PC_DataManager sharedManager].repeatDaysString isEqualToString:@"2,3,4,5,6"])
        {
            [dict setObject:@"WeekDays" forKey:@"Days Of Week"];
        }
        else if([[PC_DataManager sharedManager].repeatDaysString isEqualToString:@"1,2,3,4,5,6,7"])
        {
            [dict setObject:@"All Days" forKey:@"Days Of Week"];
        }
        else if ([[PC_DataManager sharedManager].repeatDaysString isEqualToString:@""])
        {
            [dict setObject:@"" forKey:@"Days Of Week"];
        }
        else
        {
            [dict setObject:@"Specific Days" forKey:@"Days Of Week"];
        }
        self.childViewCtrl=@"";
       
//        [detailTableView reloadData];
    }
     [detailTableView reloadData];
    NSLog(@"repeat string days-------- %@",[PC_DataManager sharedManager].repeatDaysString);
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    [doneBtn removeFromSuperview];
    doneBtn=nil;
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
        [headerView setRightType:@"Save"];
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

-(void)getMenuTouches
{
    [self doneBtnTouched];
}


#pragma mark child
-(void)childNameLabel
{
    if(!label)
    {
        if(screenWidth>700)
        {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, yy, ScreenWidthFactor*320, ScreenHeightFactor*15)withChildStr:self.afterSchoolChild.nick_Name];
            label.center=CGPointMake(screenWidth/2,yy+label.frame.size.height/2+5*ScreenHeightFactor);
        }
        else
        {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, yy, ScreenWidthFactor*320, ScreenHeightFactor*12)withChildStr:self.afterSchoolChild.nick_Name];
            label.center=CGPointMake(screenWidth/2,yy+label.frame.size.height/2);
        }
        
        [self.view addSubview:label];
        yy+=label.frame.size.height+15*ScreenHeightFactor;
    }
}

-(void)drawTableListView
{
    if(!detailTableView)
    {
        detailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,yy, screenWidth, self.view.frame.size.height-yy-self.tabBarController.tabBar.frame.size.height)];
        detailTableView.backgroundColor=appBackgroundColor;
        detailTableView .delegate=self;
        detailTableView.dataSource=self;
        detailTableView.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:detailTableView];
    }
}


-(void)addGotoMerchantt:(UITableViewCell *)cell
{
    if(!customButton)
    {
        customButton=[UIButton buttonWithType:UIButtonTypeSystem];
        [customButton setTitle:@"Delete" forState:UIControlStateNormal];
        customButton.tintColor=[UIColor redColor];
        customButton.backgroundColor=[UIColor clearColor];
        [customButton setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
        customButton.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.025*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
        [customButton sizeToFit];
        // customButton.frame=CGRectMake(.2*screenWidth, .8*screenHeight, .73*screenWidth, .07*screenHeight);
       // customButton.layer.borderWidth=1.0;
      //  customButton.layer.borderColor=radiobuttonSelectionColor.CGColor;
        [customButton addTarget:self action:@selector(customBtnTouched) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:customButton];
        cell.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
        
    }
}

-(void)drawScheduledImage
{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*20, ScreenWidthFactor*20)];
    imageView.image=[UIImage imageNamed:isiPhoneiPad(@"ActivityDone.png")];
    imageView.center=CGPointMake(screenWidth-imageView.frame.size.width,label.center.y);
    [self.view addSubview: imageView];
}
-(void)addAcitvityBtn
{
    if(!doneBtn)
    {
        doneBtn=[UIButton buttonWithType:UIButtonTypeSystem];
        [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
        doneBtn.tintColor=[UIColor whiteColor];
        doneBtn.backgroundColor=[UIColor clearColor];
        [doneBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
        doneBtn.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.025*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
        [doneBtn sizeToFit];
         doneBtn.frame=CGRectMake(0, 0, screenWidth*.25, screenHeight*.06);
        if(self.view.frame.size.width>700)
        {
            doneBtn.center=CGPointMake(screenWidth-doneBtn.frame.size.width/2,screenHeight*.02);
        }
        else
        {
            doneBtn.center=CGPointMake(screenWidth-doneBtn.frame.size.width/2,screenHeight*.04);
        }
        doneBtn.layer.cornerRadius=10;
        doneBtn.clipsToBounds=YES;
        //  customButton.layer.borderColor=radiobuttonSelectionColor.CGColor;
        [doneBtn addTarget:self action:@selector(doneBtnTouched) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.navigationBar addSubview:doneBtn];
    }
}



-(void)doneBtnTouched
{
    NSLog(@"self.subjectID] = %@",[NSString stringWithFormat:@"%i",self.subjectID]);
    NSLog(@"self.afterSchoolChild.child_ID=%@",self.afterSchoolChild.child_ID);
    NSLog(@"notes.text = %@",notes.text);
    //NSLog(@"date=%@",date);
    NSLog(@"startTime= %@",startTime);
    NSLog(@"isSpcl%@",isSpcl);
     NSLog(@"isSpcl%@",isPrivate);
     NSLog(@"endTime%@",endTime);
     NSLog(@"Startdate%@",Startdate);
     NSLog(@"Enddate%@",Enddate);
    
    if(Startdate.length==0 || Enddate.length==0 ||startTime.length==0 || endTime.length==0 || isSpcl.length==0 || isPrivate.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Incomplete Data" message:@"Oops! You left a few important fields blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else if ([isSpcl isEqualToString:@"1"] && Specialdate.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Incomplete Data" message:@"This activity is marked special. You must set a special date - like the date for stage performance, a finale or a field trip. You can always come back and change this." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    else
    {
        if ([isSpcl isEqualToString:@"0"] && Specialdate.length==0)
        {
            Specialdate=Startdate;
        }
        if (!notes.text && !remarks)
        {
            remarks=@"Type your note here...";
        }
        else if (notes.text && remarks)
        {
            remarks=notes.text;
        }
        else if (notes.text && !remarks)
        {
            remarks=notes.text;
        }
        if ([PC_DataManager sharedManager].repeatDaysString.length==0)
        {
            [self setDayValue:nil];
            if([PC_DataManager sharedManager].repeatDaysString.length>1 && [[[PC_DataManager sharedManager].repeatDaysString substringToIndex:1]isEqualToString:@","])
            {
                    [PC_DataManager sharedManager].repeatDaysString=[[[PC_DataManager sharedManager].repeatDaysString substringFromIndex:1] mutableCopy];
            }
        }
        
        addAfterSchoolActivities =[[AddAfterSchoolActivities alloc]init];
        if (iswhatToDoController == 1) {
            [addAfterSchoolActivities initService:@{
                                                    @"ActivityID"    :[NSString stringWithFormat:@"%@",[afterSchoolDataDict valueForKey:@"ActivityID"]],
                                                    @"ChildID"       :self.afterSchoolChild.child_ID,
                                                    @"Remarks"       :remarks,
                                                    @"ExamDate"      :Enddate,
                                                    @"StartDate"     :Startdate,
                                                    @"StartTime"     :startTime,
                                                    @"EndTime"       :endTime,
                                                    @"Enddate"       :Enddate,
                                                    @"ActivityDays"  :[PC_DataManager sharedManager].repeatDaysString,
                                                    @"IsSpecial"     :isSpcl,
                                                    @"IsPrivate"     :isPrivate,
                                                    @"SpecialDate"   :Specialdate
                                                    
                                                    }];
        }
        else
        {
            [addAfterSchoolActivities initService:@{
                                                    @"ActivityID"    :[NSString stringWithFormat:@"%i",self.subjectID],
                                                    @"ChildID"       :self.afterSchoolChild.child_ID,
                                                    @"Remarks"       :remarks,
                                                    @"ExamDate"      :Enddate,
                                                    @"StartDate"     :Startdate,
                                                    @"StartTime"     :startTime,
                                                    @"EndTime"       :endTime,
                                                    @"Enddate"       :Enddate,
                                                    @"ActivityDays"  :[PC_DataManager sharedManager].repeatDaysString,
                                                    @"IsSpecial"     :isSpcl,
                                                    @"IsPrivate"     :isPrivate,
                                                    @"SpecialDate"   :Specialdate
                                                    
                                                    }];
        }
       
        [addAfterSchoolActivities setDelegate:self];
        addAfterSchoolActivities.serviceName=@"AddAfterSchoolActivities";
        [self addLoaderView];
    }
}
-(void)customBtnTouched
{
    DeleteScheduledActivityByActChildID *deleteActivity=[[DeleteScheduledActivityByActChildID alloc]init];
    [deleteActivity initService:@{
                                  @"ActivityID" :[NSString stringWithFormat:@"%i",self.subjectID],
                                  @"ChildID"    :self.afterSchoolChild.child_ID
                                  }];
    [deleteActivity setServiceName:PinWiDeleteActivity];
    [deleteActivity setDelegate:self];
    [self addLoaderView];
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
    //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self removeLoaderView];
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
{
    [self removeLoaderView];
    NSDictionary * resultDict;
    if([connection.serviceName isEqualToString:@"GetAfterSchoolActivityDetails"])
    {
        resultDict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetAfterSchoolActivityDetailsResponse" resultKey:@"GetAfterSchoolActivityDetailsResult"];
        
        if(!resultDict)
        {
            return;
        }
        else if([resultDict isKindOfClass:[NSArray class]])
        {
            NSMutableArray *dictArr=[resultDict mutableCopy];
            
            for(NSMutableDictionary *dict in dictArr)
            {
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:[dict objectForKey:@"Name"] ascending:YES];
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                dictArr = [[dictArr sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
            }
            
            [self fillAndScheduleCompleteArray:[dictArr firstObject]];
        }
    }
    else if([connection.serviceName isEqualToString:@"AddAfterSchoolActivities"])
    {
        NSLog(@"result given: %@",dictionary);
        ActivityData *actData=[[ActivityData alloc]init];
        actData.activityId=[NSString stringWithFormat:@"%i",self.subjectID];
        actData.activityName=self.SubName;
        actData.acitivityNotes=remarks;
        actData.childId=self.afterSchoolChild.child_ID;
        actData.parentId=[PC_DataManager sharedManager].parentObjectInstance.parentId;
        actData.isMarkPrivate=[isPrivate boolValue];
        actData.isMarkSpecial=[isSpcl boolValue];
        actData.startTime=startTime;
        actData.endTime=endTime;
        actData.activityType=@"afterSchool";
        [[PC_DataManager sharedManager].activities addObject:actData];
        
       
        
//        if(informAllyArray.count>0)
//        {
//            if(updateAlly1)
//            {
//            [self sendAllyInfoToService:[informAllyArray objectAtIndex:0] andServiceName:@"AddAllyInformationOnActivity1"];
//            }
//            else if (updateAlly2)
//            {
//               [self sendAllyInfoToService:[informAllyArray objectAtIndex:0] andServiceName:@"AddAllyInformationOnActivity2"];
//            }
//        }
//        
//        else
//        {
            NSString *str=[NSString stringWithFormat:@"%@%@",@"GetAfterSchoolActivitiesByChildID",self.afterSchoolChild.child_ID];
            [[PC_DataManager sharedManager].serviceDictionary removeObjectForKey:str];
            //[self.navigationController popToRootViewControllerAnimated:YES];
        [self.navigationController popViewControllerAnimated:YES];
//        }
        
    }
    else if([connection.serviceName isEqualToString:@"AddAllyInformationOnActivity1"])
    {
    
        if(informAllyArray.count>1)
        {
            [self sendAllyInfoToService:[informAllyArray objectAtIndex:1] andServiceName:@"AddAllyInformationOnActivity2"];
        }
        else
        {
            NSString *str=[NSString stringWithFormat:@"%@%@",@"GetAfterSchoolActivitiesByChildID",self.afterSchoolChild.child_ID];
            [[PC_DataManager sharedManager].serviceDictionary removeObjectForKey:str];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    else if([connection.serviceName isEqualToString:@"AddAllyInformationOnActivity2"])
    {
        NSString *str=[NSString stringWithFormat:@"%@%@",@"GetAfterSchoolActivitiesByChildID",self.afterSchoolChild.child_ID];
        [[PC_DataManager sharedManager].serviceDictionary removeObjectForKey:str];
         [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    else if([connection.serviceName isEqualToString:@"GetAllyInformationOnActivity1"])
    {
         resultDict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetAllyInformationOnActivityResponse" resultKey:@"GetAllyInformationOnActivityResult"];
        
        NSMutableArray *dictArr=[resultDict mutableCopy];
        [informAllyArray addObject:[self makeAllyDetailData:[dictArr firstObject]]];
        
        [self goToAllyDetailedScreen];
        
    }
    
    else if([connection.serviceName isEqualToString:@"GetAllyInformationOnActivity2"])
    {
         resultDict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetAllyInformationOnActivityResponse" resultKey:@"GetAllyInformationOnActivityResult"];
   
        NSMutableArray *dictArr=[resultDict mutableCopy];
        [informAllyArray addObject:[self makeAllyDetailData:[dictArr firstObject]]];
        
        [self goToAllyDetailedScreen];
        if(informAllyArray.count==1)
        {
            [informAllyArray removeLastObject];
        }
    }
    else if ([connection.serviceName isEqualToString:PinWiDeleteActivity])
    {
        NSString *str=[NSString stringWithFormat:@"%@%@",@"GetAfterSchoolActivitiesByChildID",self.afterSchoolChild.child_ID];
        [[PC_DataManager sharedManager].serviceDictionary removeObjectForKey:str];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    // [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

-(void)sendAllyInfoToService:(AllyProfileObject*)alyObj andServiceName:(NSString*)serviceName
{
    AddAllyInformationOnActivity *addAllyInfo=[[AddAllyInformationOnActivity alloc]init];
    [addAllyInfo initService:@{
                               @"ChildID"            :alyObj.child_ID,
                               @"ActivityID"         :alyObj.activity_ID,
                               @"AllyID"             :alyObj.ally_ID,
                               @"Date"               :alyObj.activityDate,
                               @"Time"               :alyObj.activityTime,
                               @"PickUp"             :alyObj.pickUp,
                               @"Drop"               :alyObj.drop,
                               @"SpeicalInstructions":alyObj.remarks,
                               @"NotificationMode"   :@"email",//alyObj.notifyMode
                               @"AllyIndex"          :[serviceName substringFromIndex:serviceName.length-1]
                               }];
    [addAllyInfo setDelegate:self];
    addAllyInfo.serviceName=serviceName;
    [self addLoaderView];
}

-(void)selectDataToFill
{
    NSUInteger numberOfViewControllersOnStack = [self.navigationController.viewControllers count];
    UIViewController *parentViewController = self.navigationController.viewControllers[numberOfViewControllersOnStack - 2];
    Class parentVCClass = [parentViewController class];
    NSString *className = NSStringFromClass(parentVCClass);
    
    
    if([className isEqualToString:@"AcademicsRotation"])
    {
        [self fillCompleteArray];
    }
    else
    {
        [self callServiceSubjectDetail];
    }
}

-(void)callServiceSubjectDetail
{
    GetAfterSchoolActivityDetails *getSchoolActivityDetails=[[GetAfterSchoolActivityDetails alloc]init];
    [getSchoolActivityDetails initService:@{
                                            @"ActivityID"  :[NSString stringWithFormat:@"%@",[afterSchoolDataDict objectForKey:@"ActivityID"]],
                                            @"ChildID"     :afterSchoolChild.child_ID,
                                            }];
    [getSchoolActivityDetails setDelegate:self];
    getSchoolActivityDetails.serviceName=@"GetAfterSchoolActivityDetails";
    [self addLoaderView];
}


-(void)fillCompleteArray
{
    self.subjectID=[[afterSchoolDataDict objectForKey:@"ActivityID"] intValue];
    
    completeActivityArray=[[NSMutableArray alloc] init];
    NSMutableDictionary *markPrivateDict = [[NSMutableDictionary alloc]init];
    
    
    //    [completeActivityArray addObject:@{@"key":@"banner1", @"value":self.activityName}];
    //    [completeActivityArray addObject:@{@"key":@"banner2", @"value":[self.afterSchoolDataDict objectForKey:@"Name"]}];
    //    [completeActivityArray addObject:@{@"key":@"navigation", @"value":@"Exam Date",  @"Exam Date":@""}];
    //    [completeActivityArray addObject:@{@"key":@"navigation", @"value":@"Start Date",  @"Start Date":@""}];
    //    [completeActivityArray addObject:@{@"key":@"navigation", @"value":@"Start Time", @"Start Time":@""}];
    //    [completeActivityArray addObject:@{@"key":@"navigation", @"value":@"End Time",   @"End Time":@""}];
    //    [completeActivityArray addObject:@{@"key":@"navigation", @"value":@"End Date",@"End Date":@""}];
    //    [completeActivityArray addObject:@{@"key":@"navigation", @"value":@"Repeat",@"Repeat":@""}];
    //    [completeActivityArray addObject:@{@"key":@"banner2", @"value":@"Reminder"}];
    // [completeActivityArray addObject:@{@"key":@"switch", @"value":@"Mark Private", @"tag":@"1" ,@"isToggle":@"0"}];
    
    markPrivateDict = [[NSMutableDictionary alloc]init];
    [markPrivateDict setValue:@"banner1" forKey:@"key"];
    [markPrivateDict setValue:self.activityName forKey:@"value"];
    [completeActivityArray addObject:markPrivateDict];
    
    self.activityName=[afterSchoolDataDict objectForKey:@"Name"];
    markPrivateDict = [[NSMutableDictionary alloc]init];
    [markPrivateDict setValue:@"banner2" forKey:@"key"];
    [markPrivateDict setValue:[[afterSchoolDataDict objectForKey:@"Name"]uppercaseString] forKey:@"value"];
    [completeActivityArray addObject:markPrivateDict];
    
    NSArray *navArrayElements=@[@"Start Date", @"Start Time", @"End Time", @"End Date", @"Days Of Week"];
    
    for(NSString *str in navArrayElements)
    {
        markPrivateDict = [[NSMutableDictionary alloc]init];
        [markPrivateDict setValue:@"navigation" forKey:@"key"];
        [markPrivateDict setValue:str forKey:@"value"];
        [markPrivateDict setValue:@"" forKey:str];
        
        [completeActivityArray addObject:markPrivateDict];
    }
    
    
    markPrivateDict = [[NSMutableDictionary alloc]init];
    [markPrivateDict setValue:@"banner2" forKey:@"key"];
    [markPrivateDict setValue:@"Other Information" forKey:@"value"];
    [completeActivityArray addObject:markPrivateDict];
    
    
    
//    markPrivateDict = [[NSMutableDictionary alloc]init];
//    [markPrivateDict setValue:@"switch" forKey:@"key"];
//    [markPrivateDict setValue:@"Mark Private" forKey:@"value"];
//    [markPrivateDict setValue:@"1" forKey:@"tag"];
//    [markPrivateDict setValue:@"0" forKey:@"isToggle"];
//    [completeActivityArray addObject:markPrivateDict];
    
    
    markPrivateDict = [[NSMutableDictionary alloc]init];
    [markPrivateDict setValue:@"switch" forKey:@"key"];
    [markPrivateDict setValue:@"Mark Special" forKey:@"value"];
    [markPrivateDict setValue:@"0" forKey:@"tag"];
    [markPrivateDict setValue:@"0" forKey:@"isToggle"];
    [completeActivityArray addObject:markPrivateDict];
    
    markPrivateDict = [[NSMutableDictionary alloc]init];
    [markPrivateDict setValue:@"navigation" forKey:@"key"];
    [markPrivateDict setValue:@"Inform Ally" forKey:@"value"];
    [markPrivateDict setValue:@"" forKey:@"Inform Ally"];
    [completeActivityArray addObject:markPrivateDict];
    
//    markPrivateDict = [[NSMutableDictionary alloc]init];
//    [markPrivateDict setValue:@"navigation" forKey:@"key"];
//    [markPrivateDict setValue:@"Inform Ally 2" forKey:@"value"];
//    [markPrivateDict setValue:@"" forKey:@"Inform Ally 2"];
//    [completeActivityArray addObject:markPrivateDict];
    
    markPrivateDict = [[NSMutableDictionary alloc]init];
    [markPrivateDict setValue:@"banner2" forKey:@"key"];
    [markPrivateDict setValue:@"Location" forKey:@"value"];
    [completeActivityArray addObject:markPrivateDict];
    
    markPrivateDict = [[NSMutableDictionary alloc]init];
    [markPrivateDict setValue:@"textbox" forKey:@"key"];
    [markPrivateDict setValue:@"textbox" forKey:@"value"];
    [completeActivityArray addObject:markPrivateDict];
    
//    markPrivateDict = [[NSMutableDictionary alloc]init];
//    [markPrivateDict setValue:@"Button" forKey:@"key"];
//    [completeActivityArray addObject:markPrivateDict];
    //    [completeActivityArray addObject:@{@"key":@"navigation", @"value":@"Inform Ally",@"Inform Ally":@""}];
    //    [completeActivityArray addObject:@{@"key":@"banner2", @"value":@"Note"}];
    //    [completeActivityArray addObject:@{@"key":@"textbox", @"value":@"textbox"}];
    [detailTableView reloadData];
}


-(void)fillAndScheduleCompleteArray:(NSMutableDictionary*)dict
{
    
   // [self drawScheduledImage];
    
    self.subjectID=[[dict objectForKey:@"ActivityID"] intValue];
    self.activityName=[dict objectForKey:@"Name"];
    allyFillArray=[[NSMutableArray alloc]init];
    
    
    NSMutableDictionary *markPrivateDict = [[NSMutableDictionary alloc]init];
    [markPrivateDict setValue:@"banner1" forKey:@"key"];
    [markPrivateDict setValue:@"After School" forKey:@"value"];
    
    completeActivityArray=[[NSMutableArray alloc] initWithObjects:markPrivateDict, nil];
    // [completeActivityArray addObject:markPrivateDict];
    
    NSMutableDictionary *markPrivateDict2 = [[NSMutableDictionary alloc]init];
    [markPrivateDict2 setValue:@"banner2" forKey:@"key"];
    [markPrivateDict2 setValue:[dict objectForKey:@"Name"] forKey:@"value"];
    [completeActivityArray addObject:markPrivateDict2];
    
    NSLog(@"completeActivityArray  %@", completeActivityArray);
    
    //   NSArray *navArrayElements=@[@"Exam Date",@"Start Date", @"Start Time", @"End Time", @"End Date", @"Repeat"];
    
    //   int rindex=0;
    //  for(NSString *str in navArrayElements)
    //  {
    //        markPrivateDict = [[NSMutableDictionary alloc]init];
    //        [markPrivateDict setValue:@"navigation" forKey:@"key"];
    //        [markPrivateDict setValue:str forKey:@"value"];
    //        [markPrivateDict setValue:[dict objectForKey:@"ExamDate"] forKey:str];
    //
    //        [completeActivityArray addObject:markPrivateDict];
    //   }
    
    
    //----------------------------------------------------------------------------
    
    //    markPrivateDict = [[NSMutableDictionary alloc]init];
    //    [markPrivateDict setValue:@"navigation" forKey:@"key"];
    //    [markPrivateDict setValue:@"Exam Date" forKey:@"value"];
    //    [markPrivateDict setValue:[dict objectForKey:@"ExamDate"] forKey:@"Exam Date"];
    //    [completeActivityArray addObject:markPrivateDict];
    
    
    markPrivateDict = [[NSMutableDictionary alloc]init];
    [markPrivateDict setValue:@"navigation" forKey:@"key"];
    [markPrivateDict setValue:@"Start Date" forKey:@"value"];
    
    if([dict objectForKey:@"StartDate"])
    {
        isStartDateFilled=YES;
        Startdate=[dict objectForKey:@"StartDate"];
    }
    else
    {
        Startdate=@"";
    }
    [markPrivateDict setValue:Startdate forKey:@"Start Date"];
    [completeActivityArray addObject:markPrivateDict];
    
    
    
    markPrivateDict = [[NSMutableDictionary alloc]init];
    [markPrivateDict setValue:@"navigation" forKey:@"key"];
    [markPrivateDict setValue:@"Start Time" forKey:@"value"];
    
    
    if([dict objectForKey:@"StartTime"])
    {
        isStartTimeFilled=YES;
        startTime=[dict objectForKey:@"StartTime"];
    }
    else
    {
        startTime=@"";
    }
    [markPrivateDict setValue:startTime forKey:@"Start Time"];
    [completeActivityArray addObject:markPrivateDict];
    
    
    markPrivateDict = [[NSMutableDictionary alloc]init];
    [markPrivateDict setValue:@"navigation" forKey:@"key"];
    [markPrivateDict setValue:@"End Time" forKey:@"value"];
    if([dict objectForKey:@"EndTime"])
    {
        isStartTimeFilled=YES;
        endTime=[dict objectForKey:@"EndTime"];
    }
    else
    {
        endTime=@"";
    }
    [markPrivateDict setValue:endTime forKey:@"End Time"];
    
    [completeActivityArray addObject:markPrivateDict];
    
    
    markPrivateDict = [[NSMutableDictionary alloc]init];
    [markPrivateDict setValue:@"navigation" forKey:@"key"];
    [markPrivateDict setValue:@"End Date" forKey:@"value"];
    if([dict objectForKey:@"EndDate"])
    {
        Enddate=[dict objectForKey:@"EndDate"];
    }
    else
    {
        Enddate=@"";
    }
    [markPrivateDict setValue:Enddate forKey:@"End Date"];
    [completeActivityArray addObject:markPrivateDict];
    
    markPrivateDict = [[NSMutableDictionary alloc]init];
    [markPrivateDict setValue:@"navigation" forKey:@"key"];
    [markPrivateDict setValue:@"Days Of Week" forKey:@"value"];
    
    
    //----------------------------------------------------------------------------
    
    //[self checkrepeatString:[dict objectForKey:@"DayMode"]];
    
    [PC_DataManager sharedManager].repeatDaysString=[[NSString stringWithFormat:@"%@",[dict objectForKey:@"DayID"]] mutableCopy];
    
    [markPrivateDict setValue:[dict objectForKey:@"DayMode"] forKey:@"Days Of Week"];
    
    [completeActivityArray addObject:markPrivateDict];
    
    //----------------------------------------------------------------------------
    
    
    markPrivateDict = [[NSMutableDictionary alloc]init];
    [markPrivateDict setValue:@"banner2" forKey:@"key"];
    [markPrivateDict setValue:@"Other Information" forKey:@"value"];
    [completeActivityArray addObject:markPrivateDict];
    
//    markPrivateDict = [[NSMutableDictionary alloc]init];
//    [markPrivateDict setValue:@"switch" forKey:@"key"];
//    [markPrivateDict setValue:@"Mark Private" forKey:@"value"];
//    [markPrivateDict setValue:@"1" forKey:@"tag"];
//    [markPrivateDict setValue:[NSString stringWithFormat:@"%hhd",[[dict objectForKey:@"IsPrivate"] boolValue]] forKey:@"isToggle"];
//    isPrivate=[NSString stringWithFormat:@"%hhd",[[dict objectForKey:@"IsPrivate"]boolValue]];
//    if([isPrivate isEqualToString:@"0"])
//    {
//        isPrivate=@"0";
//    }
//    else
//    {
//        isPrivate=@"1";
//    }
//    [completeActivityArray addObject:markPrivateDict];
    
    markPrivateDict = [[NSMutableDictionary alloc]init];
    [markPrivateDict setValue:@"switch" forKey:@"key"];
    [markPrivateDict setValue:@"Mark Special" forKey:@"value"];
    [markPrivateDict setValue:@"0" forKey:@"tag"];
    [markPrivateDict setValue:[NSString stringWithFormat:@"%hhd",[[dict objectForKey:@"IsSpecial"]boolValue]] forKey:@"isToggle"];
    isSpcl=[NSString stringWithFormat:@"%hhd",[[dict objectForKey:@"IsSpecial"] boolValue]];
    if([isSpcl isEqualToString:@"0"])
    {
        isSpcl=@"0";
    }
    else
    {
        isSpcl=@"1";
    }
    [completeActivityArray addObject:markPrivateDict];
    
    if([isSpcl isEqualToString:@"1"])
    {
        markPrivateDict = [[NSMutableDictionary alloc]init];
        [markPrivateDict setValue:@"navigation" forKey:@"key"];
        [markPrivateDict setValue:@"Special Date" forKey:@"value"];
        if([dict objectForKey:@"SpecialDate"])
        {
            Specialdate=[dict objectForKey:@"SpecialDate"];
        }
        else
        {
            Specialdate=@"";
        }
        [markPrivateDict setValue:Specialdate forKey:@"Special Date"];
        [completeActivityArray addObject:markPrivateDict];
    }
    
    markPrivateDict = [[NSMutableDictionary alloc]init];
    [markPrivateDict setValue:@"navigation" forKey:@"key"];
    [markPrivateDict setValue:@"Inform Ally" forKey:@"value"];
    
    if([dict objectForKey:@"AllyID1"])
    {
        [allyFillArray addObject:[dict objectForKey:@"AllyID1"]];
        [markPrivateDict setValue:[dict objectForKey:@"Ally1FirstName"] forKey:@"Inform Ally 1"];
    }
    else{
        [markPrivateDict setValue:@"" forKey:@"Inform Ally"];
    }
    
    [completeActivityArray addObject:markPrivateDict];
    
    
//    
//    markPrivateDict = [[NSMutableDictionary alloc]init];
//    [markPrivateDict setValue:@"navigation" forKey:@"key"];
//    [markPrivateDict setValue:@"Inform Ally 2" forKey:@"value"];
//    
//    if([dict objectForKey:@"AllyID2"])
//    {
//        [allyFillArray addObject:[dict objectForKey:@"AllyID2"]];
//        [markPrivateDict setValue:[dict objectForKey:@"Ally2FirstName"] forKey:@"Inform Ally 2"];
//    }
//    else{
//        [markPrivateDict setValue:@"" forKey:@"Inform Ally 2"];
//    }
//    
//    [completeActivityArray addObject:markPrivateDict];
//    
    
    markPrivateDict = [[NSMutableDictionary alloc]init];
    [markPrivateDict setValue:@"banner2" forKey:@"key"];
    [markPrivateDict setValue:@"Location" forKey:@"value"];
    [completeActivityArray addObject:markPrivateDict];
    
    markPrivateDict = [[NSMutableDictionary alloc]init];
    [markPrivateDict setValue:@"textbox" forKey:@"key"];
    if([dict objectForKey:@"Remarks"])
    {
        remarks=[dict objectForKey:@"Remarks"];
    }
    else
    {
       remarks=@"Where is this happening?";
    }

    [markPrivateDict setValue:remarks forKey:@"value"];
    [completeActivityArray addObject:markPrivateDict];
    
    markPrivateDict = [[NSMutableDictionary alloc]init];
    [markPrivateDict setValue:@"Button" forKey:@"key"];
    [completeActivityArray addObject:markPrivateDict];
    
    NSLog(@"completeActivityArray  %@", completeActivityArray);
    [detailTableView reloadData];
    /*
     [completeActivityArray addObject:@{@"key":@"banner1", @"value":@"AfterSchool"}];
     [completeActivityArray addObject:@{@"key":@"banner2", @"value":[self.afterSchoolDataDict objectForKey:@"ActivityName"]}];
     
     
     [completeActivityArray addObject:@{@"key":@"navigation", @"value":@"Start Date",  @"Start Date":@""}];
     [completeActivityArray addObject:@{@"key":@"navigation", @"value":@"Start Time", @"Start Time":[self.afterSchoolDataDict objectForKey:@"StartTime"]}];
     [completeActivityArray addObject:@{@"key":@"navigation", @"value":@"End Time",@"End Time":[self.afterSchoolDataDict objectForKey:@"EndTime"]}];
     [completeActivityArray addObject:@{@"key":@"navigation", @"value":@"End Date",@"End Date":[self.afterSchoolDataDict objectForKey:@"EndTime"]}];
     [completeActivityArray addObject:@{@"key":@"navigation", @"value":@"Repeat",@"Repeat":@"Every Week"}];
     
     [completeActivityArray addObject:@{@"key":@"banner2", @"value":@"Reminder"}];
     
     [completeActivityArray addObject:@{@"key":@"switch", @"value":@"Mark Private", @"tag":@"1" , @"isToggle":[NSString stringWithFormat:@"%@",[self.afterSchoolDataDict objectForKey:@"IsPrivate"]]}];
     
     [completeActivityArray addObject:@{@"key":@"switch", @"value":@"Mark Special", @"tag":@"0" , @"isToggle":[NSString stringWithFormat:@"%@",[self.afterSchoolDataDict objectForKey:@"IsSpecial"]]}];
     
     
     if([[self.afterSchoolDataDict objectForKey:@"isSpecial"]boolValue])
     {
     [completeActivityArray addObject:@{@"key":@"navigation", @"value":@"Special Date", @"Special Date":[self.afterSchoolDataDict objectForKey:@"SpecialDate"]}];
     }
     
     
     
     [completeActivityArray addObject:@{@"key":@"navigation", @"value":@"Inform Ally",@"Inform Ally":@""}];
     
     [completeActivityArray addObject:@{@"key":@"banner2", @"value":@"Note"}];
     
     [completeActivityArray addObject:@{@"key":@"textbox", @"value":@"textbox"}];
     */
}


//-(void)checkrepeatString:(NSString *)str
//{
//    [PC_DataManager sharedManager].repeatDaysString=[str mutableCopy];
//    if([str isEqualToString:@"Weekend"])
//    {
//        [PC_DataManager sharedManager].repeatDaysString=[@"1,7" mutableCopy];
//    }
//    else if([str isEqualToString:@"WeekDays"])
//    {
//        [PC_DataManager sharedManager].repeatDaysString=[@"2,3,4,5,6" mutableCopy];
//    }
//    else if ([str isEqualToString:@"DaysOfWeek"])
//    {
//        [PC_DataManager sharedManager].repeatDaysString=[@"1,2,3,4,5,6,7" mutableCopy];
//    }
//    else
//    {
//        [PC_DataManager sharedManager].repeatDaysString=[@"" mutableCopy];
//    }
//}


#pragma mark TableView Specific Function
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return completeActivityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSDictionary *data = [completeActivityArray objectAtIndex:indexPath.row];
    
    
    
    if([[data valueForKey:@"key"] isEqualToString:@"banner1"] ) {
        return ScreenHeightFactor*30;
    }
    
    if([[data valueForKey:@"key"] isEqualToString:@"banner2"] ) {
        return ScreenHeightFactor*30;
    }
    if([[data valueForKey:@"key"] isEqualToString:@"navigation"] ) {
        return ScreenHeightFactor*42;
    }
    if([[data valueForKey:@"key"] isEqualToString:@"switch"] ) {
        return ScreenHeightFactor*50;
    }
    if([[data valueForKey:@"key"] isEqualToString:@"textbox"] )
    {
        return ScreenHeightFactor*100;
    }
    if([[data valueForKey:@"key"] isEqualToString:@"Button"] )
    {
        return ScreenHeightFactor*40;
    }

    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // static NSString *CellIdentifier = @"DetailPlanViewCell";
    //DetailPlanViewCell *cell = [[DetailPlanViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    
    static NSString *Head1AfterSchoolIdentifier         = @"Head1AfterSchoolCell";
    static NSString *Head2AfterSchoolIdentifier         = @"Head2AfterSchoolCell";
    static NSString *DetailDescAfterSchoolIdentifier    = @"DetailDescAfterSchoolCell";
    static NSString *ToggleAfetrSchoolIdentifier        = @"ToggleAfterSchoolCell";
    static NSString *NoteAfterSchoolIdentifier          = @"NoteAfterSchoolCell";
    static NSString *ButtonAfterSchoolIdentifier        = @"ButtonAfterSchoolCell";
    
    TextAndDescTextCell *cell;//=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    
    
    NSDictionary *data = [completeActivityArray objectAtIndex:indexPath.row];
    NSString *text;
    
    if([[data valueForKey:@"key"] isEqualToString:@"banner1"])
    {
        if(cell.textLabel.text.length==0)
        {
            cell =[tableView dequeueReusableCellWithIdentifier:Head1AfterSchoolIdentifier];
            if(!cell)
            {
                cell =[[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Head1AfterSchoolIdentifier];
            }
            [cell addText:[data objectForKey:@"value"] andDesc:@"" withTextColor:activityHeading1FontCode andDecsColor:cellTextColor andType:@"Banner"];
//            cell.textLabel.font=[UIFont fontWithName:RobotoRegular size:11*ScreenFactor];
//            cell.textLabel.text= [data objectForKey:@"value"];
//            cell.textLabel.textColor=activityHeading1FontCode;
            cell.backgroundColor=activityHeading1Code;
            
        }
    }
    
    else  if([[data valueForKey:@"key"] isEqualToString:@"banner2"])
    {
        if (iswhatToDoController == 1) {
            text = activityName1;
        }else{
            text = [data objectForKey:@"value"];
        }

        
        cell =[tableView dequeueReusableCellWithIdentifier:Head2AfterSchoolIdentifier];
        if(!cell)
        {
            cell =[[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Head2AfterSchoolIdentifier];
        }
        //        if(cell.textLabel.text.length==0)
        //        {
        [cell addText:text andDesc:@"" withTextColor:activityHeading2FontCode andDecsColor:cellTextColor andType:@"Banner"];
//        cell.textLabel.font=[UIFont fontWithName:RobotoRegular size:11*ScreenFactor];
//        cell.textLabel.text= [data objectForKey:@"value"];
//        cell.textLabel.textColor=activityHeading2FontCode;
        cell.backgroundColor=activityHeading2Code;
        //        }
    }
    
    
    else if([[data valueForKey:@"key"] isEqualToString:@"navigation"])
    {
        cell =[tableView dequeueReusableCellWithIdentifier:DetailDescAfterSchoolIdentifier];
        if(!cell)
        {
            cell =[[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:DetailDescAfterSchoolIdentifier];
        }
//        cell.textLabel.text = [data objectForKey:@"value"];
        cell.backgroundColor=appBackgroundColor;
        //        if(cell.textLabel.text.length==0)
        //        {
        [cell addText:[data objectForKey:@"value"] andDesc:[data objectForKey:[data objectForKey:@"value"]] withTextColor:cellBlackColor_7 andDecsColor:placeHolderReg andType:@""];
        cell.descTextLabel.text=[data objectForKey:cell.textlabel1.text];
        cell.descTextLabel.center=CGPointMake(cell.descTextLabel.center.x-cellPadding, cell.descTextLabel.center.y);
//        cell.textLabel.font=[UIFont fontWithName:RobotoRegular size:9*ScreenFactor];
//        cell.textLabel.textColor=cellBlackColor_7;
//        cell.detailTextLabel.text= [data objectForKey:cell.textLabel.text];
        cell.descTextLabel.font=[UIFont fontWithName:RobotoRegular size:9*ScreenFactor];
        cell.arrowImageView.alpha=1.0f;
//        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        //        }
    }
    
    else if([[data valueForKey:@"key"] isEqualToString:@"switch"])
    {
        cell =[tableView dequeueReusableCellWithIdentifier:ToggleAfetrSchoolIdentifier];
        if(!cell)
        {
            cell =[[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ToggleAfetrSchoolIdentifier];
        }
        [cell addText:[data objectForKey:@"value"] andDesc:[data objectForKey:cell.textlabel1.text] withTextColor:cellBlackColor_7 andDecsColor:placeHolderReg andType:@"Switch"];
        cell.textlabel1.center=CGPointMake(cell.textlabel1.center.x, ScreenHeightFactor*25);

//        cell.descTextLabel.text=[data objectForKey:cell.textlabel1.text];
      //  cell.textLabel.text = [data objectForKey:@"value"];
        if(cell.detailTextLabel.text.length>0)
        {
        }
        cell.descTextLabel.font=[UIFont fontWithName:RobotoRegular size:9*ScreenFactor];
       // cell.backgroundColor=appBackgroundColor;
      //  cell.textLabel.textColor=cellBlackColor_7;
//        cell.textLabel.font=[UIFont fontWithName:RobotoRegular size:9*ScreenFactor];
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchView;
        if([[data objectForKey:@"isToggle"] isEqualToString:@"1"])
        {
            [switchView setOn:YES animated:NO];
        }
        else
        {
            [switchView setOn:NO animated:NO];
        }
        switchView.onTintColor=radiobuttonSelectionColor;
        switchView.tag=[[data valueForKey:@"tag"] intValue];
        [switchView addTarget:self action:@selector(switchChanged1:) forControlEvents:UIControlEventValueChanged];
    }
    else if([[data valueForKey:@"key"] isEqualToString:@"textbox"])
    {
        cell =[tableView dequeueReusableCellWithIdentifier:NoteAfterSchoolIdentifier];
        if(!cell)
        {
            cell =[[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NoteAfterSchoolIdentifier];
        }
        //        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        if(!notes)
        {
            notes = [[UITextView alloc] initWithFrame:CGRectMake(cellPadding, 10*ScreenHeightFactor, screenWidth-2*cellPadding, 80*ScreenHeightFactor)];
            [notes setDelegate:self];
            [notes setFont:[UIFont fontWithName:RobotoLight size:9*ScreenFactor]];
            [notes setScrollEnabled:YES];
            [notes setUserInteractionEnabled:YES];
            notes.editable=YES;
            [notes setBackgroundColor:[UIColor clearColor]];
            // [notes setText:@"Type Note Here...."];
            placeholderText = @"Where is this happening?";
            notes.textColor=placeHolderReg;
            [notes setText:placeholderText];
            CGRect frame = notes.frame;
            frame.size.height = notes.contentSize.height;
            notes.frame = frame;
            [cell.contentView addSubview:notes];
            
            cell.backgroundColor=appBackgroundColor;
            cell.textLabel.textColor=cellBlackColor_7;
            //[self addGotoMerchant:tableCell];
            
            // [cell addSubview:customButton];
        }
    }
        else if([[data valueForKey:@"key"] isEqualToString:@"Button"])
        {
            cell =[tableView dequeueReusableCellWithIdentifier:ButtonAfterSchoolIdentifier];
            if(!cell)
            {
                cell =[[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ButtonAfterSchoolIdentifier];
            }
            if (iswhatToDoController != 1) {
                 [self addGotoMerchantt:cell];
            }
       
            customButton.frame=CGRectMake(screenWidth*.1,2,screenWidth*.8,screenHeight*.06-2);
            //customButton.backgroundColor=buttonGreenColor;
            customButton.center=CGPointMake(screenWidth/2, customButton.center.y);
        cell.backgroundColor=appBackgroundColor;
            if ([cell respondsToSelector:@selector(layoutMargins)]) {
                
            }
            cell.layoutMargins = UIEdgeInsetsZero;
            cell.separatorInset=UIEdgeInsetsZero;
            
    }
    
    NSLog(@"data  %@", [completeActivityArray objectAtIndex:indexPath.row]);
    
    tableCell=cell;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableCell = [tableView cellForRowAtIndexPath:indexPath];
    rowNumber=(int)indexPath.row;
    
    if(pickerView!=nil)
    {
        [pickerView removeFromSuperview];
    }
    
    if([tableCell.textlabel1.text isEqualToString: @"Start Date"] || [tableCell.textlabel1.text isEqualToString: @"Special Date"]|| [tableCell.textlabel1.text isEqualToString: @"Exam Date"])
    {
        
        if(pickerView!=nil)
        {
            [pickerView removeFromSuperview];
        }
        NSLog(@"in selection %@",tableCell.class);
        [self drawDatePicker];
        picker.datePickerMode=UIDatePickerModeDate;
        picker.minimumDate  = [NSDate date];
        // [pickerView removeFromSuperview];
        
        //   tableCell.inputView=picker
        
    }
    else if([tableCell.textlabel1.text isEqualToString:@"End Date"] && isStartDateFilled)
    {
        
        if(pickerView!=nil)
        {
            [pickerView removeFromSuperview];
            
            
        }
        NSLog(@"in selection %@",tableCell.class);
        [self drawDatePicker];
        picker.datePickerMode=UIDatePickerModeDate;
        picker.minimumDate  = startDateValidate;
        // [pickerView removeFromSuperview];
        
        //   tableCell.inputView=picker
        
    }
    
    else if([tableCell.textlabel1.text isEqualToString: @"Start Time"])
    {
        if(pickerView!=nil)
        {
            [pickerView removeFromSuperview];
            pickerView=nil;
            
            
        }
        NSLog(@"in selection %@",tableCell.class);
        [self drawDatePicker];
        picker.minimumDate  = nil;
        picker.datePickerMode=UIDatePickerModeTime;
    }
    
    else if([tableCell.textlabel1.text isEqualToString:@"End Time"] && isStartTimeFilled)
    {
        if(pickerView!=nil)
        {
            [pickerView removeFromSuperview];
            pickerView=nil;
        }
        NSLog(@"in selection %@",tableCell.class);
        [self drawDatePicker];
        picker.minimumDate  = startTimeValidate;
        picker.datePickerMode=UIDatePickerModeTime;
    }
    
    
    
    else if ([tableCell.textlabel1.text isEqualToString: @"Days Of Week"])
    {
        UIBarButtonItem *newBackButton =
        [[UIBarButtonItem alloc] initWithTitle:@""
                                         style:UIBarButtonItemStyleBordered
                                        target:nil
                                        action:nil];
        [[self navigationItem] setBackBarButtonItem:newBackButton];
        self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
        
      // [PC_DataManager sharedManager].repeatDaysString= [[[PC_DataManager sharedManager]daysFromDate:startdateForActivity toDate:enddateForActivity] mutableCopy];
        
        ActivityAfterSubjectDetailCal *activitysubjectCal=[[ActivityAfterSubjectDetailCal alloc]init];
        activitysubjectCal.child=self.afterSchoolChild;
        activitysubjectCal.subject=[[completeActivityArray objectAtIndex:1]objectForKey:@"value"];
        activitysubjectCal.subjectID=self.subjectID;
        activitysubjectCal.parentClass=parentClass;
        activitysubjectCal.activityName=[[completeActivityArray objectAtIndex:0]objectForKey:@"value"];
        activitysubjectCal.repeatModeDelegate=self;
        [activitysubjectCal setTabBarCtlr:self.tabBarCtlr];
        self.childViewCtrl=@"RepeatCtrl";
        [self.navigationController pushViewController:activitysubjectCal animated:YES];
        
        
        
    }
    else if ([tableCell.textlabel1.text isEqualToString:@"Inform Ally"])
    {
        [self informAllyforAfterSchoolActivity];
        // [self presentViewController:infromAlly animated:YES completion:nil];
    }
//    else if ([tableCell.textlabel1.text isEqualToString:@"Inform Ally 2"])
//    {
//        if(informAllyArray.count>0 || allyFillArray.count>0)
//        {
//         [self informAllyforAfterSchoolActivity];
//        }
//        else
//        {
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please fill the details for Ally 1 first" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark Inform ally

-(void)informAllyforAfterSchoolActivity
{
     [self gotoAllyaddedList];
    
   /* UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    
    if([tableCell.descTextLabel.text isEqualToString:@""])
    {
        [self gotoAllyaddedList];
//        InformToAllyViewController *inform=[[InformToAllyViewController alloc]init];
//        inform.informAllyDelegate=self;
//        inform.child=self.afterSchoolChild;
//        inform.subjectName=self.activityName;
//        inform.informAllyDict=[[AllyProfileObject alloc]init];
//        inform.informAllyDict.activity_ID=[NSString stringWithFormat:@"%i",self.subjectID];
//        inform.informAllyDict.child_ID=self.afterSchoolChild.child_ID;
////        inform.parentClass=ParentIsAfetrSchoolPlan;
//        [self.navigationController pushViewController:inform animated:YES];
    }
    else
    if((tableCell.descTextLabel.text && informAllyArray.count>0)|| allyFillArray.count>0)
    {
        
        if(allyFillArray.count!=informAllyArray.count && allyFillArray.count>0)
        {
            if( [tableCell.textlabel1.text isEqualToString:@"Inform Ally"])
            {
                [self getAllyDetailService:@"GetAllyInformationOnActivity1" andIndex:0];
            }
//            else if( [tableCell.textlabel1.text isEqualToString:@"Inform Ally 2"])
//            {
//                [self getAllyDetailService:@"GetAllyInformationOnActivity2" andIndex:1];
//            }
        }
        else{
            [self gotoAllyaddedList];
        }
    }
*/
}

-(void)gotoAllyaddedList
{
    ScheduledAllyTable *schedule=[[ScheduledAllyTable alloc]init];
    if (iswhatToDoController == 1) {
        schedule.activityDict= @{
                                 
                                 @"activityID":[NSString stringWithFormat:@"%@",[afterSchoolDataDict valueForKey:@"ActivityID"]],
                                 @"activityName":self.activityName1
                                 };
    }
    else
    {
        schedule.activityDict= @{
                                 
                                 @"activityID":[NSString stringWithFormat:@"%i", self.subjectID],
                                 @"activityName":self.activityName
                                 };
    }
    
    schedule.childObjectSubActivity=self.afterSchoolChild;
    [schedule setTabBarCtrl:self.tabBarCtlr];
    [self.navigationController pushViewController:schedule animated:YES];
}




-(void)goToAllyDetailedScreen
{
    InformAllyDetailViewController *informdet=[[InformAllyDetailViewController alloc]init];
    informdet.informAllyDetailDelegate=self;
    informdet.detailAlly=[[AllyProfileObject alloc]init];
    if( [tableCell.textlabel1.text isEqualToString:@"Inform Ally"])
    {
        informdet.detailAlly=[informAllyArray objectAtIndex:0];
    }
    else if( [tableCell.textlabel1.text isEqualToString:@"Inform Ally 2"])
    {
        informdet.detailAlly=[informAllyArray lastObject];
    }
    informdet.child=self.afterSchoolChild;
    informdet.parentClass=ParentIsAfetrSchoolPlan;
    [informdet setTabBarCtlr:self.tabBarCtlr];
    [self.navigationController pushViewController:informdet animated:YES];
}

-(void)sendAllyName:(NSString *)allyName andId:(NSString *)allyId andAllyObj:(AllyProfileObject *)allyObj
{
    
    if ([tableCell.textlabel1.text isEqualToString:@"Inform Ally"])
    {
        updateAlly1=YES;
        if(tableCell.descTextLabel.text.length>0)
        {
            [informAllyArray replaceObjectAtIndex:0 withObject:allyObj];
        }
        else
        {
        [informAllyArray addObject:allyObj];
        }
    }
    else if ([tableCell.textlabel1.text isEqualToString:@"Inform Ally"])
    {
        updateAlly2=YES;
        if(tableCell.descTextLabel.text.length>0)
        {
            [informAllyArray replaceObjectAtIndex:1 withObject:allyObj];
        }
        else
        {
            [informAllyArray addObject:allyObj];
        }

    }
    tableCell.descTextLabel.text=allyName;
   tableCell.descTextLabel.font=[UIFont fontWithName:RobotoRegular size:9*ScreenFactor];
    NSMutableDictionary *changeVal=[completeActivityArray objectAtIndex:rowNumber];
    [changeVal setObject:tableCell.descTextLabel.text forKey:tableCell.textlabel1.text];
    [detailTableView reloadData];
}


#pragma mark CALL ALLY DETAILS SERVICE
-(void)getAllyDetailService:(NSString*)serviceName andIndex:(int)index
{
    GetAllyInformationOnActivity *getInfo=[[GetAllyInformationOnActivity alloc]init];
    [getInfo initService:@{
                           @"ChildID":self.afterSchoolChild.child_ID,
                           @"ActivityID":[NSString stringWithFormat:@"%i",self.subjectID],
                           @"AllyID":[allyFillArray objectAtIndex:index],
                           @"AllyIndex":[serviceName substringFromIndex:serviceName.length-1]
                           }];
    getInfo.serviceName=serviceName;
    getInfo.delegate=self;
    [self addLoaderView];
}

-(AllyProfileObject*)makeAllyDetailData:(NSDictionary*)resultDict
{
    AllyProfileObject *alyObj=[[AllyProfileObject alloc]init];
    alyObj.child_ID     =self.afterSchoolChild.child_ID;
    alyObj.activity_ID  =[NSString stringWithFormat:@"%i",self.subjectID];
    alyObj.ally_ID      =[NSString stringWithFormat:@"%@",[allyFillArray objectAtIndex:0]];
    alyObj.firstName    =[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"FirstName"]];
    alyObj.profilePic   =[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"ProfileImage"]];
    alyObj.activityDate =[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"Date"]];
    alyObj.activityTime =[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"Time"]];
    alyObj.pickUp       =[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"PickUp"]];
    alyObj.drop         =[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"Drop"]];
    alyObj.remarks      =[NSString stringWithFormat:@"%@",[resultDict objectForKey:@"SpeicalInstructions"]];
    
    return alyObj;
}


#pragma mark RepeatModeDelagate
-(void)repeatString:(NSString *)str andRepeatIndex:(NSString *)index
{
    tableCell.descTextLabel.text=str;
    tableCell.descTextLabel.font=[UIFont fontWithName:RobotoRegular size:9*ScreenFactor];
    repeatIndex=index;
}

-(void)addKeyBoardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

-(void) keyboardWillShow:(NSNotification *)note
{
    NSLog(@"KeyBoard wiil Show");
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    //[scrollView setFrame:CGRectMake(0,-20, scrollView.frame.size.width, scrollView.frame.size.height)];
    [UIView commitAnimations];
    
    NSDictionary* info = [note userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(-detailTableView.frame.size.height, 0, kbSize.height, 0);
    detailTableView.contentInset = contentInsets;
    detailTableView.scrollIndicatorInsets = contentInsets;
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    
    //    if (!CGRectContainsPoint(aRect, timeTextField.frame.origin) ) {
    //        CGPoint scrollPoint = CGPointMake(0.0, timeTextField.frame.origin.y-kbSize.height);
    //        [scrollView setContentOffset:scrollPoint animated:YES];
    //    }
    
}

-(void) keyboardWillHide:(NSNotification *)note
{
    NSLog(@"KeyBoard wiil Hide");
    UIEdgeInsets contentInsets=UIEdgeInsetsMake(0.0,0.0,0.0,0.0);
    detailTableView.contentInset = contentInsets;
    detailTableView.scrollIndicatorInsets = contentInsets;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        
    }
    else
    {
        
    }
    
    
    return YES;
    
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

- (void) switchChanged1:(id)sender
{
    UISwitch* switchControl = sender;
    NSLog(@"tag = %li",(long)switchControl.tag);
    
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
    
    if(pickerView!=nil)
    {
        [pickerView removeFromSuperview];
    }
    
    if(switchControl.tag==0)
    {
        NSMutableDictionary *dict=[completeActivityArray objectAtIndex:8];
        // NSDictionary *dictNew;
        if(switchControl.on)
        {
            isSpcl=@"1";
            
            //       dict=@{
            //                @"isToggle":@"1",
            //            };
            [dict setValue:@"1" forKey:@"isToggle"];
            
            NSMutableDictionary* markPrivateDict = [[NSMutableDictionary alloc]init];
            [markPrivateDict setValue:@"navigation" forKey:@"key"];
            [markPrivateDict setValue:@"Special Date" forKey:@"value"];
            [markPrivateDict setValue:@"" forKey:@"Special Date"];
            
            [completeActivityArray insertObject:markPrivateDict atIndex:9];
        }
        else
        {
            isSpcl=@"0";
            [dict setValue:@"0" forKey:@"isToggle"];
            [completeActivityArray removeObjectAtIndex:9];
        }
        
        NSLog(@"complete array==\n %@",completeActivityArray);
        
        
        //[completeActivityArray addObject:@{@"key":@"navigation", @"value":@"Start Date",  @"Start Date":@""}];
        
    }
    
    else  if(switchControl.tag==1)
    {
        NSMutableDictionary *dict=[completeActivityArray objectAtIndex:7];
        //NSDictionary *dict=[completeActivityArray objectAtIndex:12];
        if(switchControl.on)
        {
            isPrivate=@"1";
            [dict setValue:@"1" forKey:@"isToggle"];
        }
        else
        {
            isPrivate=@"0";
            [dict setValue:@"0" forKey:@"isToggle"];
        }
        
    }
    [detailTableView reloadData];
    
    /*  if([tableCell.textLabel.text isEqualToString:@"Mark Special"])
     {
     if(switchControl.on)
     {
     isSpcl=@"1";
     }
     else
     {
     isSpcl=@"0";
     }
     }
     else if([tableCell.textLabel.text isEqualToString:@"Mark Private"])
     {
     if(switchControl.on)
     {
     isPrivate=@"1";
     }
     else
     {
     isPrivate=@"0";
     }
     }
     */
    
}




-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if(textView.text.length==0)
    {
        textView.text=placeholderText;
    }
    else if([textView.text isEqualToString:placeholderText])
    {
        textView.text = @"";
    }
    
}
-(void)drawDatePicker
{
    pickerView=[[UIView alloc]initWithFrame:CGRectMake(0, screenHeight-self.view.frame.size.height/2-64, screenWidth, screenHeight/2)];
    [self.view addSubview:pickerView];
    pickerView.backgroundColor=[UIColor whiteColor];
    
    
    cancelButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.tintColor=[UIColor darkGrayColor];
    cancelButton.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.022*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    [cancelButton sizeToFit];
    cancelButton.frame=CGRectMake(0,0,pickerView.frame.size.width*.3, pickerView.frame.size.height*.1);
    [cancelButton addTarget:self action:@selector(ClickOnCancel) forControlEvents:UIControlEventTouchUpInside];
    [pickerView addSubview:cancelButton];
    
    doneButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    doneButton.tintColor=[UIColor darkGrayColor];
    doneButton.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.022*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    doneButton.frame=CGRectMake(pickerView.frame.size.width-cancelButton.frame.size.width,0,pickerView.frame.size.width*.3, pickerView.frame.size.height*.1);
    [doneButton addTarget:self action:@selector(ClickOnDone) forControlEvents:UIControlEventTouchUpInside];
    [pickerView addSubview:doneButton];
    
    
    picker = [[UIDatePicker alloc] init];
    picker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    // picker.datePickerMode = UIDatePickerModeDate;
    picker.frame = CGRectMake(pickerView.frame.origin.x, pickerView.frame.size.height*.12, pickerView.frame.size.width, pickerView.frame.size.height);

    [pickerView addSubview:picker];
}



-(void)ClickOnDone
{
    NSMutableDictionary *changeVal=[completeActivityArray objectAtIndex:rowNumber];
    NSDate *date1 = picker.date;
    if(picker.date==nil)
    {
        date1=[NSDate date];
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    if([tableCell.textlabel1.text isEqualToString:@"Start Date"] || [tableCell.textlabel1.text isEqualToString:@"End Date"]||[tableCell.textlabel1.text isEqualToString:@"Special Date"]|| [tableCell.textlabel1.text isEqualToString: @"Exam Date"])
    {
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
        NSString *dateString = [dateFormat stringFromDate:date1];
        tableCell.descTextLabel.text =dateString;
        tableCell.descTextLabel.font=[UIFont fontWithName:RobotoRegular size:9*ScreenFactor];
        [pickerView removeFromSuperview];
        
        if([tableCell.textlabel1.text isEqualToString:@"Start Date"])
        {
            Startdate=dateString;
            startDateValidate=date1;
            isStartDateFilled=YES;
            startdateForActivity=date1;
            
            
            if([Enddate isEqualToString:Startdate])
            {
                [self setDayValue:date1];
            }

            [changeVal setObject:dateString forKey:@"Start Date"];
        }
        if([tableCell.textlabel1.text isEqualToString:@"End Date"])
        {
            Enddate=dateString;
            enddateForActivity=date1;
            
//            if([Enddate isEqualToString:Startdate])
//            {
//              [self setDayValue:date1];
//            }
            
            [changeVal setObject:dateString forKey:@"End Date"];
        
        }
        if([tableCell.textlabel1.text isEqualToString:@"Special Date"])
        {
            Specialdate=dateString;
            [changeVal setObject:dateString forKey:@"Special Date"];
        }
        //        if([tableCell.textLabel.text isEqualToString:@"Exam Date"])
        //        {
        //            examdate=dateString;
        //             [changeVal setObject:dateString forKey:@"Exam Date"];
        //        }
        //isStartTimeFilled=YES;
    }
    else if([tableCell.textlabel1.text isEqualToString:@"Start Time"]|| [tableCell.textlabel1.text isEqualToString:@"End Time"])
    {
        [dateFormat setDateFormat:@"hh:mm a"];
        [dateFormat setAMSymbol:@"AM "];
        [dateFormat setPMSymbol:@"PM "];
        
        NSDateComponents *dateOffset = [[NSDateComponents alloc] init];
        [dateOffset setHour:1];
        
        NSCalendar *cal=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSDate *endDate = [cal dateByAddingComponents:dateOffset toDate:date1 options:0];
        
        NSString *dateString = [dateFormat stringFromDate:date1];
        NSString *dateString1 = [dateFormat stringFromDate:endDate];
        tableCell.descTextLabel.text =dateString;
        tableCell.descTextLabel.font=[UIFont fontWithName:RobotoRegular size:9*ScreenFactor];
        [pickerView removeFromSuperview];
        
        if([tableCell.textlabel1.text isEqualToString:@"Start Time"])
        {
            startTime=dateString;
            startTimeValidate=date1;
            isStartTimeFilled=YES;
            endTime=dateString1;
            [changeVal setObject:dateString forKey:@"Start Time"];
            
            //NSMutableDictionary *chndEndval=[completeActivityArray objectAtIndex:rowNumber+1];
            [[completeActivityArray objectAtIndex:rowNumber+1] setObject:dateString1 forKey:@"End Time"];
        }
        else
        {
            endTime=dateString;
            [changeVal setObject:dateString forKey:@"End Time"];
        }
    }
    [detailTableView reloadData];
}

-(void)ClickOnCancel
{
    
    [pickerView removeFromSuperview];
}


-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" detail button tap");
}

#pragma mark ADD / REMOVE LOADER
-(void)addLoaderView
{
    loaderView=[[ShowActivityLoadingView alloc]initWithFrame:CGRectMake(0,0 , screenWidth, screenHeight)];
    [loaderView showLoaderViewWithText:@"Hold On..."];
    [self.view addSubview:loaderView];
}

-(void)removeLoaderView
{
    //[loaderView removeLoaderView];
    [loaderView removeFromSuperview];
    loaderView=nil;
}


#pragma mark AutoSet day string
-(void)setDayValue:(NSDate*)dateCheck
{
    dateCheck=startdateForActivity;
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSWeekdayCalendarUnit fromDate:dateCheck]; // Get necessary date components
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"EEEE"];
//    
    NSLog(@"%i",(int)[components weekday]);
    
    NSString *dayStr=[PC_DataManager sharedManager].repeatDaysString;
    
    if(![dayStr containsString:[NSString stringWithFormat:@"%i",(int)[components weekday]]])
        {
            dayStr=[dayStr stringByAppendingString:[NSString stringWithFormat:@",%i",(int)[components weekday]]];
        }
    
    [PC_DataManager sharedManager].repeatDaysString=[dayStr mutableCopy];
    
    //[components month]; //gives you month
   // day= [components day]; //gives you day
    //[components year]; // gives you year
   
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
