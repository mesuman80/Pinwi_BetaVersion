//
//  NetworkDetailView.m
//  ParentControl_CT
//
//  Created by Sakshi on 24/02/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "NetworkDetailView.h"
#import "RedLabelView.h"
#import "PC_DataManager.h"
#import "GetFriendsListByLoggedID.h"
#import "GetListOfPendingRequestsByLoggedID.h"
#import "GetPeopleYouMayKnowListByLoggedID.h"

#import "ShowActivityLoadingView.h"
#import "InviteFriend.h"
#import "NetworkProfileViewController.h"
#import "ConnectionDetailViewController.h"
#import "SearchFriendListGlobally.h"
#import "DiscoverDetailViewController.h"
#import "RequestDetailViewController.h"


@implementation NetworkDetailView {

    
    UISearchController *connectionSearchController;
    UISegmentedControl *segmentedControl;
    NetworkViewController *rootController;
    ChildProfileObject *childObject;
    RedLabelView *label;
    UITableView *table;
    NSString *filterString;
    int yy;
    UISearchBar *searchBar;
    UIImageView *noConnectionImageView;
    UILabel *noConnectionsPresesntLabel;
    NSMutableArray *conncetionsData;
    ShowActivityLoadingView *loaderView;
    UIButton *inviteFriends;
    UIButton *profileIconButton;
    CGFloat cellHeight;
    NSMutableArray *searchResult;
    NSString *nameToBeSearch;
    UILabel *noSearchResultLabel;
    NSInteger lastIndex;
    NSInteger totalCount;
    NSMutableArray *tempArray;
    NSInteger pageIndex;
    BOOL isScrolling;
    BOOL isSearchActive;
}


-(id)initWithRootController:(NetworkViewController *)rootViewController andChildData:(ChildProfileObject*)childObj
{
    if(self =[super init])
    {
        self.networkViewController = rootViewController;
        [[PC_DataManager sharedManager]getWidthHeight];
        
        childObject=childObj;
        
        rootController = rootViewController;
        conncetionsData = [[NSMutableArray alloc] init];
        if (screenWidth>700) {
            cellHeight  =  120;
        }
        else{
            cellHeight = 80;
        }
        
        return self;
    }
    
    return nil;
}

-(void)loadData
{
    tempArray = [[NSMutableArray alloc]init];
    totalCount = 0;
    pageIndex = 1;
    isScrolling = NO;
    if(searchResult.count >0)
    {
        [searchResult removeAllObjects];
    }
    [self childNameLabel];
   // [self addProfileButton];
    [self choseConnection];
    [self getListOfFriends];
    [self addSearchController];
}


#pragma mark child
-(void)childNameLabel
{
    if(!label)
    {
        if(screenWidth>700)
        {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, 10, ScreenWidthFactor*320, ScreenHeightFactor*15)withChildStr:[PC_DataManager sharedManager].parentObjectInstance.firstName];
            //label.center=CGPointMake(screenWidth/2,180);
        }
        else
        {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320, ScreenHeightFactor*12)withChildStr:[PC_DataManager sharedManager].parentObjectInstance.firstName];
           // label.center=CGPointMake(screenWidth/2,yy+80+label.frame.size.height/2);
        }
        
        [self addSubview:label];
//        yy+=80+label.frame.size.height+15*ScreenHeightFactor;
        yy+=label.frame.size.height + 18.5*ScreenHeightFactor;
    }
}


-(void)choseConnection
{
    if(!segmentedControl)
    {
        [searchResult removeAllObjects];
        NSArray *itemArray = [NSArray arrayWithObjects: @"Connections",@"Request",@"Discover", nil];
        segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
        if (screenWidth>700) {
            segmentedControl.frame = CGRectMake(10*ScreenWidthFactor,yy+ScreenHeightFactor*20, screenWidth- ScreenWidthFactor*20, ScreenHeightFactor*30);                                                               //set the size and placement
            segmentedControl.center = CGPointMake(screenWidth/2,yy+ScreenHeightFactor*20);
        }
        else{
            segmentedControl.frame = CGRectMake(10*ScreenWidthFactor,yy+ScreenHeightFactor*10, screenWidth- ScreenWidthFactor*20, ScreenHeightFactor*30);                                                              //set the size and placement
            segmentedControl.center = CGPointMake(screenWidth/2,yy+ScreenHeightFactor*10);
        }
        segmentedControl.selectedSegmentIndex = 0;
        segmentedControl.backgroundColor=[UIColor clearColor];
        segmentedControl.tintColor = radiobuttonSelectionColor;
        segmentedControl.layer.cornerRadius = 0.0f;
        
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont fontWithName:RobotoRegular size:9*ScreenFactor], NSFontAttributeName,
                                    radiobuttonSelectionColor, NSForegroundColorAttributeName, nil];
        
        [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
        [segmentedControl setSelectedSegmentIndex:0];
        segmentedControl.segmentedControlStyle = UISegmentedControlSegmentLeft;
        [segmentedControl addTarget:self
                             action:@selector(selectedSegmentView:)
                   forControlEvents:UIControlEventValueChanged];
        [self addSubview:segmentedControl];
        yy+=segmentedControl.frame.size.height+20*ScreenHeightFactor;
    }
 }

