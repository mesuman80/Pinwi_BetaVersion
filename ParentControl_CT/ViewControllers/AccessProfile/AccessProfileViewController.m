//
//  AccessProfileViewController.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 29/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "AccessProfileViewController.h"
#import "ShowActivityLoadingView.h"
#import "RecoverPasscode.h"
#import "OverLayView.h"
#import "GetChildSubjectActiviesByDay.h"
#import "GetChildAfterSchoolActiviesByDay.h"
#import "Constant.h"
#import "GetCurrentDayRatingStatus.h"
#import "MenuSettingsView.h"
#import "HeaderView.h"
#import "TutorialPlayView.h"
#import "PlayFirstTimeChildTutorial_VC.h"
#import "StripView.h"
#import "ChildDashboardViewController.h"



@interface AccessProfileViewController ()<AddPassCodeDelegate,OverLayProtocol,UrlConnectionDelegate,HeaderViewProtocol,UIGestureRecognizerDelegate>

@end
@implementation AccessProfileViewController
{
    UIImageView *navBgBar,*topStrip,*centerIcon,*moreImg,*footStrip;
    NSMutableArray *accessProfileArray;
    UITableViewCell *tableCell;
    GetNamesByParentID *getNamesByParentID;
    
    NSMutableArray *fillFromServer;
    ShowActivityLoadingView *loaderView;
    AddPassCode *add;
    //RecoverPasscode *forgotPasscode;
    //UIView *translucentView;
    //BOOL isPasscode;
    NSMutableArray *getAllData;
    
    MenuSettingsView *menu;
    BOOL isToggleMenu;
    HeaderView *headerView ;
    
    UIView *loadElementView;
    
    UIView *removeMenuView;
    
    int statusCountToRate;
    UIImageView *userImage;
    UIImageView *arrowImgView;
    UILabel *nameLabel;
    int yy;
    CGFloat headerHeight;
    StripView *stripView;
    UIView *lockScreen;
}

@synthesize accessTable;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=appBackgroundColor;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
     self.navigationController.navigationBarHidden=YES;
    
    [[PC_DataManager sharedManager]getWidthHeight];
    self.title=@"Access your profile";
    self.view.backgroundColor=appBackgroundColor;
    
    if (screenWidth>700) {
        headerHeight = 40;;
    }
    else{
        headerHeight = 30;;
    }

    
    if(!loadElementView)
    {
        loadElementView=[[UIView alloc]initWithFrame:CGRectMake(0,0, screenWidth*1.5, screenHeight)];
        [loadElementView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:loadElementView];
    }
    
    [self drawHeaderImage];
    [self drawCenterIcon];
    [self moreIcon];
//    [self initTable];
    //[self fillData];
 //   [self drawFooterImage];
    [self pageHeading];
   // statusCountToRate  = -1;
    getAllData = [[NSMutableArray alloc]init];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.view.backgroundColor=appBackgroundColor;
    self.navigationController.navigationBarHidden=YES;
    [self drawCenterIcon];
    [self getParentAndChild];
    //  self.navigationItem.title=@"Acces Your Profile";
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    if(isToggleMenu)
//    {
//        isToggleMenu=NO;
//        accessTable.userInteractionEnabled=YES;
//        [self slideOut];
//    }
    [self removeLoaderView];
    [centerIcon removeFromSuperview];
    centerIcon=nil;
}

-(void) drawHeaderImage
{
    if(!headerView)
    {
        headerView  = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320,ScreenHeightFactor*64)];
        [headerView setBackgroundColor:[UIColor clearColor]];
        [headerView setRootViewController:self];
        [headerView setHeaderViewdelegate:self];
        [headerView setCentreImgName:@"accessProfileIcon.png"];
        [headerView setRightType:@"Menu"];
        [headerView drawHeaderViewWithTitle:@"Welcome To PiNWi" isBackBtnReq:NO BackImage:nil];
        [loadElementView addSubview:headerView];
    
    }
    
   // initialY = 20*ScreenHeightFactor + headerView.frame.size.height;
}
-(void)touchAtBackButton
{
    
}

#pragma mark MENU BUTTON DELEGATE
-(void)getMenuTouches
{
    [self touchAtMenuButton:self];
}


-(void) drawFooterImage
{
    footStrip=[[UIImageView alloc]initWithImage:[UIImage imageNamed: isiPhoneiPad(@"welcomefooter.png") ]];
    footStrip.frame=CGRectMake(0, screenHeight-footStrip.image.size.height, screenWidth, footStrip.image.size.height);
    [loadElementView addSubview:footStrip];
}


-(void) drawCenterIcon
{
//    if(!centerIcon)
//    {
//        centerIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed: isiPhoneiPad(@"accessProfileIcon.png")]];
//        centerIcon.frame=CGRectMake(0, 0, centerIcon.image.size.width, centerIcon.image.size.height);
//        if(self.view.frame.size.width>700)
//        {
//            centerIcon.center=CGPointMake(.5*screenWidth, topStrip.frame.origin.y+topStrip.frame.size.height+20);
//        }
//        else
//        {
//            centerIcon.center=CGPointMake(.5*screenWidth, topStrip.frame.origin.y+topStrip.frame.size.height+5);
//        }
//        
//    }
//    [loadElementView addSubview:centerIcon];
}

