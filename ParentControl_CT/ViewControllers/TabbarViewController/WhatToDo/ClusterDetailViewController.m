//
//  ClusterDetailViewController.m
//  ParentControl_CT
//
//  Created by Sakshi on 18/04/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "ClusterDetailViewController.h"
#import "GetWishListsByChildID.h"
#import "StripView.h"
#import "GetListOfActivitiesOnRecommendedByClusterID.h"
#import "GetListOfActivitiesOnNetworkByClusterID.h"
#import "WhoIsDoingThisViewController.h"
#import "WishListTableViewCell.h"
#import "WishListViewController.h"
#import "ActivityDetails.h"

#import "SearchActivitiesByChildID.h"
#import "SearchActivitiesOnNetworkByClusterID.h"

@interface ClusterDetailViewController ()<HeaderViewProtocol,UIScrollViewDelegate, UISearchBarDelegate, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@end

@implementation ClusterDetailViewController
{
    UILabel *noSearchResultLabel;
    UIImageView *noActivityImageView;
    
    NSInteger pageIndex;
    NSInteger lastIndex;
    NSInteger totalCount;
    NSMutableArray *totalArray;
    BOOL isScrolling;
}

@synthesize childObject,label,connectionSearchController,filterString,activitiListData,activityName;
@synthesize searchBar,searchResult,nameToBeSearch,headerView,cellHeight,loaderView,segmentControlIndex;
@synthesize scrollView,yy,yCord,xCord,scrollXX,initialY,reduceYY,ChildNameArray;
@synthesize tabBarCtrl,childName,stripViewTitle,clusterId,clusterDetails,table,childID,activityID;

- (void)viewDidLoad {
    [super viewDidLoad];
    yy=0;
    [self.view setBackgroundColor:appBackgroundColor];
 
    if (screenWidth>700) {
        cellHeight  =  120;
    }
    else{
        if (screenWidth>320) {
            cellHeight = 70;
        }else{
        cellHeight = 60;
        }
    }
    activitiListData = [[NSMutableArray alloc] init];
    totalArray = [[NSMutableArray alloc]init];
    
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated{
    reduceYY =0;
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    pageIndex = 0;
    [totalArray removeAllObjects];
    totalCount = 0;
    isScrolling = NO;
    [self drawUiWithHead];
    [self drawHeaderView];
    [self loadData];
    
    [self.tabBarCtrl.tabBar setSelectedImageTintColor:[UIColor purpleColor]];
}

-(void)loadData{
    [self childNameLabel];
    [self addStripView:stripViewTitle clusterDetail:clusterDetails];
    [self addSearchController];
    [self getDataFromWebservice];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark drawUI
-(void)drawUiWithHead
{
    
    if(!scrollView)
    {
        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,yy, self.view.frame.size.width, self.view.frame.size.height-yy)];
        [scrollView setPagingEnabled:NO];
        [scrollView setScrollEnabled:NO];
        [scrollView setBackgroundColor:appBackgroundColor];
        [self.view addSubview:scrollView];
        
        yCord+=20*ScreenHeightFactor;
        
        //       [self  drawLabelWithText:@"Coming Soon" andColor:[UIColor darkGrayColor] andFont:[UIFont fontWithName:RobotoLight size:9*ScreenFactor]];
        
        yCord+=20*ScreenHeightFactor;
        
    }
    
    [self.view setBackgroundColor:appBackgroundColor];
}

#pragma mark headerViewSpecificFunction
-(void)drawHeaderView
{
    if(!headerView)
    {
        
        headerView  = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320,ScreenHeightFactor*64)];
        [headerView setBackgroundColor:appBackgroundColor];
        [headerView setRootViewController:self];
        [headerView setHeaderViewdelegate:self];
        [headerView setCentreImgName:@"whatToDoHeader.png"];
        //[headerView setRightType:@"Menu"];
        [headerView drawHeaderViewWithTitle:@"What To Do" isBackBtnReq:YES BackImage:@"leftArrow.png"];
        [self.view bringSubviewToFront:headerView];
        [self.view addSubview:headerView];
        if(screenWidth>700)
        {
            yy+=headerView.frame.size.height+25*ScreenHeightFactor;
        }
        else
        {
            yy+=headerView.frame.size.height+22*ScreenHeightFactor;
            
        }
    }
    
}