-(void)selectedSegmentView:(UISegmentedControl *)paramSender{
    [searchResult removeAllObjects];
    [tempArray removeAllObjects];
    totalCount = 0;
    pageIndex = 1;
    isScrolling = NO;
    if(segmentedControl.selectedSegmentIndex==0)    //// Connection
    {
        [self addLoaderView];
        
        GetFriendsListByLoggedID *getFriendsListByLoggedID = [[GetFriendsListByLoggedID alloc] init];
        [getFriendsListByLoggedID setServiceName:@"PinWiGetFriendsListByLoggedID"];
        [getFriendsListByLoggedID initService:@{
                                                @"LoggedID":[PC_DataManager sharedManager].parentObjectInstance.parentId,
                                                @"PageIndex":[NSString stringWithFormat:@"%ld",(long)pageIndex],//@"1",
                                                @"NumberOfRows":@"5"
                                                }];
        
        [getFriendsListByLoggedID setDelegate:self];
        [self endEditing:YES];
        
        searchBar.text = @"";

    }
    else if (segmentedControl.selectedSegmentIndex==1)  /// Request
    {
        [self addLoaderView];
        
        GetListOfPendingRequestsByLoggedID *getListOfPendingRequestsByLoggedID = [[GetListOfPendingRequestsByLoggedID alloc] init];
        [getListOfPendingRequestsByLoggedID setServiceName:@"PinWiGetListOfPendingRequestsByLoggedID"];
        [getListOfPendingRequestsByLoggedID initService:@{
                                                @"LoggedID":[PC_DataManager sharedManager].parentObjectInstance.parentId,
                                                @"PageIndex":[NSString stringWithFormat:@"%ld",(long)pageIndex],//@"1",
                                                @"NumberOfRows":@"5"
                                                }];
        
        [getListOfPendingRequestsByLoggedID setDelegate:self];
        [self endEditing:YES];
        searchBar.text = @"";
    }
    
    else if (segmentedControl.selectedSegmentIndex==2)  /// Discover
    {
        [self addLoaderView];
       GetPeopleYouMayKnowListByLoggedID *getPeopleYouMayKnowListByLoggedID = [[GetPeopleYouMayKnowListByLoggedID alloc] init];
         [getPeopleYouMayKnowListByLoggedID setServiceName:@"PinWiGetPeopleYouMayKnowListByLoggedID"];
       
        [getPeopleYouMayKnowListByLoggedID initService:@{
                                                         @"LoggedID":[NSNumber numberWithInteger: [PC_DataManager sharedManager].parentObjectInstance.parentId.integerValue],
                                                         @"PageIndex":[NSString stringWithFormat:@"%ld",(long)pageIndex],//@"1",
                                                         @"NumberOfRows":[NSNumber numberWithInteger:5]
                                                }];
        
        [getPeopleYouMayKnowListByLoggedID setDelegate:self];
        [self endEditing:YES];
        searchBar.text = @"";

    }

}

