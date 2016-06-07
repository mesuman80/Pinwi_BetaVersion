//
//  WelcomeScreenViewController.m
//  ParentControl_CT
//
//  Created by Priyanka on 11/03/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "Tutorial.h"
#import "TutorialView.h"
#import "TutorialPlayView.h"
#import "HeaderView.h"
//#import "AppEnterCodeTableViewController.h"

@interface Tutorial ()<HeaderViewProtocol>
{
    UIImageView *topStrip,*bottomStrip,*titleImg, *centerIcon, *moreIcon, *navBgBar;
    UIScrollView *scrollView;
    UILabel *textLabel,*textLabel1;
    CGSize displayValueSize;
    UIButton *gotoTermsBtn;
    UIView *lineView;
    int yy;
    UITextField *activeField;
    HeaderView *headerView ;
    NSMutableArray *touchTutArray;
    
}
@end

@implementation Tutorial

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [[PC_DataManager sharedManager]getWidthHeight];
    [[PC_DataManager sharedManager]welcomeScreen];
    yy  = 0;
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
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        scrollView.frame=CGRectMake(0, 0, screenWidth, screenHeight);
        scrollView.contentSize = CGSizeMake(screenHeight,screenHeight*2);
        // code for landscape orientation
    }
    else
    {
        
        //float height =[UIApplication sharedApplication].statusBarFrame.size.height;
        scrollView.frame=CGRectMake(0,yy, screenWidth, screenHeight-yy);
        scrollView.contentSize = CGSizeMake(screenWidth, screenHeight);
    }
    [self.view addSubview:scrollView];
    
    [self textLabel];
    
    
    
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
-(void)viewWillUnload{
    [super viewWillUnload];
    self.navigationController.navigationBarHidden=YES;
//    [centerIcon removeFromSuperview];
//    centerIcon=nil;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [centerIcon removeFromSuperview];
    centerIcon=nil;
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

-(void) textLabel
{
    int scrollY=screenHeight*.06;
    if(!touchTutArray)
    {
        touchTutArray = [[NSMutableArray alloc]init];
    }
    [[PC_DataManager sharedManager]TutorialImages];
    for(int i=1; i<=tutorialListArrayComplete.count; i++)
    {
        TutorialView *tut=[[TutorialView alloc]initWithFrame:CGRectMake(screenWidth*.1, scrollY, screenWidth*.75, screenHeight*.06) withTutorialNo:i andImg:[UIImage imageNamed:isiPhoneiPad(@"tutPlayIcon.png") ]];
        [scrollView addSubview:tut];
        tut.backgroundColor=appBackgroundColor;
        tut.tag=i;
        [touchTutArray addObject:tut];
        tut.userInteractionEnabled=YES;
        scrollY+=screenHeight*.1;
//        if(scrollY>screenHeight*.9)
//        {
//            scrollView.scrollEnabled=YES;
//            [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height+tut.frame.size.height)];
//        }
    }
        [scrollView setScrollEnabled:YES];
       [scrollView setContentSize:CGSizeMake(0, scrollY)];
        UITapGestureRecognizer *recognizer= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playTutorial:)];
        [scrollView addGestureRecognizer:recognizer];

    //[scrollView setContentSize:CGSizeMake(scrollView.contentSize.width,scrollY)];
//    bottomStrip=[[UIImageView alloc]initWithImage:[UIImage imageNamed: isiPhoneiPad(@"welcomefooter.png") ]];
//    [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height+bottomStrip.frame.size.height+20)];
//    bottomStrip.center=CGPointMake(screenWidth/2, scrollView.contentSize.height-bottomStrip.frame.size.height/2);
//    [scrollView addSubview:bottomStrip];
}

#pragma mark Tutorial view delegates




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

-(void)playTutorial:(id)sender
{
    int tgVal = 0;
    BOOL frameTouch=NO;
    UITapGestureRecognizer * rec =(UITapGestureRecognizer*) sender;
    CGPoint loc = [rec locationInView:scrollView];
    
    for(TutorialView *tutView in touchTutArray)
    {
        if(CGRectContainsPoint(tutView.frame, loc))
        {
            tgVal=(int)tutView.tag;
            frameTouch=YES;
            tutView.alpha=0.1f;
            [self performSelector:@selector(touchFunctionlity:) withObject:tutView afterDelay:0.1];
            break;
        }
    }
    if(frameTouch)
    {
        TutorialPlayView *tutPlayView=[[TutorialPlayView alloc]init];
        tutPlayView.loadIndexVal=tgVal-1;
        tutPlayView.tutorialName=@"Tutorial";
        [self presentViewController:tutPlayView animated:YES completion:nil];
       // [self.navigationController pushViewController:tutPlayView animated:YES];
    }
}
-(void)touchFunctionlity:(TutorialView*)tutView
{
    tutView.alpha=1.0f;
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
        [headerView setCentreImgName:@"tutorialHeader.png"];
        [headerView drawHeaderViewWithTitle:@"Tutorials" isBackBtnReq:YES BackImage:@"leftArrow.png"];
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
