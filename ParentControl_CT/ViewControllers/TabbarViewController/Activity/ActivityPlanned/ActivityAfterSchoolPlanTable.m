//
//  SubjectCalenderTableView.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 14/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "ActivityAfterSchoolPlanTable.h"
#import "PC_DataManager.h"
#import "ShowActivityLoadingView.h"

@implementation ActivityAfterSchoolPlanTable
{
   
    //NSArray *afterSchoolArray;
    NSMutableArray *daysPlannedArray;
    
    NSMutableArray *completeActivityArray;
    NSMutableArray *subjectArray;
    
    NSMutableDictionary *dict;
    
    ShowActivityLoadingView *loaderView;
    UILabel *subjectLabel;
    //NSMutableArray *completeActivityArray;
    //int head2index;
}

-(id)initWithFrame:(CGRect)frame andChild:(ChildProfileObject*)childObject
{
    if(self =[super initWithFrame:frame])
    {
        
        [self setDelegate:self];
        [self setDataSource:self];
        self.backgroundColor=appBackgroundColor;
        self.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
         self.childObjectSubActivity=childObject;
        [[PC_DataManager sharedManager] getWidthHeight];
       // [self fillCompleteArray];
       // [self GetActivities];
       
        //[self reloadData];
        return self;
    }
    return nil;
}


