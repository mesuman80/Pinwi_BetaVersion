//
//  WelcomeScreenViewController.m
//  ParentControl_CT
//
//  Created by Priyanka on 11/03/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "WelcomeScreenViewController.h"
#import "ParentViewProfile.h"
#import "HeaderView.h"
#import "TutorialPlayView.h"
//#import "AppEnterCodeTableViewController.h"



@interface WelcomeScreenViewController ()<HeaderViewProtocol,TutorialProtocol>

{
    UIImageView *topStrip,*bottomStrip,*titleImg, *centerIcon, *moreIcon, *navBgBar;
    UIScrollView *scrollView;
    UILabel *textLabel,*textLabel1;
    CGSize displayValueSize;
    UIButton *getStartedButton;
    UIView *lineView;
    HeaderView *headerView;
    int yy;
    UITextField *activeField;
    TutorialPlayView *tutorial;
}
@end

@implementation WelcomeScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   [[PC_DataManager sharedManager]getWidthHeight];
    [[PC_DataManager sharedManager]welcomeScreen];
    
 
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.hidesBackButton = YES;
     self.view.backgroundColor=appBackgroundColor;

    

    scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor=appBackgroundColor;
    scrollView.scrollEnabled = YES;
    //scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.showsHorizontalScrollIndicator = YES;
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        scrollView.frame=CGRectMake(0, 0, screenWidth, screenHeight);
        scrollView.contentSize = CGSizeMake(screenHeight,screenHeight*2);
        // code for landscape orientation
    }
    else
    {
        scrollView.frame=CGRectMake(0,yy, screenWidth, screenHeight-yy);
        scrollView.contentSize = CGSizeMake(screenWidth, screenHeight);
    }
    [self.view addSubview:scrollView];
    


    [self drawHeaderView];
    [self drawMoreIcon];
    [self welcomeImages];
    
   [self textLabel];
    [self addButton];
    
  [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"RegistrationCompleted"];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self addKeyBoardNotification];
    //self.navigationController.navigationBarHidden=NO;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:isiPhoneiPad(@"header_above.png")] forBarMetrics:UIBarMetricsDefault];
    // self.navigationItem.hidesBackButton = NO;
    self.navigationController.navigationBar.topItem.title = @"";
    self.title = @"Confirm Profile";
    [self drawCenterIcon];
   
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    self.navigationItem.hidesBackButton = YES;
//    self.title = @"Confirm Profile";
//    [self drawCenterIcon];

}

-(void)getWidthHeight
{
   
    screenHeight=[ScreenInfo getScreenHeight];
    screenWidth=[ScreenInfo getScreenWidth];
    }
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [centerIcon removeFromSuperview];
    centerIcon=nil;
}

-(void) welcomeImages
{
    
//   topStrip=[[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"header_above.png")]];
//    [topStrip setFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
//    topStrip.center=CGPointMake(screenWidth/2, .04*screenHeight);
//    [scrollView addSubview:topStrip];
    
    bottomStrip=[[UIImageView alloc]initWithImage:[UIImage imageNamed: isiPhoneiPad(@"welcomefooter.png") ]];
    [topStrip setFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    bottomStrip.center=CGPointMake(screenWidth/2, screenHeight-bottomStrip.frame.size.height/2);
    [scrollView addSubview:bottomStrip];
   
    titleImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed: isiPhoneiPad(@"pinwiLogowel.png") ]];
    titleImg.center=CGPointMake(screenWidth/2,.32*screenHeight);
    [scrollView addSubview:titleImg];
}

-(void) drawCenterIcon
{
//<<<<<<< HEAD
////    centerIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed: isiPhoneiPad(@"Confirm_header.png") ]];
////    centerIcon.frame=CGRectMake(0, 0, centerIcon.image.size.width, centerIcon.image.size.height);
////    centerIcon.center=CGPointMake(.5*screenWidth,self.navigationController.navigationBar.frame.size.height+5);
////    [self.navigationController.navigationBar addSubview:centerIcon];
//=======
//    centerIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed: isiPhoneiPad(@"Confirm_header.png") ]];
//    centerIcon.frame=CGRectMake(0, 0, centerIcon.image.size.width, centerIcon.image.size.height);
//    //centerIcon.center=CGPointMake(.5*screenWidth,self.navigationController.navigationBar.frame.size.height+5);
//    NSLog(@"self.navigationController.navigationBar, self.navigationController.navigationBar.height = %@,%f", self.navigationController.navigationBar, self.navigationController.navigationBar.frame.size.height);
//    if(self.view.frame.size.width>700)
//    {
//        centerIcon.center=CGPointMake(.5*screenWidth,self.navigationController.navigationBar.frame.size.height+20);
//    }
//    else
//    {
//        centerIcon.center=CGPointMake(.5*screenWidth,self.navigationController.navigationBar.frame.size.height+5);
//    }
//    [self.navigationController.navigationBar addSubview:centerIcon];
//>>>>>>> origin/v2
    
}
-(void) drawMoreIcon
{
    moreIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:  isiPhoneiPad(@"Flower_pinwii.png") ]];
    moreIcon.frame=CGRectMake(0, 0, moreIcon.image.size.width, moreIcon.image.size.height);
    moreIcon.center=CGPointMake(screenWidth-moreIcon.image.size.width, self.navigationController.navigationBar.frame.size
                                .height/2);
    [self.navigationController.navigationBar addSubview:moreIcon];
    
}



