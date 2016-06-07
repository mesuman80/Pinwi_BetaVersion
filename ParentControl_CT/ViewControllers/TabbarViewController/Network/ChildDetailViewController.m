//
//  ChildDetailViewController.m
//  ParentControl_CT
//
//  Created by Sakshi on 07/03/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "ChildDetailViewController.h"
#import "PC_DataManager.h"
#import "NetworkTableViewCell.h"
#import "GetChildDetailsByChildID.h"
#import "GetExhilaratorsListByChildID.h"
#import "ExhilaratorsCell.h"
#import "ExhilaratorViewController.h"


@interface ChildDetailViewController ()<HeaderViewProtocol,UrlConnectionDelegate,InterestDriverProtocol>

@end

@implementation ChildDetailViewController
{
    NSDictionary *exhilaratorDict;
}

@synthesize stripView,stripView1,childDetailView,frame;
@synthesize childDetailArray,friendsChildDetailArray,exhiliratorDetailArray;
@synthesize tabBarCtrl,loaderView,loadElementView,yCord,yy,xCord,cellHeight,headerHeight;
@synthesize label,headerView,scrollView,pageControl,pageControlHeight,ChildId;
@synthesize profileImage,childName,ageLabel,siblingLabel,familyConnectionLabel,statusButton,parentName;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLoaderView];
    
    [[PC_DataManager sharedManager]getWidthHeight];
    pageControlHeight = (ScreenWidthFactor*20);
    if(!loadElementView)
    {
        loadElementView=[[UIView alloc]initWithFrame:CGRectMake(0,0, screenWidth*1.5, screenHeight)];
        [self.view addSubview:loadElementView];
    }
    
    [self.view setBackgroundColor:appBackgroundColor];
    
    childDetailArray = [[NSMutableArray alloc]init];
    friendsChildDetailArray = [[NSMutableArray alloc] init];
    exhiliratorDetailArray = [[NSMutableArray alloc] init];
    cellHeight = 150;
    headerHeight = 50;
    
    [self drawUiWithHead];
    [self drawHeaderView];
    [self childNameLabel];
    [self getChildDetail];
    
    [self performSelector:@selector(getExhilaratorsDetail) withObject:nil afterDelay:0.5];
   
    
    NSLog(@"ChildID is: %d",ChildId);
    
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
//    [self drawUiWithHead];
//    [self drawHeaderView];
//    [self childNameLabel];
//    [self getChildDetail];
//    [self getExhilaratorsDetail ];
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
    [self addLoaderView];
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
-(void)getChildDetail {
    
    GetChildDetailsByChildID *getChildDetailsByChildID = [[GetChildDetailsByChildID alloc] init];
    [getChildDetailsByChildID setServiceName:@"PinWiGetChildDetailsByChildID"];
    [getChildDetailsByChildID initService:@{
                                              @"LoggedID":[PC_DataManager sharedManager].parentObjectInstance.parentId,
                                              @"ChildID":[NSNumber numberWithInt:ChildId]
                                              }];
    
    [getChildDetailsByChildID setDelegate:self];
    
}

-(void)getExhilaratorsDetail {
    
    
    
    GetExhilaratorsListByChildID *getExhilaratorsListByChildID = [[GetExhilaratorsListByChildID alloc] init];
    [getExhilaratorsListByChildID setServiceName:@"PinWiGetExhilaratorsListByChildID"];
    [getExhilaratorsListByChildID initService:@{
                                            @"LoggedID":[PC_DataManager sharedManager].parentObjectInstance.parentId,
                                            @"ChildID":[NSNumber numberWithInt:ChildId]
                                            }];
    
    [getExhilaratorsListByChildID setDelegate:self];
    
}


