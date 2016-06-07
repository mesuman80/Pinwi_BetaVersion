//
//  SubjectCalenderTableView.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 14/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "ActivitySubjectPlanTable.h"
#import "PC_DataManager.h"
#import "ShowActivityLoadingView.h"

@implementation ActivitySubjectPlanTable
{
    NSMutableArray *subjectArray;
    NSArray *afterSchoolArray;
    NSMutableArray *daysPlannedArray;
    
    NSMutableArray *completeActivityArray;
    
    NSMutableDictionary *dict;
    GetSubjectActivitiesByChildID *getSubjectActivitiesByChildID;
    ShowActivityLoadingView *loaderView;
    UILabel *subjectLabel;
}

-(id)initWithFrame:(CGRect)frame andChild:(ChildProfileObject*)childObject
{
    if(self =[super initWithFrame:frame])
    {
        
        [self setDelegate:self];
        [self setDataSource:self];
        self.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
        self.backgroundColor=appBackgroundColor;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        self.childObjectSubActivity=childObject;
        
        subjectArray=[[NSMutableArray alloc]init];
        //completeActivityArray=[[NSMutableArray alloc] init];
        [[PC_DataManager sharedManager] getWidthHeight];

        return self;
    }
    return nil;
}


-(void)GetActivities
{
    NSLog(@"Chld id = %@",_childObjectSubActivity.child_ID );
    
     NSString *str=[NSString stringWithFormat:@"%@%@",@"GetSubjectActivitiesByChildID",self.childObjectSubActivity.child_ID];
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
    }
    else{

    dispatch_async(dispatch_get_main_queue(), ^(void)
    {
        getSubjectActivitiesByChildID = [[GetSubjectActivitiesByChildID alloc] init];
        [getSubjectActivitiesByChildID initService:@{
                                                     @"ChildID":self.childObjectSubActivity.child_ID
                                                     }];
        [getSubjectActivitiesByChildID setDelegate:self];
        getSubjectActivitiesByChildID.serviceName=@"GetSubjectActivitiesByChildID";
    });
        
    }
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
    NSLog(@"error is: %@",errorMessage);
   
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection{
    
    NSLog(@"dictionary  %@", dictionary);
    
    NSDictionary * dict1 = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetSubjectActivitiesByChildIDResponse" resultKey:@"GetSubjectActivitiesByChildIDResult"];

    NSString *str=[NSString stringWithFormat:@"%@%@",@"GetSubjectActivitiesByChildID",self.childObjectSubActivity.child_ID];
    [[PC_DataManager sharedManager].serviceDictionary setObject:dict1 forKey:str];
    
   // NSLog(@"[PC_DataManager sharedManager].serviceDictionary  %@", [PC_DataManager sharedManager].serviceDictionary);
    
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
                NSString *str =[NSString stringWithFormat:@"%@",[dict3 objectForKey:@"dayid"]];
                str = [str stringByAppendingString:[NSString stringWithFormat:@",%@",[NSString stringWithFormat:@"%@",[accessDict objectForKey:@"dayid"]]]];
                dtct4 = @{
                            @"ActivityID" :[NSString stringWithFormat:@"%@",[dict3 objectForKey:@"ActivityID"]],
                            @"Name": [NSString stringWithFormat:@"%@",[dict3 objectForKey:@"Name"]],
                            @"IsVerified" :[NSString stringWithFormat:@"%@",[dict3 objectForKey:@"IsVerified"]],
                            @"dayid": str
                            
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
    completeActivityArray=[[PC_DataManager sharedManager]makeDaysOneSubject:subjectArray];
    
}


#pragma mark TableView Specific Function
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"instantiate cell count %lu",(unsigned long)subjectArray.count);
    return completeActivityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"row index          = %li",(long)indexPath.row);
    NSLog(@"subjectArray count = %li",subjectArray.count);
    
    NSMutableDictionary *repeatDict=[completeActivityArray objectAtIndex:indexPath.row];
        
    
