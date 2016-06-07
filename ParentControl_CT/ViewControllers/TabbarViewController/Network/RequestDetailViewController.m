//
//  RequestDetailViewController.m
//  ParentControl_CT
//
//  Created by Sakshi on 10/03/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "RequestDetailViewController.h"
#import "GetFriendDetailsByFriendID.h"
#import "PC_DataManager.h"
#import "NetworkTableViewCell.h"
#import "ChildDetailViewController.h"
#import "ImageView.h"


@interface RequestDetailViewController ()<UrlConnectionDelegate,HeaderViewProtocol>

@end

@implementation RequestDetailViewController

@synthesize FriendID,FriendName;
@synthesize table,cellImage;
@synthesize stripView;
@synthesize friendsDetailArray,friendsChildDetailArray;
@synthesize tabBarCtrl,loaderView,loadElementView,yCord,yy,xCord,cellHeight,headerHeight;
@synthesize label,headerView,scrollView,pageControl,pageControlHeight,childDetailView;
@synthesize profileImage,parentName,cityNameLabel,statusButton,friendshipStatus;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"In request detail view controller");
    yy=0;
    
    [[PC_DataManager sharedManager]getWidthHeight];
    pageControlHeight = (ScreenWidthFactor*20);
    if(!loadElementView)
    {
        loadElementView=[[UIView alloc]initWithFrame:CGRectMake(0,0, screenWidth*1.5, screenHeight)];
        [self.view addSubview:loadElementView];
    }
    
    [self.view setBackgroundColor:appBackgroundColor];
    
    NSLog(@"FriendID is: %@",FriendID);
    
    friendsDetailArray = [[NSMutableArray alloc]init];
    friendsChildDetailArray = [[NSMutableArray alloc] init];
    if (screenWidth>700) {
        cellHeight = 150;
    }
    else{
        cellHeight = 80;
    }
    if (screenWidth>700) {
        headerHeight = 40;;
    }
    else{
        headerHeight = 30;;
    }

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    [self drawUiWithHead];
    [self drawHeaderView];
    [self childNameLabel];
    [self getFriendsDetail];
    [self.tabBarCtrl.tabBar setSelectedImageTintColor:NonInfluencerGreen];
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
    
    GetFriendDetailsByFriendID *getFriendDetailsByFriendID = [[GetFriendDetailsByFriendID alloc] init];
    [getFriendDetailsByFriendID setServiceName:@"PinWiGetFriendDetailsByFriendID"];
    [getFriendDetailsByFriendID initService:@{
                                              @"LoggedID":[PC_DataManager sharedManager].parentObjectInstance.parentId,
                                              @"FriendID":self.FriendID
                                              }];
    
    [getFriendDetailsByFriendID setDelegate:self];
    
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
    
    NSLog(@"GetFriendDetailsByFriendID error message %@",errorMessage);
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection{
    
    [friendsChildDetailArray removeAllObjects];
    [friendsDetailArray removeAllObjects];
    NSDictionary *dict;
    NSLog(@"Service name inside network detail view = %@",connection.serviceName);
    
    dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetFriendDetailsByFriendIDResponse" resultKey:@"GetFriendDetailsByFriendIDResult"];
    
    if (!dict) {
        return;
    }
    
    if (dict && [dict isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)dict;
        NSDictionary *dictionary = [arr firstObject];
        if([dictionary valueForKey:@"ErrorDesc"]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:[dictionary valueForKey:@"ErrorDesc"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        else{
            [friendsDetailArray addObject:[arr objectAtIndex:0]];
            
            for (int i = 1; i<arr.count; i++) {
                [friendsChildDetailArray addObject:[arr objectAtIndex:i]];
            }
            NSLog(@"GetFriendDetailsByFriendID data: %@",dict);
        }
        
        NSDictionary * dict = [friendsDetailArray objectAtIndex:0];
        NSNumber* num = [dict objectForKey:@"FStatus"];
        int fnum = [num intValue];
        
        UIImage *img = nil;
        NSString *profileImageStr = [dict objectForKey:@"ProfileImage"];
        if (profileImageStr == (id)[NSNull null] || profileImageStr.length == 0 || [profileImageStr isEqualToString:@"(null)"] || [profileImageStr isEqualToString:@" "]) {
            if (screenWidth>700) {
                img =  [UIImage imageNamed:@"user-diPad.png"];
            }
            else{
                if (screenWidth>320) {
                    img =  [UIImage imageNamed:@"user-diPhone5.png"];
                }else{
                    img =  [UIImage imageNamed:@"user-diPhone6.png"];
                }
            }
            
        }

        else {
            img=[[PC_DataManager sharedManager] decodeImage:profileImageStr];
        }
        
        
        [self addParentDetailView:@"Parent Detail" profileImage:img parentName:[dict objectForKey:@"FriendName"] cityName:[dict objectForKey:@"CityName"] fStatus:fnum];
        [self addTableView];
    }
    
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

-(void)addTableView{
    if (screenWidth>700) {
        self.table = [[UITableView alloc] initWithFrame:CGRectMake(0,yy+30+childDetailView.center.y+childDetailView.frame.size.height, screenWidth, ScreenHeightFactor*400)];
        table.center = CGPointMake(screenWidth/2,yy+30+childDetailView.center.y*0.25+childDetailView.frame.size.height);
        table.contentInset = UIEdgeInsetsMake(0, 0, 650, 0);
    }
    else{
        self.table = [[UITableView alloc] initWithFrame:CGRectMake(10*ScreenWidthFactor,yy+30+childDetailView.frame.size.height, screenWidth, ScreenHeightFactor*380)];
        table.center = CGPointMake(screenWidth/2,yy+30+childDetailView.frame.size.height);
        if (screenWidth>320) {
            table.contentInset = UIEdgeInsetsMake(0, 0, 200, 0);
        }
        else{
            table.contentInset = UIEdgeInsetsMake(0, 0, 90, 0);
        }
    }
    table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    [self removeLoaderView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return friendsChildDetailArray.count;
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
    [stripView drawStrip:@"Children" color:[UIColor clearColor]];
    [customHeaderView addSubview:stripView];
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
    
    childDict = [friendsChildDetailArray objectAtIndex:indexPath.row];
    NSLog(@"index path %ld",(long)indexPath.row);
    
    
    NSString *profileImageStr = [childDict objectForKey:@"ProfileImage"];
    if (profileImageStr == (id)[NSNull null] || profileImageStr.length == 0 ) {
        img =  [UIImage imageNamed:@"childDefaultImage-568h@2x.png"];
    }
    else {
        img=[[PC_DataManager sharedManager] decodeImage:profileImageStr];
    }
    
    [cell addFriendsChildDetails:[childDict objectForKey:@"ChildName"] profileImage:img childAge:[childDict objectForKey:@"Age"] cellHeight:cellHeight];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict=[friendsChildDetailArray objectAtIndex:indexPath.row];
    
    ChildDetailViewController *childDetailViewController = [[ChildDetailViewController alloc] init];
    NSNumber* num = [dict objectForKey:@"ChildID"];
    int fnum = [num intValue];
//    NSInteger num1 = [[dict valueForKey:@"FStatus"] integerValue];
    
    if (friendshipStatus == 1) {
        childDetailViewController.ChildId = *(&(fnum));
        [self.navigationController pushViewController:childDetailViewController animated:YES ];
    }
    else{
        UIAlertView *alertView =  [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Add this parent to your Network to view their child's detail" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView setBackgroundColor:placeHolderReg];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSLog(@"Add this parent to your Network to view their child's detail");
    }
}


-(void)addParentDetailView:(NSString*)title profileImage:(UIImage*)image parentName:(NSString*)name cityName:(NSString*)city fStatus:(NSInteger)status{
    
    if (screenWidth>700) {
        self.childDetailView = [[UIView alloc] initWithFrame:CGRectMake(0,yy+30+label.frame.size.height, self.view.frame.size.width, ScreenHeightFactor*190)];
        self.childDetailView.center = CGPointMake(childDetailView.center.x, screenHeight/2-120);
    }
    else{
        self.childDetailView = [[UIView alloc] initWithFrame:CGRectMake(10*ScreenWidthFactor,yy+10, screenWidth, ScreenHeightFactor*190)];
        self.childDetailView.center = CGPointMake(screenWidth/2,yy+label.frame.size.height+10);
    }
    [self.view addSubview:childDetailView];
    stripView = [[StripView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width,27*ScreenHeightFactor)];
    [stripView drawStrip:title color:[UIColor clearColor]];
    [childDetailView addSubview:stripView];
    
    profileImage = [[UIImageView alloc] init];
    cellImage = image;
    profileImage.image = image;
    if (screenWidth>700) {
        profileImage.frame=CGRectMake(childDetailView.frame.size.width/2-312, childDetailView.frame.size.height/2-50, ScreenHeightFactor*48, ScreenHeightFactor*48);
        profileImage.center = CGPointMake(childDetailView.frame.size.width/2-312, childDetailView.frame.size.height/2-50);
        
    }else{
        if (screenWidth>320) {
            profileImage.frame=CGRectMake(childDetailView.frame.size.width/2-300, ScreenHeightFactor*10, ScreenHeightFactor*48, ScreenHeightFactor*48);
            profileImage.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2-140,childDetailView.frame.size.height/2-30);
        }
        else{
            profileImage.frame=CGRectMake(childDetailView.frame.size.width/2-300, ScreenHeightFactor*10, ScreenHeightFactor*48, ScreenHeightFactor*48);
            profileImage.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2-120,childDetailView.frame.size.height/2-30);
        }
        
    }
    
    profileImage.layer.cornerRadius = profileImage.frame.size.width/2;
    profileImage.layer.masksToBounds = YES;
    profileImage.layer.borderWidth = 0;
    profileImage.contentMode=UIViewContentModeScaleAspectFill;
    
    [profileImage setUserInteractionEnabled:YES];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchImage:)];
    [profileImage addGestureRecognizer:gestureRecognizer];
    
    [childDetailView addSubview:profileImage];
    
    
    parentName = [[UILabel alloc] init];
    parentName.text=name;
    if (screenWidth>700) {
        parentName.frame=CGRectMake(ScreenWidthFactor*20+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*50,childDetailView.frame.size.width-profileImage.frame.size.width+10,20);
        parentName.center=CGPointMake(parentName.center.x,ScreenHeightFactor*50);
    }
    else{
        parentName.frame=CGRectMake(ScreenWidthFactor*20+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*50,childDetailView.frame.size.width-profileImage.frame.size.width+10,20);
        parentName.center=CGPointMake(parentName.center.x,ScreenHeightFactor*50);
    }
    
    parentName.font=[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
    parentName.textColor=textBlueColor;
    [parentName sizeToFit];
    [childDetailView addSubview:parentName];
    
    statusButton = [[UIButton alloc] init];
    [childDetailView addSubview:statusButton];
    NSInteger FriendStatus = status;
    self.friendshipStatus = status;
    
    if (screenWidth>700) {
        statusButton.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-200,ScreenHeightFactor,125,ScreenHeightFactor*30);
        statusButton.center=CGPointMake(statusButton.center.x,childDetailView.frame.size.height/2-50);
       
    }
    else{
        statusButton.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-80,ScreenHeightFactor*10,60,ScreenHeightFactor*30);
        statusButton.center=CGPointMake(statusButton.center.x,childDetailView.frame.size.height/2-30);
    }
    
    statusButton.titleLabel.font = [UIFont fontWithName:RobotoBold size:10*ScreenHeightFactor];
    [statusButton.layer setBorderWidth:1.0f];
    
    
    switch (FriendStatus) {
        case 0:
            [statusButton setTitle:@"Sent" forState:UIControlStateNormal ];
            [statusButton.layer setBorderColor:textBlueColor.CGColor];
            [statusButton setTitleColor:textBlueColor forState:UIControlStateNormal];
            
            break;
        case 1:
            [statusButton setTitle:@"Remove" forState:UIControlStateNormal ];
            [statusButton.layer setBorderColor:[UIColor redColor].CGColor];
            [statusButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            break;
        case 2:
            [statusButton setTitle:@"Accept" forState:UIControlStateNormal ];
            [statusButton.layer setBorderColor:buttonGreenColor.CGColor];
            [statusButton setTitleColor:buttonGreenColor forState:UIControlStateNormal];
            
            break;
            
        case 5:
            [statusButton setTitle:@"Add" forState:UIControlStateNormal];
            [statusButton.layer setBorderColor:textBlueColor.CGColor];
            [statusButton setTitleColor:textBlueColor forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    
    
    cityNameLabel =[[UILabel alloc] init];
    [childDetailView addSubview:cityNameLabel];
    cityNameLabel.font=[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
    cityNameLabel.text=city;
    cityNameLabel.frame=CGRectMake(ScreenWidthFactor*20+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*70,childDetailView.frame.size.width-profileImage.frame.size.width+10,ScreenHeightFactor*30);
    cityNameLabel.center=CGPointMake(cityNameLabel.center.x,ScreenHeightFactor*70);
    cityNameLabel.textColor=[UIColor grayColor];
    
    
}

-(void)touchImage:(id)sender {
    
    
    // [imageView setFrame:];
    
    ImageView *imageView  =[[ImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [imageView drawImage:cellImage];
    
    AppDelegate *appDelegate  = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[appDelegate window]addSubview:imageView];
    [imageView setAlpha:0.0f];
    
    [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
        //[imageView setFrame:[UIScreen mainScreen].bounds];
        [imageView setAlpha:1.0f];
    }completion:^(BOOL finished){
        
    }];
    
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
