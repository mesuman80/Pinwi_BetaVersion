//
//  WelcomeScreenViewController.m
//  ParentControl_CT
//
//  Created by Priyanka on 11/03/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "Support.h"
#import "SupportView.h"
#import "HeaderView.h"
#import "WebPageViewController.h"

//#import "AppEnterCodeTableViewController.h"

@interface Support ()<HeaderViewProtocol>
{
    UIImageView *topStrip,*bottomStrip,*titleImg, *centerIcon, *moreIcon, *navBgBar;
    UIScrollView *scrollView;
    UILabel *textLabel,*textLabel1;
    CGSize displayValueSize;
    UIButton *gotoTermsBtn;
    UIView *lineView;
    HeaderView *headerView;
    UITextField *activeField;
        int yy;
}
@end

@implementation Support

- (void)viewDidLoad {
    [super viewDidLoad];
//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
//        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [[PC_DataManager sharedManager]getWidthHeight];
    [[PC_DataManager sharedManager]welcomeScreen];
    
    [self.view setBackgroundColor:appBackgroundColor];
    
    self.navigationController.navigationBarHidden=YES;
    self.navigationItem.hidesBackButton = YES;
    
//    self.navigationItem.title=@"Support";
//    [self.navigationController.navigationBar setTitleTextAttributes:
//     [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
//    //[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:isiPhoneiPad(@"header_above.png")] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
//   
    
//    scrollView = [[UIScrollView alloc] init];
//    scrollView.backgroundColor=appBackgroundColor;
//    scrollView.scrollEnabled = NO;
//    //scrollView.pagingEnabled = YES;
//    scrollView.showsVerticalScrollIndicator = YES;
//    scrollView.showsHorizontalScrollIndicator = YES;
    [self drawHeaderView];
//    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
//    {
//        scrollView.frame=CGRectMake(0, 0, screenWidth, screenHeight);
//        scrollView.contentSize = CGSizeMake(screenHeight,screenHeight*2);
//        // code for landscape orientation
//    }
//    else
//    {
//        
//       
//       scrollView.frame=CGRectMake(0,yy, screenWidth, screenHeight-yy);
//        
////        if(screenWidth>700)
////        {
////             scrollView.frame=CGRectMake(0, 0, screenWidth, screenHeight-64);
////        }
////        else
////        {
////             scrollView.frame=CGRectMake(0, 0, screenWidth, screenHeight-([[UIApplication sharedApplication]statusBarFrame].size.height+ self.navigationController.navigationBar.frame.size.height)-64*2);
////        }
//       
//        scrollView.contentSize = CGSizeMake(screenWidth, screenHeight);
//    }
//    [self.view addSubview:scrollView];
//    
//    [self welcomeImages];
//   
//    [self textLabel];
  
    WebPageViewController *webPage=[[WebPageViewController alloc]initWithFrame:CGRectMake(0,yy, screenWidth, screenHeight-yy)];
    [webPage drawWebView:@"http://designer.convergenttec.com/pinwi/html/faq.html"];
    [self.view addSubview:webPage];
    
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
    [centerIcon removeFromSuperview];
    centerIcon=nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self drawCenterIcon];
     // [self drawBottomStrip];
}

-(void) welcomeImages
{
//    topStrip=[[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"headerBg.png")]];
//    topStrip.center=CGPointMake(screenWidth/2, .04*screenHeight);
//    [scrollView addSubview:topStrip];
    
    
    
//    titleImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed: isiPhoneiPad(@"pinwiLogowel.png") ]];
//    titleImg.center=CGPointMake(screenWidth/2,.1*screenHeight);
//    [scrollView addSubview:titleImg];
}

-(void) drawCenterIcon
{
//    centerIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed: isiPhoneiPad(@"supportHeader.png") ]];
//    centerIcon.frame=CGRectMake(0, 0, centerIcon.image.size.width, centerIcon.image.size.height);
//    if(self.view.frame.size.width>700)
//    {
//        centerIcon.center=CGPointMake(.5*screenWidth,self.navigationController.navigationBar.frame.size.height+24);
//    }
//    else
//    {
//        centerIcon.center=CGPointMake(.5*screenWidth,self.navigationController.navigationBar.frame.size.height+5);
//    }
// //   centerIcon.center=CGPointMake(.5*screenWidth,self.navigationController.navigationBar.frame.size.height+20);
//    [self.navigationController.navigationBar addSubview:centerIcon];
    
}

