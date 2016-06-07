//
//  NetworkViewController.m
//  ParentControl_CT
//
//  Created by Priyanka on 03/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "NetworkViewController.h"
#import "PC_DataManager.h"
#import "HeaderView.h"
#import "RedLabelView.h"
#import "ParentViewProfile.h"
#import "MenuSettingsView.h"
#import "NetworkDetailView.h"
#import "NetworkProfileViewController.h"


@interface NetworkViewController ()<HeaderViewProtocol>

@end

@implementation NetworkViewController

{
    RedLabelView *label;
    HeaderView *headerView;
    UIScrollView *scrollView;
    int yy;
    int yCord, xCord;
    UIButton *continueButton;
    MenuSettingsView *menu;
    BOOL isToggleMenu;
    UIPageControl *pageControl;
    int pageControlHeight;
    UIView *loadElementView;
    UIButton *profileIconButton;
    UIView *removeMenuView;
}
@synthesize networkObjectArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    yy=0;
    
    [[PC_DataManager sharedManager]getWidthHeight];
    pageControlHeight = (ScreenWidthFactor*20);
    if(!loadElementView)
    {
        loadElementView=[[UIView alloc]initWithFrame:CGRectMake(0,0, screenWidth*1.5, screenHeight)];
        [self.view addSubview:loadElementView];
    }

    
    [self.view setBackgroundColor:appBackgroundColor];
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    //self.title=@"Insights";
    [self.navigationController setNavigationBarHidden:YES];
    for(NetworkDetailView *network in self.networkObjectArray)
    {
        [network loadData];
        return;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.navigationController.navigationBarHidden=YES;
    [self drawHeaderView];
    [self drawUiWithHead];
 //   [self addProfileButton];
    
    [self.tabBarCtrl.tabBar setSelectedImageTintColor:NonInfluencerGreen];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //  [viewBack removeGestureRecognizer:gestureRecognizer];
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
        [headerView setRightType:@"Menu"];
        [headerView drawHeaderViewWithTitle:@"Network" isBackBtnReq:YES BackImage:@"homeBack.png"];
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


-(void)addProfileButton{
    if(!profileIconButton)
    {
        profileIconButton = [[UIButton alloc] init];
        if(screenWidth>700)
        {
            profileIconButton.frame =CGRectMake(ScreenWidthFactor*285, 0 , ScreenHeightFactor*30, ScreenHeightFactor*30);
            // profileIconButton.center=CGPointMake(ScreenWidthFactor*295,label.frame.origin.y);
            profileIconButton.center=CGPointMake(screenWidth-profileIconButton.frame.size.width/2-cellPadding, yy+5);
            UIImage *buttonImage = [UIImage imageNamed:@"profile-iPad.png"];
            [profileIconButton setImage:buttonImage forState:UIControlStateNormal];
            
        }
        else
        {
            profileIconButton.frame =CGRectMake(ScreenWidthFactor*275, 0, ScreenHeightFactor*30, ScreenHeightFactor*30);
            //profileIconButton.center=CGPointMake(ScreenWidthFactor*292,label.frame.origin.y+2);
            profileIconButton.center=CGPointMake(screenWidth-profileIconButton.frame.size.width/2-cellPadding, yy+5);
            UIImage *buttonImage = [[UIImage alloc]init];
            if (screenWidth>320) {
                 buttonImage = [UIImage imageNamed:@"profile-iPhone6.png"];
            }
            else{
                 buttonImage = [UIImage imageNamed:@"profile-iPhone5.png"];
            }
            [profileIconButton setImage:buttonImage forState:UIControlStateNormal];
        }
        
        profileIconButton.layer.cornerRadius = profileIconButton.frame.size.width/2;
        profileIconButton.layer.cornerRadius = profileIconButton.frame.size.height /2;
        profileIconButton.layer.masksToBounds = YES;
//        profileIconButton.layer.borderWidth = 2.0f;
//        [profileIconButton.layer setBorderColor:textBlueColor.CGColor];
        profileIconButton.contentMode=UIViewContentModeScaleAspectFill;
        [profileIconButton addTarget:self action:@selector(profileIconButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:profileIconButton];
    }
    
}

-(void)profileIconButtonTouched:(UIButton*)sender{
    NetworkProfileViewController *networkProfileViewController = [[NetworkProfileViewController alloc] init];
    [self.navigationController pushViewController:networkProfileViewController animated:YES];
}


#pragma mark BACK BUTTON DELEGATE
-(void)touchAtBackButton
{
    ParentViewProfile *access=[[ParentViewProfile alloc]init];
    UINavigationController *naviCtrl=[[UINavigationController alloc]initWithRootViewController:access];
    [[[UIApplication sharedApplication]keyWindow]setRootViewController:naviCtrl];
    
}

#pragma mark MENU BUTTON DELEGATE
-(void)getMenuTouches
{
    [self touchAtPinwiWheel];
}



-(void)touchAtPinwiWheel
{
    NSLog(@"Touch at pinwiWheel");
    if(!menu)
    {
        menu=[[MenuSettingsView alloc]initWithFrame:CGRectMake(screenWidth,headerView.frame.size.height, screenWidth*.5, screenHeight-headerView.frame.size.height)andViewCtrl:self];
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:menu.bounds];
        menu.layer.masksToBounds = NO;
        [menu.layer setShadowColor:[UIColor grayColor].CGColor];
        [menu.layer setShadowOpacity:0.8];
        [menu.layer setShadowRadius:10.0];
        [menu.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
        menu.layer.shadowPath = shadowPath.CGPath;
        [self.view addSubview:menu];
        
        
        
        
    }
    if(!isToggleMenu)
    {
        isToggleMenu=YES;
        [self slideIn];
    }
    else
    {
        isToggleMenu=NO;
        [self slideOut];
    }
}


-(void)slideIn
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //        [view1 setCenter:CGPointMake(view1.center.x-screenWidth*.5, view1.center.y)];
        [menu setCenter:CGPointMake(menu.center.x-screenWidth*.5, menu.center.y)];
        scrollView.alpha=0.5f;
        //[self.view setFrame:CGRectMake(0, 0, screenWidth*1.5, screenHeight)];
        //[self.view setCenter:CGPointMake(self.view.center.x-screenWidth*.5, self.view.center.y)];
    } completion:^(BOOL finished) {
        
    }];
    
}
-(void)slideOut
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [menu setCenter:CGPointMake(menu.center.x+screenWidth*.5, menu.center.y)];
        scrollView.alpha=1.0f;
        //        [view1 setCenter:CGPointMake(view1.center.x-screenWidth*.5, menu.center.y)];
        //        [self.view setCenter:CGPointMake(self.view.center.x+screenWidth*.5, self.view.center.y)];
        //        [self.view setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    } completion:^(BOOL finished) {
        
    }];
}