//    if(indexPath.row==0 || indexPath.row==1)
//    {
//        return screenHeight*.05;
//    }
//    else
//    {
    if([[repeatDict objectForKey:@"CellType"]isEqualToString:@"Activity"])
    {
        if(screenWidth>700)
        {
            return ScreenHeightFactor*83;
        }
        return ScreenHeightFactor*73;
    }
    else {
        return ScreenHeightFactor*50;

    }
//    }
//    else
//    {
//        return screenHeight*.13;
//    }
//    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"instantiate caleder school cell");
    if(daysPlannedArray)
    {
        [daysPlannedArray removeAllObjects];
        daysPlannedArray = nil;
    }
    
    
    NSMutableDictionary *repeatDict=[completeActivityArray objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"ActivityTableCell";
    static NSString *CellIdentifier1 = @"ActivityTableCell1";
    
   
    UITableViewCell *cell;
    if([[repeatDict objectForKey:@"CellType"]isEqualToString:@"Activity"])
    {
       ActivityTableCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell1 == nil)
        {
            cell1 = [[ActivityTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
 [cell1 addActivity:repeatDict];
//        [cell1 addSubject:[repeatDict objectForKey:@"CellTitle"] withDaysArray:[repeatDict objectForKey:@"repeat"] withScreenWd:screenWidth screenHt:screenHeight];
        //[cell1 setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
       
        cell=cell1;
    }
    else  if([[repeatDict objectForKey:@"CellType"]isEqualToString:@"Blank"])
    {
       cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier1];
        }
        
        cell.textLabel.text = [repeatDict objectForKey:@"Desc"];
        cell.textLabel.font=[UIFont fontWithName:RobotoRegular size:10*ScreenFactor];
        cell.textLabel.textColor=radiobuttonSelectionColor;
        
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
cell.backgroundColor=appBackgroundColor;

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

        //[self scheduleActivity:repeatDict];
        
        
    }
   //  [self becomeFirstResponder];
    repeatDict=nil;
    return cell;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
       NSMutableDictionary *repeatDict=[completeActivityArray objectAtIndex:indexPath.row];
    NSLog(@"ROW === %i",(int)indexPath.row);
    NSLog(@"completeActivityArray objectAtIndex:indexPath.row == %@",[completeActivityArray objectAtIndex:indexPath.row]);
    
    
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [[self.rootViewController navigationItem] setBackBarButtonItem:newBackButton];
    self.rootViewController.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    
    
    if([[repeatDict objectForKey:@"CellType"]isEqualToString:@"Activity"])
    {
    ActivitySubjectDetailCal *subDetail=[[ActivitySubjectDetailCal alloc]init];
    subDetail.child=self.childObjectSubActivity;
    subDetail.subjectDataDict=[completeActivityArray objectAtIndex:(int)indexPath.row];
    [self.rootViewController.navigationController pushViewController:subDetail animated:YES];
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

-(void)scheduleActivity:(NSMutableDictionary*)statusDict
{
    if(!subjectLabel)
    {
    subjectLabel.font=[UIFont fontWithName:RobotoRegular size:15.0f];
    subjectLabel.text=[statusDict objectForKey:@"Desc"];
    subjectLabel.frame=CGRectMake(screenWidth*.05,screenHeight*.01,screenWidth*.9,screenHeight*.08);
    subjectLabel.center=CGPointMake(screenWidth*.5,subjectLabel.center.y);
    subjectLabel.textAlignment=NSTextAlignmentCenter;
    subjectLabel.textColor=[UIColor lightGrayColor];
    }
}
-(void)gotoNewActvityToSchedule
{
    SubjectCalenderList *subjectCalenderList=[[SubjectCalenderList alloc]init];
    subjectCalenderList.child=self.childObjectSubActivity;
    [self.rootViewController.navigationController pushViewController:subjectCalenderList animated:YES];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


@end