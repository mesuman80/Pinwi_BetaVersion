//
//  ActivitySubjectDetailCal.m
//  ParentControl_CT
//
//  Created by Priyanka on 19/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "ActivitySubjectDetailCal.h"
#import "ShowActivityLoadingView.h"
#import "RedLabelView.h"
#import "HeaderView.h"
#import "TextAndDescTextCell.h"
#import "DeleteScheduledActivityByActChildID.h"

@interface ActivitySubjectDetailCal ()<HeaderViewProtocol>

{
    
    
    NSMutableArray *completeActivityArray;
    
    UITableView *detailTableView;
    // UIScrollView *scrollView;
    UITextView *notes;
    NSString *placeholderText;
    UIView *pickerView;
    UIButton *doneBtn;
    UIButton *doneButton, *cancelButton;
    UIDatePicker *picker;
    TextAndDescTextCell *tableCell;
    UIImageView *exam;
    UIButton  *customButton;
    AddSubjectActivity *addSubjectActivity;
    NSString *examDate;
    NSString *daysStr;
    NSString *remarks;
    ShowActivityLoadingView *loaderView;
    int yy;
    
    RedLabelView *label;
    HeaderView *headerView;
    
    int rowNumber;
    UIImageView *examImgView;
}

@end

@implementation ActivitySubjectDetailCal
{
    
}
@synthesize child;
@synthesize subjectID;
@synthesize subject;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=appBackgroundColor;
    [[PC_DataManager sharedManager] getWidthHeight];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    daysStr=@"";
    [self drawHeaderView];
    [self childNameLabel];
    [self drawTableListView];
    [self selectDataToFill];
   
    
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        [self addKeyBoardNotification];
    [self.navigationController setNavigationBarHidden:YES];
    [self.tabBarController.tabBar setSelectedImageTintColor:[UIColor orangeColor]];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
     [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
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
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, yy, ScreenWidthFactor*320, ScreenHeightFactor*15)withChildStr:self.child.nick_Name];
            label.center=CGPointMake(screenWidth/2,yy+label.frame.size.height/2+5*ScreenHeightFactor);
        }
        else
        {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, yy, ScreenWidthFactor*320, ScreenHeightFactor*12)withChildStr:self.child.nick_Name];
            label.center=CGPointMake(screenWidth/2,yy+label.frame.size.height/2);
        }
        
        [self.view addSubview:label];
        yy+=label.frame.size.height+15*ScreenHeightFactor;
    }
}

#pragma mark draw Table
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

-(void)callServiceSubjectDetail
{
   GetSchoolActivityDetails *getSchoolActivityDetails=[[GetSchoolActivityDetails alloc]init];
    [getSchoolActivityDetails initService:@{
                                      @"ActivityID"  :[NSString stringWithFormat:@"%@",[self.subjectDataDict objectForKey:@"ActivityID"]],
                                      @"ChildID"     :self.child.child_ID,
                                    }];
    [getSchoolActivityDetails setDelegate:self];
    getSchoolActivityDetails.serviceName=@"GetSchoolActivityDetails";
    [self addLoaderView];
}


//-(void)viewDidAppear:(BOOL)animated
//{
//   // [detailTableView reloadData];
//}

-(void)selectDataToFill
{
    NSUInteger numberOfViewControllersOnStack = [self.navigationController.viewControllers count];
    UIViewController *parentViewController = self.navigationController.viewControllers[numberOfViewControllersOnStack - 2];
    Class parentVCClass = [parentViewController class];
    NSString *className = NSStringFromClass(parentVCClass);
    
    
    if([className isEqualToString:@"SubjectCalenderList"])
    {
        [self fillCompleteArray];
    }
    else
    {
        [self callServiceSubjectDetail];
    }
}