-(void) moreIcon
{
    //    UIView *view=[[UIView alloc]init];
    //    view.userInteractionEnabled=YES;
    //    [loadElementView addSubview:view];
    
//    moreImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"Flower_pinwii.png") ]];
//    
//    if(self.view.frame.size.width>700)
//    {
//        // moreImg.frame=CGRectMake(topStrip.frame.size.width-topStrip.frame.size.height-10, 0,topStrip.frame.size.height-10, topStrip.frame.size.height-22);
//        moreImg.frame=CGRectMake(topStrip.frame.size.width-moreImg.image.size.width*2-5,0,moreImg.frame.size.width,moreImg.frame.size.height);
//    }
//    else
//    {
//        moreImg.frame=CGRectMake(topStrip.frame.size.width-moreImg.image.size.width-10, 0,moreImg.image.size.width*1,moreImg.image.size.height*1);
//    }
//    
//    moreImg.center=CGPointMake(moreImg.center.x,topStrip.frame.size.height/2.0f+10);
//    NSLog(@"FRAME :   %f----  %f",moreImg.frame.size.width,moreImg.frame.size.height+10);
//    [moreImg setUserInteractionEnabled:YES];
//    [topStrip setUserInteractionEnabled:YES];
//    [topStrip  addSubview:moreImg];
//    
//    
//    //    view.frame=CGRectMake(0, 0, moreImg.frame.size.width*3, moreImg.frame.size.height*3);
//    //    view.center=CGPointMake(moreImg.center.x, moreImg.center.y);
//    
//    UITapGestureRecognizer *recognizer= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchAtMenuButton:)];
//    [moreImg addGestureRecognizer:recognizer];
}


-(void)pageHeading
{
//    NSString *labelStr=[NSString stringWithFormat:@"Access your Profile"];
//    UILabel *name=[[UILabel alloc]init];
//    CGSize displayValueSize = [labelStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}];
//    name.font=[UIFont fontWithName:RobotoRegular size:15.0f];
//    name.text=labelStr;
//    name.frame=CGRectMake(0,0,displayValueSize.width,displayValueSize.height);
//    name.center=CGPointMake(topStrip.center.x, topStrip.center.y);
//    name.textColor=[UIColor whiteColor];
//    [name sizeToFit];
//    [loadElementView addSubview:name];
}

-(void)addParentDetail:(NSString*)name image:(UIImage*)image earnedPoints:(NSString*)earned pendingPOints:(NSString*)pending{
    
    UIView *parentDetailView;
    if (screenWidth>700) {
        parentDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight*.16, screenWidth, screenHeight/4)];
    }
    else{
        parentDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight*.14, screenWidth, screenHeight/4)];
    }
    
    userImage=[[UIImageView alloc]init];
    [parentDetailView addSubview:userImage];
    
    nameLabel=[[UILabel alloc]init];
    [parentDetailView addSubview:nameLabel];
    
    UIImageView *earnedImage=[[UIImageView alloc]init];
    [parentDetailView addSubview:earnedImage];
    
    UIImageView *pendingImage=[[UIImageView alloc]init];
    [parentDetailView addSubview:pendingImage];
    
    UILabel *earnedPoints=[[UILabel alloc]init];
    [parentDetailView addSubview:earnedPoints];
    
    UILabel *description=[[UILabel alloc]init];
    [parentDetailView addSubview:description];
    
    UILabel *pendingPoints=[[UILabel alloc]init];
    [parentDetailView addSubview:pendingPoints];
    
    arrowImgView=[[UIImageView alloc]init];
    [parentDetailView addSubview:arrowImgView];
    
    parentDetailView.backgroundColor=appBackgroundColor;
    
    if(!image)
    {
        image=[UIImage imageNamed:isiPhoneiPad(@"childDefaultImage.png")];
    }
    
    [self drawImageIcon:image];
        
    CGSize displayValueSize = [name sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20*ScreenHeightFactor]}];
    nameLabel.font=[UIFont fontWithName:RobotoRegular size:18*ScreenHeightFactor];
    nameLabel.text=name;
    nameLabel.frame=CGRectMake(ScreenWidthFactor*10+userImage.frame.origin.x+userImage.frame.size.width,ScreenHeightFactor*2,displayValueSize.width,displayValueSize.height);
    nameLabel.center=CGPointMake(nameLabel.center.x,userImage.frame.origin.y+nameLabel.frame.size.height/2+2*ScreenHeightFactor    );
    nameLabel.textColor=[[UIColor blackColor]colorWithAlphaComponent:0.8f];
    [nameLabel sizeToFit];
    
    yy=nameLabel.frame.size.height+ScreenHeightFactor*15;
    
    description.font=[UIFont fontWithName:RobotoRegular size:12*ScreenHeightFactor];
    description.numberOfLines=4;
    description.text=@"Access your profile to schedule activities, view insights, see what-to-do and network.";
    description.frame=CGRectMake(ScreenWidthFactor*10+userImage.frame.origin.x+userImage.frame.size.width,yy,screenWidth/2+20,ScreenHeightFactor*50);
    description.center=CGPointMake(description.center.x,userImage.frame.origin.y+description.frame.size.height/2+30*ScreenHeightFactor    );
    description.textColor=[UIColor grayColor];
    [description sizeToFit];
    
