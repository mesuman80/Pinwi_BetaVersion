//
//  MoreViewController.m
//  ParentControl_CT
//
//  Created by Priyanka on 03/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "InsightViewController.h"
#import "PC_DataManager.h"
#import "InsightView.h"
#import "SubscribeButtonView.h"
#import "Constant.h"
#import "ChildProfileObject.h"
#import "InsightData.h"
#import "PinWiRightSideButton.h"
#import "MenuSettingsView.h"
#import "HeaderView.h"
#import "TutorialPlayView.h"
#import "ParentViewProfile.h"

@interface InsightViewController ()<SubscribeButtonViewDelegate,UIScrollViewDelegate,HeaderViewProtocol>

@end

@implementation InsightViewController
{
    UIScrollView *scrollView;
    BOOL pageControlBeingUsed;
    UIPageControl *pageControl;
    int currentPage;
    int scrollXX;
    int reduceYY;
    int initialY;
    int pageControlHeight;
    BOOL isViewAppear;
    UIImageView *centerIcon;
    HeaderView *headerView ;
    MenuSettingsView *menu;
    SubscribeButtonView *subscribeView;
    UIView *view1;
    BOOL isToggleMenu;
    
    int yy;
    
    UIView *loadElementView;
    UIView *removeMenuView;
}

#pragma mark ViewLifeCycleFunctions
- (void)viewDidLoad {
    [super viewDidLoad];
    [[PC_DataManager sharedManager]getWidthHeight];
    self.edgesForExtendedLayout = UIRectEdgeNone;
     pageControlHeight = (ScreenWidthFactor*20);

    if(!loadElementView)
    {
        loadElementView=[[UIView alloc]initWithFrame:CGRectMake(0,0, screenWidth*1.5, screenHeight)];
        [self.view addSubview:loadElementView];
    }

    [self.view setBackgroundColor:appBackgroundColor];
    isViewAppear = NO;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    
    if(!isViewAppear)
    {
        reduceYY = 0;
       //initialY = 20*ScreenFactor + 64;
        [self drawHeaderView];
        [self drawUI];
        [self subscribeNowView];
        [self drawTutorial];
    }
   isViewAppear = YES;
    [self.tabBarCtlr.tabBar setSelectedImageTintColor:[UIColor redColor]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [pageControl removeFromSuperview];
//     pageControl = nil;
//    [scrollView removeFromSuperview];
//     scrollView = nil;
    [[InsightData insightData]updateConnectionArray:nil isRemove:NO isAllRemove:YES];
    isViewAppear = NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark SubscribeSpecificFunctions
-(void)subscribeNowView
{
//    if(!subscribeView)
//    {
//     subscribeView = [[SubscribeButtonView alloc]initWithFrame:CGRectMake(0,screenHeight - (screenHeight*.16f)-self.tabBarController.tabBar.frame.size.height,screenWidth,screenHeight*.16f)];
//    [subscribeView setDelegate:self];
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
//    [dictionary setValue:@"Interested in more Insights?" forKey:@"labelStr"];
//    [dictionary setValue:@"Subscribe Now" forKey:@"buttonStr"];
//    [subscribeView drawUI:dictionary];
//    [subscribeView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewContentModeBottom];
//    [self.view addSubview:subscribeView];
//    reduceYY +=(subscribeView.frame.size.height + initialY);
//    }
}
-(void)touchAtSubscribe:(SubscribeButtonView *)subscribeButton
{
    NSLog(@"Subscribe at Insight View Controller");
}
#pragma mark NavigationBarSetUp
-(void)navigationBarSetup
{
     self.navigationItem.title=@"Insights";
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed : isiPhoneiPad( @"header_above.png")] forBarMetrics:UIBarMetricsDefault];
   self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIFont fontWithName:RobotoRegular size:21],
      NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"Flower_pinwii.png")] style:UIBarButtonItemStyleDone target:self action:@selector(touchAtRightBarButton:)];
}