#pragma mark BACK BUTTON DELEGATE
-(void)touchAtBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark drawing implmentation

-(void)childNameLabel
{
    if(!label) {
        if(screenWidth>700) {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, yy, ScreenWidthFactor*320, ScreenHeightFactor*15)withChildStr:childName];
            label.center=CGPointMake(screenWidth/2,label.center.y);
        }
        else {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, yy, ScreenWidthFactor*320, ScreenHeightFactor*12)withChildStr:childName];
            label.center=CGPointMake(screenWidth/2,label.center.y);
        }
        [self.view addSubview:label];
        yy += label.frame.size.height + 20*ScreenHeightFactor;
    }
}

-(void)addStripView:(NSString*)title clusterDetail:(NSString*)clusterDetail{
    
    StripView *stripView1 = [[StripView alloc] initWithFrame:CGRectMake(0, yy, screenWidth, ScreenHeightFactor*30)];
    [stripView1 drawStrip:title color:activityHeading1Code];
    stripView1.StripLabel.font = [UIFont fontWithName:RobotoRegular size:14.0f*ScreenHeightFactor];
    stripView1.StripLabel.textColor = activityHeading1FontCode;
    [self.view addSubview:stripView1];
    
    
    
    StripView *stripView2 = [[StripView alloc] initWithFrame:CGRectMake(0, stripView1.frame.origin.y+stripView1.frame.size.height, screenWidth, ScreenHeightFactor*30)];
    [stripView2 drawStrip:[clusterDetail uppercaseString] color:[UIColor grayColor]];
     stripView2.StripLabel.font = [UIFont fontWithName:RobotoRegular size:14.0f*ScreenHeightFactor];
    stripView2.backgroundColor = activityHeading2Code;
    //stripView2.alpha = 0.7f;
    stripView2.StripLabel.textColor = activityHeading2FontCode;
    [self.view addSubview:stripView2];
    
    yy += stripView2.frame.origin.y+stripView2.frame.size.height+10;
}


-(void)addSearchController{
    if(!searchBar)
    {
        searchBar = [[UISearchBar alloc] init];
        if (screenWidth>700) {
            searchBar.frame = CGRectMake(10*ScreenWidthFactor,yy,screenWidth- ScreenWidthFactor*20, ScreenHeightFactor*80);
            searchBar.center = CGPointMake(screenWidth/2,screenHeight/2-140);
        }
        else{
            if (screenWidth>320) {
                searchBar.frame = CGRectMake(10*ScreenWidthFactor,yy,screenWidth- ScreenWidthFactor*20, ScreenHeightFactor*30);
                searchBar.center = CGPointMake(screenWidth/2,screenHeight/2-100);
            }
            else{
                searchBar.frame = CGRectMake(10*ScreenWidthFactor,yy,screenWidth- ScreenWidthFactor*10, ScreenHeightFactor*30);
                searchBar.center = CGPointMake(screenWidth/2,screenHeight/2-80);

            }
        }
        [searchBar setReturnKeyType:UIReturnKeyDone];
        searchBar.searchBarStyle = UISearchBarStyleMinimal;
        searchBar.delegate = self;
        searchBar.placeholder = @"Search";
        [self.view addSubview:searchBar];
    }
    yy += searchBar.frame.origin.y+searchBar.frame.size.height+20;
}