//    yy=description.frame.size.height+ScreenHeightFactor*5;
//    
//    [earnedImage removeFromSuperview];
//    earnedImage.frame=CGRectMake(nameLabel.frame.origin.x,yy, ScreenFactor*16, ScreenFactor*16);
//    earnedImage.center=CGPointMake(earnedImage.center.x,userImage.center.y+earnedImage.frame.size.height/2+40*ScreenHeightFactor);
//    earnedImage.image=[UIImage imageNamed:isiPhoneiPad(@"earnedCup.png")];
//    
//    
//    pendingImage.frame=CGRectMake(ScreenWidthFactor*200,yy, ScreenFactor*16, ScreenFactor*16);
//    pendingImage.center=CGPointMake(pendingImage.center.x,userImage.center.y+pendingImage.frame.size.height/2+40*ScreenHeightFactor);
//    pendingImage.image=[UIImage imageNamed:isiPhoneiPad(@"pendingCup.png")];
//    
//    displayValueSize = [earned sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9*ScreenFactor]}];
//    earnedPoints.font=[UIFont fontWithName:RobotoRegular size:9*ScreenFactor];
//    earnedPoints.text=earned;//[NSString stringWithFormat:@"Earned: %@",earned];;
//    earnedPoints.frame=CGRectMake(cellPadding+earnedImage.frame.size.width+earnedImage.frame.origin.x,yy,displayValueSize.width,displayValueSize.height);
//    earnedPoints.center=CGPointMake(earnedPoints.center.x, earnedImage.center.y);
//    earnedPoints.textColor=[[UIColor blackColor]colorWithAlphaComponent:0.6f];
//    [earnedPoints sizeToFit];
//    
//    displayValueSize = [pending sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9*ScreenFactor]}];
//    pendingPoints.font=[UIFont fontWithName:RobotoRegular size:9*ScreenFactor];
//    pendingPoints.text=pending;//[NSString stringWithFormat:@"Pending: %@",pending];
//    pendingPoints.frame=CGRectMake(cellPadding+pendingImage.frame.size.width+pendingImage.frame.origin.x,yy,displayValueSize.width,displayValueSize.height);
//    pendingPoints.center=CGPointMake(pendingPoints.center.x,pendingImage.center.y);
//    pendingPoints.textColor=[[UIColor blackColor]colorWithAlphaComponent:0.6f];
//    [pendingPoints sizeToFit];
    
    [self drawArrowIcon];
    [loadElementView addSubview:parentDetailView];
    
    [parentDetailView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arrowTaped:)];
    tapGesture.numberOfTapsRequired = 1;
    [parentDetailView addGestureRecognizer:tapGesture];
    
    yy = parentDetailView.frame.origin.y+parentDetailView.frame.size.height+ScreenHeightFactor*5;
}

-(void)drawImageIcon:(UIImage*)profileImg
{
    userImage.frame=CGRectMake(cellPadding*2, ScreenHeightFactor*8 , ScreenHeightFactor*70, ScreenHeightFactor*70);
    userImage.image=profileImg;
    userImage.center=CGPointMake(userImage.center.x,ScreenHeightFactor*60);
    userImage.layer.cornerRadius = userImage.frame.size.width/2;
    userImage.layer.cornerRadius = userImage.frame.size.height /2;
    userImage.layer.masksToBounds = YES;
    userImage.layer.borderWidth = 0;
    userImage.contentMode=UIViewContentModeScaleAspectFill;
}

-(void)drawArrowIcon
{
    arrowImgView.frame=CGRectMake(screenWidth-cellPadding, ScreenHeightFactor*8 , ScreenHeightFactor*20, ScreenHeightFactor*20);
    arrowImgView.image=[UIImage imageNamed:isiPhoneiPad(@"parentAccessArrow.png")];
    arrowImgView.center=CGPointMake(screenWidth- arrowImgView.frame.size.width/2 -cellPadding,nameLabel.center.y+ScreenHeightFactor*20);
    
    [arrowImgView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arrowTaped:)];
    tapGesture.numberOfTapsRequired = 1;
    [arrowImgView addGestureRecognizer:tapGesture];
    
}

-(void)arrowTaped:(id)sender{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"doesPswdExist"]boolValue]) {
        NSString *lth=/*[[NSUserDefaults standardUserDefaults]objectForKey:@"LocalPassword"];*/[LTHKeychainUtils getPasswordForUsername:kCAUserInfoUsernameKey andServiceName:@"PCApp" error:nil];
        
        
        if(lth.length>=4)
        {
            add=[[AddPassCode alloc]initwithEnablePswd:NO changePswd:NO deletePswd:NO key:kCAUserInfoUsernameKey];
            add.passcodeDelegate=self;
            [self.navigationController presentViewController:add animated:YES completion:nil];
            
            
        }
        else
        {
            ParentViewProfile *parent=[[ParentViewProfile alloc]init];
            [self.navigationController pushViewController:parent animated:YES];
        }
    }
    
    else
    {
        ParentViewProfile *parent=[[ParentViewProfile alloc]init];
        [self.navigationController pushViewController:parent animated:YES];
    }

}