-(void)touchAtRightBarButton:(id)sender
{
    NSLog(@"Right Buttton Touch");
}
#pragma mark UISpecificFunctions
-(void)drawUI
{
    if(!scrollView)
    {
         [self.view setBackgroundColor:appBackgroundColor];
    NSMutableArray *array =[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles;
    scrollXX = 0;
    int i = 0 ;
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,initialY, self.view.frame.size.width,self.view.frame.size.height-reduceYY/2-self.navigationController.navigationBar.frame.size.height/2)];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    scrollView.pagingEnabled = YES;
    [scrollView setDelegate:self];
    [loadElementView addSubview:scrollView];
    scrollXX = 0;
    NSInteger count  = array.count;
    while (i<count)
    {
        InsightView *insightView = [[InsightView alloc]initWithFrame:CGRectMake(scrollXX,0, scrollView.frame.size.width, scrollView.frame.size.height)];
         ChildProfileObject *childProfileObject =  [array objectAtIndex:i];
        [insightView setBackgroundColor:[UIColor clearColor]];
        [insightView setRootViewController:self];
        [insightView setTabBarCtlr:self.tabBarCtlr];
        [insightView drawUI:childProfileObject];
        [scrollView addSubview:insightView];
        scrollXX += insightView.frame.size.width;
        yy+=insightView.frame.size.height;
        i++;
    }
        
//        if(!subscribeView)
//        {
//            subscribeView = [[SubscribeButtonView alloc]initWithFrame:CGRectMake(0,yy,screenWidth,screenHeight*.16f)];
//            [subscribeView setDelegate:self];
//            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
//            [dictionary setValue:@"Interested in more Insights?" forKey:@"labelStr"];
//            [dictionary setValue:@"Subscribe Now" forKey:@"buttonStr"];
//            [subscribeView drawUI:dictionary];
//            [subscribeView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewContentModeBottom];
//            [scrollView addSubview:subscribeView];
//            yy+=subscribeView.frame.size.height;
//          //  reduceYY +=(subscribeView.frame.size.height + initialY);
//        }
//    
    [scrollView setContentSize:CGSizeMake(scrollXX,scrollView.frame.size.height)];
    
    }
}
-(void)setupPageControl:(NSInteger)number_Of_Page
{
    int height  = [self navigationBarHeight];
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
#pragma mark headerViewSpecificFunction
-(void)drawHeaderView
{
    if(!headerView)
    {
        headerView  = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320,ScreenHeightFactor*64)];
        [headerView setBackgroundColor:appBackgroundColor];//[UIColor whiteColor]];
        [headerView setRootViewController:self];
        [headerView setHeaderViewdelegate:self];
        [headerView setRightType:@"Menu"];
        [headerView setCentreImgName:@"insightHeader.png"];
        [headerView drawHeaderViewWithTitle:@"Insights" isBackBtnReq:YES BackImage:@"homeBack.png"];
        //[self.view bringSubviewToFront:headerView];
        [loadElementView addSubview:headerView];
        
        [self setupPageControl:[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles.count];
       /*
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"header_above.png")]];
        [imageView setFrame:CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height)];
        [headerView addSubview:imageView];
        
         UIImage *img = [UIImage imageNamed:isiPhoneiPad(@"Flower_pinwii.png")];
        
        PinWiRightSideButton *button = [[PinWiRightSideButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-60, 0, img.size.width,img.size.height)];
    
        
        if(self.view.frame.size.width>700)
        {
            // moreImg.frame=CGRectMake(topStrip.frame.size.width-topStrip.frame.size.height-10, 0,topStrip.frame.size.height-10, topStrip.frame.size.height-22);
            button.frame=CGRectMake(headerView.frame.size.width-img.size.width*2-5,0,img.size.width,img.size.height);
        }
        else
        {
            button.frame=CGRectMake(headerView.frame.size.width-img.size.width*2-10, 0,img.size.width*2,img.size.height*2);
        }

        
        [button setCenter:CGPointMake(button.center.x, headerView.frame.size.height/2+10)];
        [button setDelegate:self];
        [button drawRightHandButton];
        [headerView addSubview:button];
        
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        label.text = @"Insights";
        label.textColor = [UIColor whiteColor];
        if(screenWidth>700)
        {
            label.font = [UIFont fontWithName:RobotoRegular size:20.0f];
        }
        else
        {
            label.font = [UIFont fontWithName:RobotoRegular size:18.0f];
        }
        
        CGSize labelSize = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
        [label setFrame:CGRectMake(0,0, labelSize.width, labelSize.height)];
        if([self navigationBarHeight] == 0) // For Iphone
        {
            [label setCenter:CGPointMake(headerView.frame.size.width/2.0f,headerView.frame.size.height/2.0f+8)];
        }
        else
        {
            [label setCenter:CGPointMake(headerView.frame.size.width/2.0f,headerView.frame.size.height/2.0f+8)];
        }
        
        [headerView addSubview:label];

        centerIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"insightHeader.png") ]];
        centerIcon.frame=CGRectMake(0,headerView.frame.size.height-10, centerIcon.image.size.width, centerIcon.image.size.height);
        if(self.view.frame.size.width>700)
        {
            centerIcon.center=CGPointMake(.5*screenWidth,centerIcon.center.y-3);
        }
        else
        {
            centerIcon.center=CGPointMake(.5*screenWidth,centerIcon.center.y );
        }
        [self.view addSubview:centerIcon];*/
        
    }
   
  initialY = 20*ScreenHeightFactor + headerView.frame.size.height;
    
    
    
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
//        view1=[[UIView alloc]initWithFrame:CGRectMake(screenWidth,0-headerView.frame.size.height, screenWidth*.5, screenHeight)];
//        view1.backgroundColor=appBackgroundColor;
//        [self.view addSubview:view1];
        
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
        [loadElementView setCenter:CGPointMake(loadElementView.center.x-screenWidth*.5, loadElementView.center.y)];
    } completion:^(BOOL finished) {
        [loadElementView setUserInteractionEnabled:YES];
    }];
    
}
-(void)slideOut
{
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [removeMenuView removeFromSuperview];
        [loadElementView setUserInteractionEnabled:NO];
        scrollView.alpha=1.0f;
        scrollView.userInteractionEnabled=YES;
        [loadElementView setCenter:CGPointMake(loadElementView.center.x+screenWidth*.5, loadElementView.center.y)];
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
    return screenWidth >700 ? 0 :0;
}
#pragma mark Tutorial
-(void)drawTutorial
{
    if(![[[NSUserDefaults standardUserDefaults]objectForKey:@"InsightsTutorial1"]isEqualToString:@"1"])
    {
        TutorialPlayView *tutorial=[[TutorialPlayView alloc]init];
        tutorial.tutorialName=@"Insights";
        tutorial.loadIndexVal=insightsIndex;
        [self presentViewController:tutorial animated:YES completion:nil];
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"InsightsTutorial1"];
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
