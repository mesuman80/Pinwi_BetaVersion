//
//  ChildNetworkDetailViewController.m
//  ParentControl_CT
//
//  Created by Sakshi on 08/04/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "ChildNetworkDetailViewController.h"
#import "PC_DataManager.h"
#import "NetworkTableViewCell.h"
#import "ChildDetailViewController.h"
#import "GetListOfPinWiNetworksByLoggedID.h"

@interface ChildNetworkDetailViewController ()<UrlConnectionDelegate,HeaderViewProtocol>

@end

@implementation ChildNetworkDetailViewController

@synthesize table,childId,childName;
@synthesize stripView,loggedId;
@synthesize ChildConnectionDetailArray;
@synthesize tabBarCtrl,loaderView,loadElementView,yCord,yy,xCord,cellHeight,headerHeight;
@synthesize label,headerView,scrollView,pageControl,pageControlHeight,childDetailView;
@synthesize profileImage,parentName,cityNameLabel,statusButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"In connections detail view controller");
    yy=0;
    
    [[PC_DataManager sharedManager]getWidthHeight];
    pageControlHeight = (ScreenWidthFactor*20);
    if(!loadElementView)
    {
        loadElementView=[[UIView alloc]initWithFrame:CGRectMake(0,0, screenWidth*1.5, screenHeight)];
        [self.view addSubview:loadElementView];
    }
    
    [self.view setBackgroundColor:appBackgroundColor];
    
    
    ChildConnectionDetailArray = [[NSMutableArray alloc] init];
    if (screenWidth>700) {
        cellHeight = 150;
    }
    else{
        cellHeight = 80;
    }
    if (screenWidth>700) {
        headerHeight = 70;;
    }
    else{
        headerHeight = 60;;
    }
    
    [self drawUiWithHead];
    [self drawHeaderView];
    [self childNameLabel];
    [self getFriendsDetail];
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    [self.tabBarCtrl.tabBar setSelectedImageTintColor:NonInfluencerGreen];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        [headerView setCentreImgName:@"networkHeader.png"];
        //[headerView setRightType:@"Menu"];
        [headerView drawHeaderViewWithTitle:@"Network" isBackBtnReq:YES BackImage:@"leftArrow.png"];
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
        //        StripView *stripView = [[StripView alloc]initWithFrame:CGRectMake(0,yy+50, self.view.frame.size.width,27*ScreenHeightFactor)];
        //        [stripView drawStrip:@"My Profile" color:[UIColor clearColor]];
        //
        //        [self.view addSubview:stripView];
        
        
    }
}
#pragma mark BACK BUTTON DELEGATE
-(void)touchAtBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark drawUI
-(void)drawUiWithHead
{
    
    [self setupPageControl:[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles.count];
    if(!scrollView)
    {
        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,yy, self.view.frame.size.width, self.view.frame.size.height-yy)];
        [scrollView setPagingEnabled:NO];
        [scrollView setScrollEnabled:NO];
        [scrollView setBackgroundColor:appBackgroundColor];
        [self.view addSubview:scrollView];
        
        yCord+=20*ScreenFactor;
        [scrollView setContentSize:CGSizeMake(xCord, scrollView.contentSize.height)];
    }
    [self.view setBackgroundColor:appBackgroundColor];
}

-(void)setupPageControl:(NSInteger)number_Of_Page
{
    //int height  = [self navigationBarHeight];
    if(screenWidth>700)
    {
        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0,ScreenHeightFactor*3,pageControlHeight,pageControlHeight)];
        pageControl.transform = CGAffineTransformMakeScale(2, 2);
    }
    else
    {
        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0,ScreenHeightFactor*12,pageControlHeight,pageControlHeight)];
    }
    
    [pageControl setCenter:CGPointMake(screenWidth/2, pageControl.center.y)];
    pageControl.currentPage=0;
    pageControl.numberOfPages=number_Of_Page;
    // pageControl.pageIndicatorTintColor=[UIColor blackColor];
    [pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
    
    [loadElementView addSubview:pageControl];
}

#pragma mark child
-(void)childNameLabel
{
    if(!label)
    {
        if(screenWidth>700)
        {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, 180, ScreenWidthFactor*320, ScreenHeightFactor*15)withChildStr:[PC_DataManager sharedManager].parentObjectInstance.firstName];
            label.center=CGPointMake(screenWidth/2,180);
        }
        else
        {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, yy, ScreenWidthFactor*320, ScreenHeightFactor*12)withChildStr:[PC_DataManager sharedManager].parentObjectInstance.firstName];
            label.center=CGPointMake(screenWidth/2,yy+label.frame.size.height/2);
        }
        
        [self.view addSubview:label];
        yy+=80+label.frame.size.height+15*ScreenHeightFactor;
    }
    [self addLoaderView];
}



