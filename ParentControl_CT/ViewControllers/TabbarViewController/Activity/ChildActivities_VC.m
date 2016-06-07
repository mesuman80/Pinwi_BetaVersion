//
//  ChildActivities_VC.m
//  ParentControl_CT
//
//  Created by Priyanka on 03/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "ChildActivities_VC.h"
#import "ActivityDetailView.h"
#import "SubjectCalenderList.h"
#import "AfterSchoolActivities.h"
#import "PinWiRightSideButton.h"
#import "MenuSettingsView.h"
#import "HeaderView.h"
#import "ActivityDetailView.h"

@interface ChildActivities_VC ()<PinWiRightSideButtonDelegate,HeaderViewProtocol,UIScrollViewDelegate>

@end

@implementation ChildActivities_VC

{
    UITableView *subjectCalenderTable;
    UITableView *afterSchoolTable;
    UISegmentedControl *segmentedControl;
    
    UIImageView *navBgBar, *centerIcon;
    UINavigationBar *navBar;
    
    UIPageControl *pageControl;
    UIScrollView *scrollView;
    
    UIButton *addBtn;
    UIButton *anotherButton;
    AddNewActivity *addNewActivity;
    PinWiRightSideButton *button;
    MenuSettingsView *menu;
    UIView *viewBack;
    BOOL isToggleMenu;
    int x;
    
    UITapGestureRecognizer *gestureRecognizer;
    HeaderView *headerView;
    int yy;
    int pageControlHeight;
    int xCord;
    BOOL pageControlBeingUsed;
    
    UIView *loadElementView;
    UIView *removeMenuView;
}

//@synthesize navCtrlActivity;

-(id)init
{
    if(self =[super init])
    {
        
        
        return self;
    }
    return nil;
}
//************************************************************************************************************************

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
    [self drawHeaderView];
    [self drawUiWithHead];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    //self.title=@"Insights";
    [self.navigationController setNavigationBarHidden:YES];
    for(ActivityDetailView *activity in self.ActivityObjectArray)
    {
        [activity loadData];
    }
    [PC_DataManager sharedManager].repeatDaysString=[@"" mutableCopy];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=YES;
    
    [self.tabBarController.tabBar setSelectedImageTintColor:[UIColor orangeColor]];
    
    self.view.backgroundColor = appBackgroundColor;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
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
        [headerView setCentreImgName:@"activityHeader.png"];
        [headerView setRightType:@"Menu"];
        [headerView drawHeaderViewWithTitle:@"Scheduler" isBackBtnReq:YES BackImage:@"homeBack.png"];
        [loadElementView bringSubviewToFront:headerView];
        [loadElementView addSubview:headerView];
        if(screenWidth>700)
        {
            yy+=headerView.frame.size.height+26*ScreenHeightFactor;
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
        
        removeMenuView=[[UIView alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height, screenWidth, screenHeight-headerView.frame.size.height)];
         removeMenuView.backgroundColor=[UIColor clearColor];
        
        UITapGestureRecognizer *removeMenuGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchToRemoveMenu:)];
        [removeMenuView addGestureRecognizer:removeMenuGesture];

        
        menu=[[MenuSettingsView alloc]initWithFrame:CGRectMake(screenWidth,20*ScreenHeightFactor, screenWidth*.5, screenHeight-headerView.frame.size.height)andViewCtrl:self];
//        if(screenHeight<700)
//        {
//            [menu setFrame:CGRectMake(screenWidth,headerView.frame.size.height-7*ScreenHeightFactor, screenWidth*.5, screenHeight-headerView.frame.size.height)];
//        }
        
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
    [self slideOut];
}
-(void)slideIn
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
    
    [loadElementView addSubview:removeMenuView];
    [loadElementView setUserInteractionEnabled:NO];
    scrollView.alpha=0.5f;
    scrollView.userInteractionEnabled=NO;
    [loadElementView setCenter:CGPointMake(loadElementView.center.x-screenWidth*.5, self.view.center.y)];
} completion:^(BOOL finished) {
    [loadElementView setUserInteractionEnabled:YES];
}];
}