-(void)GetActivities
{
    
    
    //dispatch_async(dispatch_get_global_queue(0,0), ^{
     NSString *str=[NSString stringWithFormat:@"%@%@",@"GetAfterSchoolActivitiesByChildID",self.childObjectSubActivity.child_ID];
    NSDictionary *dict1 = [[PC_DataManager sharedManager].serviceDictionary objectForKey:str];
    if(dict1)
    {
        [self loadTableDataWith:dict1];
        if(!completeActivityArray)
        {
            completeActivityArray=[[NSMutableArray alloc]init];
        }
        [completeActivityArray addObject:@{
                                           @"CellType"  :@"Blank",
                                           @"Desc"      :@"       Tap to schedule an activity"
                                           }];

        [self reloadData];
    }else{
    GetAfterSchoolActivitiesByChildID *getAfterSchoolActivitiesByChildID;
    getAfterSchoolActivitiesByChildID = [[GetAfterSchoolActivitiesByChildID alloc] init];
    [getAfterSchoolActivitiesByChildID initService:@{
                                                     @"ChildID":self.childObjectSubActivity.child_ID
                                                     }];
    [getAfterSchoolActivitiesByChildID setDelegate:self];
    getAfterSchoolActivitiesByChildID.serviceName=@"getAfterSchoolActivitiesByChildID";
    //[self addLoaderView];
}
    //NSString *childId = self.childObjectSubActivity.child_ID;
//    
//    dispatch_queue_t disconnectQueue2 = dispatch_queue_create("1111",NULL);
//    dispatch_async(disconnectQueue2,
//                   ^{
//                       GetAfterSchoolActivitiesByChildID *  getAfterSchoolActivitiesByChildID = [[GetAfterSchoolActivitiesByChildID alloc] init];
//                       [getAfterSchoolActivitiesByChildID initService:@{
//                                                                        @"ChildID":self.childObjectSubActivity.child_ID
//                                                                        }];
//                       
//                       dispatch_async(dispatch_get_main_queue(),
//                                      ^{
//                                          [getAfterSchoolActivitiesByChildID setDelegate:self];
//                                          getAfterSchoolActivitiesByChildID.serviceName=@"getAfterSchoolActivitiesByChildID";
//
//                                          NSLog(@"aafdafdfdsfdsfdsfdsfdsfdsfd");
//                                      });
//
//                   });
//
//    
    
//.......................................
//});
//    dispatch_async(dispatch_get_main_queue(), ^(void)
//                   {
//                       getAfterSchoolActivitiesByChildID = [[GetAfterSchoolActivitiesByChildID alloc] init];
//                       [getAfterSchoolActivitiesByChildID initService:@{
//                                                                    @"ChildID":self.childObjectSubActivity.child_ID
//                                                                    }];
//                       [getAfterSchoolActivitiesByChildID setDelegate:self];
//                       // getAfterSchoolActivitiesByChildID.serviceName=self;
//                   });
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
    NSLog(@"error is: %@",errorMessage);
    
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection{
    
    NSLog(@"dictionary  %@", dictionary);

  ///  NSDictionary *dict1=dictionary;
    NSDictionary * dict1 = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetAfterSchoolActivityByChildIDResponse" resultKey:@"GetAfterSchoolActivityByChildIDResult"];
     NSString *str=[NSString stringWithFormat:@"%@%@",@"GetAfterSchoolActivitiesByChildID",self.childObjectSubActivity.child_ID];
     [[PC_DataManager sharedManager].serviceDictionary setObject:dict1 forKey:str];
    [self loadTableDataWith:dict1];
    if(!completeActivityArray)
    {
        completeActivityArray=[[NSMutableArray alloc]init];
    }
    [completeActivityArray addObject:@{
                                       @"CellType"  :@"Blank",
                                       @"Desc"      :@"       Tap to schedule an activity"
                                       }];
    [self reloadData];
    [self removeLoaderView];
}

-(void)loadTableDataWith:(NSDictionary*)dict1{
            NSLog(@"dictionary  %@", dict1);
    if(completeActivityArray)
    {
        [completeActivityArray removeAllObjects];
        completeActivityArray=nil;
    }
    if(!dict1)
    {
        return;
    }
    if([dict1 isKindOfClass:[NSArray  class]])
    {
        
        NSArray *resultArray = (NSArray *)dict1;
        NSDictionary *resultDictionary = [resultArray firstObject];
        NSString *errorCode = [resultDictionary valueForKey:@"ErrorCode"];
        if([errorCode isEqualToString:@"0"])
        {
            return;
        }
    }

    if(subjectArray)
    {
        [subjectArray removeAllObjects];
        subjectArray=nil;
    }
    
    subjectArray = [[NSMutableArray alloc]init];
    
    
    for (NSDictionary *accessDict in dict1)
    {
        NSLog(@"access dict:%@",accessDict);
        
        NSDictionary *dtct4;
        BOOL flag= NO;
        for(NSDictionary * dict3 in subjectArray){
            NSString * actId1= [NSString stringWithFormat:@"%@",[dict3 objectForKey:@"ActivityID"]] ;
            NSString * actId2= [NSString stringWithFormat:@"%@",[accessDict objectForKey:@"ActivityID"]] ;
            NSLog(@"id  %@   %@", actId1, actId2);
            if([actId1 isEqualToString:actId2]){
                NSString *str =[NSString stringWithFormat:@"%@",[dict3 objectForKey:@"DayID"]];
                str = [str stringByAppendingString:[NSString stringWithFormat:@",%@",[NSString stringWithFormat:@"%@",[accessDict objectForKey:@"DayID"]]]];
                dtct4 = @{
                          @"ActivityID" :[NSString stringWithFormat:@"%@",[dict3 objectForKey:@"ActivityID"]],
                          @"ActivityName" :[NSString stringWithFormat:@"%@",[dict3 objectForKey:@"ActivityName"]],
                          @"EndTime": [NSString stringWithFormat:@"%@",[dict3 objectForKey:@"EndTime"]],
                          @"ActivityID" :[NSString stringWithFormat:@"%@",[dict3 objectForKey:@"ActivityID"]],
                          @"Enddate": [NSString stringWithFormat:@"%@",[dict3 objectForKey:@"Enddate"]],
                          @"ExamDate" :[NSString stringWithFormat:@"%@",[dict3 objectForKey:@"ExamDate"]],
                          @"IsPrivate": [NSString stringWithFormat:@"%@",[dict3 objectForKey:@"IsPrivate"]],
                          @"IsSpecial" :[NSString stringWithFormat:@"%@",[dict3 objectForKey:@"IsSpecial"]],
                          @"IsVerified" :[NSString stringWithFormat:@"%@",[dict3 objectForKey:@"IsVerified"]],
                          @"Remarks": [NSString stringWithFormat:@"%@",[dict3 objectForKey:@"Remarks"]],
                          @"SpecialDate" :[NSString stringWithFormat:@"%@",[dict3 objectForKey:@"SpecialDate"]],
                          @"StartDate" :[NSString stringWithFormat:@"%@",[dict3 objectForKey:@"StartDate"]],
                          @"StartTime": [NSString stringWithFormat:@"%@",[dict3 objectForKey:@"StartTime"]],
                          @"DayID": str
                          
                          };
                [subjectArray removeObject:dict3];
                [subjectArray addObject:dtct4];
                flag= YES;
                break;
            }
        }
        if(!flag){
            [subjectArray addObject:accessDict];
        }
        
        
        
        // [self fillCompleteArray];
    }
    
    
    // [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self fillCompleteArray];
    
    [self reloadData];
    //[accessTable reloadData];
    
}




-(void)fillCompleteArray
{
    if(completeActivityArray)
    {
        [completeActivityArray removeAllObjects];
        completeActivityArray=nil;
    }
    
    completeActivityArray=[[NSMutableArray alloc]init];
    //completeActivityArray=[[PC_DataManager sharedManager]makeDaysOneSubject:subjectArray];
      for(NSDictionary *subject in subjectArray)
     {
         NSMutableArray * newArr= [[NSMutableArray alloc]init];
         NSString *str=[NSString stringWithFormat:@"%@",[subject objectForKey:@"DayID"]];
         // str=@"3,5,6";
         if(str){
             NSArray *days=[str componentsSeparatedByString:@","];
             NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:days];
             days = [orderedSet array];
             
             days = [days sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                 return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
             }];
             
             int cnt=0;
             for(NSString * str1 in days)
             {
                 int val = [str1 intValue];
                 val = val - cnt;
                 //cnt=0;
                 for(int i=1; i<val;i++){
                     [newArr addObject:@"0"];
                     cnt++;
                 }
                 [newArr addObject:@"1"];
                 cnt++;
             }
             NSLog(@"newArr  %@", newArr);
             if(newArr.count<7){
                 for(int val=(int)newArr.count; val<7; val++){
                     [newArr addObject:@"0"];
                 }
             }
         }
     
     
     [completeActivityArray addObject:@{
                                        @"CellType":@"Activity",
                                        @"ActivityID" :[NSString stringWithFormat:@"%@",[subject objectForKey:@"ActivityID"]],
                                        @"ActivityName" :[NSString stringWithFormat:@"%@",[subject objectForKey:@"ActivityName"]],
                                        @"EndTime": [NSString stringWithFormat:@"%@",[subject objectForKey:@"EndTime"]],
                                        @"Enddate": [NSString stringWithFormat:@"%@",[subject objectForKey:@"Enddate"]],
                                        @"ExamDate" :[NSString stringWithFormat:@"%@",[subject objectForKey:@"ExamDate"]],
                                        @"IsPrivate": [NSString stringWithFormat:@"%@",[subject objectForKey:@"IsPrivate"]],
                                        @"IsSpecial" :[NSString stringWithFormat:@"%@",[subject objectForKey:@"IsSpecial"]],
                                        @"IsVerified" :[NSString stringWithFormat:@"%@",[subject objectForKey:@"IsVerified"]],
                                        @"Remarks": [NSString stringWithFormat:@"%@",[subject objectForKey:@"Remarks"]],
                                        @"SpecialDate" :[NSString stringWithFormat:@"%@",[subject objectForKey:@"SpecialDate"]],
                                        @"StartDate" :[NSString stringWithFormat:@"%@",[subject objectForKey:@"StartDate"]],
                                        @"StartTime": [NSString stringWithFormat:@"%@",[subject objectForKey:@"StartTime"]],
                                        @"repeat"    : newArr
     }];
     }
    [self reloadData];
    
}