-(void)addSearchController{
    if(!searchBar)
    {
        searchBar = [[UISearchBar alloc] init];
        if (screenWidth>700) {
            searchBar.frame = CGRectMake(10*ScreenWidthFactor,yy+ScreenHeightFactor+segmentedControl.frame.size.height,  screenWidth- ScreenWidthFactor*10, ScreenHeightFactor*50);
            searchBar.center = CGPointMake(screenWidth/2,yy+ScreenHeightFactor);
        }
        else{
            searchBar.frame = CGRectMake(10*ScreenWidthFactor,yy+ScreenHeightFactor+segmentedControl.frame.size.height-4, screenWidth- ScreenWidthFactor*10, ScreenHeightFactor*30);
            searchBar.center = CGPointMake(screenWidth/2,yy+ScreenHeightFactor-4);
        }
        [searchBar setReturnKeyType:UIReturnKeyDone];
        searchBar.searchBarStyle = UISearchBarStyleMinimal;
        searchBar.delegate = self;
        searchBar.placeholder = @"Search parents on PiNWi";
        [self addSubview:searchBar];
    }
    
}

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
        isSearchActive = NO;
        
        if(noSearchResultLabel)
        {
            [noSearchResultLabel removeFromSuperview];
            [noConnectionImageView removeFromSuperview];
            
        }
        
        if(tempArray.count <=0)
        {
            [self setUpForNoConnection];
        }
        else{
            [table reloadData];
            table.alpha = 1.0f;
        }
        
        
    }
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar1{
    NSLog(@"searchBarTextDidEndEditing");
    
    [searchBar1 resignFirstResponder];
    if(noSearchResultLabel)
    {
        [noSearchResultLabel removeFromSuperview];
        [noConnectionImageView removeFromSuperview];
    }
    isSearchActive = NO;
    [table reloadData];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1
{
    // Do the search...
    [searchResult removeAllObjects];
     pageIndex = 0;
    [self searchBegins];
   // [self endEditing:YES];
}
-(void)searchBegins
{
    isSearchActive = YES;
    pageIndex ++;
    [self addLoaderView];
    SearchFriendListGlobally *searchFriendListGlobally = [[SearchFriendListGlobally alloc] init];
    [searchFriendListGlobally setServiceName:PinWiSearchFriendListGlobally  ];
    [searchFriendListGlobally initService:@{
                                            @"LoggedID":[PC_DataManager sharedManager].parentObjectInstance.parentId,
                                            @"PageIndex":[NSString stringWithFormat:@"%ld",(long)pageIndex],//@"1",
                                            @"NumberOfRows":@"5",
                                            @"SearchText":nameToBeSearch
                                            }];
    
    
    [searchFriendListGlobally setDelegate:self];
    
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

#pragma mark WebServices related Functions
-(void)getListOfFriends{
  
    [self addLoaderView];
    if(segmentedControl.selectedSegmentIndex==0)    //// Connection
    {
        GetFriendsListByLoggedID *getFriendsListByLoggedID = [[GetFriendsListByLoggedID alloc] init];
        [getFriendsListByLoggedID setServiceName:@"PinWiGetFriendsListByLoggedID"];
        [getFriendsListByLoggedID initService:@{
                                                @"LoggedID":[PC_DataManager sharedManager].parentObjectInstance.parentId,
                                                @"PageIndex":[NSString stringWithFormat:@"%ld",(long)pageIndex],
                                                @"NumberOfRows":@"5"
                                                }];
        
        [getFriendsListByLoggedID setDelegate:self];

    }
    else if(segmentedControl.selectedSegmentIndex==1)    //// Request
    {
        GetListOfPendingRequestsByLoggedID *getListOfPendingRequestsByLoggedID = [[GetListOfPendingRequestsByLoggedID alloc] init];
        [getListOfPendingRequestsByLoggedID setServiceName:@"PinWiGetListOfPendingRequestsByLoggedID"];
        [getListOfPendingRequestsByLoggedID initService:@{
                                                          @"LoggedID":[PC_DataManager sharedManager].parentObjectInstance.parentId,
                                                          @"PageIndex":[NSString stringWithFormat:@"%ld",(long)pageIndex],
                                                          @"NumberOfRows":@"5"
                                                          }];
        
        [getListOfPendingRequestsByLoggedID setDelegate:self];
        
    }
    else if(segmentedControl.selectedSegmentIndex==2)    //// discover
    {
        GetPeopleYouMayKnowListByLoggedID *getPeopleYouMayKnowListByLoggedID = [[GetPeopleYouMayKnowListByLoggedID alloc] init];
        [getPeopleYouMayKnowListByLoggedID setServiceName:@"PinWiGetPeopleYouMayKnowListByLoggedID"];
        
        [getPeopleYouMayKnowListByLoggedID initService:@{
                                                         @"LoggedID":[NSNumber numberWithInteger: [PC_DataManager sharedManager].parentObjectInstance.parentId.integerValue],
                                                         @"PageIndex":[NSNumber numberWithInteger:pageIndex],
                                                         @"NumberOfRows":[NSNumber numberWithInteger:5]
                                                         }];
        
        [getPeopleYouMayKnowListByLoggedID setDelegate:self];
    }
    

    
    
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
    
    NSLog(@"Service name inside network detail view = %@",connection.serviceName);
    
    if ([connection.serviceName isEqualToString:@"PinWiGetFriendsListByLoggedID"]) {
        NSLog(@"GetFriendsListByLoggedID error message %@",errorMessage);
    }
    else if ([connection.serviceName isEqualToString:@"PinWiGetListOfPendingRequestsByLoggedID"]){
        NSLog(@"GetListOfPendingRequestsByLoggedID error message %@",errorMessage);
    }
    else if ([connection.serviceName isEqualToString:@"PinWiGetPeopleYouMayKnowListByLoggedID"]){
        NSLog(@"GetPeopleYouMayKnowListByLoggedID error message %@",errorMessage);
    }
    
    else if ([connection.serviceName isEqualToString:PinWiSearchFriendListGlobally]){
        NSLog(@"PinWiSearchFriendListGlobally error message %@",errorMessage);
    }
    [self removeLoaderView];
    pageIndex --;
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection{
    
    NSDictionary *dict;
    isScrolling = NO;
    NSLog(@"Service name inside network detail view = %@",connection.serviceName);
    
    if ([connection.serviceName isEqualToString:@"PinWiGetFriendsListByLoggedID"])
    {
        [self removeLoaderView];
        dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetFriendsListByLoggedIDResponse" resultKey:@"GetFriendsListByLoggedIDResult"];
        
        [conncetionsData removeAllObjects];
        [table removeFromSuperview];
        [self removeNoConnectionData];
        
        
        if (!dict) {
//            [self setUpForNoConnection];
//            pageIndex--;
            if(totalCount<=0)
            {
                [self setUpForNoConnection];
                
                
            }
            else
            {
                [self addTableView];
                int index = (int)totalCount-5;
                if (index>0) {
                    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(totalCount - 5 -1) inSection:0]
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
//                 [self setUpForNoConnection];
//                pageIndex--;
                if(totalCount<=0)
                {
                    [self setUpForNoConnection];
                    
                    
                }
                else
                {
                    [self addTableView];
                    int index = (int)totalCount-5;
                    if (index>0) {
                        [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(totalCount - 5 -1) inSection:0]
                                     atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                    }else{
                        
                    }
                }
                
                pageIndex--;


            }
            else{
                [arr enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
                    [conncetionsData addObject:dictionary];
                     [tempArray addObject:dictionary];
                }];
                 totalCount = tempArray.count;
                [self addTableView];
                int index = (int)totalCount-5;
                if (index>0) {
                    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(totalCount - 5 -1) inSection:0]
                                 atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                }else{
                    
                }

            }
            
        }
        [self removeLoaderView];
    }
    else if ([connection.serviceName isEqualToString:@"PinWiGetListOfPendingRequestsByLoggedID"]){
        
        [self removeLoaderView];
        dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetListOfPendingRequestsByLoggedIDResponse" resultKey:@"GetListOfPendingRequestsByLoggedIDResult"];
        NSLog(@"GetListOfPendingRequestsByLoggedID data %@",dictionary);
        [conncetionsData removeAllObjects];
        [table removeFromSuperview];
        [self removeNoConnectionData];
        
        
        if (dict == nil) {
//            [self setUpForNoConnection];
//            pageIndex--;
            
            if(totalCount<=0)
            {
                [self setUpForNoConnection];
                
                
            }
            else
            {
                [self addTableView];
                int index = (int)totalCount-5;
                if (index>0) {
                    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(totalCount - 5 -1) inSection:0]
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
//                [self setUpForNoConnection];
//                pageIndex--;
                if(totalCount<=0)
                {
                    [self setUpForNoConnection];
                    
                    
                }
                else
                {
                    [self addTableView];
                    int index = (int)totalCount-5;
                    if (index>0) {
                        [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(totalCount - 5 -1) inSection:0]
                                     atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                    }else{
                        
                    }
                }
                
                pageIndex--;


            }
            else{
                [arr enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
                    [conncetionsData addObject:dictionary];
                     [tempArray addObject:dictionary];
                }];
                totalCount = tempArray.count;
                [self addTableView];
                int index = (int)totalCount-5;
                if (index>0) {
                    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(totalCount - 5 -1) inSection:0]
                                 atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                }else{
                    
                }

            }
            
        }

    }
    else if ([connection.serviceName isEqualToString:@"PinWiGetPeopleYouMayKnowListByLoggedID"]){
        [self removeLoaderView];
        dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetPeopleYouMayKnowListByLoggedIDResponse" resultKey:@"GetPeopleYouMayKnowListByLoggedIDResult"];
        [table removeFromSuperview];
        [conncetionsData removeAllObjects];
        [self removeNoConnectionData];
        
        
        if (!dict) {
//            [self setUpForNoConnection];
//            pageIndex--;

            if(totalCount<=0)
            {
                [self setUpForNoConnection];
                
                
            }
            else
            {
                [self addTableView];
                int index = (int)totalCount-5;
                if (index>0) {
                    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(totalCount - 5 -1) inSection:0]
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
                //[self setUpForNoConnection];
                if(totalCount<=0)
                {
                    [self setUpForNoConnection];
                    
                    
                }
                else
                {
                    [self addTableView];
                    int index = (int)totalCount-5;
                    if (index>0) {
                        [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(totalCount - 5 -1) inSection:0]
                                     atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                    }else{
                        
                    }
                }

                pageIndex--;

            }
            else{
                [arr enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
                    [conncetionsData addObject:dictionary];
                    [tempArray addObject:dictionary];
                }];
                 totalCount = tempArray.count;
                 [self addTableView];
                int index = (int)totalCount-5;
                if (index>0) {
                    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(totalCount - 5 -1) inSection:0]
                                 atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                }else{
                    
                }
                
            }
           
        }

    }
    else if ([connection.serviceName isEqualToString:PinWiSearchFriendListGlobally]){
        
        
        [self removeLoaderView];
        
        dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:PinWiSearchFriendListGloballyResponse resultKey:PinWiSearchFriendListGloballyResult];
        connection = nil;
       // [searchResult removeAllObjects];
        [self removeNoConnectionData];
        
        if (dict && [dict isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray *)dict;
            NSDictionary *dictionary = [arr firstObject];
            if([dictionary valueForKey:@"ErrorDesc"]) {
                
                if(searchResult.count<=0)
                {
                    [self setupForNoSearchResult:[dictionary valueForKey:@"ErrorDesc"]];
                    
                }
                else
                {
                    [self addTableView];
                    int index = (int)searchResult.count-5;
                    if (index>0) {
                        [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(searchResult.count - 5) inSection:0]
                                     atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                    }else{
                        
                    }
                }

                pageIndex--;

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

            }
            
            NSLog(@"searchResult count = %lu",(unsigned long)searchResult.count);
        //    [self removeNoConnectionData];
        }

}