-(void)fillCompleteArray
{
   /* [completeActivityArray addObject:@{@"key":@"banner1", @"value":@"Subject Calendar"}];
    [completeActivityArray addObject:@{@"key":@"banner2", @"value":subject}];
    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Monday"   ,@"Type":@"0"}];
    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Tuesday"  ,@"Type":@"0"}];
    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Wednesday",@"Type":@"0"}];
    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Thursday" ,@"Type":@"0"}];
    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Friday"   ,@"Type":@"0"}];
    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Saturday" ,@"Type":@"0"}];
    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Sunday"   ,@"Type":@"0"}];
    
    [completeActivityArray addObject:@{@"key":@"navigation", @"value":@"Exam Date",  @"Exam Date":@""}];
    [completeActivityArray addObject:@{@"key":@"banner2", @"value":@"Note"}];
    
    
    [completeActivityArray addObject:@{@"key":@"textbox", @"value":@"textbox", @"Remarks":@"Type Note Here...."}];
    */
    subject=[subject uppercaseString];
   
    
    completeActivityArray=[[NSMutableArray alloc] init];
    NSMutableDictionary *markPrivateDict;
    
    markPrivateDict = [[NSMutableDictionary alloc]init];
    [markPrivateDict setValue:@"banner1" forKey:@"key"];
    [markPrivateDict setValue:@"At School" forKey:@"value"];
    [completeActivityArray addObject:markPrivateDict];
    
    markPrivateDict = [[NSMutableDictionary alloc]init];
    [markPrivateDict setValue:@"banner2" forKey:@"key"];
    [markPrivateDict setValue:subject forKey:@"value"];
    [completeActivityArray addObject:markPrivateDict];
    
    NSArray *navArrayElements=@[@"Monday",@"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", @"Sunday",@"Week days",@"Weekend"];
    
    for(NSString *str in navArrayElements)
    {
        markPrivateDict = [[NSMutableDictionary alloc]init];
        [markPrivateDict setValue:@"Days" forKey:@"key"];
        [markPrivateDict setValue:str forKey:@"value"];
        [markPrivateDict setValue:@"0" forKey:@"Type"];
        
        [completeActivityArray addObject:markPrivateDict];
    }
    
    markPrivateDict = [[NSMutableDictionary alloc]init];
    [markPrivateDict setValue:@"navigation" forKey:@"key"];
    [markPrivateDict setValue:@"Exam Date" forKey:@"value"];
    [markPrivateDict setValue:@"" forKey:@"Exam Date"];
    [completeActivityArray addObject:markPrivateDict];
    
    markPrivateDict = [[NSMutableDictionary alloc]init];
    [markPrivateDict setValue:@"banner2" forKey:@"key"];
    [markPrivateDict setValue:@"Note" forKey:@"value"];
    [completeActivityArray addObject:markPrivateDict];

    markPrivateDict = [[NSMutableDictionary alloc]init];
    [markPrivateDict setValue:@"textbox" forKey:@"key"];
    [markPrivateDict setValue:@"textbox" forKey:@"value"];
    [markPrivateDict setValue:@"Type Note Here...." forKey:@"Remarks"];
    
    [completeActivityArray addObject:markPrivateDict];
   
//    markPrivateDict = [[NSMutableDictionary alloc]init];
//    [markPrivateDict setValue:@"Button" forKey:@"key"];
//    [completeActivityArray addObject:markPrivateDict];
    // [completeActivityArray addObject:@{@"key":@"Button", @"value":@"textbox"}];
    
}