#pragma mark TableView Specific Function
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"instantiate cell count %lu",(unsigned long)afterSchoolArray.count);
    return completeActivityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"row index          = %li",(long)indexPath.row);
   // NSLog(@"subjectArray count = %li",(unsigned long)afterSchoolArray.count);
    
   
       // return screenHeight*.10;
    
     NSMutableDictionary *repeatDict=[completeActivityArray objectAtIndex:indexPath.row];
    if([[repeatDict objectForKey:@"CellType"]isEqualToString:@"Activity"])
    {
        if(screenWidth>700)
        {
        return ScreenHeightFactor*83;
        }
        return ScreenHeightFactor*73;
    }
    else
    {
         return ScreenHeightFactor*50;
    }
    
//    if(indexPath.row==0 || indexPath.row==1)
//    {
//        return screenHeight*.05;
//    }
//    else
//    {
//        return screenHeight*.15;
//    }
//    else
//    {
//        return screenHeight*.13;
//    }
   // return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"instantiate caleder school cell");
   
    NSMutableDictionary *repeatDict=[completeActivityArray objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"ActivityAfterSchoolPlanCell";
    static NSString *CellIdentifier1 = @"ActivityAfterSchoolPlanCell1";
    
    UITableViewCell *cell;
   
    
    NSLog(@"activity id: %@",[repeatDict objectForKey:@"ActivityID"]);
    if([[repeatDict objectForKey:@"CellType"]isEqualToString:@"Activity"])
    {
        ActivityAfterSchoolPlanCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                             ];
        if(!cell1)
        {
            cell1 = [[ActivityAfterSchoolPlanCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            
        }
        [cell1 addActivity:repeatDict];
        //[cell1 setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell=cell1;
    }
    else if([[repeatDict objectForKey:@"CellType"]isEqualToString:@"Blank"])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier1];
        }
        cell.textLabel.text = [repeatDict objectForKey:@"Desc"];
        cell.textLabel.font=[UIFont fontWithName:RobotoRegular size:10*ScreenFactor];
        cell.textLabel.textColor=textBlueColor;
        
        if(!subjectLabel)
        {
            subjectLabel=[[UILabel alloc]init];
            UIButton *imgView = [UIButton buttonWithType:UIButtonTypeCustom];
            imgView.tintColor=textBlueColor;
            [imgView setBackgroundImage:[UIImage imageNamed:isiPhoneiPad(@"addActivity.png")] forState:UIControlStateNormal];
            if(screenWidth>700)
            {
                imgView.frame= CGRectMake(cellPadding, 14*ScreenHeightFactor,20*ScreenHeightFactor, 20*ScreenHeightFactor);
            }
            else
            {
                imgView.frame= CGRectMake(cellPadding, 15*ScreenHeightFactor,20*ScreenHeightFactor, 20*ScreenHeightFactor);
            }
            [imgView addTarget:self action:@selector(gotoNewActvityToSchedule) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:imgView];
        }
        
