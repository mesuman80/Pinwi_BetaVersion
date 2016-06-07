//
//  NetworkProfileViewController.m
//  ParentControl_CT
//
//  Created by Sakshi on 03/03/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "NetworkProfileViewController.h"
#import "PC_DataManager.h"
#import "HeaderView.h"
#import "RedLabelView.h"
#import "ParentViewProfile.h"
#import "GetProfileDetailsByLoggedID.h"
#import "ShowActivityLoadingView.h"
#import "ParentProfileObject.h"
#import "StripView.h"
#import "NetworkTableViewCell.h"
#import "Settings.h"
#import "ChildNetworkDetailViewController.h"
#import "ImageView.h"
#import "ChildDetailViewController.h"

@interface NetworkProfileViewController ()<HeaderViewProtocol>

@end

@implementation NetworkProfileViewController{
    RedLabelView *label;
    HeaderView *headerView;
    UIScrollView *scrollView;
    int yy;
    int yCord, xCord;
    UIPageControl *pageControl;
    int pageControlHeight;
    UIView *loadElementView;
    ShowActivityLoadingView *loaderView;
    NSMutableArray *parentProfileDetails;
    CGFloat cellHeight;
    CGFloat childrenCellHeight;
    CGFloat headerHeight;
    int tableSection;
    NSMutableArray *childrenProfileDetails;
     UIImage *cellImage;
}
@synthesize table,parentName,settingsButton,cityLabel,addressLabel,profileImage,parentDetailView;
@synthesize stripView,index;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"In Profile view controller");
    yy=0;
    
    [[PC_DataManager sharedManager]getWidthHeight];
    pageControlHeight = (ScreenWidthFactor*20);
    if(!loadElementView)
    {
        loadElementView=[[UIView alloc]initWithFrame:CGRectMake(0,0, screenWidth*1.5, screenHeight)];
        [self.view addSubview:loadElementView];
    }
    
    [self.view setBackgroundColor:appBackgroundColor];
   
    if (screenWidth>700) {
         headerHeight =50;
         cellHeight = 280;
    }
    else{
         headerHeight =35;
         cellHeight = 175;
    }
    childrenCellHeight = 400;
    
    [self drawUiWithHead];
    [self drawHeaderView];
    [self childNameLabel];
    [self getListOfFriends];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
     [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
//    [self drawUiWithHead];
//    [self drawHeaderView];
//    [self childNameLabel];
//    [self getListOfFriends];
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
      if(screenWidth>700)
    {
        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0,ScreenHeightFactor*12,pageControlHeight,pageControlHeight)];
        pageControl.transform = CGAffineTransformMakeScale(2, 2);
    }
    else
    {
        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0,ScreenHeightFactor*12,pageControlHeight,pageControlHeight)];
    }
    
    [pageControl setCenter:CGPointMake(screenWidth/2, pageControl.center.y)];
    pageControl.currentPage=0;
    pageControl.numberOfPages=number_Of_Page;
    [pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
    
    [loadElementView addSubview:pageControl];
}

#pragma mark child
-(void)childNameLabel
{
    [self addLoaderView];
    if(!label)
    {
        if(screenWidth>700)
        {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, yy, ScreenWidthFactor*320, ScreenHeightFactor*12)withChildStr:[PC_DataManager sharedManager].parentObjectInstance.firstName];
            label.center=CGPointMake(screenWidth/2,yy+label.frame.size.height/2);
        }
        else
        {
            label=[[RedLabelView alloc]initWithFrame:CGRectMake(0, yy, ScreenWidthFactor*320, ScreenHeightFactor*12)withChildStr:[PC_DataManager sharedManager].parentObjectInstance.firstName];
            label.center=CGPointMake(screenWidth/2,yy+label.frame.size.height/2);
        }
        
        [self.view addSubview:label];
        yy+=80+label.frame.size.height+15*ScreenHeightFactor;
    }
     [self removeLoaderView];
}