-(void) textLabel
{
    int scrollY=screenHeight*.1;
     scrollView.scrollEnabled=YES;
    for(int i=1; i<=10; i++)
    {
        SupportView *sprt=[[SupportView alloc]initWithFrame:CGRectMake(screenWidth*.15, scrollY, screenWidth*.7, screenHeight*.2)withSupportNo:i];
        [scrollView addSubview:sprt];
        sprt.userInteractionEnabled=NO;
        scrollY+=sprt.frame.origin.x+sprt.frame.size.height;
//        if(scrollY>screenHeight*.9)
//        {
//            scrollView.scrollEnabled=YES;
//            [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height+sprt.frame.size.height+20)];
//        }

        
//        if(scrollY>screenHeight*.9)
//        {
//            scrollView.scrollEnabled=YES;
//            [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height+sprt.frame.size.height+20)];
//        }
        
    }
    scrollView.scrollEnabled=YES;
    [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width,scrollY)];
//     bottomStrip=[[UIImageView alloc]initWithImage:[UIImage imageNamed: isiPhoneiPad(@"welcomefooter.png") ]];
//    [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height+bottomStrip.frame.size.height+20)];
//    bottomStrip.center=CGPointMake(screenWidth/2, scrollView.contentSize.height-bottomStrip.frame.size.height/2);
//    [scrollView addSubview:bottomStrip];
    
    

   }


-(void)drawBottomStrip
{
    if(!bottomStrip)
    {
    bottomStrip=[[UIImageView alloc]initWithImage:[UIImage imageNamed: isiPhoneiPad(@"welcomefooter.png") ]];
    [bottomStrip setBackgroundColor:[UIColor whiteColor]];
    [bottomStrip setFrame:CGRectMake(0,scrollView.contentSize.height-64,screenWidth, 64)];
    //[scrollView setContentSize:CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height+bottomStrip.frame.size.height+20)];
    bottomStrip.center=CGPointMake(screenWidth/2,bottomStrip.center.y);
    [scrollView addSubview:bottomStrip];
    [scrollView bringSubviewToFront:bottomStrip];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark KeyBoard Notification
-(void)addKeyBoardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}
-(void) keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0f, 0.0, kbSize.height-64, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    CGRect aRect = scrollView.frame;
    aRect.size.height -= kbSize.height;
    CGPoint point=activeField.frame.origin;
    point.y+=64;
    if (!CGRectContainsPoint(aRect,point))
    {
        CGPoint scrollPoint = CGPointMake(0.0,activeField.frame.origin.y-aRect.size.height+activeField.frame.size.height+5);
        scrollPoint.y+=64;
        [scrollView setContentOffset:scrollPoint animated:YES];
        //CGPointMake
        [scrollView setContentSize:CGSizeMake(screenWidth, screenHeight+64)];
    }
}
-(void) keyboardWillHide:(NSNotification *)notification
{
    UIEdgeInsets contentInsets=UIEdgeInsetsMake(0, 0.0,0.0, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    NSLog(@"Live=%f",self.view.frame.size.height/2.0f);
    [ scrollView setContentSize:CGSizeMake(screenWidth, screenHeight)];
}
-(void)drawHeaderView
{
    if(!headerView)
    {
        headerView  = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320,ScreenHeightFactor*64)];
        [headerView setBackgroundColor:[UIColor clearColor]];
        [headerView setRootViewController:self];
        [headerView setHeaderViewdelegate:self];
        [headerView setRightType:nil];
        [headerView setCentreImgName:@"supportHeader.png"];
        [headerView drawHeaderViewWithTitle:@"FAQs" isBackBtnReq:YES BackImage:@"leftArrow.png"];
        [self.view addSubview:headerView];
        if(screenWidth>700)
        {
            yy+=headerView.frame.size.height+30*ScreenHeightFactor;
        }
        else
        {
            yy+=headerView.frame.size.height+18*ScreenHeightFactor;
            
        }

    }
    
    
}
-(void)getMenuTouches
{
    
}
-(void)touchAtBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue gotoTermsBtner:(id)gotoTermsBtner {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