-(void)getDataFromWebservice{
    pageIndex ++;

    [self addLoaderView];
    if (segmentControlIndex == 0) {
        GetListOfActivitiesOnRecommendedByClusterID *getListOfActivitiesOnRecommendedByClusterID = [[GetListOfActivitiesOnRecommendedByClusterID alloc] init];
        [getListOfActivitiesOnRecommendedByClusterID setServiceName:@"PinWiGetListOfActivitiesOnRecommendedByClusterID"];
        [getListOfActivitiesOnRecommendedByClusterID initService:@{
                                                                   @"ChildID":[NSString stringWithFormat:@"%li",(long)childID],
                                                                   @"ClusterID":[NSString stringWithFormat:@"%li",(long)clusterId],
                                                                   @"PageIndex":[NSString stringWithFormat:@"%ld",(long)pageIndex], //@"1",
                                                                   @"NumberOfRows":@"5"
                                                                   }];
        
        [getListOfActivitiesOnRecommendedByClusterID setDelegate:self];
    }
    if (segmentControlIndex == 1 || segmentControlIndex == 2) {
        GetListOfActivitiesOnNetworkByClusterID *getListOfActivitiesOnNetworkByClusterID = [[GetListOfActivitiesOnNetworkByClusterID alloc] init];
        [getListOfActivitiesOnNetworkByClusterID setServiceName:@"PinWiGetListOfActivitiesOnNetworkByClusterID"];
        [getListOfActivitiesOnNetworkByClusterID initService:@{
                                                                   @"ChildID":[NSString stringWithFormat:@"%li",(long)childID],
                                                                   @"ClusterID":[NSString stringWithFormat:@"%li",(long)clusterId],
                                                                   @"PageIndex":[NSString stringWithFormat:@"%ld",(long)pageIndex], //@"1",
                                                                   @"NumberOfRows":@"5"
                                                                   }];
        
        [getListOfActivitiesOnNetworkByClusterID setDelegate:self];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    for (UITableViewCell *cell in [table visibleCells])
    {
        lastIndex  = [table indexPathForCell:cell].row;
        
    }
    if( lastIndex+1 == totalCount && totalCount!=0 && totalCount>=5 && !isScrolling)
    {
        //NSInteger pageIndex = (totalCount / 5) + 1;
        [self getDataFromWebservice];
        isScrolling = YES;
    }
    
}

#pragma mark connection delegates

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
    
    [self removeLoaderView];
    NSLog(@"Service name inside network detail view = %@",connection.serviceName);
    
    if ([connection.serviceName isEqualToString:@"PinWiGetListOfActivitiesOnRecommendedByClusterID"]) {
        NSLog(@"PinWiGetListOfActivitiesOnRecommendedByClusterID error message %@",errorMessage);
    }
    if ([connection.serviceName isEqualToString:@"PinWiGetListOfActivitiesOnNetworkByClusterID"]) {
        NSLog(@"PinWiGetListOfActivitiesOnNetworkByClusterID error message %@",errorMessage);
    }
    pageIndex --;
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection{
    
    NSDictionary *dict;
    NSLog(@"Service name inside network detail view = %@",connection.serviceName);
    isScrolling = NO;
    if ([connection.serviceName isEqualToString:@"PinWiGetListOfActivitiesOnRecommendedByClusterID"])
    {
        [self removeLoaderView];
        dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetListOfActivitiesOnRecommendedByClusterIDResponse" resultKey:@"GetListOfActivitiesOnRecommendedByClusterIDResult"];
        
        [activitiListData removeAllObjects];
        [table removeFromSuperview];
        NSArray *array = (NSArray*)dict;
        NSDictionary *errorDictionary = [array firstObject];
        NSString *erroDesc = [errorDictionary valueForKey:@"ErrorDesc"];
        //[dict valueForKey:@"ErrorDesc"];
        
        if (!dict) {
            NSLog(@"error description %@",erroDesc);
            
            if(totalCount <=0)
            {
               [self setUpForNoActivity:erroDesc];
                
            }
            else
            {
                [self addTableView];
                int index = (int)totalCount-5;
                if (index>0) {
                    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(totalCount - 5-1) inSection:0]
                                 atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                }else{
                    
                }
            }
            pageIndex--;

            
        }
        
        if (dict && [dict isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray *)dict;
            NSDictionary *dictionary = [arr firstObject];
            
            if([dictionary valueForKey:@"ErrorDesc"]) {
                NSLog(@"error description %@",erroDesc);
               // [self setUpForNoActivity:erroDesc];
                if(totalCount <=0)
                {
                    [self setUpForNoActivity:erroDesc];
                    
                }
                else
                {
                    [self addTableView];
                    int index = (int)totalCount-5;
                    if (index>0) {
                        [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(totalCount - 5-1) inSection:0]
                                     atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                    }else{
                        
                    }
                }
                pageIndex--;

            }
            else{
                [arr enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
                    [activitiListData addObject:dictionary];
                    [totalArray addObject:dictionary];
                }];
                totalCount = totalArray.count;
                int index = (int)totalCount-5;
                if (index>0) {
                    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(totalCount - 5-1) inSection:0]
                                 atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                }else{
                    
                }

                 NSLog(@"Recommended tab data : %@",dict);
                [self addTableView];
            }
            
        }
        
        [self removeLoaderView];
    }
    
    if ([connection.serviceName isEqualToString:@"PinWiGetListOfActivitiesOnNetworkByClusterID"])
    {
        [self removeLoaderView];
        dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetListOfActivitiesOnNetworkByClusterIDResponse" resultKey:@"GetListOfActivitiesOnNetworkByClusterIDResult"];
        
        [activitiListData removeAllObjects];
        [table removeFromSuperview];
        NSArray *array = (NSArray*)dict;
        NSDictionary *errorDictionary = [array firstObject];
        NSString *erroDesc = [errorDictionary valueForKey:@"ErrorDesc"];
        //[dict valueForKey:@"ErrorDesc"];
        
        if (!dict) {
            NSLog(@"error description %@",erroDesc);
            if(totalCount <=0)
            {
                [self setUpForNoActivity:erroDesc];
                
            }
            else
            {
                [self addTableView];
                int index = (int)totalCount-5;
                if (index>0) {
                    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(totalCount - 5-1) inSection:0]
                                 atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                }else{
                    
                }
            }
            pageIndex--;

        }
        
        if (dict && [dict isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray *)dict;
            NSDictionary *dictionary = [arr firstObject];
            
            if([dictionary valueForKey:@"ErrorDesc"]) {
                NSLog(@"error description %@",erroDesc);
               // [self setUpForNoActivity:erroDesc];
                if(totalCount <=0)
                {
                    [self setUpForNoActivity:erroDesc];
                    
                }
                else
                {
                    [self addTableView];
                    int index = (int)totalCount-5;
                    if (index>0) {
                        [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(totalCount - 5-1) inSection:0]
                                     atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                    }else{
                        
                    }
                }
                pageIndex--;

            }
            else{
                [arr enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
                    [activitiListData addObject:dictionary];
                    [totalArray addObject:dictionary];
                }];
                NSLog(@"Recommended tab data : %@",dict);
                totalCount = totalArray.count;
                int index = (int)totalCount-5;
                if (index>0) {
                    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(totalCount - 5 -1) inSection:0]
                                 atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                }else{
                    
                }

                [self addTableView];
            }
            
        }
        
        [self removeLoaderView];
    }
    
    if ([connection.serviceName isEqualToString:PinWiSearchActivitiesByChildID])
    {
        [self removeLoaderView];
        dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:PinWiSearchActivitiesByChildIDResponse resultKey:PinWiSearchActivitiesByChildIDResult];
        
        
        connection = nil;
       // [searchResult removeAllObjects];
        
        if (dict && [dict isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray *)dict;
            NSDictionary *dictionary = [arr firstObject];
            if([dictionary valueForKey:@"ErrorDesc"]) {
//                if(totalCount <=0)
//                {
//                    [self setUpForNoActivity:[dictionary valueForKey:@"ErrorDesc"]];
//                    
//                }
//                else
//                {
//                    [self addTableView];
//                    int index = (int)totalCount-5;
//                    if (index>0) {
//                        [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(totalCount - 5 -1) inSection:0]
//                                     atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
//                    }else{
//                        
//                    }
//                }
                pageIndex--;
                [self setUpForNoActivity:[dictionary valueForKey:@"ErrorDesc"]];
                
            }
            else{
                table.alpha = 1.0f;
                [arr enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
                    [searchResult addObject:dictionary];
                }];
                totalCount = searchResult.count;
                int index = (int)totalCount-5;
                if (index>0) {
                    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(totalCount - 5 -1) inSection:0]
                                 atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                }else{
                    
                }
                
                if(!table)
                {
                    [self addTableView];
                }
                [table reloadData];
            }
            
            NSLog(@"searchResult count = %lu",(unsigned long)searchResult.count);
            //    [self removeNoConnectionData];
            
            
        }
    }
    else if ([connection.serviceName isEqualToString:PinWiSearchActivitiesOnNetworkByClusterID])
    {
        [self removeLoaderView];
        dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:PinWiSearchActivitiesOnNetworkByClusterIDResponse resultKey:PinWiSearchActivitiesOnNetworkByClusterIDResult];
        
        
        connection = nil;
        [searchResult removeAllObjects];
        
        if (dict && [dict isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray *)dict;
            NSDictionary *dictionary = [arr firstObject];
            if([dictionary valueForKey:@"ErrorDesc"]) {
            //[self setUpForNoActivity:[dictionary valueForKey:@"ErrorDesc"]];
//                if(totalCount <=0)
//                {
//                    [self setUpForNoActivity:[dictionary valueForKey:@"ErrorDesc"]];
//                    
//                }
//                else
//                {
//                    [self addTableView];
//                    int index = (int)totalCount-5;
//                    if (index>0) {
//                        [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(totalCount - 5) inSection:0]
//                                     atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
//                    }else{
//                        
//                    }
//                }
                 [self setUpForNoActivity:[dictionary valueForKey:@"ErrorDesc"]];
                pageIndex--;

        }
            else{
                table.alpha = 1.0f;
                [arr enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
                    [searchResult addObject:dictionary];
                }];
                totalCount = searchResult.count;
                int index = (int)totalCount-5;
                if (index>0) {
                    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(totalCount - 5 -1) inSection:0]
                                 atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                }else{
                    
                }

                if(!table)
                {
                    [self addTableView];
                }
                [table reloadData];
            }
            
            NSLog(@"searchResult count = %lu",(unsigned long)searchResult.count);
            //    [self removeNoConnectionData];
            
        }
    }


    
}

