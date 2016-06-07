//
//  NetworkViewController.m
//  ParentControl_CT
//
//  Created by Priyanka on 03/04/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "WhatToDo.h"
#import "PC_DataManager.h"
#import "HeaderView.h"
#import "RedLabelView.h"
#import "ParentViewProfile.h"
#import "MenuSettingsView.h"
#import "WhatToDoDetailViewController.h"


@interface WhatToDo ()<HeaderViewProtocol,UIScrollViewDelegate>

@end

@implementation WhatToDo

{
    HeaderView *headerView;
    UIScrollView *scrollView;
    int yy;
    int yCord, xCord;
    UIButton *continueButton;
    MenuSettingsView *menu;
    BOOL isToggleMenu;
    int scrollXX;
    int initialY;
    int reduceYY;
    NSMutableArray *ChildNameArray;
    UIPageControl *pageControl;
    int pageControlHeight;
    BOOL pageControlBeingUsed;
    NSInteger pageIndexVal;

 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    yy=0;
    [self.view setBackgroundColor:appBackgroundColor];
    pageControlHeight = (ScreenWidthFactor*20);
    
    [self drawUiWithHead];
    [self drawHeaderView];
  //  [self drawUI];

    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated{
    reduceYY =0;
    [super viewWillAppear:animated];
     self.navigationController.navigationBarHidden=YES;
//    [self drawUiWithHead];
//    [self drawHeaderView];
//    [self drawUI];
 
    [self.tabBarCtrl.tabBar setSelectedImageTintColor:[UIColor purpleColor]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
          [headerView setCentreImgName:@"whatToDoHeader.png"];
        [headerView setRightType:@"Menu"];
        [headerView drawHeaderViewWithTitle:@"What To Do" isBackBtnReq:YES BackImage:@"homeBack.png"];
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
    
   // [self setupPageControl:[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles.count];
    
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
        menu.layer.borderColor=[UIColor blackColor].CGColor;
        [menu.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
        menu.userInteractionEnabled=YES;
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
    return screenWidth >700 ? -20 :0;
}



#pragma mark drawUI
-(void)drawUiWithHead
{
  //  [self setupPageControl:[PC_DataManager sharedManager].parentObjectInstance.childrenProfiles.count];
    if(!scrollView)
    {
        scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,yy, self.view.frame.size.width, self.view.frame.size.height-yy)];
        [scrollView setPagingEnabled:YES];
        [scrollView setScrollEnabled:YES];
        [scrollView setBackgroundColor:appBackgroundColor];
        [scrollView setDelegate:self];
        [self.view addSubview:scrollView];
        
        yCord+=20*ScreenHeightFactor;
        
        [self  drawLabelWithText:@"Coming Soon" andColor:[UIColor darkGrayColor] andFont:[UIFont fontWithName:RobotoLight size:9*ScreenFactor]];
        
        yCord+=20*ScreenHeightFactor;
        
        xCord += [PC_DataManager sharedManager].parentObjectInstance.childrenProfiles.count *scrollView.frame.size.width;
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
    
    [headerView addSubview:pageControl];
}
//-(void)scrollViewDidScroll:(UIScrollView *)sender
//{
//    if (!pageControlBeingUsed)
//    {
//        CGFloat pageWidth = sender.frame.size.width;
//        int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//        pageControl.currentPage = page;
//        
//    }
//    
//}
//- (void)scrollViewWillBeginDragging:(UIScrollView *)sender
//{
//    pageControlBeingUsed = NO;
//    
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender
//{
//    pageControlBeingUsed = NO;
//    
//}

#pragma mark DrawingSpecific Functions
-(void)drawUI
{
    if(self.pageController == nil) {
        self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        self.pageController.dataSource = self;
        self.pageController.delegate = self;
        if (screenWidth>700) {
            [[self.pageController view] setFrame:CGRectMake(0,yy+5, screenWidth,screenHeight-headerView.frame.size.height)];
        }else{
            [[self.pageController view] setFrame:CGRectMake(0,yy-5, screenWidth,screenHeight-headerView.frame.size.height)];
        }
        WhatToDoDetailViewController *initialViewController = [self viewControllerAtIndex:0];
        NSArray *viewController = [NSArray arrayWithObject:initialViewController];
        [self.pageController setViewControllers:viewController direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        [self addChildViewController:self.pageController];
        
        [[self view] addSubview:[self.pageController view]];
        [self.pageController didMoveToParentViewController:self];
    }
    
    
    
}

-(UILabel*)drawLabelWithText:(NSString*)title1 andColor:(UIColor*)color andFont:(UIFont*)font
{
    NSString *title=@"You will soon be able to view recommended activities for your children based on their interest reports and network activities.";
    UILabel *label = [[UILabel alloc]init];
    //[label setText:title];
    [label setTextColor:color];
//    [label setFont:font];
    [label setNumberOfLines:0];
    //CGSize size = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
   // CGSize displayValueSize = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
    label.font=font;//[UIFont fontWithName:RobotoLight size:[[welcomeScreenSizeArray objectAtIndex:1] floatValue]];
    label.text=title;
    CGSize  size = {self.view.frame.size.width - 60, 10000.0};
    CGRect frame = [label.text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                              attributes:@{NSFontAttributeName:label.font}
                                                 context:nil];
    
    [label setFrame:CGRectMake(10*ScreenWidthFactor,yCord, frame.size.width, frame.size.height)];
    [scrollView addSubview:label];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setCenter:CGPointMake(scrollView.frame.size.width/2, scrollView.frame.size.height*.4)];
    yCord+=label.frame.origin.y + label.frame.size.height+10*ScreenHeightFactor;
    
    label=[[UILabel alloc]init];
    NSString *str=@"Isn’t that swell!";
    size = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11*ScreenFactor]}];
    label.font=[UIFont fontWithName:RobotoBold size:11*ScreenFactor];
    label.text=str;
    label.frame=CGRectMake(20*ScreenWidthFactor,yCord,size.width,size.height);
    [label sizeToFit];
    label.textColor=[UIColor blackColor];
    label.center=CGPointMake(screenWidth/2,label.center.y);
    [scrollView addSubview:label];
    
    return label;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSInteger index = [(WhatToDoDetailViewController*)viewController index];
    if (index == 0) {
       // pageIndexVal = index;
        return nil;
    }
    index--;
    pageIndexVal = index;
    return [self viewControllerAtIndex:index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSInteger index = [(WhatToDoDetailViewController*)viewController index];
    if (index == [PC_DataManager sharedManager].parentObjectInstance.childrenProfiles.count-1) {
        return nil;
    }
    index++;
    pageIndexVal = index;
    return [self viewControllerAtIndex:index];
}

-(WhatToDoDetailViewController*)viewControllerAtIndex:(NSInteger)index{
    WhatToDoDetailViewController *whatToDoDetailViewController = [[WhatToDoDetailViewController alloc] init:index];
    whatToDoDetailViewController.index = index;
    return whatToDoDetailViewController;
}
-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{
    
   return [PC_DataManager sharedManager].parentObjectInstance.childrenProfiles.count;
}
-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController{
    //return 0;
    return pageIndexVal;
}



-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    WhatToDoDetailViewController *detailController= (WhatToDoDetailViewController *)pendingViewControllers[0];
    pageControl.currentPage = detailController.index;
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