-(void) textLabel
{
    
    textLabel=[[UILabel alloc]init];
    NSString *str=[welcomeScreenArray objectAtIndex:0];
    displayValueSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[[welcomeScreenSizeArray objectAtIndex:0]floatValue]]}];
    textLabel.font=[UIFont fontWithName:RobotoBold size:[[welcomeScreenSizeArray objectAtIndex:0] floatValue]];
    textLabel.text=str; 
    textLabel.frame=CGRectMake([[welcomecreenPosPXArray objectAtIndex:0]floatValue],[[welcomeScreenPosPYArray objectAtIndex:0]floatValue],displayValueSize.width,displayValueSize.height);
    [textLabel sizeToFit];
    textLabel.textColor=[UIColor blackColor];
    textLabel.center=CGPointMake(screenWidth/2, textLabel.center.y);
    [scrollView addSubview:textLabel];
    
    lineView= [[PC_DataManager sharedManager] drawLineView_withXPos:screenWidth/2 andYPos:screenHeight*.45 withScrnWid:.2*screenWidth withScrnHt:.001*screenHeight ofColor:welcomelinecolorCode];
   
    [scrollView addSubview:lineView];

    textLabel1=[[UILabel alloc]init];
    NSString *str1=[welcomeScreenArray objectAtIndex:1];
    
      displayValueSize = [str1 sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[[welcomeScreenSizeArray objectAtIndex:1]floatValue]]}];
    textLabel1.font=[UIFont fontWithName:RobotoLight size:[[welcomeScreenSizeArray objectAtIndex:1] floatValue]];
    textLabel1.text=str1;
    CGSize  size = {self.view.frame.size.width - 60, 10000.0};
    CGRect frame = [textLabel1.text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                              attributes:@{NSFontAttributeName:textLabel1.font}
                                                 context:nil];
    

    textLabel1.lineBreakMode = NSLineBreakByWordWrapping;
    textLabel1.numberOfLines = 0;
   textLabel1.frame=CGRectMake([[welcomecreenPosPXArray objectAtIndex:1]floatValue],[[welcomeScreenPosPYArray objectAtIndex:1]floatValue],frame.size.width,frame.size.height);
    [textLabel1 sizeToFit];
    textLabel1.textColor=[UIColor darkGrayColor];
    
    textLabel1.textAlignment=NSTextAlignmentCenter;
    [scrollView addSubview:textLabel1];

    
    
}

-(void)addButton
{
    getStartedButton=[UIButton buttonWithType:UIButtonTypeSystem];
    
    [getStartedButton setTitle:@"Get Started" forState:UIControlStateNormal];
    getStartedButton.tintColor=cellBlackColor_8;
    getStartedButton.backgroundColor=buttonGreenColor;
    [getStartedButton setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    getStartedButton.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.025*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    [getStartedButton sizeToFit];
    getStartedButton.frame=CGRectMake(cellPaddingReg, .8*screenHeight, screenWidth-2*cellPaddingReg, .07*screenHeight);
    getStartedButton.center=CGPointMake(screenWidth*.5,screenHeight*.8);
    
    [getStartedButton addTarget:self action:@selector(getStartedButtonTouch) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:getStartedButton];
}

-(void)getStartedButtonTouch
{
    [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"RegistrationCompleted"];
    [self pinwiWorksTutorial];
//    AccessProfileViewController *access=[[AccessProfileViewController alloc]init];
//    UINavigationController *naviCtrl=[[UINavigationController alloc]initWithRootViewController:access];
//    [self presentViewController:naviCtrl animated:YES completion:nil];
//    ParentViewProfile *parentProfile=[[ParentViewProfile alloc]init];
//    [self presentViewController:parentProfile animated:YES completion:nil];
  
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
        [headerView setBackgroundColor:appBackgroundColor];
        [headerView setRootViewController:self];
        [headerView setHeaderViewdelegate:self];
        [headerView setRightType:nil];
        [headerView setCentreImgName:@"Confirm_header.png"];
        [headerView drawHeaderViewWithTitle:@"Confirm Profile" isBackBtnReq:NO BackImage:nil];
        [self.view bringSubviewToFront:headerView];
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
#pragma mark BACK BUTTON DELEGATE
-(void)touchAtBackButton
{
  }

#pragma mark MENU BUTTON DELEGATE
-(void)getMenuTouches
{
    
}
#pragma mark tutorial

-(void)pinwiWorksTutorial
{
    if(![[[NSUserDefaults standardUserDefaults]objectForKey:@"pinwiWorksTutorial1152"]isEqualToString:@"1"])
    {
        tutorial=[[TutorialPlayView alloc]init];
        tutorial.delegate=self;
        tutorial.tutorialName=@"How PiNWi Works.";
        tutorial.loadIndexVal=pinwiWorksIndex;
        [self presentViewController:tutorial animated:YES completion:nil];
    //    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"pinwiWorksTutorial1152"];
    }
}
-(void)SkipTouched
{
    [tutorial dismissViewControllerAnimated:YES completion:^{
        AccessProfileViewController *access=[[AccessProfileViewController alloc]init];
        UINavigationController *naviCtrl=[[UINavigationController alloc]initWithRootViewController:access];
        [self presentViewController:naviCtrl animated:YES completion:nil];

    }];
    
   
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