#pragma mark table implementation
-(void)addTableView {
    
    if (screenWidth>700) {
        table = [[UITableView alloc] initWithFrame:CGRectMake(10*ScreenWidthFactor,yy, screenWidth- ScreenWidthFactor*20, ScreenHeightFactor*365)];
        table.center = CGPointMake(screenWidth/2,screenHeight/2+220);
        table.contentInset = UIEdgeInsetsMake(0, 0, 300, 0);
    }
    else{
        table = [[UITableView alloc] initWithFrame:CGRectMake(10*ScreenWidthFactor,yy, screenWidth- ScreenWidthFactor*20, ScreenHeightFactor*380)];
        table.center = CGPointMake(screenWidth/2,screenHeight/2+150);
        if (screenWidth>320) {
            table.contentInset = UIEdgeInsetsMake(0, 0, 200, 0);
        }else{
            table.contentInset = UIEdgeInsetsMake(0, 0, 90, 0);
        }
    }
    table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    table.backgroundColor = appBackgroundColor;
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    yy += table.frame.origin.y+table.frame.size.height+20;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(searchResult.count >0) {
       return searchResult.count;
    }
    return totalArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"Cell";
    WishListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[WishListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    //cell.removeFriendDelegate = self;
    NSDictionary *dict= nil;
    if(searchResult.count >0) {
        dict=  [searchResult objectAtIndex:indexPath.row];
    }
    else {
        dict = [totalArray objectAtIndex:indexPath.row];
    }
    BOOL isSchedule = [[dict objectForKey:@"IsScheduled"]boolValue ];
    BOOL isWished = [[dict objectForKey:@"IsWished"]boolValue ];
    cell.backgroundColor = appBackgroundColor;
    
    [cell addActivityList:[dict objectForKey:@"ActivityName"] childCount:[dict objectForKey:@"ChildrenDoingThis"] cellHeight:cellHeight isScheduled:isSchedule isWished:isWished];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict= nil;
    
    if(searchResult.count >0) {
        dict =[searchResult objectAtIndex:indexPath.row];
    }
    else {
        dict = [totalArray objectAtIndex:indexPath.row];
    }
    UIActionSheet *actionSheet;
    BOOL isSchedule = [[dict objectForKey:@"IsScheduled"]boolValue ];
    activityID = [[dict objectForKey:@"ActivityID"] integerValue];
    activityName = [dict objectForKey:@"ActivityName"];
    
    if(isSchedule)
    {
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:nil
                       delegate:self
                       cancelButtonTitle:@"Cancel"
                       destructiveButtonTitle:nil
                       otherButtonTitles:@"Who is doing this?", @"View Wishlist",nil];
        actionSheet.tag = 1;
    }
    else
    {
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:nil
                       delegate:self
                       cancelButtonTitle:@"Cancel"
                       destructiveButtonTitle:nil
                       otherButtonTitles:@"Who is doing this?",@"Schedule this Activity",@"View Wishlist",nil];
        actionSheet.tag = 2;
    }

    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    SEL selector = NSSelectorFromString(@"_alertController");
    if ([actionSheet respondsToSelector:selector])
    {
        UIAlertController *alertController = [actionSheet valueForKey:@"_alertController"];
        if ([alertController isKindOfClass:[UIAlertController class]])
        {
            for (int i=0; i<4; i++) {
                if (actionSheet.tag == 1) {
                    if (i == 2) {
                        [[[alertController valueForKey:@"_actions"] objectAtIndex:1] setValue:[UIColor purpleColor] forKey:@"_titleTextColor"];
                    }else{
                        alertController.view.tintColor = textBlueColor;
                    }
                }
                if (actionSheet.tag == 2) {
                    if (i == 2) {
                        [[[alertController valueForKey:@"_actions"] objectAtIndex:2] setValue:[UIColor purpleColor] forKey:@"_titleTextColor"];
                    }else{
                        alertController.view.tintColor = textBlueColor;
                    }
                }
            }

        }
    }
}


- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self addWhoIsDoingThisController];
                    break;
                case 1:
                    [self addViewWishlistController];
                    break;
                 default:
                    break;
            }
            break;
        }
        case 2: {
            switch (buttonIndex) {
                case 0:
                    [self addWhoIsDoingThisController];
                    break;
                case 1:
                    [self addScheduleThisActivityController];
                    break;
                case 2:
                    [self addViewWishlistController];
                    break;
                default:
                    break;
            }
            break;
        }

        default:
            break;
    }
}

-(void)addWhoIsDoingThisController{
    WhoIsDoingThisViewController *whoIsDoingThisViewController = [[WhoIsDoingThisViewController alloc] init];
    whoIsDoingThisViewController.stripViewTitle = activityName;
    whoIsDoingThisViewController.childName = childName;
    whoIsDoingThisViewController.activityId = activityID;
    [self.navigationController pushViewController:whoIsDoingThisViewController animated:YES];
}

-(void)addScheduleThisActivityController{
    
    NSMutableDictionary *dict = [NSMutableDictionary
                                 dictionaryWithDictionary:@{
                                                            @"ActivityID":[NSString stringWithFormat:@"%li",(long)activityID],
                                                            @"Name":activityName
                                                            }];
  
    
    ActivityDetails *activityDetails =[[ActivityDetails alloc]init];
    
    activityDetails.afterSchoolChild = childObject;
    activityDetails.activityName1 = activityName;
    [activityDetails setTabBarCtlr:self.tabBarCtrl];
    activityDetails.afterSchoolDataDict = dict;
    activityDetails.iswhatToDoController = 1;
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self.navigationController pushViewController:activityDetails animated:YES];
}

