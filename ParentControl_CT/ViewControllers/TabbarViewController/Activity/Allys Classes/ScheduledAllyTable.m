//
//  SubjectCalenderTableView.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 14/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "ScheduledAllyTable.h"
#import "PC_DataManager.h"
#import "ShowActivityLoadingView.h"
#import "ScheduledAllyCell.h"
#import "HeaderView.h"
#import "RedLabelView.h"
#import "GetListOfAllysOnActivityByChildIDAct.h"
#import "ScheduledAllyCell.h"
#import "TextAndDescTextCell.h"
#import "InformAllyDetailViewController.h"

@interface ScheduledAllyTable() <HeaderViewProtocol,UrlConnectionDelegate, InformAllyDetailProtocol>

@end

@implementation ScheduledAllyTable
{
    UITableView *allyTable;
    NSMutableArray *completeActivityArray;
    
    RedLabelView *label;
    ShowActivityLoadingView *loaderView;
    HeaderView *headerView;
    int yy;
    
    UILabel *subjectLabel;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor=appBackgroundColor;
    yy=0;
    [[PC_DataManager sharedManager] getWidthHeight];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self drawHeaderView];
    [self childNameLabel];
    // [self addButton];
    [self drawTableListView];
    [self callAllyList];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // [completeActivityArray removeAllObjects];
    //[[PC_DataManager sharedManager].calTableActivitybyDateArray removeAllObjects];
    [self.tabBarController.tabBar setSelectedImageTintColor:[UIColor orangeColor]];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    // [allyTable reloadData];
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
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, yy, ScreenWidthFactor*320, ScreenHeightFactor*15)withChildStr:self.childObjectSubActivity.nick_Name];
            label.center=CGPointMake(screenWidth/2,yy+label.frame.size.height/2+5*ScreenHeightFactor);
        }
        else
        {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, yy, ScreenWidthFactor*320, ScreenHeightFactor*12)withChildStr:self.childObjectSubActivity.nick_Name];
            label.center=CGPointMake(screenWidth/2,yy+label.frame.size.height/2);
        }
        
        [self.view addSubview:label];
        yy+=label.frame.size.height+15*ScreenHeightFactor;
    }
}


#pragma mark draw Table
-(void)drawTableListView
{
    if(!allyTable)
    {
        allyTable = [[UITableView alloc]initWithFrame:CGRectMake(0,yy, screenWidth, self.view.frame.size.height-yy)];
        allyTable.backgroundColor=appBackgroundColor;
        //  allyTable.frame =;
        allyTable .delegate=self;
        allyTable.dataSource=self;
        allyTable.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:allyTable];
        
    }
}