#pragma mark WebServices related Functions
-(void)getFriendsDetail {
    NSLog(@"LoggedID %@",[PC_DataManager sharedManager].parentObjectInstance.parentId);
    GetListOfPinWiNetworksByLoggedID *getListOfPinWiNetworksByLoggedID = [[GetListOfPinWiNetworksByLoggedID alloc] init];
    [getListOfPinWiNetworksByLoggedID setServiceName:@"GetListOfPinWiNetworksByLoggedID"];
    [getListOfPinWiNetworksByLoggedID initService:@{
                                                      @"LoggedID":[NSNumber numberWithInt:loggedId],
                                                      @"ChildID":[NSNumber numberWithInt:self.childId],
                                                      @"PageIndex":@"1",
                                                      @"NumberOfRows":@"5"
                                                      }];
    
    [getListOfPinWiNetworksByLoggedID setDelegate:self];
    
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
    
    NSLog(@"GetListOfPinWiNetworksByLoggedID error message %@",errorMessage);
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection{
    
    
    NSDictionary *dict;
    NSLog(@"Service name inside network detail view = %@",connection.serviceName);
    
    dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetListOfPinWiNetworksByLoggedIDResponse" resultKey:@"GetListOfPinWiNetworksByLoggedIDResult"];
    
    if (!dict) {
        return;
    }
    
    if (dict && [dict isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)dict;
        NSLog(@"ChildId %d",self.childId);
        NSDictionary *dictionary = [arr firstObject];
        if([dictionary valueForKey:@"ErrorDesc"]) {
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:[dictionary valueForKey:@"ErrorDesc"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//            [alert show];
            
        }
        else{
            for (int i = 0; i<arr.count; i++) {
                [ChildConnectionDetailArray addObject:[arr objectAtIndex:i]];
            }
            NSLog(@"GetListOfPinWiNetworksByLoggedID data: %@",dict);
        }
        
//        UIImage *img = nil;
//        NSString *profileImageStr = [dict objectForKey:@"ProfileImage"];
//        if (profileImageStr == (id)[NSNull null] || profileImageStr.length == 0 ) {
//            img =  [UIImage imageNamed:@"notificationProfile-568h@2x.png"];
//        }
//        else {
//            img=[[PC_DataManager sharedManager] decodeImage:profileImageStr];
//        }
//        
        
//        [self addParentDetailView:@"Parent Detail" profileImage:img parentName:[dict objectForKey:@"FriendName"] cityName:[dict objectForKey:@"CityName"] fStatus:fnum];
        [self addTableView];
    }
    
}

-(void)addTableView{
    if (screenWidth>700) {
        self.table = [[UITableView alloc] initWithFrame:CGRectMake(0,yy+300, screenWidth, ScreenHeightFactor*400)];
        table.center = CGPointMake(screenWidth/2, yy+300);
        table.contentInset = UIEdgeInsetsMake(0, 0, 650, 0);
    }
    else{
        self.table = [[UITableView alloc] initWithFrame:CGRectMake(10*ScreenWidthFactor,yy+label.frame.size.height, screenWidth, ScreenHeightFactor*380)];
        table.center = CGPointMake(screenWidth/2,screenWidth/2+160);
        table.contentInset = UIEdgeInsetsMake(0, 0, 180, 0);
    }
    table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    [self removeLoaderView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ChildConnectionDetailArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return headerHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *customHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0, screenWidth,headerHeight)];
    stripView = [[StripView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width,27*ScreenHeightFactor)];
    [stripView drawStrip:childName color:[UIColor clearColor]];
    stripView.StripLabel.font = [UIFont fontWithName:RobotoRegular size:14.0f*ScreenHeightFactor];
    stripView.StripLabel.textColor = activityHeading1FontCode;
    [customHeaderView addSubview:stripView];
    
    StripView *stripView1 = [[StripView alloc]initWithFrame:CGRectMake(0,stripView.frame.size.height, self.view.frame.size.width,27*ScreenHeightFactor)];
    NSLog(@"number of connections %ld",(long)self.numberOfConnections);
    NSString *str = @" Network Connections";
    NSString *str1 = [NSString stringWithFormat:@"%ld",(long)self.numberOfConnections];
    str1 = [str1 stringByAppendingString:str];
    [stripView1 drawStrip:str1 color:[UIColor clearColor]];
    stripView1.StripLabel.font = [UIFont fontWithName:RobotoRegular size:14.0f*ScreenHeightFactor];
    stripView1.backgroundColor = activityHeading2Code;
    //stripView2.alpha = 0.7f;
    stripView1.StripLabel.textColor = activityHeading2FontCode;
    [customHeaderView addSubview:stripView1];
    return customHeaderView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = @"profileCell";
    
    
    NetworkTableViewCell *cell = [table dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[NetworkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *childDict;
    
    UIImage *img = nil;
    
    childDict = [ChildConnectionDetailArray objectAtIndex:indexPath.row];
    NSLog(@"index path %ld",(long)indexPath.row);
    
    
    NSString *profileImageStr = [childDict objectForKey:@"ProfileImage"];
    if (profileImageStr == (id)[NSNull null] || profileImageStr.length == 0 ) {
        img =  [UIImage imageNamed:@"childDefaultImage-568h@2x.png"];
    }
    else {
        img=[[PC_DataManager sharedManager] decodeImage:profileImageStr];
    }
    
    [cell addChildConnectionDetails:[childDict objectForKey:@"ChildName"] profileImage:img parentName:[childDict objectForKey:@"ParentName"] cellHeight:cellHeight];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict=[ChildConnectionDetailArray objectAtIndex:indexPath.row];
    
    ChildDetailViewController *childDetailViewController = [[ChildDetailViewController alloc] init];
    NSNumber* num = [dict objectForKey:@"ChildID"];
    int fnum = [num intValue];
    
    childDetailViewController.ChildId = *(&(fnum));
    [self.navigationController pushViewController:childDetailViewController animated:YES ];
}



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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