-(void)touchAtFlower:(id)sender
{
    NSLog(@"Touch at flower at insightViewController");
}
-(int)navigationBarHeight
{
    return screenWidth >700 ? 0 :0;
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
        
        self.networkObjectArray=[[NSMutableArray alloc]init];
        
//        for(int i=0; i<[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles.count; i++)
//        {
//            NetworkDetailView *networkd=[[NetworkDetailView alloc]initWithRootController:self andChildData:[[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles objectAtIndex:i]];
//            
//            NSLog(@"RootViewCtrl = %@",networkd.networkViewController);
//            
//            networkd.frame=CGRectMake(xCord,0, scrollView.frame.size.width, scrollView.frame.size.height);
//            
//            [scrollView addSubview:networkd];
//            [self.networkObjectArray addObject:networkd];
//            xCord+=networkd.frame.size.width;
//        }
        
        UILabel *textLabel;
        if (screenWidth>700) {
            textLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2+ScreenWidthFactor*20
                                                                           , ScreenWidthFactor*200, ScreenWidthFactor*200, ScreenHeightFactor*80)];
            textLabel.center = CGPointMake(screenWidth/2, ScreenWidthFactor*200);
        }
        else{
            textLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2+ScreenWidthFactor*20
                                                                           , ScreenWidthFactor*200, ScreenWidthFactor*300, ScreenHeightFactor*80)];
            textLabel.center = CGPointMake(screenWidth/2, ScreenWidthFactor*200);
        }
        textLabel.text = @"You will soon be able to connect with \n others parents in your community.";
        textLabel.textColor = [UIColor grayColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.numberOfLines = 2;
        textLabel.font = [UIFont fontWithName:RobotoRegular size:14*ScreenHeightFactor];
        UILabel *comingSoonLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2+ScreenWidthFactor*20, ScreenWidthFactor*200+textLabel.frame.size.height, ScreenWidthFactor*200, ScreenHeightFactor*50)];
        comingSoonLabel.center = CGPointMake(screenWidth/2, ScreenWidthFactor*200+textLabel.frame.size.height);
        comingSoonLabel.text = @"Stay Tuned!!!";
        comingSoonLabel.textColor = [UIColor blackColor];
        comingSoonLabel.textAlignment = NSTextAlignmentCenter;
        comingSoonLabel.font = [UIFont fontWithName:RobotoRegular size:15*ScreenHeightFactor];
       

        [self.view addSubview:textLabel];
        [self.view addSubview:comingSoonLabel];
        
        
        [scrollView setContentSize:CGSizeMake(xCord, scrollView.contentSize.height)];
     }
     [self.view setBackgroundColor:appBackgroundColor];
}

-(void)setupPageControl:(NSInteger)number_Of_Page
{
    //int height  = [self navigationBarHeight];
    if(!pageControl)
    {
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
    }
   
    
    [loadElementView addSubview:pageControl];
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