//        if(!subjectLabel)
//        {
//            subjectLabel=[[UILabel alloc]init];
//            subjectLabel.font=[UIFont fontWithName:RobotoRegular size:15.0f];
//            subjectLabel.text=[repeatDict objectForKey:@"Desc"];
//            subjectLabel.frame=CGRectMake(screenWidth*.05,screenHeight*.01,screenWidth*.9,screenHeight*.08);
//            subjectLabel.center=CGPointMake(screenWidth*.5,subjectLabel.center.y);
//            subjectLabel.textAlignment=NSTextAlignmentCenter;
//            subjectLabel.textColor=[UIColor lightGrayColor];
//            [cell.contentView addSubview:subjectLabel];
//            cell.backgroundColor=appBackgroundColor;
//        }
    }
//    [cell addActivity:[repeatDict objectForKey:@"ActivityName"] withDaysArray:daysPlannedArray startOn:[repeatDict objectForKey:@"StartTime"] endOn:[repeatDict objectForKey:@"EndTime"] repaetFor:[repeatDict objectForKey:@"RepeatMode"] withScreenWd:screenWidth screenHt:screenHeight];

     cell.backgroundColor=appBackgroundColor;
    repeatDict=nil;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [[self.rootViewController navigationItem] setBackBarButtonItem:newBackButton];
    self.rootViewController.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
     NSMutableDictionary *repeatDict=[completeActivityArray objectAtIndex:indexPath.row];
    if([[repeatDict objectForKey:@"CellType"]isEqualToString:@"Activity"])
    {
    ActivityDetails *details=[[ActivityDetails alloc]init];
    details.afterSchoolChild=self.childObjectSubActivity;
    details.afterSchoolDataDict=[[NSMutableDictionary alloc]init];
    details.parentClass=ParentIsAfetrSchoolPlan;
    details.afterSchoolDataDict=[completeActivityArray objectAtIndex:indexPath.row];
    
    [self.rootViewController.navigationController pushViewController:details animated:YES];
    }
    else if([[repeatDict objectForKey:@"CellType"]isEqualToString:@"Blank"])
    {
        [self gotoNewActvityToSchedule];
           }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)])
    {
        tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
    
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
}

-(void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    
}

-(void)gotoNewActvityToSchedule
{
    AfterSchoolActivities *afterSchoolactivities=[[AfterSchoolActivities alloc]init];
    afterSchoolactivities.afterChild=self.childObjectSubActivity;
    [self.rootViewController.navigationController pushViewController:afterSchoolactivities animated:YES];

}

#pragma mark ADD / REMOVE LOADER
-(void)addLoaderView
{
    loaderView=[[ShowActivityLoadingView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [loaderView showLoaderViewWithText:@"Hold On..."];
    [self addSubview:loaderView];
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