-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
    
    NSLog(@"GetChildDetailsByChildID error message %@",errorMessage);
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection{
    
    
    NSDictionary *dict;
    
    NSLog(@"Service name inside network detail view = %@",connection.serviceName);
    
    if ([connection.serviceName isEqualToString:@"PinWiGetChildDetailsByChildID"]) {
        dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetChildDetailsByChildIDResponse" resultKey:@"GetChildDetailsByChildIDResult"];
        
        [childDetailArray removeAllObjects];
        
        if (!dict) {
//            return;
            [self addChildDetailView:@"Child Detail" profileImage:nil parentName:@"" childName:@"" childAge:0 childDob:@"" childSiblings:@"" familyConnection:@""];
        }
        
        if (dict && [dict isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray *)dict;
            NSDictionary *dictionary = [arr firstObject];
            if([dictionary valueForKey:@"ErrorDesc"]) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:[dictionary valueForKey:@"ErrorDesc"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            else{
                [arr enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
                    [childDetailArray addObject:dictionary];
                }];
                NSLog(@"GetChildDetailsByChildID data: %@",dict);
            }
            
            NSDictionary *childDict = [childDetailArray objectAtIndex:0];
            NSNumber* num = [childDict objectForKey:@"Age"];
            int fnum = [num intValue];
            
            UIImage *img = nil;
            NSString *profileImageStr = [childDict objectForKey:@"ProfileImage"];
            if (profileImageStr == (id)[NSNull null] || profileImageStr.length == 0 || [profileImageStr isEqualToString:@"(null)"] || [profileImageStr isEqualToString:@" "]) {
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
                
            }            else {
                
                img=[[PC_DataManager sharedManager] decodeImage:profileImageStr];
            }
            
            
            [self addChildDetailView:@"Child Detail" profileImage:img parentName:[childDict objectForKey:@"ParentName"] childName:[childDict objectForKey:@"ChildName"] childAge:fnum childDob:[childDict objectForKey:@"DateOfBirth"] childSiblings:[childDict objectForKey:@"Siblings"] familyConnection:[childDict objectForKey:@"FamilyConnection"]];
            
            
        }

    }
    else if ([connection.serviceName isEqualToString:@"PinWiGetExhilaratorsListByChildID"])
    {
        dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetExhilaratorsListByChildIDResponse" resultKey:@"GetExhilaratorsListByChildIDResult"];
        [exhiliratorDetailArray removeAllObjects];
       
       
        if (!dict) {
  //          return;
            [self addNoExhilaratorView];
        }
        
        if (dict && [dict isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray *)dict;
            NSDictionary *dictionary = [arr firstObject];
            
           
            if([dictionary valueForKey:@"ErrorDesc"]) {
               [self addNoExhilaratorView];
                
            }
            else{
                [arr enumerateObjectsUsingBlock:^(NSDictionary *dictionary, NSUInteger idx, BOOL * _Nonnull stop) {
                    [exhiliratorDetailArray addObject:dictionary];
                }];
                exhilaratorDict = dict;
                NSLog(@"GetExhilaratorsListByChildID data: %@",dict);
                NSDictionary *childDict = [childDetailArray objectAtIndex:0];
                 [self addExhilaratorView:[childDict valueForKey:@"ChildName"]];
            }
           
        }
        [self removeLoaderView];
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


-(void)addChildDetailView:(NSString*)title profileImage:(UIImage*)image parentName:(NSString*)pname childName:(NSString*)name childAge:(NSInteger)age childDob:(NSString*)dob childSiblings:(NSString*)siblings familyConnection:(NSString*)connection {
    
    childDetailView = [[UIView alloc] init];
    if (screenWidth>700) {
        if(siblings.length >30)
        {
            childDetailView.frame = CGRectMake(0,label.frame.origin.y+label.frame.size.height+20, self.view.frame.size.width, ScreenHeightFactor*190);
            
        }
        else
        {
            childDetailView.frame = CGRectMake(0,label.frame.origin.y+label.frame.size.height+20, self.view.frame.size.width, ScreenHeightFactor*160);
            
        }
        //childDetailView.frame = CGRectMake(0,label.frame.origin.y+label.frame.size.height+20, self.view.frame.size.width, ScreenHeightFactor*190);
        childDetailView.center = CGPointMake(childDetailView.center.x,childDetailView.center.y);
    }
    else{
        if(siblings.length >30)
        {
            childDetailView.frame = CGRectMake(0,label.frame.origin.y+label.frame.size.height+20, self.view.frame.size.width, ScreenHeightFactor*250);
            
        }
        else
        {
            childDetailView.frame = CGRectMake(0,label.frame.origin.y+label.frame.size.height+20, self.view.frame.size.width, ScreenHeightFactor*200);
            
        }
        childDetailView.center = CGPointMake(childDetailView.center.x,childDetailView.center.y);
    }
    
    [self.view addSubview:childDetailView];
    stripView = [[StripView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width,27*ScreenHeightFactor)];
    [stripView drawStrip:title color:[UIColor clearColor]];
    [childDetailView addSubview:stripView];
    
    profileImage = [[UIImageView alloc] init];
    if (screenWidth>700) {
        profileImage.frame=CGRectMake(childDetailView.frame.size.width/2-312, childDetailView.frame.size.height/2-50, ScreenHeightFactor*48, ScreenHeightFactor*48);
        
        profileImage.center=CGPointMake(childDetailView.frame.size.width/2-312,childDetailView.frame.size.height/2-50);
    }
    else{
    if (screenWidth>320) {
        profileImage.frame=CGRectMake(childDetailView.frame.size.width-300, childDetailView.frame.size.height/2, ScreenHeightFactor*48, ScreenHeightFactor*48);
       
        profileImage.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2-150,childDetailView.frame.size.height/2-25);
    }
    else{
    profileImage.frame=CGRectMake(childDetailView.frame.size.width-280, childDetailView.frame.size.height/2, ScreenHeightFactor*48, ScreenHeightFactor*48);
    profileImage.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2-120,childDetailView.frame.size.height/2-25);
    }
    }
    
    profileImage.image=image;
    profileImage.layer.cornerRadius = profileImage.frame.size.width/2;
    profileImage.layer.masksToBounds = YES;
    profileImage.layer.borderWidth = 0;
    profileImage.contentMode=UIViewContentModeScaleAspectFill;
    [childDetailView addSubview:profileImage];
    
    
    childName = [[UILabel alloc] init];
    if(name.length>20)
    {
        name = [name substringToIndex:19];
        name = [name stringByAppendingString:@"...."];
    }
    childName.text=name;
    if (screenWidth>700) {
        childName.frame=CGRectMake(ScreenWidthFactor*20+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*40,childDetailView.frame.size.width-profileImage.frame.size.width+10,20);
        childName.center=CGPointMake(childName.center.x,ScreenHeightFactor*40);
    }
    else{
        childName.frame=CGRectMake(ScreenWidthFactor*20+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*50,childDetailView.frame.size.width-profileImage.frame.size.width+10,20);
       childName.center=CGPointMake(childName.center.x,ScreenHeightFactor*50);
    }
    
    childName.font=[UIFont fontWithName:RobotoRegular size:17*ScreenHeightFactor];
    childName.textColor=[UIColor blackColor];
    [childName sizeToFit];
    [childDetailView addSubview:childName];
    
    parentName = [[UILabel alloc] init];
    
    if (screenWidth>700) {
        parentName.frame=CGRectMake(ScreenWidthFactor*20+profileImage.frame.origin.x+profileImage.frame.size.width,childName.center.y+20,childDetailView.frame.size.width-profileImage.frame.size.width+10,20);
        parentName.center=CGPointMake(parentName.center.x,childName.center.y+20);
    }
    else{
        parentName.frame=CGRectMake(ScreenWidthFactor*20+profileImage.frame.origin.x+profileImage.frame.size.width,childName.center.y+30,childDetailView.frame.size.width-profileImage.frame.size.width+10,20);
        parentName.center=CGPointMake(parentName.center.x,childName.center.y+30);
    }
    
    parentName.font=[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
    NSString *pStr = @"Parent: ";
    pStr = [pStr stringByAppendingString:pname];
    parentName.text=pStr;
    parentName.textColor=[UIColor grayColor];
    [parentName sizeToFit];
    [childDetailView addSubview:parentName];
    
    ageLabel = [[UILabel alloc] init];
    NSString *str = @" Years Old,";
    NSString *str1 = @" Born on: ";
    NSString *ageString = [NSString stringWithFormat:@"%ld",(long)age];
    ageString = [ageString stringByAppendingString:str];
    str1 = [str1 stringByAppendingString:dob];
    ageString = [ageString stringByAppendingString: str1];
    
    ageLabel.text=ageString;
    if (screenWidth>700) {
        ageLabel.frame=CGRectMake(ScreenWidthFactor*20+profileImage.frame.origin.x+profileImage.frame.size.width,parentName.center.y+20,childDetailView.frame.size.width-profileImage.frame.size.width+10,20);
        ageLabel.center=CGPointMake(ageLabel.center.x,parentName.center.y+20);
    }
    else{
        ageLabel.frame=CGRectMake(ScreenWidthFactor*20+profileImage.frame.origin.x+profileImage.frame.size.width,parentName.frame.size.height +parentName.frame.origin.y,childDetailView.frame.size.width-profileImage.frame.size.width+10,20);
        ageLabel.center=CGPointMake(ageLabel.center.x,ageLabel.center.y);
    }
    
    ageLabel.font=[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
    ageLabel.textColor=[UIColor grayColor];
    [ageLabel sizeToFit];
    [childDetailView addSubview:ageLabel];

    siblingLabel =[[UILabel alloc] init];
    [childDetailView addSubview:siblingLabel];
    siblingLabel.font=[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
    NSString *siblingsInfo = @"Siblings: ";
    siblingsInfo = [siblingsInfo stringByAppendingString:siblings];
    siblingLabel.text=siblingsInfo;
    siblingLabel.numberOfLines = 0;
    NSInteger startX = childDetailView.frame.size.width-profileImage.frame.size.width-ScreenWidthFactor*30 - profileImage.frame.origin.x;
    CGSize constarintSize = CGSizeMake(startX, childDetailView.frame.size.height-childName.frame.size.height-parentName.frame.size.height-ageLabel.frame.size.height - 100);
  
    
    frame = [siblingLabel.text boundingRectWithSize:constarintSize options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:siblingLabel.font} context:nil];
    if (screenWidth>700) {


        if (frame.size.height > 40) {
            siblingLabel.frame=CGRectMake(ScreenWidthFactor*20+profileImage.frame.origin.x+profileImage.frame.size.width,ageLabel.frame.size.height +ageLabel.frame.origin.y+ScreenHeightFactor*10,frame.size.width,frame.size.height);
            
        }else{
            siblingLabel.frame=CGRectMake(ScreenWidthFactor*20+profileImage.frame.origin.x+profileImage.frame.size.width,ageLabel.frame.size.height +ageLabel.frame.origin.y+ScreenHeightFactor*10,frame.size.width,frame.size.height);
        }

    }
    else{



         siblingLabel.frame=CGRectMake(ScreenWidthFactor*20+profileImage.frame.origin.x+profileImage.frame.size.width,ageLabel.frame.size.height +ageLabel.frame.origin.y+ScreenHeightFactor*10,frame.size.width,frame.size.height);

    }
    siblingLabel.textColor=[UIColor grayColor];
    
    familyConnectionLabel =[[UILabel alloc] init];
    [childDetailView addSubview:familyConnectionLabel];
    familyConnectionLabel.font=[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
    NSString *family = @"Family Connection: ";
    family = [family stringByAppendingString:connection];
    familyConnectionLabel.text=family;
    if (screenWidth>700) {

        familyConnectionLabel.frame=CGRectMake(ScreenWidthFactor*20+profileImage.frame.origin.x+profileImage.frame.size.width,siblingLabel.frame.size.height +siblingLabel.frame.origin.y,childDetailView.frame.size.width-profileImage.frame.size.width+10,30);
        familyConnectionLabel.center=CGPointMake(familyConnectionLabel.center.x,familyConnectionLabel.center.y);
    }
    else{
        familyConnectionLabel.frame=CGRectMake(ScreenWidthFactor*20+profileImage.frame.origin.x+profileImage.frame.size.width,siblingLabel.frame.size.height +siblingLabel.frame.origin.y+ScreenHeightFactor*5,childDetailView.frame.size.width-profileImage.frame.size.width*1.5,40);
        familyConnectionLabel.center=CGPointMake(familyConnectionLabel.center.x,familyConnectionLabel.center.y);
        
        }
    familyConnectionLabel.numberOfLines =3;
    familyConnectionLabel.textColor=[UIColor grayColor];
    

}
-(void)addExhilaratorView:(NSString*)childNameA{
    
   UIView *exhilaratorView = [[UIView alloc] init];
   
    self.childName1 = childNameA;
    if (screenWidth>700) {

        exhilaratorView.frame = CGRectMake(0,childDetailView.frame.size.height +childDetailView.frame.origin.y , self.view.frame.size.width, ScreenHeightFactor*170);
        exhilaratorView.center = CGPointMake(exhilaratorView.center.x,exhilaratorView.center.y);

    }
    else{

        
        exhilaratorView.frame = CGRectMake(0,childDetailView.frame.size.height +childDetailView.frame.origin.y , self.view.frame.size.width, ScreenHeightFactor*170);
        exhilaratorView.center = CGPointMake(exhilaratorView.center.x,exhilaratorView.center.y);


    }
    
    [self.view addSubview:exhilaratorView];
    self.stripView1 = [[StripView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width,27*ScreenHeightFactor)];
    [stripView1 drawStrip:@"Exhilarators" color:[UIColor clearColor]];
    [exhilaratorView addSubview:stripView1];
    int circleCount = (int)exhiliratorDetailArray.count;
    int xx;
    if (screenWidth>700) {
        xx = exhilaratorView.frame.size.width/2-300;
    }else{
        xx = 0;
    }
    
    int xxc = 0;
    
    for (int i=0; i<circleCount; i++) {
        
        profileImage = [[UIImageView alloc] init];
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2;
        profileImage.layer.masksToBounds = YES;
        profileImage.layer.borderWidth = 0;
        profileImage.contentMode=UIViewContentModeScaleAspectFill;
        if (screenWidth>700) {
            profileImage.frame=CGRectMake(xx, exhilaratorView.frame.size.height/2-15, ScreenHeightFactor*48, ScreenHeightFactor*48);
            profileImage.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2-(325-xxc),exhilaratorView.frame.size.height/2-12);
        }else{
        if (screenWidth>320) {
            profileImage.frame=CGRectMake(xx, exhilaratorView.frame.size.height/2-15, ScreenHeightFactor*48, ScreenHeightFactor*48);
            profileImage.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2-(150-xxc),exhilaratorView.frame.size.height/2-15);
        }
        else {
            profileImage.frame=CGRectMake(xx+15, exhilaratorView.frame.size.height/2-15, ScreenHeightFactor*48, ScreenHeightFactor*48);
            profileImage.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2-(130-xxc),exhilaratorView.frame.size.height/2-15);
        }
        }
        NSDictionary *dict = [exhiliratorDetailArray objectAtIndex:i];
        if (screenWidth>700) {
            
            NSInteger interestTraitID = [[dict objectForKey:@"InterestTraitID"] integerValue];
            NSString *img = [[NSString stringWithFormat:@"%ld",(long)interestTraitID] stringByAppendingString:@"~ipad.png"];
            NSLog(@"%@",img);
            profileImage.image=[UIImage imageNamed:img];
            NSLog(@"%f",profileImage.center.x);
        }
        else{
            if (screenWidth>320) {
                NSInteger interestTraitID = [[dict objectForKey:@"InterestTraitID"] integerValue];
                NSString *img = [[NSString stringWithFormat:@"%ld",(long)interestTraitID] stringByAppendingString:@"-667h@2x.png"];
                NSLog(@"%@",img);
                profileImage.image=[UIImage imageNamed:img];
                NSLog(@"%f",profileImage.center.x);
            }
            else{
                NSInteger interestTraitID = [[dict objectForKey:@"InterestTraitID"] integerValue];
                NSString *img = [[NSString stringWithFormat:@"%ld",(long)interestTraitID] stringByAppendingString:@"-568h@2x.png"];
                NSLog(@"%@",img);
                profileImage.image=[UIImage imageNamed:img];
                NSLog(@"%f",profileImage.center.x);
            }
        }
           
//        }
        
        xx += profileImage.frame.size.width+10;
        xxc +=profileImage.frame.size.width+10;
        [exhilaratorView addSubview:profileImage];
    }
    
    UIButton *arrowButton;
    if (screenWidth>700) {
        arrowButton = [[UIButton alloc] initWithFrame:CGRectMake(exhilaratorView.frame.size.width/2+620, exhilaratorView.frame.size.height/2-15, ScreenHeightFactor*30, ScreenHeightFactor*30)];
        arrowButton.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2+350,exhilaratorView.frame.size.height/2-15);

    }else{
    
    if (screenWidth>320) {
       arrowButton = [[UIButton alloc] initWithFrame:CGRectMake(exhilaratorView.frame.size.width/2+320, exhilaratorView.frame.size.height/2-15, ScreenHeightFactor*30, ScreenHeightFactor*30)];
        arrowButton.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2+170,exhilaratorView.frame.size.height/2-15);
    }
    else{
        arrowButton = [[UIButton alloc] initWithFrame:CGRectMake(exhilaratorView.frame.size.width/2+300, exhilaratorView.frame.size.height/2-15, ScreenHeightFactor*30, ScreenHeightFactor*30)];
        arrowButton.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2+150,exhilaratorView.frame.size.height/2-15);
    }
    }
    
    [arrowButton setImage:[UIImage imageNamed:@"grayArrow-568h@2x.png"] forState:UIControlStateNormal];
    [arrowButton addTarget:self action:@selector(arrowButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [exhilaratorView addSubview:arrowButton];
    
    [exhilaratorView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arrowButtonTouched:)];
    tapGesture.numberOfTapsRequired = 1;
    [exhilaratorView addGestureRecognizer:tapGesture];
}

