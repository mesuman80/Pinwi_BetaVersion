//
//  WishListViewController.m
//  ParentControl_CT
//
//  Created by Sakshi on 15/04/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "WishListViewController.h"
#import "GetWishListsByChildID.h"
#import "StripView.h"
#import "WishListTableViewCell.h"
#import "SearchWishListByChildID.h"
#import "WhoIsDoingThisViewController.h"
#import "ActivityDetails.h"

@interface WishListViewController ()<HeaderViewProtocol,UIScrollViewDelegate, UISearchBarDelegate, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@end

@implementation WishListViewController
{
    NSMutableArray *conncetionsData;
    ShowActivityLoadingView *loaderView;
    UITableView *table;
    StripView *stripView;
    UISearchBar *searchBar;
    CGFloat cellHeight;
    UILabel *noSearchResultLabel;
    NSInteger pageIndex;
    NSInteger lastIndex;
    NSInteger totalCount;
    UIImageView *noActivityImageView;
    BOOL isScrolling;
    
}
@synthesize childObject,label,connectionSearchController,filterString;
@synthesize searchBar,searchResult,nameToBeSearch,headerView,activityName;
@synthesize scrollView,continueButton,yy,yCord,xCord,scrollXX,initialY,reduceYY,ChildNameArray;
@synthesize tabBarCtrl,whatToDoObjectArray,pageController,childName,activityId,childID;