-(void)addLockScreen{
    lockScreen = [[UIView alloc]initWithFrame:CGRectMake(0, yy, screenWidth, screenHeight*.7) ];
    lockScreen.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.87f];
    [lockScreen setUserInteractionEnabled:NO];
    [accessTable setUserInteractionEnabled:NO];
   

    UIImageView *lockImageView = [[UIImageView alloc] initWithFrame:CGRectMake(lockScreen.frame.size.width/2, lockScreen.frame.size.height/2, ScreenHeightFactor*55, ScreenHeightFactor*55)];
    if (screenWidth>700) {
        lockImageView.image=[UIImage imageNamed:@"lock-iPad.png"];
    }else{
        if (screenWidth>320) {
            lockImageView.image=[UIImage imageNamed:@"lock-iPhone6.png"];
        }else{
            lockImageView.image=[UIImage imageNamed:@"lock-iPhone5.png"];
        }
    }
    
    lockImageView.center=CGPointMake(lockImageView.center.x-lockImageView.frame.size.width*.4,ScreenHeightFactor*150);
    lockImageView.layer.cornerRadius = lockImageView.frame.size.width/2;
    lockImageView.layer.cornerRadius = lockImageView.frame.size.height /2;
    lockImageView.layer.masksToBounds = YES;
    lockImageView.layer.borderWidth = 0;
    lockImageView.contentMode=UIViewContentModeScaleAspectFill;
    
    [lockScreen setUserInteractionEnabled:YES];
    [lockImageView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture:)];
    
    tapGesture1.numberOfTapsRequired = 1;
//    tapGesture1.numberOfTouchesRequired=2;
//    
//    [tapGesture1 setDelegate:self];
//    
    [lockImageView addGestureRecognizer:tapGesture1];
    
    [lockScreen addSubview:lockImageView];
    [loadElementView addSubview:lockScreen];
}

-(void)tapGesture:(id)sender{
    [lockScreen removeFromSuperview];
    lockScreen = nil;
    [accessTable setUserInteractionEnabled:YES];
    [accessTable setScrollEnabled:YES];
}
-(void)addTableHeaderView{
    UIView *customHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0,yy, screenWidth,headerHeight)];
     stripView = [[StripView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width,customHeaderView.frame.size.height-4)];
    [stripView drawStrip:@"GIVE CHILD ACCESS" color:[UIColor clearColor]];
    stripView.StripLabel.font = [UIFont fontWithName:RobotoRegular size:12.0f*ScreenHeightFactor];
    stripView.StripLabel.textColor = activityHeading2FontCode;
    stripView.StripLabel.textAlignment = NSTextAlignmentCenter;
    [[stripView StripLabel] setCenter:CGPointMake(stripView.frame.size.width/2.0f, stripView.frame.size.height/2)];
    [customHeaderView addSubview:stripView];
    [loadElementView addSubview:customHeaderView];
    
    yy = customHeaderView.frame.origin.y+customHeaderView.frame.size.height;
}

-(void)initTable
{
    accessTable=[[UITableView alloc]initWithFrame:CGRectMake(0, yy, screenWidth, screenHeight*.7)];
    [loadElementView addSubview:accessTable];
    accessTable.backgroundColor=[UIColor clearColor];
    accessTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    accessTable.delegate=self;
    accessTable.dataSource=self;
    
    UIImageView *accessTableBackgroundImageView;
    
    if (screenWidth>700) {
        accessTableBackgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Child-Pinwheel-iPad.png"]];
    }
    else{
        if (screenWidth>320) {
            accessTableBackgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Child-Pinwheel-iPhone6.png"]];
        }else{
            accessTableBackgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Child-Pinwheel-iPhone5.png"]];
        }
    }
    
    [accessTableBackgroundImageView setFrame:accessTable.frame];
    
    accessTable.backgroundView = accessTableBackgroundImageView;
    [accessTable setScrollEnabled:NO];
    [accessTable setUserInteractionEnabled:NO];
    [accessTable setPagingEnabled:NO];
}

#pragma mark gesture recognizers
-(void)touchAtMenuButton:(id)sender
{
    if(!menu)
    {
        removeMenuView=[[UIView alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height, screenWidth, screenHeight-headerView.frame.size.height)];
        removeMenuView.backgroundColor=[UIColor clearColor];
        
        UITapGestureRecognizer *removeMenuGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchToRemoveMenu:)];
        [removeMenuView addGestureRecognizer:removeMenuGesture];
        
        menu=[[MenuSettingsView alloc]initWithFrame:CGRectMake(screenWidth,20*ScreenHeightFactor, screenWidth*.5, screenHeight-moreImg.frame.origin.y)andViewCtrl:self];

        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:menu.bounds];
        menu.layer.masksToBounds = NO;
        [menu.layer setShadowColor:[UIColor grayColor].CGColor];
        [menu.layer setShadowOpacity:0.8];
        [menu.layer setShadowRadius:10.0];
        [menu.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
        menu.layer.shadowPath = shadowPath.CGPath;
        [loadElementView addSubview:menu];
    }
    if(!isToggleMenu)
    {
        isToggleMenu=YES;
        accessTable.userInteractionEnabled=NO;
        [self slideIn];
    }
    else
    {
        [self touchToRemoveMenu:nil];
    }
}


