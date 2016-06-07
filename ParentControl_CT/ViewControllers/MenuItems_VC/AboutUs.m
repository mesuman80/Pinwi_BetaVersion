//
//  WelcomeScreenViewController.m
//  ParentControl_CT
//
//  Created by Priyanka on 11/03/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "AboutUs.h"
#import "ParentViewProfile.h"
#import "HeaderView.h"
#import "WebPageViewController.h"
//#import "AppEnterCodeTableViewController.h"

@interface AboutUs ()<HeaderViewProtocol>
{
    UIImageView *topStrip,*bottomStrip,*titleImg, *centerIcon, *moreIcon, *navBgBar;
    UIScrollView *scrollView;
    UILabel *textLabel,*textLabel1;
    CGSize displayValueSize;
    UIButton *gotoTermsBtn;
    UIView *lineView;
    HeaderView *headerView ;
    UITextField *activeField;
    int yy ;
}
@end

@implementation AboutUs

- (void)viewDidLoad {
    [super viewDidLoad];

    [[PC_DataManager sharedManager]getWidthHeight];
    [[PC_DataManager sharedManager]welcomeScreen];
    yy = 0;
    [self.view setBackgroundColor:appBackgroundColor];
    
    self.navigationController.navigationBarHidden=YES;
    self.navigationItem.hidesBackButton = YES;

    scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor=appBackgroundColor;
    scrollView.scrollEnabled = NO;
    //scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.showsHorizontalScrollIndicator = YES;
    [self drawHeaderView];
    
    WebPageViewController *webPage=[[WebPageViewController alloc]initWithFrame:CGRectMake(0,yy, screenWidth, screenHeight-yy)];
    [webPage drawWebView:@"http://pinwi.in/aboutus.html"];
    [self.view addSubview:webPage];
    
//    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
//    {
//        scrollView.frame=CGRectMake(0, 0, screenWidth, screenHeight);
//        scrollView.contentSize = CGSizeMake(screenHeight,screenHeight*2);
//        // code for landscape orientation
//    }
//    else
//    {
////        if(screenWidth>700)
////        {
////            scrollView.frame=CGRectMake(0, 0, screenWidth, screenHeight);
////
////        }
////        else
////        {
//      
//            scrollView.frame=CGRectMake(0,yy, screenWidth, screenHeight-yy);
//
////        }
//        scrollView.contentSize = CGSizeMake(screenWidth, screenHeight);
//    }
// //   [self.view addSubview:scrollView];
//    
////    [self welcomeImages];
////    
////    [self textLabel];
////    [self addButton];
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self drawCenterIcon];
}

-(void)getWidthHeight
{
    
    screenHeight=[ScreenInfo getScreenHeight];
    screenWidth=[ScreenInfo getScreenWidth];
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
-(void) welcomeImages
{
//    topStrip=[[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"headerBg.png")]];
//    topStrip.center=CGPointMake(screenWidth/2, .04*screenHeight);
//    [scrollView addSubview:topStrip];
    
//    bottomStrip=[[UIImageView alloc]initWithImage:[UIImage imageNamed: isiPhoneiPad(@"welcomefooter.png") ]];
//    bottomStrip.center=CGPointMake(screenWidth/2, scrollView.contentSize.height-bottomStrip.frame.size.height/2);
//    [scrollView addSubview:bottomStrip];
//    
    titleImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed: isiPhoneiPad(@"pinwiLogowel.png") ]];
    titleImg.center=CGPointMake(screenWidth/2,.12*screenHeight);
    [scrollView addSubview:titleImg];
}

-(void) drawCenterIcon
{
//    centerIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed: isiPhoneiPad(@"aboutHeader.png") ]];
//    centerIcon.frame=CGRectMake(0, 0, centerIcon.image.size.width, centerIcon.image.size.height);
//    if(self.view.frame.size.width>700)
//    {
//        // centerIcon.frame=CGRectMake(0, 0,centerIcon.image.size.height-20, centerIcon.image.size.height-20);
//         centerIcon.center=CGPointMake(.5*screenWidth,self.navigationController.navigationBar.frame.size.height+20);
//        
//    }
//    else
//    {
//          centerIcon.frame=CGRectMake(0, 0, centerIcon.image.size.width, centerIcon.image.size.height);
//         centerIcon.center=CGPointMake(.5*screenWidth,self.navigationController.navigationBar.frame.size.height+5);
//       
//    }
//   
//   
//    [self.navigationController.navigationBar addSubview:centerIcon];
    
}