-(void)callAllyList
{
    
    
    //dispatch_async(dispatch_get_global_queue(0,0), ^{
    NSString *str=[NSString stringWithFormat:@"%@-%@-%@",PinWiGetListOfScheduledAllys,self.childObjectSubActivity.child_ID,[self.activityDict objectForKey:@"activityID"]];
    NSDictionary *dict1 = [[PC_DataManager sharedManager].serviceDictionary objectForKey:str];
    if(dict1)
    {
        
        [self loadTableDataWith:dict1];
    
        [self addHeadsofTable];
        [completeActivityArray addObject:@{
                                           @"CellType"  :@"Blank",
                                           @"Desc"      :@"       Add New Ally Notification"
                                           }];
        
        [allyTable reloadData];
    }else{
        GetListOfAllysOnActivityByChildIDAct *getInfo=[[GetListOfAllysOnActivityByChildIDAct alloc]init];
        [getInfo initService:@{
                               @"ChildID":self.childObjectSubActivity.child_ID,
                               @"ActivityID":[self.activityDict objectForKey:@"activityID"]
                               }];
        getInfo.serviceName=PinWiGetListOfScheduledAllys;
        getInfo.delegate=self;
        [self addLoaderView];
    }
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection
{
    NSLog(@"error is: %@",errorMessage);
    [self removeLoaderView];
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection{
    
    NSLog(@"dictionary  %@", dictionary);
    [self removeLoaderView];
    if([connection.serviceName isEqualToString:PinWiGetListOfScheduledAllys])
    {
        NSDictionary * dict1 = [connection getJsonWithXmlDictionary:dictionary ResponseKey:PinWiGetListOfScheduledAllysResponse resultKey:PinWiGetListOfScheduledAllysResult];
        if(dict1)
        {
            NSString *str=[NSString stringWithFormat:@"%@-%@-%@",PinWiGetListOfScheduledAllys,self.childObjectSubActivity.child_ID,[self.activityDict objectForKey:@"activityID"]];
            [[PC_DataManager sharedManager].serviceDictionary setObject:dict1 forKey:str];
            [self loadTableDataWith:dict1];
        }
        [self addHeadsofTable];
        [completeActivityArray addObject:@{
                                           @"CellType"  :@"Blank",
                                           @"Desc"      :@"       Add New Ally Notification"
                                           }];
    }
    [allyTable reloadData];
    // [self removeLoaderView];
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
    
    [self addHeadsofTable];
    for(NSDictionary *allyDict in dict1)
    {
        AllyProfileObject *allyObj=[[AllyProfileObject alloc]init];
        allyObj.firstName       =[allyDict objectForKey:@"AllyName"];
        allyObj.activityDate    =[allyDict objectForKey:@"Date"];
        allyObj.drop            =[allyDict objectForKey:@"Drop"];
        allyObj.pickUp          =[allyDict objectForKey:@"PickUp"];
        allyObj.remarks         =[allyDict objectForKey:@"SpeicalInstructions"];
        allyObj.activityTime    =[allyDict objectForKey:@"Time"];
        
        [completeActivityArray addObject:@{
                                           @"CellType"  :@"Activity",
                                           @"Desc"      :allyObj
                                           }];
    }
    
    [allyTable reloadData];
    
}
-(void)addHeadsofTable
{
    if(!completeActivityArray)
    {
        completeActivityArray=[[NSMutableArray alloc]init];
        
        [completeActivityArray addObject:@{
                                           @"CellType"  :@"Banner1",
                                           @"Desc"      :[self.activityDict objectForKey:@"activityName"]
                                           }];
        [completeActivityArray addObject:@{
                                           @"CellType"  :@"Banner2",
                                           @"Desc"      :@"INFORM ALLY"
                                           }];
    }
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
            return ScreenHeightFactor*73;
        }
        return ScreenHeightFactor*63;
    }
    else  if([[repeatDict objectForKey:@"CellType"]isEqualToString:@"Banner1"]|| [[repeatDict objectForKey:@"CellType"]isEqualToString:@"Banner2"])
    {
        return ScreenHeightFactor*30;
    }
    else
    {
        return ScreenHeightFactor*50;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"instantiate caleder school cell");
    
    NSMutableDictionary *repeatDict=[completeActivityArray objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"ScheduleAllyPlanCell";
    static NSString *CellIdentifier1 = @"ScheduleAllyPlanCell1";
    static NSString *CellIdentifier2 = @"ScheduleAllyPlanCell2";
    static NSString *CellIdentifier3 = @"ScheduleAllyPlanCell3";
    
    UITableViewCell *cell;
    
    
    NSLog(@"activity id: %@",[repeatDict objectForKey:@"ActivityID"]);
    
    if([[repeatDict objectForKey:@"CellType"]isEqualToString:@"Banner1"])
    {
        TextAndDescTextCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2
                                      ];
        if(!cell1)
        {
            cell1 = [[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier2];
            
        }
        [cell1 addText:[repeatDict objectForKey:@"Desc"] andDesc:@"" withTextColor:activityHeading1FontCode andDecsColor:activityHeading1Code andType:@"Banner"];
        cell1.backgroundColor=activityHeading1Code;
        //[cell1 setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell=cell1;
    }
    
    if([[repeatDict objectForKey:@"CellType"]isEqualToString:@"Banner2"])
    {
        TextAndDescTextCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3
                                      ];
        if(!cell1)
        {
            cell1 = [[TextAndDescTextCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier3];
            
        }
        [cell1 addText:[repeatDict objectForKey:@"Desc"] andDesc:@"" withTextColor:activityHeading2FontCode andDecsColor:activityHeading2Code andType:@"Banner"];
        cell1.backgroundColor=activityHeading2Code;
        //[cell1 setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell=cell1;
    }
    
    
    if([[repeatDict objectForKey:@"CellType"]isEqualToString:@"Activity"])
    {
        ScheduledAllyCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                    ];
        if(!cell1)
        {
            cell1 = [[ScheduledAllyCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            
        }
        [cell1 listingOfAlly:[repeatDict objectForKey:@"Desc"]];
        //[cell1 setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell=cell1;
        cell.backgroundColor=appBackgroundColor;
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
            [imgView addTarget:self action:@selector(newAllyNotifyTouched) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:imgView];
        }
        cell.backgroundColor=appBackgroundColor;
    }
    //    [cell addActivity:[repeatDict objectForKey:@"ActivityName"] withDaysArray:daysPlannedArray startOn:[repeatDict objectForKey:@"StartTime"] endOn:[repeatDict objectForKey:@"EndTime"] repaetFor:[repeatDict objectForKey:@"RepeatMode"] withScreenWd:screenWidth screenHt:screenHeight];
    
    
    repeatDict=nil;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableDictionary *repeatDict=[completeActivityArray objectAtIndex:indexPath.row];
    if([[repeatDict objectForKey:@"CellType"]isEqualToString:@"Activity"])
    {
        [self goToAllyDetailedScreen:YES andAllyInfo:[repeatDict objectForKey:@"Desc"]];
    }
    else if([[repeatDict objectForKey:@"CellType"]isEqualToString:@"Blank"])
    {
        [self newAllyNotifyTouched];
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

-(void)newAllyNotifyTouched
{
     [self goToAllyDetailedScreen:NO andAllyInfo:nil];
}

#pragma call Ally Screen to fill
-(void)goToAllyDetailedScreen:(BOOL)parent andAllyInfo:(AllyProfileObject*)allyInfoObj
{
    InformAllyDetailViewController *informdet=[[InformAllyDetailViewController alloc]init];
    informdet.informAllyDetailDelegate=self;
    informdet.detailAlly=[[AllyProfileObject alloc]init];
    informdet.child=self.childObjectSubActivity;
    if(parent)
    {
        informdet.parentClass=ParentIsAfetrSchoolPlan;
        informdet.detailAlly=allyInfoObj;
    }
    informdet.activityDict=self.activityDict;
    [informdet setTabBarCtlr:self.tabBarCtrl];
    [self.navigationController pushViewController:informdet animated:YES];
}

-(void)sendAllyObject:(AllyProfileObject *)allyObj
{
    
    NSLog(@"detal ally object in delegate: %@\n%@\n%@\n%@\n%@\n%@",allyObj.drop,
          allyObj.pickUp,
          allyObj.activityTime,
          allyObj.activityDate,
          allyObj.remarks,
          allyObj.notifyMode);
    
    //    AllyProfileObject *allyObj=[[AllyProfileObject alloc]init];
    //    allyObj.firstName       =allyObj.firstName;
    //    allyObj.activityDate    =allyObj.activityDate;
    //    allyObj.drop            =allyObj.drop;
    //    allyObj.pickUp          =allyObj.pickUp;
    //    allyObj.remarks         =allyObj.remarks;
    //    allyObj.activityTime    =allyObj.activityTime;
    //    allyObj.notifyMode      =allyObj.notifyMode;
    
    
    [completeActivityArray insertObject:@{
                                          @"CellType"  :@"Activity",
                                          @"Desc"      :allyObj
                                          }
                                atIndex:completeActivityArray.count-1];
    [allyTable reloadData];
}

#pragma mark ADD / REMOVE LOADER
-(void)addLoaderView
{
    loaderView=[[ShowActivityLoadingView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [loaderView showLoaderViewWithText:@"Hold On.."];
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