-(void)getListOfFriends {
    [self addLoaderView];
    GetProfileDetailsByLoggedID *getProfileDetailsByLoggedID = [[GetProfileDetailsByLoggedID alloc] init];
    [getProfileDetailsByLoggedID setServiceName:@"PinWiGetProfileDetailsByLoggedID"];
    [getProfileDetailsByLoggedID initService:@{
                                            @"LoggedID":[PC_DataManager sharedManager].parentObjectInstance.parentId,
                                            }];
    
    [getProfileDetailsByLoggedID setDelegate:self];
}
-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection{
    
   NSDictionary *dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetProfileDetailsByLoggedIDResponse" resultKey:@"GetProfileDetailsByLoggedIDResult"];
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
            NSLog(@"Network profile data %@",dict);
            if(!parentProfileDetails) {
                parentProfileDetails = [[NSMutableArray alloc]init];
            }
            else {
                [parentProfileDetails removeAllObjects];
            }
            
            [parentProfileDetails addObject:[arr objectAtIndex:0]];
            
            NSDictionary *dict = [parentProfileDetails objectAtIndex:0];
            UIImage *img = nil;
            NSString *profileImageStr = [dict objectForKey:@"ProfileImage"];
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

            else {
                
                profileImageStr = [profileImageStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if (profileImageStr.length == 0 || [profileImageStr isEqualToString:@"(null)"]) {
                    img =  [UIImage imageNamed:@"notificationProfile-568h@2x.png"];
                }
                else
                {
                    img=[[PC_DataManager sharedManager] decodeImage:profileImageStr];
                }
                
    
            }
            
            [self addParentDetailView:@"My Profile" profileImage:img parentName:[dict objectForKey:@"LoggedUserName"] cityName:[dict objectForKey:@"CityName"] parentAddress:[dict objectForKey:@"ParentAddress"]];
            
            if(!childrenProfileDetails){
                childrenProfileDetails = [[NSMutableArray alloc] init];
            }
            else {
                [childrenProfileDetails removeAllObjects];
            }
            
            for(int i=1;i< arr.count; i++){
                [childrenProfileDetails addObject:[arr objectAtIndex:i]];
            }
            [self removeLoaderView];
            [self addTableView];
        }
}
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
    NSLog(@"Network profile connection error %@",errorMessage);
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
    table = [[UITableView alloc] initWithFrame:CGRectMake(0,parentDetailView.frame.origin.y + parentDetailView.frame.size.height, screenWidth, ScreenHeightFactor*320)];
    //table.center = CGPointMake(screenWidth/2,yy+parentDetailView.frame.size.height+50);
    table.contentInset = UIEdgeInsetsMake(0, 0, 180, 0);
    table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return childrenProfileDetails.count;
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
    StripView *stripView1 = [[StripView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width,27*ScreenHeightFactor)];
    [stripView1 drawStrip:@"Children" color:[UIColor clearColor]];
    [customHeaderView addSubview:stripView1];
   return customHeaderView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   static NSString *cellIdentifier = @"profileCell1";
    NetworkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[NetworkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *childDict;
    
   
    UIImage *img = nil;
        childDict = [childrenProfileDetails objectAtIndex:indexPath.row];
        NSLog(@"index path %ld",(long)indexPath.row);
    NSString *profileImagestr = [childDict objectForKey:@"ProfileImage"];
    if (profileImagestr == (id)[NSNull null] || profileImagestr.length == 0 || [profileImagestr isEqualToString:@"(null)"] || [profileImagestr isEqualToString:@" "]) {
        if (screenWidth>700) {
            img =  [UIImage imageNamed:@"user-iPad.png"];
        }
        else{
            if (screenWidth>320) {
                img =  [UIImage imageNamed:@"user-iPhone6.png"];
            }else{
                img =  [UIImage imageNamed:@"user-iPhone5.png"];
            }
        }
        
    }
    else {
        profileImagestr = [profileImagestr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (profileImagestr.length == 0 || [profileImagestr isEqualToString:@"(null)"]) {
            img = [UIImage imageNamed:@"childDefaultImage-568h@2x.png"];
        }
        else
        {
            img=[[PC_DataManager sharedManager] decodeImage:profileImagestr];
        }
        
    }

    
    [cell addChildCredential:[childDict objectForKey:@"ChildName"] profileImage:img childAge:[childDict objectForKey:@"Age"] childDob:[childDict objectForKey:@"DateOfBirth"] childSchool:[childDict objectForKey:@"SchoolName1"] pinwiConnections:[childDict objectForKey:@"PinWiConnection"] cellHeight:cellHeight];
    
    
    cell.networkButton.tag = indexPath.row;
    index = cell.networkButton.tag;

//    [cell.networkButton setUserInteractionEnabled:YES];
//    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(networkButtonTapped:)];
//    [profileImage addGestureRecognizer:gestureRecognizer];
    
    [cell.networkButton addTarget:self action:@selector(networkButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    

      [cell addChildCredential:[childDict objectForKey:@"ChildName"] profileImage:img childAge:[childDict objectForKey:@"Age"] childDob:[childDict objectForKey:@"DateOfBirth"] childSchool:[childDict objectForKey:@"SchoolName1"] pinwiConnections:[childDict objectForKey:@"PinWiConnection"] cellHeight:cellHeight];
    

    return cell ;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [childrenProfileDetails objectAtIndex:indexPath.row];
     [table deselectRowAtIndexPath:indexPath animated:YES];
    NSNumber* num = [dict objectForKey:@"ChildID"];
    int fnum = [num intValue];
    
    ChildDetailViewController *childDetailViewController = [[ChildDetailViewController alloc] init];
    childDetailViewController.ChildId = *(&(fnum));
    [self.navigationController pushViewController:childDetailViewController animated:YES ];
}

-(void)addParentDetailView:(NSString*)title profileImage:(UIImage*)image parentName:(NSString*)name cityName:(NSString*)city parentAddress:(NSString*)address{
    
    
    if (screenWidth>700) {

        parentDetailView = [[UIView alloc] initWithFrame:CGRectMake(10*ScreenWidthFactor,yy+90, screenWidth, ScreenHeightFactor*150)];
        parentDetailView.center = CGPointMake(screenWidth/2,yy+90);
    
    }
    else{
        yy += 6;;
        parentDetailView = [[UIView alloc] initWithFrame:CGRectMake(10*ScreenWidthFactor,yy, screenWidth, ScreenHeightFactor*160)];
        parentDetailView.center = CGPointMake(screenWidth/2,yy);
    }
    [self.view addSubview:parentDetailView];
     stripView = [[StripView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width,27*ScreenHeightFactor)];
    [stripView drawStrip:title color:[UIColor clearColor]];
    [parentDetailView addSubview:stripView];
    
    cellImage = image;
    profileImage = [[UIImageView alloc] init];
    profileImage.frame=CGRectMake(cellPadding+10, ScreenHeightFactor*30, ScreenHeightFactor*48, ScreenHeightFactor*48);
    profileImage.image=image;
    profileImage.center=CGPointMake(profileImage.center.x,parentDetailView.frame.size.height/2- stripView.frame.size.height/4);
    profileImage.layer.cornerRadius = profileImage.frame.size.width/2;
    profileImage.layer.masksToBounds = YES;
    profileImage.layer.borderWidth = 0;
    profileImage.contentMode=UIViewContentModeScaleAspectFill;
    
    [profileImage setUserInteractionEnabled:YES];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchImage:)];
    [profileImage addGestureRecognizer:gestureRecognizer];
    
    [parentDetailView addSubview:profileImage];
    
    
    parentName = [[UILabel alloc] init];
    parentName.text=name;
    if (screenWidth>700) {
        parentName.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor *50,parentDetailView.frame.size.width-profileImage.frame.size.width+10,20);
        parentName.center=CGPointMake(parentName.center.x,parentName.center.y);
    }
    else{
        parentName.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*50,parentDetailView.frame.size.width-profileImage.frame.size.width+10,20);
        parentName.center=CGPointMake(parentName.center.x,parentName.center.y);
    }
    
    parentName.font=[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
    parentName.textColor=[UIColor blackColor];
    [parentName sizeToFit];
    [parentDetailView addSubview:parentName];
    
    settingsButton = [[UIButton alloc] init];
    [parentDetailView addSubview:settingsButton];
    
    if (screenWidth>700) {

        settingsButton.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-145,ScreenHeightFactor*30,125,ScreenHeightFactor*30);
        settingsButton.center=CGPointMake(settingsButton.center.x,parentDetailView.frame.size.height/2 - stripView.frame.size.height/2 );
      
    }
    else{
        settingsButton.frame=CGRectMake([UIScreen mainScreen].bounds.size.width-80,ScreenHeightFactor*20,60,ScreenHeightFactor*30);
        settingsButton.center=CGPointMake(settingsButton.center.x,parentDetailView.frame.size.height/2-10);
    
    }
    [settingsButton setTitleColor:textBlueColor forState:UIControlStateNormal];
      [settingsButton.layer setBorderWidth:1.0f];
    settingsButton.titleLabel.font = [UIFont fontWithName:RobotoBold size:10*ScreenHeightFactor];
    
    [settingsButton.layer setBorderColor:textBlueColor.CGColor];
    [settingsButton setTitle:@"Settings" forState:UIControlStateNormal ];
    [settingsButton addTarget:self action:@selector(settingsButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    
    cityLabel =[[UILabel alloc] init];
    [parentDetailView addSubview:cityLabel];
    cityLabel.font=[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
    cityLabel.text=city;
    if (screenWidth>700) {
        cityLabel.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,parentName.frame.size.height + parentName.frame.origin.y,parentDetailView.frame.size.width-profileImage.frame.size.width+10,30);
        cityLabel.center=CGPointMake(cityLabel.center.x,cityLabel.center.y);
    }
    else{
        cityLabel.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,parentName.frame.size.height + parentName.frame.origin.y,parentDetailView.frame.size.width-profileImage.frame.size.width+10,20);
         cityLabel.center=CGPointMake(cityLabel.center.x,cityLabel.center.y);
    }

    cityLabel.textColor=[UIColor grayColor];
    
    addressLabel =[[UILabel alloc] initWithFrame:CGRectZero];
    addressLabel.numberOfLines = 0;
    addressLabel.text = address;
    addressLabel.textAlignment = NSTextAlignmentLeft;
    addressLabel.font=[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
    
   // [addressLabel sizeThatFits:CGSizeMake(screenWidth-profileImage.frame.size.width, MAXFLOAT)];
    CGRect frame = [addressLabel.text boundingRectWithSize:CGSizeMake(screenWidth-profileImage.frame.size.width -10*ScreenWidthFactor, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                            attributes:@{NSFontAttributeName:addressLabel.font}
                                               context:nil];
    
    if (screenWidth>700) {
        
        
        
        addressLabel.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,cityLabel.frame.size.height + cityLabel.frame.origin.y,parentDetailView.frame.size.width-profileImage.frame.size.width+10,30);
        //addressLabel.center=CGPointMake(addressLabel.center.x,ScreenHeightFactor*100);
    }
    else{
        addressLabel.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*90,frame.size.width,frame.size.height);
        
//        addressLabel.frame=CGRectMake(ScreenWidthFactor*10+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*100,parentDetailView.frame.size.width-profileImage.frame.size.width-20,30);
//        addressLabel.center=CGPointMake(addressLabel.center.x,ScreenHeightFactor*100);
    }
    
    addressLabel.textColor=[UIColor grayColor];
    [parentDetailView addSubview:addressLabel];
    
    yy += addressLabel.frame.origin.y + addressLabel.frame.size.height - parentDetailView.frame.size.height*.7;
   // yy += parentDetailView.frame.size.height + 10;

}