-(void) textLabel
{
    
    UITextView  *myTextView = nil;
    if(screenWidth>700)
    {
        myTextView = [[UITextView alloc]initWithFrame:
         CGRectMake(scrollView.frame.size.width*.15, scrollView.frame.size.height*.25, scrollView.frame.size.width*.7, scrollView.frame.size.height*.35)];
    }
    else
    {
        myTextView = [[UITextView alloc]initWithFrame:
                      CGRectMake(scrollView.frame.size.width*.15, scrollView.frame.size.height*.25, scrollView.frame.size.width*.7, scrollView.frame.size.height*.35)];
    }
    myTextView.backgroundColor=appBackgroundColor;
    [myTextView setFont:[UIFont fontWithName:RobotoLight size:10*ScreenHeightFactor]];
    
    [myTextView setText:@"dfcdvcdvcjhgehjfgrjfghegrhjeghjegrjhejvejgjegrhjegjhwgvjheghjeghjegjhegjhegjgefgrhghfbcbyegbrhgfhgfhgfhgfhgfhdgfhfgfghdfghdfghdfghdfgchfghfghfghfghfghfghfhfghfghfghfghfghfghfghfgfghfghfghfghfghfghdfcdfchfgchdfgchdfgchdfgchdfgchdfgchdfgcdfhgcdfhgcdfhgcdfhgcdfhgcdfhgchdfcdvcdvcjhgehjfgrjfghegrhjeghjegrjhejvejgjegrhjegjhwgvjheghjeghjegjhegjhegjgefgrhghfbcbyegbrhgfhgfhgfhgfhgfhdgfhfgfghdfghdfghdfghdfgchfghfghfghfghfghfghfhfghfghfghfghfghfghfghfgfghfghfghfghfghfghdfcdfchfgchdfgchdfgchdfgchdfgchdfgchdfgcdfhgcdfhgcdfhgcdfhgcdfhgcdfhgchdfcdvcdvcjhgehjfgrjfghegrhjeghjegrjhejvejgjegrhjegjhwgvjheghjeghjegjhegjhegjgefgrhghfbcbyegbrhgfhgfhgfhgfhgfhdgfhfgfghdfghdfghdfghdfgchfghfghfghfghfghfghfhfghfghfghfghfghfghfghfgfghfghfghfghfghfghdfcdfchfgchdfgchdfgchdfgchdfgchdfgchdfgcdfhgcdfhgcdfhgcdfhgcdfhgcdfhgch"];
    [scrollView addSubview:myTextView];
    //[myTextView setBackgroundColor:[UIColor redColor]];

   // [myTextView sizeToFit];
    
     
     textLabel1=[[UILabel alloc]init];
//    [NSString stringWithFormat:@"Copyright \u00A9 2010"]
    NSString *str1=@"version 1.0 \n\n \u00A9 2015 All Rights Reserved.";
    displayValueSize = [str1 sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[[welcomeScreenSizeArray objectAtIndex:1]floatValue]]}];
    textLabel1.font=[UIFont fontWithName:RobotoLight size:[[welcomeScreenSizeArray objectAtIndex:1] floatValue]];
    textLabel1.text=str1;
    textLabel1.lineBreakMode = NSLineBreakByWordWrapping;
    textLabel1.numberOfLines = 0;
    textLabel1.frame=CGRectMake(screenWidth*.2, screenHeight*.65,screenWidth*.55,screenHeight*.25);
    
    textLabel1.textColor=[UIColor darkGrayColor];
    textLabel1.textAlignment=NSTextAlignmentCenter;
    //textLabel.center=CGPointMake(screenWidth/2, scrollView.frame.size.height*.5);
    [scrollView addSubview:textLabel1];
    //[textLabel1 sizeToFit];
}

-(void)addButton
{
    gotoTermsBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    [gotoTermsBtn setTitle:@"View Terms and Conditions" forState:UIControlStateNormal];
    
    gotoTermsBtn.tintColor=radiobuttonSelectionColor;
    gotoTermsBtn.backgroundColor=[UIColor clearColor];
    gotoTermsBtn.layer.borderColor = radiobuttonSelectionColor.CGColor;
    gotoTermsBtn.layer.borderWidth = 1.0;
    [gotoTermsBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    gotoTermsBtn.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.025*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    [gotoTermsBtn sizeToFit];
    gotoTermsBtn.frame=CGRectMake(.15*screenWidth, .6*screenHeight, .7*screenWidth, .07*screenHeight);
    gotoTermsBtn.center=CGPointMake(screenWidth*.5,screenHeight*.65);
    [gotoTermsBtn addTarget:self action:@selector(gotoTermsButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:gotoTermsBtn];

}

-(void)gotoTermsButtonTouch
{
   
    
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
#pragma mark HeaderViewSpecificFunction
-(void)drawHeaderView
{
    if(!headerView)
    {
        headerView  = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidthFactor*320,ScreenHeightFactor*64)];
        [headerView setBackgroundColor:[UIColor clearColor]];
        [headerView setRootViewController:self];
        [headerView setHeaderViewdelegate:self];
        [headerView setRightType:nil];
        [headerView setCentreImgName:@"aboutHeader.png"];
        [headerView drawHeaderViewWithTitle:@"About Us" isBackBtnReq:YES BackImage:@"leftArrow.png"];
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