-(void)fillAndScheduleCompleteArray:(NSMutableDictionary*)dict
{
    NSMutableDictionary *dictionary1;
    if([dict isKindOfClass:[NSArray class]])
    {
        NSMutableArray *arr=(NSMutableArray*)dict;
       dictionary1=[arr firstObject];
    }
    
  //  [self drawScheduledImage];
    
     subjectID=[[self.subjectDataDict objectForKey:@"ActivityID"]intValue];
    completeActivityArray=[[NSMutableArray alloc] init];
    NSMutableDictionary *markPrivateDict;
    
    markPrivateDict = [[NSMutableDictionary alloc]init];
    [markPrivateDict setValue:@"banner1" forKey:@"key"];
    [markPrivateDict setValue:@"At School" forKey:@"value"];
    [completeActivityArray addObject:markPrivateDict];
    
    markPrivateDict = [[NSMutableDictionary alloc]init];
    [markPrivateDict setValue:@"banner2" forKey:@"key"];
    [markPrivateDict setValue:[dictionary1 objectForKey:@"Name"] forKey:@"value"];
    [completeActivityArray addObject:markPrivateDict];
    
    
    int rindex=0;
    NSMutableArray *tickSubArr=[[NSMutableArray alloc]init];
    
    for(NSString *indx in [self.subjectDataDict objectForKey:@"repeat"])
    {
        if([indx isEqualToString:@"1"])
        {
         daysStr= [daysStr stringByAppendingString:[NSString stringWithFormat:@",%i",(rindex+1)]];
        }
        [tickSubArr addObject:indx];
        rindex++;
    }
    if ([daysStr isEqualToString:@",1,7"])
    {
        tickSubArr=[[NSMutableArray alloc]init];
        for(rindex=0; rindex<7; rindex++)
        {
        [tickSubArr addObject:@"0"];
        }
        [tickSubArr addObject:@"0"];
        [tickSubArr addObject:@"1"];
    }
    else if ([daysStr isEqualToString:@",2,3,4,5,6"])
    {
        tickSubArr=[[NSMutableArray alloc]init];
        for(rindex=0; rindex<7; rindex++)
        {
            [tickSubArr addObject:@"0"];
        }
        [tickSubArr addObject:@"1"];
        [tickSubArr addObject:@"0"];
    }
    else
    {
        [tickSubArr addObject:@"0"];
        [tickSubArr addObject:@"0"];
    }
    
    NSArray *navArrayElements=@[@"Sunday", @"Monday",@"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday",@"Week days",@"Weekend"];
    
    rindex=0;
    for(NSString *str in navArrayElements)
    {
        markPrivateDict = [[NSMutableDictionary alloc]init];
        [markPrivateDict setValue:@"Days" forKey:@"key"];
        [markPrivateDict setValue:str forKey:@"value"];
        
            [markPrivateDict setValue:[tickSubArr objectAtIndex:rindex] forKey:@"Type"];
            [completeActivityArray addObject:markPrivateDict];
            rindex++;
    }
    
    markPrivateDict = [[NSMutableDictionary alloc]init];
    [markPrivateDict setValue:@"navigation" forKey:@"key"];
    [markPrivateDict setValue:@"Exam Date" forKey:@"value"];
    [markPrivateDict setValue:[dictionary1 objectForKey:@"ExamDate"] forKey:@"Exam Date"];
    if ([[dictionary1 objectForKey:@"ExamDate"] isEqualToString:@""] || [[dictionary1 objectForKey:@"ExamDate"] isEqualToString:@"(null)"] || [dictionary1 objectForKey:@"ExamDate"]==NULL) {
        examDate = @"";
    }else{
        examDate=[dictionary1 objectForKey:@"ExamDate"];
    }
    
    [completeActivityArray addObject:markPrivateDict];
    
    markPrivateDict = [[NSMutableDictionary alloc]init];
    [markPrivateDict setValue:@"banner2" forKey:@"key"];
    [markPrivateDict setValue:@"Note" forKey:@"value"];
    [completeActivityArray addObject:markPrivateDict];
    
    markPrivateDict = [[NSMutableDictionary alloc]init];
    [markPrivateDict setValue:@"textbox" forKey:@"key"];
    [markPrivateDict setValue:@"textbox" forKey:@"value"];
    [markPrivateDict setValue:[dictionary1 objectForKey:@"Remarks"] forKey:@"Remarks"];
    remarks=[dictionary1 objectForKey:@"Remarks"];
    [completeActivityArray addObject:markPrivateDict];

    markPrivateDict = [[NSMutableDictionary alloc]init];
    [markPrivateDict setValue:@"Button" forKey:@"key"];
    [completeActivityArray addObject:markPrivateDict];
   /*
    completeActivityArray=[[NSMutableArray alloc] init];
    
    [completeActivityArray addObject:@{@"key":@"banner1", @"value":@"Subject Calendar"}];
    [completeActivityArray addObject:@{@"key":@"banner2", @"value":[dictionary1 objectForKey:@"Name"]}];
    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Monday"   ,@"Type":[[self.subjectDataDict objectForKey:@"repeat"] objectAtIndex:0]}];
    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Tuesday"  ,@"Type":[[self.subjectDataDict objectForKey:@"repeat"] objectAtIndex:1]}];
    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Wednesday",@"Type":[[self.subjectDataDict objectForKey:@"repeat"] objectAtIndex:2]}];
    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Thursday" ,@"Type":[[self.subjectDataDict objectForKey:@"repeat"] objectAtIndex:3]}];
    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Friday"   ,@"Type":[[self.subjectDataDict objectForKey:@"repeat"] objectAtIndex:4]}];
    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Saturday" ,@"Type":[[self.subjectDataDict objectForKey:@"repeat"] objectAtIndex:5]}];
    [completeActivityArray addObject:@{@"key":@"Days", @"value":@"Sunday"   ,@"Type":[[self.subjectDataDict objectForKey:@"repeat"] objectAtIndex:6]}];
    
    [completeActivityArray addObject:@{@"key":@"navigation", @"value":@"Exam Date",  @"Exam Date":[dictionary1 objectForKey:@"ExamDate"]}];
    [completeActivityArray addObject:@{@"key":@"banner2", @"value":@"Note"}];
    
    
    [completeActivityArray addObject:@{@"key":@"textbox", @"value":@"textbox", @"Remarks":[dictionary1 objectForKey:@"Remarks"]}];
    
    // [completeActivityArray addObject:@{@"key":@"Button", @"value":@"textbox"}];*/
    [detailTableView reloadData];
}