-(void)slideOut
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
       // [menu setCenter:CGPointMake(menu.center.x+screenWidth*.5, menu.center.y)];
        [removeMenuView removeFromSuperview];
        [loadElementView setUserInteractionEnabled:NO];
        [loadElementView setCenter:CGPointMake(loadElementView.center.x+screenWidth*.5, self.view.center.y)];
        scrollView.alpha=1.0f;
        scrollView.userInteractionEnabled=YES;
    } completion:^(BOOL finished) {
         [loadElementView setUserInteractionEnabled:YES];
    }];
}
-(void)touchAtFlower:(id)sender
{
    NSLog(@"Touch at flower at insightViewController");
}
-(int)navigationBarHeight
{
    return screenWidth >700 ? -20 :0;
}



#pragma mark drawUI
-(void)drawUiWithHead
{
    
    [self setupPageControl:[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles.count];
    [self.view setBackgroundColor:appBackgroundColor];
    if(!scrollView)
    {
        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,yy, self.view.frame.size.width, self.view.frame.size.height-yy)];
        [scrollView setPagingEnabled:YES];
        [scrollView setDelegate:self];
        [scrollView setScrollEnabled:YES];
        [scrollView setBackgroundColor:appBackgroundColor];
        [loadElementView addSubview:scrollView];
        
        xCord=0;
        
        self.ActivityObjectArray=[[NSMutableArray alloc]init];
        
        for(int i=0; i<[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles.count; i++)
        {
            ActivityDetailView *activityd=[[ActivityDetailView alloc]initWithRootController:self andChildData:[[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles objectAtIndex:i]];
            
            NSLog(@"RootViewCtrl = %@",activityd.activityViewController);
            
            activityd.frame=CGRectMake(xCord,0, scrollView.frame.size.width, scrollView.frame.size.height);
            
            [scrollView addSubview:activityd];
            [self.ActivityObjectArray addObject:activityd];
            xCord+=activityd.frame.size.width;
        }
        [scrollView setContentSize:CGSizeMake(xCord, scrollView.contentSize.height)];
        [self addButton];
    }
    
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
-(void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (!pageControlBeingUsed)
    {
        CGFloat pageWidth = sender.frame.size.width;
        int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        pageControl.currentPage = page;
        
    }
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)sender
{
    pageControlBeingUsed = NO;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender
{
    pageControlBeingUsed = NO;
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //   if(currentPage!= pageControl.currentPage)
    //   {
    //       NSLog(@"Want to Update");
    //       currentPage = (int)pageControl.currentPage;
    //   }
}


#pragma mark add new activity button
-(void) addButton {
    if(!addBtn)
    {
        addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setFrame:CGRectMake(0, 0, ScreenHeightFactor*25, ScreenHeightFactor*25)];
        [addBtn setBackgroundImage:[UIImage imageNamed:isiPhoneiPad(@"addActivity.png")] forState:UIControlStateNormal];
        addBtn.tintColor=radiobuttonSelectionColor;
        addBtn.center=CGPointMake(screenWidth-addBtn.frame.size.width/2-cellPadding, yy);
        if(screenWidth>500)
        {
            addBtn.center=CGPointMake(screenWidth-addBtn.frame.size.width/2-cellPadding, yy);
        }
        [loadElementView addSubview:addBtn];
        [addBtn addTarget:self action:@selector(addNewActivity) forControlEvents:UIControlEventTouchUpInside];
        
        yy+=2*ScreenHeightFactor;
    }
}


-(void)addNewActivity
{
    ActivityDetailView* act=[self.ActivityObjectArray objectAtIndex:pageControl.currentPage];
    [act addNewActivity];
}


@end