-(void)settingsButtonTouched:(UIButton*)sender{
    Settings *settingsObj = [[Settings alloc] init];
    settingsObj.hidesBottomBarWhenPushed =YES;
    settingsObj.rootViewController = @"NetworkProfileViewController";
    settingsObj.isComingFromNatwork = YES;
    [self.navigationController pushViewController:settingsObj animated:YES];
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

-(void)networkButtonTapped:(UIButton*)sender{
    
    
    NSDictionary *dict = [childrenProfileDetails objectAtIndex:sender.tag];
    NSNumber* num = [dict objectForKey:@"ChildID"];
    int fnum = [num intValue];
    NSInteger num1 = [[dict valueForKey:@"PinWiConnection"] integerValue];
    
    NSDictionary *dict1 = [parentProfileDetails objectAtIndex:0];
    NSNumber* numParent = [dict1 objectForKey:@"ProfileID"];
    int fnumParent = [numParent intValue];
    
    ChildNetworkDetailViewController *childNetworkDetailViewController = [[ChildNetworkDetailViewController alloc] init];
    childNetworkDetailViewController.childId = fnum;
    childNetworkDetailViewController.childName = [dict valueForKey:@"ChildName"];
    childNetworkDetailViewController.numberOfConnections = num1;
    childNetworkDetailViewController.loggedId = fnumParent;
    [self.navigationController pushViewController:childNetworkDetailViewController animated:NO];

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