-(void)drawScheduledImage
{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*20, ScreenWidthFactor*20)];
    imageView.image=[UIImage imageNamed:isiPhoneiPad(@"ActivityDone.png")];
    imageView.center=CGPointMake(screenWidth-imageView.frame.size.width,label.center.y);
    [self.view addSubview: imageView];
}

-(void)addGotoMerchant:(UITableViewCell *)cell
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
//        customButton.layer.borderWidth=1.0;
//        customButton.layer.borderColor=radiobuttonSelectionColor.CGColor;
        [customButton addTarget:self action:@selector(customBtnTouched) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:customButton];
        
    }
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
        doneBtn.frame=CGRectMake(0, 0, screenWidth*.25,screenHeight*.06);
        if(self.view.frame.size.width>700)
        {
        doneBtn.center=CGPointMake(screenWidth-doneBtn.frame.size.width/2,screenHeight*.02);
        }
        else
        {
            doneBtn.center=CGPointMake(screenWidth-doneBtn.frame.size.width/2,screenHeight*.04);
        }
        customButton.layer.cornerRadius=10;
        customButton.clipsToBounds=YES;
        //  customButton.layer.borderColor=radiobuttonSelectionColor.CGColor;
        [doneBtn addTarget:self action:@selector(doneBtnTouched) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.navigationBar addSubview:doneBtn];
    }
}