- (void)viewDidLoad {
    [super viewDidLoad];
    yy=0;
    [self.view setBackgroundColor:appBackgroundColor];
    conncetionsData = [[NSMutableArray alloc]init];
    if (screenWidth>700) {
        cellHeight  =  120;
    }
    else{
        cellHeight = 80;
    }
    [self drawUiWithHead];
    [self drawHeaderView];
    [self loadData];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    reduceYY =0;
    pageIndex = 0;
    [conncetionsData removeAllObjects];
    isScrolling = NO;
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
//    [self drawUiWithHead];
//    [self drawHeaderView];
//    [self loadData];
    [self getData];
    [self.tabBarCtrl.tabBar setSelectedImageTintColor:[UIColor purpleColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
    [self childNameLabel];
    [self setupHeaderLabel];
    [self addSearchbar];
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


#pragma mark get Data
-(void)getData
{
    [self addLoaderView];
    pageIndex ++;
    GetWishListsByChildID *getWishListsByChildID = [[GetWishListsByChildID alloc] init];
    [getWishListsByChildID setServiceName:PinWiGetWishListsByChildID];
    [getWishListsByChildID initService:@{
                                                      @"ChildID":[NSString stringWithFormat:@"%ld",(long)childID],
                                                      @"PageIndex":[NSString stringWithFormat:@"%ld",(long)pageIndex],//@"1",
                                                      @"NumberOfRows":@"5"
                                                      }];
    
    [getWishListsByChildID setDelegate:self];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    for (UITableViewCell *cell in [table visibleCells])
    {
        lastIndex  = [table indexPathForCell:cell].row;
        
    }
    if( lastIndex+1 == totalCount && totalCount!=0 && totalCount>=5 &&!isScrolling)
    {
       // NSInteger pageIndex = (totalCount / 5) + 1;
        isScrolling = YES;
        [self getData];
    }
    
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
    
    [self removeLoaderView];
    NSLog(@"Service name inside network detail view = %@",connection.serviceName);
    
    if ([connection.serviceName isEqualToString:PinWiGetWishListsByChildID]) {
        NSLog(@"GetFriendsListByLoggedID error message %@",errorMessage);
        pageIndex--;
    }
   
    
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection{
    
    NSDictionary *dict;
    isScrolling = NO;
    NSLog(@"Service name inside network detail view = %@",connection.serviceName);
    
    if ([connection.serviceName isEqualToString:PinWiGetWishListsByChildID])
    {
        [self removeLoaderView];
        dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:PinWiGetWishListsByChildIDResponse resultKey:PinWiGetWishListsByChildIDResult];
        
        if (!dict) {
           // [self setUpForNoConnection];
        }
        
        if (dict && [dict isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray *)dict;
            NSDictionary *dictionary = [arr firstObject];
            if([dictionary valueForKey:@"ErrorDesc"]) {
                //[self setUpForNoConnection];
                [self setUpForNoActivity:[dictionary valueForKey:@"ErrorDesc"]];
                pageIndex--;
            }
            else{
                [arr enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
                    [conncetionsData addObject:dictionary];
                    
                }];
                totalCount = conncetionsData.count;
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
    
    if ([connection.serviceName isEqualToString:PinWiSearchWishListByChildID])
    {
        [self removeLoaderView];
        dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:PinWiSearchWishListByChildIDResponse resultKey:PinWiSearchWishListByChildIDResult];
        
        connection = nil;
        [searchResult removeAllObjects];
        
        if (dict && [dict isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray *)dict;
            NSDictionary *dictionary = [arr firstObject];
            if([dictionary valueForKey:@"ErrorDesc"]) {
                //                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:[dictionary valueForKey:@"ErrorDesc"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                //                [alert show];
                
                table.alpha = 0.0f;
//                if(!noSearchResultLabel)
//                {
//                    noSearchResultLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*ScreenWidthFactor, yy+ScreenHeightFactor*220, screenWidth-ScreenWidthFactor*20, ScreenHeightFactor*30)];
//                    noSearchResultLabel.center = CGPointMake(screenWidth/2, yy+ScreenHeightFactor*220);
//                    noSearchResultLabel.text = @"No Match Found.";;
//                    [noSearchResultLabel setFont:[UIFont fontWithName:RobotoLight size:10*ScreenHeightFactor]];
//                    noSearchResultLabel.textAlignment = NSTextAlignmentCenter;
//                    noSearchResultLabel.textColor = [UIColor grayColor];
//                    
//                }
//                [self.view addSubview:noSearchResultLabel];
                [self setUpForNoActivity:[dictionary valueForKey:@"ErrorDesc"]];
                
            }
            else{
                table.alpha = 1.0f;
                [arr enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
                    [searchResult addObject:dictionary];
                }];
                
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

#pragma mark Tableview implementation
-(void)addTableView {
    
    if (screenWidth>700) {
        table = [[UITableView alloc] initWithFrame:CGRectMake(10*ScreenWidthFactor,yy, screenWidth- ScreenWidthFactor*20, screenHeight - yy)];
        table.center = CGPointMake(screenWidth/2,table.center.y);
        table.contentInset = UIEdgeInsetsMake(0, 0, 300, 0);
    }
    else{
        table = [[UITableView alloc] initWithFrame:CGRectMake(10*ScreenWidthFactor,yy, screenWidth- ScreenWidthFactor*20, screenHeight - yy)];
        table.center = CGPointMake(screenWidth/2,table.center.y);
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
    
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(searchResult.count >0) {
        NSInteger count = searchResult.count;
        return count;
    }
    
    return totalCount;
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
        dict = [conncetionsData objectAtIndex:indexPath.row];
    }
    BOOL isSchedule = [[dict objectForKey:@"IsScheduled"]boolValue ];
    cell.backgroundColor = appBackgroundColor;
    
    [cell addWishList:[dict objectForKey:@"Name"] childCount:[dict objectForKey:@"ChildrenDoingThis"] cellHeight:cellHeight isScheduled:isSchedule];
      return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict= nil;
    
    if(searchResult.count >0) {
        dict =[searchResult objectAtIndex:indexPath.row];
    }
    else {
        dict = [conncetionsData objectAtIndex:indexPath.row];
    }
    activityId = [[dict objectForKey:@"ActivityID"] integerValue];
    activityName = [dict objectForKey:@"Name"];
    UIActionSheet *actionSheet;
    BOOL isSchedule = [[dict objectForKey:@"IsScheduled"]boolValue ];
    if(isSchedule)
    {
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:nil
                       delegate:self
                       cancelButtonTitle:@"Cancel"
                       destructiveButtonTitle:nil
                       otherButtonTitles:@"Who is doing this?",nil];
        actionSheet.tag = 1;
    }
    else
    {
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:nil
                       delegate:self
                       cancelButtonTitle:@"Cancel"
                       destructiveButtonTitle:nil
                       otherButtonTitles:@"Who is doing this?",@"Schedule this Activity",nil];
        actionSheet.tag = 2;
    }
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self addWhoIsDoingThisController];
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
    whoIsDoingThisViewController.activityId = activityId;
    [self.navigationController pushViewController:whoIsDoingThisViewController animated:YES];
}

-(void)addScheduleThisActivityController{
    NSMutableDictionary *dict = [NSMutableDictionary
                                 dictionaryWithDictionary:@{
                                                            @"ActivityID":[NSString stringWithFormat:@"%li",(long)activityId],
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


#pragma mark BACK BUTTON DELEGATE
-(void)touchAtBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark drawing implmentation

-(void)childNameLabel
{
    if(!label)
    {
        if(screenWidth>700)
        {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, yy, ScreenWidthFactor*320, ScreenHeightFactor*15)withChildStr:childName];
            label.center=CGPointMake(screenWidth/2,label.center.y);
        }
        else
        {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, yy, ScreenWidthFactor*320, ScreenHeightFactor*12)withChildStr:childName];
            label.center=CGPointMake(screenWidth/2,label.center.y);
        }
        
        [self.view addSubview:label];
        yy += label.frame.size.height + 20*ScreenHeightFactor;
    }
}

-(void)setupHeaderLabel
{
//    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, yy, screenWidth, 12*ScreenHeightFactor)];
//    headerLabel.text = @"Wishlist";
//    headerLabel.textColor = [UIColor blackColor];
//    headerLabel.backgroundColor = BlankstersGray;
//    [self.view addSubview:headerLabel];
    
    stripView = [[StripView alloc]initWithFrame:CGRectMake(0,yy, screenWidth, 27*ScreenHeightFactor)];
    [stripView drawStrip:@"Wishlist" color:[UIColor clearColor]];
    [self.view addSubview:stripView];
    
   
    yy += stripView.frame.size.height + 10*ScreenHeightFactor;
}



-(void)addSearchbar
{
    if(!searchBar)
    {
        searchBar = [[UISearchBar alloc] init];
        if (screenWidth>700) {
            searchBar.frame = CGRectMake(10*ScreenWidthFactor,yy,  screenWidth- ScreenWidthFactor*20, ScreenHeightFactor*20);
            searchBar.center = CGPointMake(screenWidth/2,searchBar.center.y);
        }
        else{
            searchBar.frame = CGRectMake(10*ScreenWidthFactor,yy, screenWidth- ScreenWidthFactor*20, ScreenHeightFactor*30);
            searchBar.center = CGPointMake(screenWidth/2,searchBar.center.y);
        }
        [searchBar setReturnKeyType:UIReturnKeyDone];
        searchBar.searchBarStyle = UISearchBarStyleMinimal;
        searchBar.delegate = self;
        searchBar.placeholder = @"Search ";
        [self.view addSubview:searchBar];
    }
    
    yy += searchBar.frame.size.height+ 10*ScreenHeightFactor;

}

#pragma mark searchbar delegates
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
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
        
//        if(noSearchResultLabel)
//        {
//            [noSearchResultLabel removeFromSuperview];
//            
//        }
////        
////        if(!tempArray.count >0)
////        {
////            [self setUpForNoConnection];
////        }
////        else{
////            [table reloadData];
////            table.alpha = 1.0f;
////        }
////        
//        [table reloadData];
//        table.alpha = 1.0f;
        
        if(conncetionsData.count >0)
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
    
    if(conncetionsData.count >0)
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

//    if(noSearchResultLabel)
//    {
//        [noSearchResultLabel removeFromSuperview];
//    }
//    
//    [table reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1
{
    // Do the search...
    [searchResult removeAllObjects];
   // [self.view endEditing:YES];
    [self searchBegins];
    
}
-(void)searchBegins
{
    [self addLoaderView];
    SearchWishListByChildID *searchWishListByChildID = [[SearchWishListByChildID alloc] init];
    [searchWishListByChildID setServiceName:PinWiSearchWishListByChildID  ];
    [searchWishListByChildID initService:@{
                                            @"ChildID":[NSString stringWithFormat:@"%ld",(long)childID],
                                            @"PageIndex":@"1",
                                            @"NumberOfRows":@"5",
                                            @"SearchText":nameToBeSearch
                                            }];
    
    
    [searchWishListByChildID setDelegate:self];
    
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


#pragma mark loader view functions
-(void)addLoaderView {
    loaderView=[[ShowActivityLoadingView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height)];
    [loaderView showLoaderViewWithText:@"Hold On..."];
    [self.view addSubview:loaderView];
    
}

-(void)removeLoaderView {
    [loaderView removeLoaderView];
    [loaderView removeFromSuperview];
    loaderView=nil;
}


-(void)setUpForNoActivity:(NSString*)errorDecs{
    
    table.alpha = 0.0f;
    if(!noActivityImageView)
    {
        if (screenWidth>700) {
            noActivityImageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/2,ScreenHeightFactor*180, screenWidth- ScreenWidthFactor*260, ScreenHeightFactor*50)];
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
        noSearchResultLabel.textColor = [UIColor grayColor];
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