-(void)touchToRemoveMenu:(id)sender
{
    isToggleMenu=NO;
    accessTable.userInteractionEnabled=YES;
    [self slideOut];
}

-(void)slideIn
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        // [menu setCenter:CGPointMake(menu.center.x-screenWidth*.2, screenHeight/2)];
        [loadElementView addSubview:removeMenuView];
        [loadElementView setCenter:CGPointMake(loadElementView.center.x-screenWidth*.5, self.view.center.y)];
    } completion:^(BOOL finished) {
        
    }];
    
}
-(void)slideOut
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        // [menu setCenter:CGPointMake(menu.center.x+screenWidth*.2, screenHeight/2)];
        [removeMenuView removeFromSuperview];
        [loadElementView setCenter:CGPointMake(loadElementView.center.x+screenWidth*.5, self.view.center.y)];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)fillData
{
    int i=0;
    accessProfileArray=[[NSMutableArray alloc]init];
    [[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles removeAllObjects];
    for(NSDictionary *child in fillFromServer)
    {
        if([[NSString stringWithFormat:@"%@",[child objectForKey:@"ProfileType"]]isEqualToString:@"1"])
        {
            [PC_DataManager sharedManager].parentObjectInstance.image=[NSString stringWithFormat:@"%@" ,[child objectForKey:@"ProfileImage"]];
            [PC_DataManager sharedManager].parentObjectInstance.parentId=[NSString stringWithFormat:@"%@"  ,[child objectForKey:@"ProfileID"]];
            [PC_DataManager sharedManager].parentObjectInstance.firstName=[NSString stringWithFormat:@"%@"  ,[child objectForKey:@"FirstName"]];
            [PC_DataManager sharedManager].parentObjectInstance.lastName=[NSString stringWithFormat:@"%@"  ,[child objectForKey:@"ProfileName"]];
            
            [accessProfileArray addObject:@{@"user" :[NSString stringWithFormat:@"%@",[child objectForKey:@"ProfileType"]],
                                            @"name" :[PC_DataManager sharedManager].parentObjectInstance.firstName,
                                            @"lastName" :[PC_DataManager sharedManager].parentObjectInstance.lastName,
                                            @"image":[PC_DataManager sharedManager].parentObjectInstance.image,
                                            @"earnedPoints":[NSString stringWithFormat:@"%@"  ,[child objectForKey:@"EarnedPoints"]],
                                            @"pendingPoints":[NSString stringWithFormat:@"%@"  ,[child objectForKey:@"PendingPoints"]],
                                            }];
            
            
        }
        else if([[NSString stringWithFormat:@"%@",[child objectForKey:@"ProfileType"]]isEqualToString:@"2"]){
            ChildProfileObject *child1=[[ChildProfileObject alloc]init];
            child1.nick_Name=[NSString stringWithFormat:@"%@"  ,[child objectForKey:@"FirstName"]];
            child1.profile_pic=[NSString stringWithFormat:@"%@"  ,[child objectForKey:@"ProfileImage"]];
            child1.child_ID=[NSString stringWithFormat:@"%@"  ,[child objectForKey:@"ProfileID"]];
            child1.firstName=[NSString stringWithFormat:@"%@"  ,[child objectForKey:@"FirstName"]];
            child1.lastName=[NSString stringWithFormat:@"%@"  ,[child objectForKey:@"ProfileName"]];
            child1.earnedPts=[NSString stringWithFormat:@"%@"  ,[child objectForKey:@"EarnedPoints"]];
            child1.pendingPts=[NSString stringWithFormat:@"%@"  ,[child objectForKey:@"PendingPoints"]];
            
            [[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles addObject:child1];
            [accessProfileArray addObject:@{@"user" :[NSString stringWithFormat:@"%@",[child objectForKey:@"ProfileType"]],
                                            @"name" :child1.nick_Name,
                                            @"image":child1.profile_pic,
                                            @"earnedPoints":child1.earnedPts,//[NSString stringWithFormat:@"%@"  ,[child objectForKey:@"EarnedPoints"]],
                                            @"pendingPoints":child1.pendingPts,//[NSString stringWithFormat:@"%@"  ,[child objectForKey:@"PendingPoints"]]
                                            }];
            
        }
        i++;
    }
    
    NSDictionary *profileDictionary; BOOL isReplaced=NO;
    for(NSDictionary *profileDict in accessProfileArray)
    {
        if([[profileDict objectForKey:@"user"]isEqualToString:@"1"])
        {
            isReplaced=YES;
            profileDictionary=profileDict;
            UIImage *img;
            NSString *imageName = [profileDict objectForKey:@"image"];
            if (imageName == (id)[NSNull null] || imageName.length == 0 ||[imageName isEqualToString:@"(null)"])
            {
                if (screenWidth>700) {
                    img =  [UIImage imageNamed:@"parentDefaultImage~ipad.png"];
                }else{
                    if (screenWidth>320) {
                        img =  [UIImage imageNamed:@"parentDefaultImage-667h@2x.png"];
                    }else{
                        img =  [UIImage imageNamed:@"parentDefaultImage-568h@2x.png"];
                    }
                }
                
                
            }
            else
            {
                img=[[PC_DataManager sharedManager] decodeImage:imageName];
            }

            
            [self addParentDetail:[profileDict objectForKey:@"name"] image:img earnedPoints:[profileDict objectForKey:@"earnedPoints"] pendingPOints:[profileDict objectForKey:@"pendingPoints"]];
            
            [accessProfileArray removeObject:profileDict];
            [self addTableHeaderView];
            [self initTable];
            [self addLockScreen];
            break;
//            [accessProfileArray insertObject:profileDictionary atIndex:0];
        }
    }
    if(isReplaced==YES && profileDictionary)
    {
         [accessProfileArray insertObject:profileDictionary atIndex:0];
    }
    [accessTable reloadData];
}


-(void)getParentAndChild
{
    NSDictionary *dict = [[PC_DataManager sharedManager].serviceDictionary objectForKey:@"GetNamesByParentID"];
    if(dict)
    {
        NSArray *arr=(NSArray*)dict;
        NSMutableDictionary *checkDict=[[arr firstObject]mutableCopy];
        if([[checkDict objectForKey:@"ErrorDesc"]isEqualToString:@"Parent doesn't exixts."])
        {
            exit(1);
        }
        else
        {
            fillFromServer = [[NSMutableArray alloc]init];
            for (NSDictionary *accessDict in dict)
            {
                NSLog(@"access dict:%@",accessDict);
                [fillFromServer addObject:accessDict];
            }
            [self fillData];
        }
    }
    else
    {
        getNamesByParentID = [[GetNamesByParentID alloc] init];
        [getNamesByParentID initService:@{
                                          @"ParentID":[PC_DataManager sharedManager].parentObjectInstance.parentId
                                          }];
        [getNamesByParentID setDelegate:self];
        [self addLoaderView];
    }
    
}

-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
    [self removeLoaderView];
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection
{
    NSLog(@"Connection Finish data =%@",dictionary);
    [self removeLoaderView];
    if([connection.serviceName isEqualToString:PinWiGetCurrentDayRatingStatus])
    {
        
        NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetCurrentDayRatingStatusResponse" resultKey:@"GetCurrentDayRatingStatusResult"];
        NSLog(@"Dict  = %@ ",dict);
        if([dict isKindOfClass:[NSArray class]])
        {
            NSArray *arr = (NSArray *)dict;
            NSDictionary *dictionary = [arr firstObject];
            NSString *status=[NSString stringWithFormat:@"%@",[dictionary valueForKey:@"Status"]];
            statusCountToRate=[status intValue];
            
            ChildProfileObject *child = [[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles objectAtIndex:connection.indexPath.row];
            
            if(statusCountToRate==0 || statusCountToRate==1 || statusCountToRate==3 || statusCountToRate==4)
            {
                RatingConfirmation_VC *dashborad=[[RatingConfirmation_VC alloc]init];
                dashborad.childObj=child;
                dashborad.statusCount=statusCountToRate;
                dashborad.parentClass=@"Acess";
                dashborad.isComingFormRating = YES;
                dashborad.childObj.earnedPts=[NSString stringWithFormat:@"%@",child.earnedPts];
                [self.navigationController pushViewController:dashborad animated:YES];
            }
            
            else if(statusCountToRate==2 || statusCountToRate==5 )
            {
                GetChildSubjectActiviesByDay * afterSchoolService  = [[GetChildSubjectActiviesByDay alloc]init];
                [afterSchoolService setDelegate:self];
                [afterSchoolService setIndexPath:connection.indexPath];
                [afterSchoolService setServiceName:PinWiGetSubjectByChildID];
                [afterSchoolService initService:@{
                                                  @"ChildID":child.child_ID,
                                                  @"DaysAgo":@"0"
                                                  }];
                [self addLoaderView];
            }
            
            //             ChildProfileObject *child = [[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles objectAtIndex:connection.indexPath.row-1];;
            //             RatingConfirmation_VC *dashborad=[[RatingConfirmation_VC alloc]init];
            //             dashborad.childObj=child;
            //             dashborad.childObj.earnedPts=[NSString stringWithFormat:@"%i",0];
            //             [self.navigationController pushViewController:dashborad animated:YES];
            //}
        }
        
        
    }
    else if([connection.serviceName isEqualToString:PinWiGetSubjectByChildID])
    {
        // [getAllData removeAllObjects];
        //if(get)
         [getAllData removeAllObjects];
        NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetChildSubjectActiviesByDayResponse" resultKey:@"GetChildSubjectActiviesByDayResult"];
        ChildProfileObject *child = [[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles objectAtIndex:connection.indexPath.row];
        if([dict isKindOfClass:[NSArray class]])
        {
            NSArray *arr = (NSArray *)dict;
            NSDictionary *dictionary = [arr firstObject];
            if([dictionary valueForKey:@"ErrorDesc"])
            {
//                RatingConfirmation_VC *dashborad=[[RatingConfirmation_VC alloc]init];
//                dashborad.childObj=child;
//                dashborad.statusCount=statusCountToRate;
//                dashborad.parentClass=@"Acess";
//                dashborad.isComingFormRating = YES;
//                dashborad.childObj.earnedPts=[NSString stringWithFormat:@"%@",child.earnedPts];
//                [self.navigationController pushViewController:dashborad animated:YES];
              //  UIAlertView *alert=[[UIAlertView alloc]initWithTitle:PinWiGetAfterSchoolActivityByChildId message:[dictionary valueForKey:@"ErrorDesc"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
              //  [alert show];
            }
        
        else
        {
            if(dict)
            {
                for(NSDictionary *dictionary in dict)
                {
                    [getAllData addObject:dictionary];
                }
            }
        }
        }
        
        GetChildAfterSchoolActiviesByDay *activityID =  [[GetChildAfterSchoolActiviesByDay alloc]init];
        [activityID setServiceName:PinWiGetAfterSchoolActivityByChildId];
        [activityID setDelegate:self];
        
        NSLog(@"Child Id = %@",child.child_ID);
        [activityID initService:@{@"ChildID":child.child_ID, @"DaysAgo":@"0"}];
        [activityID setIndexPath:connection.indexPath];
        [self addLoaderView];

    }
    else if([connection.serviceName isEqualToString:PinWiGetAfterSchoolActivityByChildId])
    {
       
        ChildProfileObject *child = [[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles objectAtIndex:connection.indexPath.row];
        NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetChildAfterSchoolActiviesByDayResponse" resultKey:@"GetChildAfterSchoolActiviesByDayResult"];
        if([dict isKindOfClass:[NSArray class]])
        {
            NSArray *arr = (NSArray *)dict;
            NSDictionary *dictionary = [arr firstObject];
            if([dictionary valueForKey:@"ErrorDesc"])
            {
                //UIAlertView *alert=[[UIAlertView alloc]initWithTitle:PinWiGetSubjectByChildID message:[dictionary valueForKey:@"ErrorDesc"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
               // [alert show];
            }
            else
            {
                
                for(NSDictionary *dictionary in arr)
                {
                    [getAllData addObject:dictionary];
                }
            }
        }
        if(getAllData.count>0)
        {
            
            [self gotochildRatingScreen:child andEarnedPoints:[[accessProfileArray objectAtIndex:connection.indexPath.row ] objectForKey:@"earnedPoints"]];
  
            //            }
        }
        else
        {
            RatingConfirmation_VC *dashborad=[[RatingConfirmation_VC alloc]init];
            dashborad.childObj=child;
            dashborad.statusCount=statusCountToRate;
            dashborad.parentClass=@"Acess";
            dashborad.isComingFormRating = YES;
            dashborad.childObj.earnedPts=[NSString stringWithFormat:@"%@",child.earnedPts];
            [self.navigationController pushViewController:dashborad animated:YES];

        }
        
    }
    /*else if(isPasscode)
     {
     isPasscode=NO;
     NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"RecoverPasscodeResponse" resultKey:@"RecoverPasscodeResult"];
     if(!dict)
     {
     return;
     }
     
     UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Recover Passcode" message:@"passcode has been sent to your mail" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
     [alert show];
     [self removeLoaderView];
     }*/
    
    else
    {
        NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"GetNamesByParentIDResponse" resultKey:@"GetNamesByParentIDResult"];
        
        if(!dict)
        {
            return;
        }
        
        if(fillFromServer)
        {
            [fillFromServer removeAllObjects];
        }
        else{
            fillFromServer = [[NSMutableArray alloc]init];
        }
        for (NSDictionary *accessDict in dict)
        {
            NSLog(@"access dict:%@",accessDict);
            [fillFromServer addObject:accessDict];
            
        }
        [[PC_DataManager sharedManager].serviceDictionary setObject:dict forKey:@"GetNamesByParentID"];
        [self fillData];
        [self removeLoaderView];
    }
    
    
}

#pragma mark TABLE VIEW DELEGATES

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return accessProfileArray.count-1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return ScreenHeightFactor*100;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"AccessProfileCell";
    AccessProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];//
    if(cell==nil)
    {
        cell=  [[AccessProfileCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
  //  [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    NSDictionary *dict=[accessProfileArray objectAtIndex:indexPath.row+1];
    UIImage *img;
    

        NSString *imageName = [dict objectForKey:@"image"];
        if (imageName == (id)[NSNull null] || imageName.length == 0 )
        {
            if (screenWidth>700) {
                img =  [UIImage imageNamed:@"childDefaultImage~ipad.png"];
            }else{
                if (screenWidth>320) {
                    img =  [UIImage imageNamed:@"childDefaultImage-667h@2x.png"];
                }else{
                    img =  [UIImage imageNamed:@"childDefaultImage-568h@2x.png"];
                }
            }
            
            
        }
        else
        {
            img=[[PC_DataManager sharedManager] decodeImage:imageName];
        }

        
    cell.backgroundColor = [UIColor clearColor];
        [cell addChildCredential:[dict objectForKey:@"name"] image:img earnedPoints:[dict objectForKey:@"earnedPoints"] pendingPOints:[dict objectForKey:@"pendingPoints"]];

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableCell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
        NSLog(@"Value of index Path =  %ld",(long)indexPath.row);
        GetCurrentDayRatingStatus *activityID =  [[GetCurrentDayRatingStatus alloc]init];
        [activityID setServiceName:PinWiGetCurrentDayRatingStatus];
        [activityID setDelegate:self];
        
        ChildProfileObject *child = [[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles objectAtIndex:indexPath.row];
        
        NSLog(@"Child Id = %@",child.child_ID);
        [activityID initService:@{@"ChildID":child.child_ID}];
        [activityID setIndexPath:indexPath];
        [self addLoaderView];

//    ChildDashboardViewController *childDashboardViewController = [[ChildDashboardViewController alloc] init];
//    [self.navigationController pushViewController:childDashboardViewController animated:YES];
    
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    if([tableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)])
    {
        tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Return from sucess
-(void)passCodeSuccess
{
    ParentViewProfile *parent=[[ParentViewProfile alloc]init];
    [self.navigationController pushViewController:parent animated:YES];
    
    // [self setPassword:nil];
    // [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)cancelBtnTouched
{
    [add dismissViewControllerAnimated:YES completion:nil];
    add=nil;
}
-(void)forgotPasscode
{
    // [self addOverLay];
    [add dismissViewControllerAnimated:YES completion:nil];
    add=nil;
    // call service
    // [self dismissViewControllerAnimated:YES completion:nil];
}

/*
 #pragma Load recover Passcode Screen
 -(void)addOverLay
 {
 translucentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
 translucentView.backgroundColor=[UIColor grayColor];
 translucentView.alpha=0.5;
 [self.view addSubview:translucentView];
 
 OverLayView *overlayView=[[OverLayView alloc]initWithFrame:CGRectMake(0, screenHeight*.8, screenWidth, screenHeight*.2)withInfoText:@"Recover Passcode?" AndButtonText:@"SEND"];
 overlayView.overLayDelegate=self;
 // goAheadView.tintColor=confirmcolorcode;
 [self.view addSubview:overlayView];
 }
 
 
 -(void)continueTouched
 {
 [translucentView removeFromSuperview];
 translucentView=nil;
 isPasscode=YES;
 forgotPasscode = [[RecoverPasscode alloc] init];
 [forgotPasscode initService:@{@"ProfileID":[PC_DataManager sharedManager].parentObjectInstance.parentId
 }];
 [forgotPasscode setDelegate:self];
 [self addLoaderView];
 }
 */
#pragma mark ADD / REMOVE LOADER
-(void)addLoaderView
{
    loaderView=[[ShowActivityLoadingView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [loaderView showLoaderViewWithText:@"Hold On..."];
    [self.view addSubview:loaderView];
}

-(void)removeLoaderView
{
    [loaderView removeLoaderView];
    [loaderView removeFromSuperview];
    loaderView=nil;
}

#pragma mark  CHOOSE THE RATING SCREEN TO OPEN

-(void)choseChildInterface:(int)status andChild:(ChildProfileObject*)child
{
    statusCountToRate=status;
    if(status==0 || status==1 || status==3 || status==4)
    {
        RatingConfirmation_VC *dashborad=[[RatingConfirmation_VC alloc]init];
        dashborad.childObj=child;
        dashborad.statusCount=status;
        dashborad.parentClass=@"Acess";
        dashborad.isComingFormRating = YES;
        dashborad.childObj.earnedPts=[NSString stringWithFormat:@"%@",child.earnedPts];
        [self.navigationController pushViewController:dashborad animated:YES];
    }
    
    else if(status==2 || status==5 )
    {
        GetChildSubjectActiviesByDay * afterSchoolService  = [[GetChildSubjectActiviesByDay alloc]init];
        [afterSchoolService setDelegate:self];
        [afterSchoolService setChildId:child.child_ID];
        [afterSchoolService setServiceName:PinWiGetSubjectByChildID];
        [afterSchoolService initService:@{
                                          @"ChildID":child.child_ID,
                                          @"DaysAgo":@"0"
                                          }];
        [self addLoaderView];
    }
}

-(void)gotochildRatingScreen:(ChildProfileObject*)childObj1 andEarnedPoints:(NSString*)earnedPts
{
    //NSString *str=[NSString stringWithFormat:@"ChildTutorial4-%@",childObj1.child_ID];
    ChildSubjectRatingViewController *child=[[ChildSubjectRatingViewController alloc]init];
    [ChildSubjectRatingViewController setDaysAgoValue:0];
    [child setAllData:getAllData];
    child.rateChilObj=childObj1;
    child.rateChilObj.earnedPts=earnedPts;
    child.statusCount=statusCountToRate;
    child.parentClass=@"Acess";
    UINavigationController *navigationcontroller  = [[UINavigationController alloc]initWithRootViewController:child];
    [self presentViewController:navigationcontroller animated:YES completion:nil];

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
