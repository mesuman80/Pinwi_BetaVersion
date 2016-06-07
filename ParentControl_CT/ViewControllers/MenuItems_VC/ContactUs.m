//
//  WelcomeScreenViewController.m
//  ParentControl_CT
//
//  Created by Priyanka on 11/03/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "ContactUs.h"
#import "HeaderView.h"
#import "WebPageViewController.h"

//#import "AppEnterCodeTableViewController.h"

@interface ContactUs ()<HeaderViewProtocol>
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

@implementation ContactUs

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
    [self drawWebView];
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
     // [self drawBottomStrip];
}
-(void)drawWebView
{
    WebPageViewController *webPage=[[WebPageViewController alloc]initWithFrame:CGRectMake(0,yy, screenWidth, screenHeight-yy)];
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",@"http://pinwi.in/contactus.aspx?",[PC_DataManager sharedManager].parentObjectInstance.parentId];
    
    [webPage drawWebView:urlString];
    [self.view addSubview:webPage];
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
        [headerView setCentreImgName:@"contactHeader.png"];
        [headerView drawHeaderViewWithTitle:@"Contact Us" isBackBtnReq:YES BackImage:@"leftArrow.png"];
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
    [self.view setBackgroundColor:appBackgroundColor];
    
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