-(void)addTableView {
  
    if (screenWidth>700) {
        table = [[UITableView alloc] initWithFrame:CGRectMake(10*ScreenWidthFactor,yy+ScreenHeightFactor*150+segmentedControl.frame.size.height+searchBar.frame.size.height, screenWidth- ScreenWidthFactor*20, ScreenHeightFactor*365)];
        table.center = CGPointMake(screenWidth/2,screenWidth/2+150);
        table.contentInset = UIEdgeInsetsMake(0, 0, 300, 0);
    }
    else{
        table = [[UITableView alloc] initWithFrame:CGRectMake(10*ScreenWidthFactor,yy+ScreenHeightFactor*215, screenWidth- ScreenWidthFactor*20, ScreenHeightFactor*380)];
        table.center = CGPointMake(screenWidth/2,yy+ScreenHeightFactor*215);
        if (screenWidth>320) {
             table.contentInset = UIEdgeInsetsMake(0, 0, 200, 0);
        }else{
        table.contentInset = UIEdgeInsetsMake(0, 0, 90, 0);
        }
    }
    table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    table.delegate = self;
    table.dataSource = self;
    [self addSubview:table];
   
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if(searchResult.count >0) {
                NSInteger count = searchResult.count;
                return count;
            }
    
    return tempArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"Cell";
    NetworkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[NetworkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.removeFriendDelegate = self;
    NSDictionary *dict= nil;
    if(searchResult.count >0) {
        dict=  [searchResult objectAtIndex:indexPath.row];
    }
    else {
       dict = [tempArray objectAtIndex:indexPath.row];
    }
    
    UIImage *img = nil;
    NSString *profileImageStr = [dict objectForKey:@"ProfileImage"];
    //profileImageStr = [profileImageStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if (profileImageStr == (id)[NSNull null] || profileImageStr.length == 0 || [profileImageStr isEqualToString:@"(null)"] || [profileImageStr isEqualToString:@" "]) {
        if (screenWidth>700) {
            img =  [UIImage imageNamed:@"user-diPad.png"];
        }
        else{
            if (screenWidth>320) {
                img =  [UIImage imageNamed:@"user-diPhone6.png"];
            }else{
                img =  [UIImage imageNamed:@"user-diPhone5.png"];
            }
        }
    }
        else
        {
            img=[[PC_DataManager sharedManager] decodeImage:profileImageStr];
        }
        
    if([dict objectForKey:@"FriendID"])
    {
         cell.friendId = [dict objectForKey:@"FriendID"];
    }
    else
    {
         cell.friendId = [dict objectForKey:@"ParentID"];
    }
    if (segmentedControl.selectedSegmentIndex ==0) {
      //  cell.friendId = [dict objectForKey:@"FriendID"];
        
        
        if([dict objectForKey:@"ChildName"])
        {
            [cell addFriendsCredential:[dict objectForKey:@"FriendName"] profileImage:img childName:[dict objectForKey:@"ChildName"] fStatus:[dict objectForKey:@"FStatus"] cellHeight:cellHeight];
            
        }
        else
        {
            [cell addFoundFriendsCredential:[dict objectForKey:@"ParentName"] profileImage:img fStatus:[dict objectForKey:@"FStatus"] cellHeight:cellHeight];
            
        }
        
//        [cell addFriendsCredential:[dict objectForKey:@"FriendName"] profileImage:img childName:[dict objectForKey:@"ChildName"] fStatus:[dict objectForKey:@"FStatus"] cellHeight:cellHeight];
        
    }
    
    else if (segmentedControl.selectedSegmentIndex ==1){
        NSLog(@"child name = %@",[dict objectForKey:@"ChildName"] );
      //  cell.friendId = [dict objectForKey:@"FriendID"];
        NSInteger num = [[dict valueForKey:@"FStatus"] integerValue];
        NSString *fnum = [NSString stringWithFormat:@"%li",(long)num];
        
        if([dict objectForKey:@"ChildName"])
        {
            NSLog(@"child name found");
            [cell addFriendsCredential:[dict objectForKey:@"FriendName"] profileImage:img childName:[dict objectForKey:@"ChildName"] fStatus:[dict objectForKey:@"FStatus"] cellHeight:cellHeight];
            
        }
        else
        {
            NSLog(@"not null condition");
            [cell addFoundFriendsCredential:[dict objectForKey:@"ParentName"] profileImage:img fStatus:fnum cellHeight:cellHeight];
            
        }
        
    }
   
    else if (segmentedControl.selectedSegmentIndex ==2){
        NSLog(@"child name = %@",[dict objectForKey:@"ChildName"] );
     //   cell.friendId = [dict objectForKey:@"ParentID"];
        NSInteger num = [[dict valueForKey:@"FStatus"] integerValue];
        NSString *fnum = [NSString stringWithFormat:@"%li",(long)num];
        
        if([dict objectForKey:@"ChildName"])
        {
            NSLog(@"child name found");
            [cell addFriendsCredential:[dict objectForKey:@"ParentName"] profileImage:img childName:[dict objectForKey:@"ChildName"] fStatus:[dict objectForKey:@"FStatus"] cellHeight:cellHeight];
            
        }
        else
        {
            NSLog(@"not null condition");
            [cell addFoundFriendsCredential:[dict objectForKey:@"ParentName"] profileImage:img fStatus:fnum cellHeight:cellHeight];
        
        }
        
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict= nil;
    
    if(searchResult.count >0) {
        dict =[searchResult objectAtIndex:indexPath.row];
    }
    else {
        dict = [tempArray objectAtIndex:indexPath.row];
    }
    NSInteger num = [[dict valueForKey:@"FriendID"] integerValue];
    NSString *fnum = [NSString stringWithFormat:@"%li",(long)num];
    
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        ConnectionDetailViewController *connectionDetailViewController = [[ConnectionDetailViewController alloc] init];
        if ([dict objectForKey:@"FriendID"]) {
            connectionDetailViewController.FriendID = [dict objectForKey:@"FriendID"];
            connectionDetailViewController.FriendName = [dict objectForKey:@"FriendName"];

        }
        else{
            connectionDetailViewController.FriendID = [dict objectForKey:@"ParentID"];
            connectionDetailViewController.FriendName = [dict objectForKey:@"ParentName"];

        }
        [rootController.navigationController pushViewController:connectionDetailViewController animated:YES];
    }
    else if (segmentedControl.selectedSegmentIndex == 1) {
        RequestDetailViewController *requestDetailViewController = [[RequestDetailViewController alloc] init];
        if ([dict objectForKey:@"FriendID"]){
            requestDetailViewController.FriendID = [dict objectForKey:@"FriendID"];
            requestDetailViewController.FriendName = [dict objectForKey:@"FriendName"];
        }
        else{
            requestDetailViewController.FriendID = [dict objectForKey:@"ParentID"];
            requestDetailViewController.FriendName = [dict objectForKey:@"ParentName"];
        }
        [rootController.navigationController pushViewController:requestDetailViewController animated:YES];
        NSLog(@"In request detail view controller");
    }
    else if (segmentedControl.selectedSegmentIndex == 2) {
        DiscoverDetailViewController *discoverDetailViewController = [[DiscoverDetailViewController alloc] init];
        discoverDetailViewController.FriendID = [dict objectForKey:@"ParentID"];
        discoverDetailViewController.FriendName = [dict objectForKey:@"ParentName"];
        [rootController.navigationController pushViewController:discoverDetailViewController animated:YES];
        
    }


}