-(void)doneBtnTouched
{
    if(daysStr.length==0)
    {
        UIAlertView *examAlert=[[UIAlertView alloc]initWithTitle:@"Incomplete Data" message:@"You must select days of the week this activity happens at school." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [examAlert show];
    }
//    else if([examDate isEqualToString:@""] || examDate==nil)
//    {
//        UIAlertView *examAlert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please fill exam date" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [examAlert show];
//        //examDate=@"Not Added";
//    }
    else{
        if([daysStr length]>1 && [[daysStr substringToIndex:1]isEqualToString:@","])
        {
            daysStr=[daysStr substringFromIndex:1];
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
        
        if([examDate isEqualToString:@""] || examDate==nil)
        {
//            NSDate *date = picker.date;
//            if(picker.date==nil)
//            {
//                date=[NSDate date];
//            }
//            NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
//            [dateFormat setDateFormat:@"dd/MM/yyyy"];
//            NSString *dateString = [dateFormat stringFromDate:date];
            examDate=@"";

        }
        addSubjectActivity=[[AddSubjectActivity alloc]init];
        [addSubjectActivity initService:@{
                                          @"ActivityID"  :[NSString stringWithFormat:@"%i",subjectID],
                                          @"ChildID"     :self.child.child_ID,
                                          @"ActivityDays":daysStr,
                                          @"Remarks"     :remarks,
                                          @"ExamDate"    :examDate
                                          }];
        [addSubjectActivity setDelegate:self];
        addSubjectActivity.serviceName=@"AddSubjectActivity";
        [self addLoaderView];
    }
}

-(void)customBtnTouched
{
    DeleteScheduledActivityByActChildID *deleteActivity=[[DeleteScheduledActivityByActChildID alloc]init];
    [deleteActivity initService:@{
                                  @"ActivityID" :[NSString stringWithFormat:@"%i",subjectID],
                                  @"ChildID"    :self.child.child_ID
                                  }];
    [deleteActivity setServiceName:PinWiDeleteActivity];
    [deleteActivity setDelegate:self];
    [self addLoaderView];
}


# pragma mark URL DELEGATES
-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
    //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self removeLoaderView];
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
{
     NSDictionary * resultDict;
     [self removeLoaderView];
    
     if ([connection.serviceName isEqualToString:PinWiDeleteActivity])
    {
        NSString *str=[NSString stringWithFormat:@"%@%@",@"GetSubjectActivitiesByChildID",self.child.child_ID];
        [[PC_DataManager sharedManager].serviceDictionary removeObjectForKey:str];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    else if([connection.serviceName isEqualToString:@"GetSchoolActivityDetails"])
    {
        resultDict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetSchoolActivityDetailsResponse" resultKey:@"GetSchoolActivityDetailsResult"];
        
        if(!resultDict)
        {
            return;
        }
        else{
            [self fillAndScheduleCompleteArray:[resultDict mutableCopy]];
        }
        
    }
    else
    {
    NSLog(@"result given: %@",dictionary);
    ActivityData *actData=[[ActivityData alloc]init];
    actData.activityId=[NSString stringWithFormat:@"%i",subjectID];
    actData.activityName=subject;
    actData.acitivityNotes=remarks;
    actData.childId=self.child.child_ID;
    actData.activityType=@"Subject";
    actData.parentId=[PC_DataManager sharedManager].parentObjectInstance.parentId;
    [[PC_DataManager sharedManager].activities addObject:actData];
    
        
        NSString *str=[NSString stringWithFormat:@"%@%@",@"GetSubjectActivitiesByChildID",self.child.child_ID];
        [[PC_DataManager sharedManager].serviceDictionary removeObjectForKey:str];
        
    [self.navigationController popToRootViewControllerAnimated:YES];
    
        

}
   
//    NSMutableArray *activityArr=[NSUserDefaults standardUserDefaults];
//    
//    NSString *str=[NSString stringWithFormat:@"Activities%@",self.childObjectSubActivity.child_ID];
//    
//    [[NSUserDefaults standardUserDefaults]setObject:subjectArray forKey:str];
    // [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


#pragma mark TableView Specific Function
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return completeActivityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSDictionary *data = [completeActivityArray objectAtIndex:indexPath.row];
    
    
    
    if([[data valueForKey:@"key"] isEqualToString:@"banner1"] )
    {
        return ScreenHeightFactor*30;
    }
    if([[data valueForKey:@"key"] isEqualToString:@"banner2"] )
    {
        return ScreenHeightFactor*30;
    }
    
    if([[data valueForKey:@"key"] isEqualToString:@"Days"] )
    {
        return ScreenHeightFactor*42;
    }
    
    if([[data valueForKey:@"key"] isEqualToString:@"navigation"] )
    {
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
    
    //    if([[data valueForKey:@"key"] isEqualToString:@"Button"] )
    //    {
    //        return 70;
    //    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  

    
    static NSString *Head1CellIdentifier    = @"Head1Cell";
    static NSString *Head2CellIdentifier    = @"Head2Cell";
    static NSString *DaysCellIdentifier     = @"DaysCell";
    static NSString *ExamDateCellIdentifier = @"ExamDateCell";
    static NSString *NoteCellIdentifier     = @"NoteCell";
    static NSString *ButtonCellIdentifier   = @"ButtonCell";
    //DetailPlanViewCell *cell = [[DetailPlanViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    TextAndDescTextCell *cell;
    NSDictionary *data = [completeActivityArray objectAtIndex:indexPath.row];
    if([[data objectForKey:@"Days"]isEqualToString:@"Week days"] && [[data objectForKey:@"Days"]isEqualToString:@"Weekend"])
    {
        [self validateCheckMark2];
    }
    
    if([[data valueForKey:@"key"] isEqualToString:@"banner1"])
    {
       
        cell =[tableView dequeueReusableCellWithIdentifier:Head1CellIdentifier];
        if(!cell)
        {
            cell =[[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Head1CellIdentifier];
        }

        cell.backgroundColor=activityHeading1Code;
//        cell.textLabel.textColor=activityHeading1FontCode;
        
        if(cell.textLabel.text.length==0)
        {
            [cell addText:[data objectForKey:@"value"] andDesc:@"" withTextColor:activityHeading1FontCode andDecsColor:cellTextColor andType:@"Banner"];
//            cell.textLabel.text= [data objectForKey:@"value"];
//            cell.textLabel.font=[UIFont fontWithName:RobotoRegular size:12*ScreenFactor];
            // cell.backgroundColor=logintextGreyColor;
        }
        
    }
    
    else  if([[data valueForKey:@"key"] isEqualToString:@"banner2"])
    {
        cell =[tableView dequeueReusableCellWithIdentifier:Head2CellIdentifier];
        if(!cell)
        {
            cell =[[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Head2CellIdentifier];
        }
         [cell addText:[data objectForKey:@"value"] andDesc:@"" withTextColor:activityHeading2FontCode andDecsColor:cellTextColor andType:@"Banner"];
        cell.backgroundColor=activityHeading2Code;
//        cell.textLabel.textColor=activityHeading2FontCode;
//        cell.textLabel.font=[UIFont fontWithName:RobotoLight size:11*ScreenFactor];
//        cell.textLabel.text= [data objectForKey:@"value"];
    }
    
    
    
    
    else if([[data valueForKey:@"key"] isEqualToString:@"Days"])
    {
        cell =[tableView dequeueReusableCellWithIdentifier:DaysCellIdentifier];
        if(!cell)
        {
            cell =[[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:DaysCellIdentifier];
        }
        [cell addText:[data objectForKey:@"value"] andDesc:@"" withTextColor:ActivityDaysColor andDecsColor:cellTextColor andType:@""];
//        cell.textLabel.text = [data objectForKey:@"value"];
        cell.arrowImageView.image=[UIImage imageNamed:isiPhoneiPad(@"selectedWeekDay.png")];
        if([[data objectForKey:@"Type"] isEqualToString:@"1"])
        {
            cell.arrowImageView.alpha=1;
            //[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        else
        {
             cell.arrowImageView.alpha=0;
             [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
//        cell.textLabel.textColor=ActivityDaysColor;
//        cell.backgroundColor =appBackgroundColor;
//         Kcell.textlabel1.font=[UIFont fontWithName:RobotoRegular size:9*ScreenFactor];
    }
    
    else if([[data valueForKey:@"key"] isEqualToString:@"navigation"])
    {
        cell =[tableView dequeueReusableCellWithIdentifier:ExamDateCellIdentifier];
        if(!cell)
        {
            cell =[[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ExamDateCellIdentifier];
        }
        if ([[data objectForKey:@"ExamDate"] isEqualToString:@""]) {
            [cell addText:[data objectForKey:@"value"] andDesc:@"" withTextColor:cellBlackColor_7 andDecsColor:placeHolderReg andType:@""];
        }
        else{
            [cell addText:[data objectForKey:@"value"] andDesc:[data objectForKey:[data objectForKey:@"value"]] withTextColor:cellBlackColor_7 andDecsColor:placeHolderReg andType:@""];
        }
        
//        cell.textLabel.text = [data objectForKey:@"value"];
         cell.textlabel1.font=[UIFont fontWithName:RobotoRegular size:9*ScreenFactor];
        cell.descTextLabel.font=[UIFont fontWithName:RobotoRegular size:9*ScreenFactor];
        
        cell.textlabel1.center=CGPointMake(cell.textlabel1.center.x+cellPadding*1.7, ScreenHeightFactor*25);
        cell.descTextLabel.center=CGPointMake(cell.descTextLabel.center.x-cellPadding*2,  ScreenHeightFactor*25);
        
        if(cell.detailTextLabel.text.length==0)
        {
//            cell.detailTextLabel.text= [data objectForKey:cell.textLabel.text];
//            cell.detailTextLabel.font=[UIFont fontWithName:RobotoRegular size:9*ScreenFactor];
//            cell.detailTextLabel.textColor=[[UIColor blackColor]colorWithAlphaComponent:0.4f];
        }
        if(!examImgView)
        {
        examImgView = [[UIImageView alloc] initWithFrame:CGRectMake(cellPadding, 0,20*ScreenWidthFactor, 20*ScreenWidthFactor)];
        examImgView.center=CGPointMake(examImgView.center.x, ScreenHeightFactor*25);
        examImgView.image = [UIImage imageNamed:isiPhoneiPad(@"exam.png")];
        //cell.imageView.image = imgView.image;
        [cell.contentView addSubview:examImgView];
        }
        cell.arrowImageView.alpha=1.0;
        cell.arrowImageView.image=[UIImage imageNamed:isiPhoneiPad(@"examDate.png")];
        cell.arrowImageView.frame=CGRectMake(cellPadding, 0,20*ScreenWidthFactor, 20*ScreenWidthFactor);
        cell.arrowImageView.center=CGPointMake(screenWidth-cell.arrowImageView.frame.size.width/2-cellPadding, ScreenHeightFactor*25);
       // UIImageView *imgView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:isiPhoneiPad(@"calendar.png")]];
       // cell.accessoryView=imgView1;
        cell.backgroundColor =appBackgroundColor;
        
        
        
        //        [cell.accessoryView setUserInteractionEnabled:YES];
        //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
        //        [tap setNumberOfTouchesRequired:1];
        //        [tap setNumberOfTapsRequired:1];
        //        [cell.accessoryView addGestureRecognizer:tap];
        
    }
    else if([[data valueForKey:@"key"] isEqualToString:@"textbox"])
    {
        cell =[tableView dequeueReusableCellWithIdentifier:NoteCellIdentifier];
        if(!cell)
        {
            cell =[[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NoteCellIdentifier];
        }
        if(!notes)
        {
            notes = [[UITextView alloc] initWithFrame:CGRectMake(cellPadding, 10*ScreenHeightFactor, screenWidth-2*cellPadding, 80*ScreenHeightFactor)];
            [notes setDelegate:self];
            [notes setFont:[UIFont fontWithName:RobotoLight size:9*ScreenFactor]];
            [notes setScrollEnabled:YES];
            [notes setUserInteractionEnabled:YES];
            notes.editable=YES;
            [notes setBackgroundColor:[UIColor clearColor]];
            [notes setTextColor:placeHolderReg];
            placeholderText = [data objectForKey:@"Remarks"];
            [notes setText:placeholderText];
            CGRect frame = notes.frame;
            frame.size.height = notes.contentSize.height;
            notes.frame = frame;
            [cell.contentView addSubview:notes];
            cell.backgroundColor =appBackgroundColor;
        }
      
    }
    else if([[data valueForKey:@"key"] isEqualToString:@"Button"])
    {
        cell =[tableView dequeueReusableCellWithIdentifier:ButtonCellIdentifier];
        if(!cell)
        {
            cell =[[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ButtonCellIdentifier];
        }

        [self addGotoMerchant:cell];
        customButton.frame=CGRectMake(cellPadding,2,screenWidth-2*cellPadding,screenHeight*.06-2);
        cell.backgroundColor =appBackgroundColor;
        customButton.center=CGPointMake(screenWidth/2, customButton.center.y);
//        customButton.frame=CGRectMake(20,100,200,40);
//        customButton.center=CGPointMake(screenWidth/2, customButton.center.y);
    }
    
    NSLog(@"data  %@", [completeActivityArray objectAtIndex:indexPath.row]);
    
    
    
    
    return cell;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableCell = [tableView cellForRowAtIndexPath:indexPath];
    rowNumber= [indexPath row];
    NSLog(@"%@",tableCell.textLabel.text);
    if(pickerView!=nil)
    {
        [pickerView removeFromSuperview];
    }
    NSMutableDictionary *changeDict=[completeActivityArray objectAtIndex:indexPath.row];
    
    if([tableCell.textlabel1.text isEqualToString: @"Exam Date"] )
    {
        [self drawDatePicker];
        [changeDict setObject:tableCell.descTextLabel.text forKey:@"Exam Date"];
    }
    
    else{
    if([tableCell.textlabel1.text isEqualToString: @"Sunday"] )
    {
        [self validCheckWithdict:changeDict];
         [self updateViewCheck:@"Sunday" andDay:@",1" withdict:changeDict];
    }
    
    if([tableCell.textlabel1.text isEqualToString: @"Monday"] )
    {
        [self validCheckWithdict:changeDict];
        [self updateViewCheck:@"Monday" andDay:@",2" withdict:changeDict];
        
    }
    
    if([tableCell.textlabel1.text isEqualToString: @"Tuesday"] )
    {
        [self validCheckWithdict:changeDict];
        [self updateViewCheck:@"Tuesday" andDay:@",3" withdict:changeDict];
        
    }
    
    if([tableCell.textlabel1.text isEqualToString: @"Wednesday"])
    {
        [self validCheckWithdict:changeDict];
         [self updateViewCheck:@"Wednesday" andDay:@",4" withdict:changeDict];
        
    }
    
    if([tableCell.textlabel1.text isEqualToString: @"Thursday"] )
    {
        [self validCheckWithdict:changeDict];
        [self updateViewCheck:@"Thursday" andDay:@",5" withdict:changeDict];
    }
    
    if([tableCell.textlabel1.text isEqualToString: @"Friday"])
    {
        [self validCheckWithdict:changeDict];
         [self updateViewCheck:@"Friday" andDay:@",6" withdict:changeDict];
    }
    
    if([tableCell.textlabel1.text isEqualToString: @"Saturday"])
    {
        [self validCheckWithdict:changeDict];
         [self updateViewCheck:@"Saturday" andDay:@",7" withdict:changeDict];
        
    }
    if([tableCell.textlabel1.text isEqualToString: @"Week days"])
    {
        [self validateCheckMark];
        [self updateViewCheck:@"Week days" andDay:@",2,3,4,5,6" withdict:changeDict];
        
    }
    if([tableCell.textlabel1.text isEqualToString: @"Weekend"])
    {
        [self validateCheckMark];
        [self updateViewCheck:@"Weekend" andDay:@",1,7" withdict:changeDict];
        
    }
    
    NSLog(@"DAYS STRING==== %@,",daysStr);
    
  //  [PC_DataManager sharedManager].repeatDaysString=[daysStr mutableCopy];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)updateViewCheck:(NSString*)str andDay:(NSString*)dayNo withdict:(NSMutableDictionary*)chngDict
{
//    if(!([[chngDict objectForKey:@"Days"]isEqualToString:@"Weekend"] || [[chngDict objectForKey:@"Days"]isEqualToString:@"Week days"]))
//    {
//    for (int section = 0, sectionCount = (int)detailTableView.numberOfSections; section < sectionCount; ++section)
//    {
//        int i=0;
//        
//        for(NSMutableDictionary *dict in completeActivityArray)
//        {
//            if([[dict objectForKey:@"Days"]isEqualToString:@"Weekend"]|| [[dict objectForKey:@"Days"]isEqualToString:@"Week days"])
//            {
//                UITableViewCell *cell = [detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:section]];
//                if(cell.accessoryType == UITableViewCellAccessoryCheckmark)
//                {
//                    [cell setAccessoryType:UITableViewCellAccessoryNone];
//                    daysStr=@"";
//                }
//            }
//            
//        }
//    }
//    }
    
 
    if([tableCell.textlabel1.text isEqualToString:str])
    {
        if ( tableCell.arrowImageView.alpha==0) {
           // [tableCell setAccessoryType:UITableViewCellAccessoryCheckmark];
            tableCell.arrowImageView.alpha=1;
            daysStr= [daysStr stringByAppendingString:dayNo];
            [chngDict setObject:@"1" forKey:@"Type"];
            
        } else {
             tableCell.arrowImageView.alpha=0;
            [tableCell setAccessoryType:UITableViewCellAccessoryNone];
            daysStr= [daysStr stringByReplacingOccurrencesOfString:dayNo withString:@""];
            [chngDict setObject:@"0" forKey:@"Type"];
        }
        
    }
  
}
-(void)validateCheckMark
{
    for (int section = 0, sectionCount = (int)detailTableView.numberOfSections; section < sectionCount; ++section)
    {
//        for (int row = 2, rowCount = (int)[detailTableView numberOfRowsInSection:section]; row < rowCount; ++row)
//        {
        int i=0;
            for(NSMutableDictionary *chngDict in completeActivityArray)
            {
                if([[chngDict objectForKey:@"key"]isEqualToString:@"Days"])
                {
                    TextAndDescTextCell *cell = [detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:section]];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                     cell.arrowImageView.alpha=0;
                    cell.accessoryView = nil;
                     daysStr=@"";
                }
                i++;
            }
//        }
    }
   
}

-(void)validateCheckMark2
{
    
    
    TextAndDescTextCell *cell = [detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]];
    if ( cell.arrowImageView.alpha==1)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.arrowImageView.alpha=0;
        cell.accessoryView = nil;
        daysStr=@"";
    }
    
    TextAndDescTextCell *cell1 = [detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:10 inSection:0]];
    if ( cell1.arrowImageView.alpha==1)
    {
        cell1.accessoryType = UITableViewCellAccessoryNone;
        cell1.accessoryView = nil;
        cell1.arrowImageView.alpha=0;
        daysStr=@"";
    }
}

-(void)validCheckWithdict:(NSMutableDictionary*)chngDict1
{
    for (int section = 0, sectionCount = (int)detailTableView.numberOfSections; section < sectionCount; ++section)
    {
        int i=0;
    for(NSMutableDictionary *chngDict in completeActivityArray)
    {
        if(([[chngDict objectForKey:@"value"]isEqualToString:@"Weekend"] || [[chngDict objectForKey:@"value"]isEqualToString:@"Week days"]) &&([[chngDict objectForKey:@"Type"]isEqualToString:@"1"]))
        {
            TextAndDescTextCell *cell = [detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:section]];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.accessoryView = nil;
            cell.arrowImageView.alpha=0;
            [chngDict setObject:@"0" forKey:@"Type"];
            daysStr=@"";
        }
        i++;
    }
    }
}


-(void)singleTapping:(UIGestureRecognizer *)recognizer
{
    [self drawDatePicker];
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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(-150, 0, kbSize.height, 0);
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
    if ([text isEqualToString:@"\n"]|| text.length>150) {
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




-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:placeholderText])
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
    picker.datePickerMode = UIDatePickerModeDate;
    picker.frame = CGRectMake(pickerView.frame.origin.x, pickerView.frame.size.height*.12, pickerView.frame.size.width, pickerView.frame.size.height);
    picker.minimumDate  = [NSDate date];
    
    [pickerView addSubview:picker];
    
    
}



-(void)ClickOnDone
{
    NSMutableDictionary *chandeDict=[completeActivityArray objectAtIndex:rowNumber];
    
    NSDate *date = picker.date;
    if(picker.date==nil)
    {
        date=[NSDate date];
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:date];
    tableCell.descTextLabel.text =dateString;
    examDate=dateString;
    [pickerView removeFromSuperview];
    [chandeDict setObject:tableCell.descTextLabel.text forKey:tableCell.textlabel1.text];
    [detailTableView reloadData];
}

-(void)ClickOnCancel
{
    
    [pickerView removeFromSuperview];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark ADD / REMOVE LOADER
-(void)addLoaderView
{
    loaderView=[[ShowActivityLoadingView alloc]initWithFrame:CGRectMake(0,yy , screenWidth, screenHeight-yy-self.tabBarController.tabBar.frame.size.height)];
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
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