-(void)arrowButtonTouched:(UIButton*)sender{
    ExhilaratorViewController *exhilaratorViewController=[[ExhilaratorViewController alloc]init];
    exhilaratorViewController.childName = self.childName1;
    exhilaratorViewController.dataDictionary = exhilaratorDict;
    [self.navigationController pushViewController:exhilaratorViewController animated:YES];
}

-(void)addNoExhilaratorView{
  
    
    UIView *noExhilaratorView = [[UIView alloc] init];
    if (screenWidth>700) {

        noExhilaratorView.frame = CGRectMake(0,childDetailView.frame.size.height + childDetailView.frame.origin.y, self.view.frame.size.width, ScreenHeightFactor*170);
        noExhilaratorView.center = CGPointMake(noExhilaratorView.center.x,noExhilaratorView.center.y);
    }
    else{
        
        noExhilaratorView.frame = CGRectMake(0,childDetailView.frame.size.height + childDetailView.frame.origin.y, self.view.frame.size.width, ScreenHeightFactor*170);
        noExhilaratorView.center = CGPointMake(noExhilaratorView.center.x,noExhilaratorView.center.y);
    }
    [self.view addSubview:noExhilaratorView];
    self.stripView1 = [[StripView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width,27*ScreenHeightFactor)];
    [stripView1 drawStrip:@"Exhilarators" color:[UIColor clearColor]];
    [noExhilaratorView addSubview:stripView1];
    
    profileImage = [[UIImageView alloc] init];
    
    if (screenWidth>700) {
        profileImage.frame=CGRectMake(childDetailView.frame.size.width/2-312, childDetailView.frame.size.height/2-50, ScreenHeightFactor*48, ScreenHeightFactor*48);
        
        profileImage.center=CGPointMake(childDetailView.frame.size.width/2-312,childDetailView.frame.size.height/2-50);
    }
    else{
    if (screenWidth>320) {
        profileImage.frame=CGRectMake(noExhilaratorView.frame.size.width/2-310, ScreenHeightFactor*10, ScreenHeightFactor*48, ScreenHeightFactor*48);
        profileImage.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2-140,noExhilaratorView.frame.size.height/2-30);
    }
    else{
        profileImage.frame=CGRectMake(noExhilaratorView.frame.size.width/2-300, ScreenHeightFactor*10, ScreenHeightFactor*48, ScreenHeightFactor*48);
        profileImage.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2-120,noExhilaratorView.frame.size.height/2-30);
    }
    }

        if (screenWidth>700) {
            profileImage.image =  [UIImage imageNamed:@"user-iPad.png"];
        }
        else{
            if (screenWidth>320) {
                profileImage.image =  [UIImage imageNamed:@"user-iPhone6.png"];
            }else{
                profileImage.image =  [UIImage imageNamed:@"user-iPhone5.png"];
            }
        }
    profileImage.layer.cornerRadius = profileImage.frame.size.width/2;
    profileImage.layer.masksToBounds = YES;
    profileImage.layer.borderWidth = 0;
    profileImage.contentMode=UIViewContentModeScaleAspectFill;
    [noExhilaratorView addSubview:profileImage];
    
    childName = [[UILabel alloc] init];
    childName.text=@"Errr...!";
    if (screenWidth>700) {
        childName.frame=CGRectMake(ScreenWidthFactor*20+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*40,childDetailView.frame.size.width-profileImage.frame.size.width+10,20);
        childName.center=CGPointMake(childName.center.x,ScreenHeightFactor*40);
    }
    else{
        childName.frame=CGRectMake(ScreenWidthFactor*20+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*50,childDetailView.frame.size.width-profileImage.frame.size.width+10,20);
        childName.center=CGPointMake(childName.center.x,ScreenHeightFactor*50);
    }
    
    childName.font=[UIFont fontWithName:RobotoRegular size:17*ScreenHeightFactor];
    childName.textColor=[UIColor blackColor];
    [childName sizeToFit];
    [noExhilaratorView addSubview:childName];
    
    parentName = [[UILabel alloc] init];
    parentName.numberOfLines=4;
    parentName.text=@"There are no Exhilarators to display for this child at the moment.";
    if (screenWidth>700) {
        parentName.frame=CGRectMake(ScreenWidthFactor*20+profileImage.frame.origin.x+profileImage.frame.size.width,childName.center.y+40,childDetailView.frame.size.width/2+10,50);
        parentName.center=CGPointMake(parentName.center.x,childName.center.y+40);
    }
    else{
        parentName.frame=CGRectMake(ScreenWidthFactor*20+profileImage.frame.origin.x+profileImage.frame.size.width,ScreenHeightFactor*70+childName.frame.size.height,childDetailView.frame.size.width/2+10,50);
        parentName.center=CGPointMake(parentName.center.x,ScreenHeightFactor*70+childName.frame.size.height);
    }
    
    parentName.font=[UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
    parentName.textColor=[UIColor grayColor];
    [parentName sizeToFit];
    [noExhilaratorView addSubview:parentName];
    [self removeLoaderView];
    
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