-(void)setUpForNoConnection{
    [table removeFromSuperview];
    table = nil;
    if(!noConnectionImageView)
    {
        noConnectionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/2,yy+ScreenHeightFactor*180, screenWidth- ScreenWidthFactor*220, ScreenHeightFactor*50)];
        noConnectionImageView.center = CGPointMake(screenWidth/2, yy+ScreenHeightFactor*180);
        
        if (screenWidth>700) {
            noConnectionImageView.image = [UIImage imageNamed:@"friends-list.png"];
        }
        else{
            noConnectionImageView.image = [UIImage imageNamed:@"friends-list.png"];
        }
    }
   if(!noConnectionsPresesntLabel)
   {
       noConnectionsPresesntLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*ScreenWidthFactor,yy+ScreenHeightFactor*220+noConnectionImageView.frame.size.height, screenWidth- ScreenWidthFactor*20, ScreenHeightFactor*30)];
       noConnectionsPresesntLabel.center = CGPointMake(screenWidth/2, yy+ScreenHeightFactor*220);
       [noConnectionsPresesntLabel setFont:[UIFont fontWithName:RobotoLight size:10*ScreenHeightFactor]];
       noConnectionsPresesntLabel.textAlignment = NSTextAlignmentCenter;
       noConnectionsPresesntLabel.textColor = [UIColor grayColor];

   }
    
        if (segmentedControl.selectedSegmentIndex ==0) {
        noConnectionsPresesntLabel.text = @"You have no parent connection.";
        if (screenWidth>700) {
            inviteFriends = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth/2,yy+ScreenHeightFactor*310,ScreenWidthFactor*250, ScreenHeightFactor*40)];
            inviteFriends.center = CGPointMake(screenWidth/2, yy+ScreenHeightFactor*310);
        }
        else{
            inviteFriends = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth/2,yy+ScreenHeightFactor*330,ScreenWidthFactor*250, ScreenHeightFactor*40)];
            inviteFriends.center = CGPointMake(screenWidth/2, yy+ScreenHeightFactor*330);
        }
        
        [inviteFriends setTitle:@"Invite Parents to PiNWi" forState:UIControlStateNormal];
        [inviteFriends setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        inviteFriends.backgroundColor = buttonGreenColor;
        inviteFriends.titleLabel.font = [UIFont fontWithName:RobotoLight size:10*ScreenHeightFactor];
        [self addSubview:inviteFriends];
        [inviteFriends addTarget:self action:@selector(inviteFriendsButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (segmentedControl.selectedSegmentIndex ==1){
        noConnectionsPresesntLabel.text = @"You have no new request.";
    }
    else if (segmentedControl.selectedSegmentIndex ==2){
        noConnectionsPresesntLabel.text = @"Discover new connection.";
    }
    
    [self addSubview:noConnectionImageView];
    [self addSubview:noConnectionsPresesntLabel];
}

-(void)removeNoConnectionData{
    [noConnectionImageView removeFromSuperview];
    [noConnectionsPresesntLabel removeFromSuperview];
    [inviteFriends removeFromSuperview];
    [noSearchResultLabel removeFromSuperview];
}

-(void)addLoaderView {
    if (screenWidth>700) {
        loaderView=[[ShowActivityLoadingView alloc]initWithFrame:CGRectMake(0,yy-segmentedControl.frame.size.height-ScreenHeightFactor*15,self.frame.size.width, self.frame.size.height)];
    }
    else{
        loaderView=[[ShowActivityLoadingView alloc]initWithFrame:CGRectMake(0,yy-segmentedControl.frame.size.height-ScreenHeightFactor*26
                                                                            
                                                                            ,self.frame.size.width, self.frame.size.height)];
    }
    
    [loaderView showLoaderViewWithText:@"Hold On..."];
    [self addSubview:loaderView];
    
}

-(void)removeLoaderView {
    [loaderView removeLoaderView];
    [loaderView removeFromSuperview];
    loaderView=nil;
}

-(void)inviteFriendsButtonTouched: (UIButton*)sender{
    InviteFriend *inviteFriendsViewController = [[InviteFriend alloc] init];
    [rootController.navigationController pushViewController:inviteFriendsViewController animated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(searchResult.count >0)
    {
        for (UITableViewCell *cell in [table visibleCells])
        {
            lastIndex  = [table indexPathForCell:cell].row;
            
        }
        if( lastIndex+1 == searchResult.count && searchResult.count!=0 && searchResult.count>=5 &&!isScrolling)
        {
            // NSInteger pageIndex = (totalCount / 5) + 1;
           // pageIndex ++;
            isScrolling = YES;
            [self searchBegins];
        }
    }
    else
    {
        for (UITableViewCell *cell in [table visibleCells])
        {
            lastIndex  = [table indexPathForCell:cell].row;
            
        }
        if( lastIndex+1 == totalCount && totalCount!=0 && totalCount>=5 && !isScrolling)
        {
           // NSInteger pageIndex = (totalCount / 5) + 1;
            pageIndex ++;
            isScrolling = YES;
            [self getListOfFriends];
        }

    }
    
}

-(void)setupForNoSearchResult:(NSString *)errMSg
{
    table.alpha = 0.0f;
    
        if(!noSearchResultLabel)
        {
            noConnectionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/2,yy+ScreenHeightFactor*180, screenWidth- ScreenWidthFactor*220, ScreenHeightFactor*50)];
            noConnectionImageView.center = CGPointMake(screenWidth/2, yy+ScreenHeightFactor*180);
            noConnectionImageView.image = [UIImage imageNamed:@"friends-list.png"];

            noSearchResultLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*ScreenWidthFactor, yy+ScreenHeightFactor*220, screenWidth-ScreenWidthFactor*20, ScreenHeightFactor*30)];
            noSearchResultLabel.center = CGPointMake(screenWidth/2, yy+ScreenHeightFactor*220);
            noSearchResultLabel.text = errMSg;
            [noSearchResultLabel setFont:[UIFont fontWithName:RobotoLight size:10*ScreenHeightFactor]];
            noSearchResultLabel.textAlignment = NSTextAlignmentCenter;
            noSearchResultLabel.textColor = [UIColor grayColor];

        }
        [self addSubview:noSearchResultLabel];
//        noConnectionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(screenWidth/2,yy+ScreenHeightFactor*180, screenWidth- ScreenWidthFactor*220, ScreenHeightFactor*50)];
//        noConnectionImageView.center = CGPointMake(screenWidth/2, yy+ScreenHeightFactor*180);
//        noConnectionImageView.image = [UIImage imageNamed:@"friends-list.png"];
        [self addSubview:noConnectionImageView];
    
}

-(void)updateList
{
    
    
    if(isSearchActive)
    {
        pageIndex = 0;
        [searchResult removeAllObjects];
        [self searchBegins];
    }
    else
    {
        [tempArray removeAllObjects];
         [self getListOfFriends];
    }
   
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