-(void)addViewWishlistController{
    WishListViewController *wishListViewController = [[WishListViewController alloc] init];
    wishListViewController.childName = childName;
    wishListViewController.childID = childID;
    [self.navigationController pushViewController:wishListViewController animated:YES];

}

-(void)addLoaderView {
    loaderView=[[ShowActivityLoadingView alloc]initWithFrame:CGRectMake(0, 0,screenWidth, screenHeight)];
    loaderView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [loaderView showLoaderViewWithText:@"Hold On..."];
    [self.view addSubview:loaderView];
    
}

-(void)removeLoaderView {
    [loaderView removeLoaderView];
    [loaderView removeFromSuperview];
    loaderView=nil;
}

#pragma mark search Implementation
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar1{
    NSLog(@"searchBarTextDidBeginEditing ");
    if(!searchResult) {
        searchResult = [[NSMutableArray alloc]init];
    }
    else {
        [searchResult removeAllObjects];
         [searchBar resignFirstResponder];
    }
}

-(BOOL)searchBar:(UISearchBar *)searchBr shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // NSLog(@"replacementText=%@ shouldChangeTextInRange= %@ ",text,searchBr.text);
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBr textDidChange:(NSString *)searchText {
    NSLog(@"textDidChange= %@ textDidChange =%@",searchText,searchBr.text);
    
    nameToBeSearch = searchText;
    
    if(searchText.length <=0)
    {
        
        [searchResult removeAllObjects];
        [searchBar resignFirstResponder];
       
        
        if(activitiListData.count >0)
        {
            [table reloadData];
            table.alpha = 1.0f;
            
            if(noSearchResultLabel)
            {
                [noSearchResultLabel removeFromSuperview];
                [noActivityImageView removeFromSuperview];
                noSearchResultLabel = nil;
                noActivityImageView = nil;
            }
        }
        
    }
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar1{
    NSLog(@"searchBarTextDidEndEditing");
    
    [searchBar1 resignFirstResponder];
//    if(noSearchResultLabel)
//    {
//        [noSearchResultLabel removeFromSuperview];
//        [noActivityImageView removeFromSuperview];
//        noSearchResultLabel = nil;
//        noActivityImageView = nil;
//    }
    
    //[table reloadData];
    
    if(activitiListData.count >0)
    {
        [table reloadData];
        table.alpha = 1.0f;
        
        if(noSearchResultLabel)
        {
            [noSearchResultLabel removeFromSuperview];
            [noActivityImageView removeFromSuperview];
            noSearchResultLabel = nil;
            noActivityImageView = nil;
            [self.view endEditing:YES];
        }
    }
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1
{
    // Do the search...
    [searchResult removeAllObjects];
    //[self.view endEditing:YES];
//    if(noSearchResultLabel)
//    {
//        [noSearchResultLabel removeFromSuperview];
//        [noActivityImageView removeFromSuperview];
//        noSearchResultLabel = nil;
//        noActivityImageView = nil;
//    }
    [self searchBegins];
    [self.view endEditing:YES];
}


-(void)searchBegins
{
    [self addLoaderView];
    if (segmentControlIndex == 0) {
        SearchActivitiesByChildID *searchActivitiesByChildID = [[SearchActivitiesByChildID alloc] init];
        [searchActivitiesByChildID setServiceName:PinWiSearchActivitiesByChildID  ];
        [searchActivitiesByChildID initService:@{
                                                 @"ChildID":[NSString stringWithFormat:@"%ld",(long)childID],
                                                 @"ClusterID":[NSString stringWithFormat:@"%ld",(long)clusterId],
                                                 @"PageIndex":@"1",
                                                 @"NumberOfRows":@"5",
                                                 @"SearchText":nameToBeSearch
                                                 }];
        
        
        [searchActivitiesByChildID setDelegate:self];
    }
    if (segmentControlIndex == 1 || segmentControlIndex == 2) {
        SearchActivitiesOnNetworkByClusterID *searchActivitiesOnNetworkByClusterID = [[SearchActivitiesOnNetworkByClusterID alloc] init];
        [searchActivitiesOnNetworkByClusterID setServiceName:PinWiSearchActivitiesOnNetworkByClusterID];
        [searchActivitiesOnNetworkByClusterID initService:@{
                                                            @"ChildID":[NSString stringWithFormat:@"%ld",(long)childID],
                                                            @"ClusterID":[NSString stringWithFormat:@"%ld",(long)clusterId],
                                                            @"PageIndex":@"1",
                                                            @"NumberOfRows":@"5",
                                                            @"SearchText":nameToBeSearch
                                                            }];
        
        [searchActivitiesOnNetworkByClusterID setDelegate:self];
    }

    
    
    if(nameToBeSearch.length <=0)
    {
        [searchResult removeAllObjects];
        [searchBar resignFirstResponder];
        [table reloadData];
        table.alpha = 1.0f;
        
    }
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [searchBar resignFirstResponder];
}

-(void)setUpForNoActivity:(NSString*)errorDecs{
    
    table.alpha = 0.0f;
    if(!noActivityImageView)
    {
        if (screenWidth>700) {
            noActivityImageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/2,ScreenHeightFactor*180, screenWidth- ScreenWidthFactor*220, ScreenHeightFactor*50)];
            noActivityImageView.center = CGPointMake(screenWidth/2, screenHeight/2 + noActivityImageView.frame.size.height/2 + ScreenHeightFactor);
        }
        else{
            noActivityImageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/2,ScreenHeightFactor*180, screenWidth- ScreenWidthFactor*260, ScreenHeightFactor*40)];
            noActivityImageView.center = CGPointMake(screenWidth/2, screenHeight/2 + noActivityImageView.frame.size.height/2 + ScreenHeightFactor);
        }
        
        
        if (screenWidth>700) {
            noActivityImageView.image = [UIImage imageNamed:@"what-to-do-iPad.png"];
        }
        else{
            if (screenWidth>320) {
                noActivityImageView.image = [UIImage imageNamed:@"what-to-do-iPhone6.png"];
            }else{
                noActivityImageView.image = [UIImage imageNamed:@"what-to-do-iPhone5.png"];
            }
        }
        [self.view addSubview:noActivityImageView];
    }
    if(!noSearchResultLabel)
    {
        noSearchResultLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*ScreenWidthFactor,noActivityImageView.frame.size.height + noActivityImageView.frame.origin.y + 5*ScreenHeightFactor, screenWidth- ScreenWidthFactor*20, ScreenHeightFactor*30)];
        noSearchResultLabel.center = CGPointMake(screenWidth/2, noSearchResultLabel.center.y);
        [noSearchResultLabel setFont:[UIFont fontWithName:RobotoLight size:10*ScreenHeightFactor]];
        noSearchResultLabel.textAlignment = NSTextAlignmentCenter;
        noSearchResultLabel.textColor = [UIColor blackColor];
        noSearchResultLabel.text = [NSString stringWithFormat:@"%@",errorDecs];
        NSLog(@"error description : %@",errorDecs);
        
        [self.view addSubview:noSearchResultLabel];

    }
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
