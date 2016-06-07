//
//  ViewController.m
//  ParentControl_CT
//
//  Created by Priyanka on 2/23/15.
//  Copyright (c) 2015 ImagineInteractive. All rights reserved.
//

#import "SignUpViewController.h"
#import "ProfileSetUp2.h"
#import "ProfileSetUpViewController.h"
#import "FaceBookFriendsViewController.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "AuthenticateUser.h"
#import "ChildProfileEntity.h"
#import "AllyProfileEntity.h"
#import "TimePicker.h"
#import "AllyProfileController.h"
#import "ForgetPassword.h"
#import "ChildActivities_VC.h"
#import "AllyProfileController.h"
#import "ConfirmationProfileViewController.h"
#import "ResetPassword.h"
#import "ShowActivityLoadingView.h"
#import "NameAndTextButton.h"
#import "ForgotPassword_VC.h"
#import "AboutUs.h"
#import "ContactUs.h"

//#import "ForgetPassword.h"

@interface SignUpViewController () <NameTextProtocol>
{
    UITextField *enterEmail;
    UITextField *enterPsWd;
    
    UILabel *subHead, *loggdIn, *signInLabel;
    UIScrollView* scrollView;
    TTTAttributedLabel *ttLabel;
    UIButton *loginButton, *facebookButton, *googlePlusButton, *forgotPswdButton, *newUserButton, *aboutUsButton, *helpButton;
    NSMutableArray *labelobjectArray, *ttLabelobjectArray;
    
    NSLayoutConstraint *constraint;
    CGRect keyboardBounds;
    BOOL isKeyBoard;
    UIImageView *bkGndImg, *titleImg, *lockImg, *fbImg, *googleImg;
    UIImageView *userImg, *pswdImg;
    
    
    UIView *lineView;
    CGSize displayValueSize;
    
    AuthenticateUser * authenticateUser;
    BOOL isAuthenticate;
    BOOL forgetpassword;
    
    ForgetPassword *forgetPassword;
    
    
    BOOL fromLogin;
    
    GPPSignIn *signIn;
    ParentProfileEntity *parentProfileEntity;
    
    UITextField *resetCode;
    ShowActivityLoadingView *loaderView;
    
    BOOL isDeviceTokenExist;
    
    NSString *profileStatus;
    
}


@property (nonatomic, strong) AppDelegate *appDelegate;
@end



@implementation SignUpViewController

//@synthesize checkbox;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[PC_DataManager sharedManager]getWidthHeight];
    
    labelobjectArray=[[NSMutableArray alloc]init];
    ttLabelobjectArray=[[NSMutableArray alloc]init];
    
    scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor =[UIColor whiteColor];
    scrollView.scrollEnabled = YES;
    //scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.bounces=NO;
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        scrollView.frame=CGRectMake(0, 0, screenWidth, screenHeight);
        scrollView.contentSize = CGSizeMake(screenHeight,screenHeight*2);
        // code for landscape orientation
    }
    else
    {
        scrollView.frame=CGRectMake(0, 0, screenWidth, screenHeight);
        scrollView.contentSize = CGSizeMake(screenWidth, screenHeight);
    }
    
    
    [self.view addSubview:scrollView];
    
    [[PC_DataManager sharedManager]signUpLabel];
    [[PC_DataManager sharedManager]checkBox];
    
    [self addBkImages];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=YES;
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:isiPhoneiPad(@"header_above.png")] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    // [self isUserExist];
}

-(void)getHtWd
{
    screenHeight=[ScreenInfo getScreenHeight];
    screenWidth=[ScreenInfo getScreenWidth];
}


-(void)drawElements
{

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [scrollView addGestureRecognizer:singleTap];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleFBSessionStateChangeWithNotification:)
                                                 name:@"SessionStateChangeNotification"
                                               object:nil];
    
}

#pragma mark
-(void)isDeviceTokenExist:(BOOL)isExist
{
//    if(isExist)
//    {
    
        [self drawElements];
        [self titleLabel:isExist];
        [self addButton:isExist];
        [self addLoginBtn];
        [self addNewUser];
        [self addImgaesIcon];
        [self addEmail];
        [self addPassword];
        [self addforgotButton];
//    }
//    else
//    {
//        [self drawElements];
//        [self titleLabel:isExist];
//        [self addButton:isExist];
//        [self addNewUser];
//    }
//    
}


#pragma mark SPAWN default

-(void)addBkImages
{
    scrollView.backgroundColor=[UIColor blackColor];
    bkGndImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"loginBgImg.png")]];
    
    bkGndImg.frame=CGRectMake(0, 0, screenWidth, screenHeight);
    [scrollView addSubview:bkGndImg];
}

-(void)addImgaesIcon
{
    
//    lineView= [[PC_DataManager sharedManager] drawLineView_withXPos:.3*screenWidth andYPos:screenHeight*.33 withScrnWid:.3*screenWidth withScrnHt:.001*screenHeight ofColor:lineColor];
//    [scrollView addSubview:lineView];
//    
//    lineView= [[PC_DataManager sharedManager] drawLineView_withXPos:.7*screenWidth andYPos:screenHeight*.33 withScrnWid:.3*screenWidth withScrnHt:.001*screenHeight ofColor:lineColor];
//    [scrollView addSubview:lineView];
    
    lockImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed: isiPhoneiPad(@"lock.png")]];
    lockImg.center=CGPointMake(screenWidth/2, .33*screenHeight);
    [scrollView addSubview:lockImg];
    
    userImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"user.png")]];
    userImg.center=CGPointMake(screenWidth*.15, .42*screenHeight);
    [scrollView addSubview:userImg];
    
    pswdImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"password.png")]];
    pswdImg.center=CGPointMake(screenWidth*.15, .49*screenHeight);
    [scrollView addSubview:pswdImg];
    
}


-(void)titleLabel:(BOOL)isExist
{
    
    titleImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"pinwiLogo.png")]];
//    if (isExist) {
        titleImg.center=CGPointMake(screenWidth/2, .15*screenHeight);
//    }
//    else{
//        titleImg.center=CGPointMake(screenWidth/2, .3*screenHeight);
//    }
    [scrollView addSubview:titleImg];
    
    subHead=[[UILabel alloc]init];
    NSString *SubHeadstr=[labelSignUpArray objectAtIndex:0];
    
    
    displayValueSize= [SubHeadstr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[[signUpLabelSize objectAtIndex:0]floatValue]]}];
    subHead.font=[UIFont fontWithName:RobotoRegular size:12*ScreenHeightFactor];
    subHead.text=SubHeadstr;
//    if(isExist)
//    {
        subHead.frame=CGRectMake([[labelSignUpPosPxArray objectAtIndex:0]floatValue],[[labelSignUpPosPyArray objectAtIndex:0]floatValue],displayValueSize.width,displayValueSize.height);
//    }
//    else{
//        subHead.frame=CGRectMake([[labelSignUpPosPxArray objectAtIndex:0]floatValue],screenHeight*.40,displayValueSize.width,displayValueSize.height);
//    }
        [subHead sizeToFit];
    subHead.textColor=[[UIColor whiteColor]colorWithAlphaComponent:0.6f];
    subHead.textAlignment=NSTextAlignmentCenter;
    subHead.center=CGPointMake(screenWidth/2, subHead.center.y);

    [scrollView addSubview:subHead];
    
 /*
    if(isExist){
        NSString *signInstr=[labelSignUpArray objectAtIndex:1];
        signInLabel=[[UILabel alloc]init];
        displayValueSize = [signInstr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[[signUpLabelSize objectAtIndex:1]floatValue]]}];
        signInLabel.font=[UIFont fontWithName:RobotoLight size:7*ScreenFactor];//[[signUpLabelSize objectAtIndex:1] floatValue]];
        signInLabel.text=signInstr;
        signInLabel.frame=CGRectMake([[labelSignUpPosPxArray objectAtIndex:1]floatValue],[[labelSignUpPosPyArray objectAtIndex:1]floatValue],displayValueSize.width,displayValueSize.height);
        [signInLabel sizeToFit];
        signInLabel.center=CGPointMake(screenWidth/2, .78*screenHeight);
        signInLabel.textColor=[UIColor colorWithRed:215.0f/255 green:228.0f/255 blue:240.f/255 alpha:1];
       //
        [scrollView addSubview:signInLabel];
    }
    else{
        NSString *signInstr=[labelSignUpArray objectAtIndex:2];
        signInLabel=[[UILabel alloc]init];
        displayValueSize = [signInstr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[[signUpLabelSize objectAtIndex:2]floatValue]]}];
        signInLabel.font=[UIFont fontWithName:RobotoLight size:7*ScreenFactor];//[[signUpLabelSize objectAtIndex:2] floatValue]];
        signInLabel.text=signInstr;
        signInLabel.frame=CGRectMake([[labelSignUpPosPxArray objectAtIndex:2]floatValue],[[labelSignUpPosPyArray objectAtIndex:2]floatValue],displayValueSize.width,displayValueSize.height);
        [signInLabel sizeToFit];
        signInLabel.center=CGPointMake(screenWidth/2, .63*screenHeight);
        signInLabel.textColor=[UIColor colorWithRed:215.0f/255 green:228.0f/255 blue:240.f/255 alpha:1];//logintextGreyColor;
        //[signInLabel sizeToFit];
        [scrollView addSubview:signInLabel];
    }
  */
}

-(void)addEmail
{
    if (enterEmail == NULL) {
        enterEmail=[[UITextField alloc]initWithFrame:CGRectMake([[signUpTextFieldPosPXArray objectAtIndex:0]floatValue],[[signUpTextFieldPosPYArray objectAtIndex:0]floatValue],screenWidth*.7,screenHeight*.05)];
        enterEmail.placeholder = [signUpTextFieldsArray objectAtIndex:0];
        [enterEmail setValue:logintextGreyPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
        enterEmail.autocorrectionType = UITextAutocorrectionTypeNo;
        [enterEmail setFont:[UIFont fontWithName:RobotoLight size:15.0f]];
        enterEmail.borderStyle=UITextBorderStyleNone;
        enterEmail.tintColor=[UIColor whiteColor];
        enterEmail.textColor=logintextGreyColor;
        enterEmail.keyboardType=UIKeyboardTypeEmailAddress;
        enterEmail.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [enterEmail setDelegate:self];
        [scrollView addSubview:enterEmail];
        enterEmail.delegate=self;
        
        lineView= [[PC_DataManager sharedManager] drawLineView_withXPos:screenWidth/2 andYPos:screenHeight*.45 withScrnWid:.72*screenWidth withScrnHt:.001*screenHeight ofColor: lineColor];
        [scrollView addSubview:lineView];
    }
    
    return;
}

-(void)addPassword
{
    if (enterPsWd == NULL) {
        enterPsWd=[[UITextField alloc]initWithFrame:CGRectMake([[signUpTextFieldPosPXArray objectAtIndex:1]floatValue], [[signUpTextFieldPosPYArray objectAtIndex:1]floatValue],screenWidth*.7,screenHeight*.05)];
        enterPsWd.placeholder = [signUpTextFieldsArray objectAtIndex:1];
        [enterPsWd setValue:logintextGreyPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
        enterPsWd.autocorrectionType = UITextAutocorrectionTypeNo;
        [enterPsWd setFont:[UIFont fontWithName:RobotoLight size:15.0f]];
        enterPsWd.secureTextEntry=YES;
        enterPsWd.borderStyle=UITextBorderStyleNone;
        enterPsWd.tintColor=[UIColor whiteColor];
        enterPsWd.textColor=logintextGreyColor;
        [enterPsWd setDelegate:self];
        [scrollView addSubview:enterPsWd];
        enterPsWd.delegate=self;
        
        lineView =[[PC_DataManager sharedManager]drawLineView_withXPos:screenWidth/2 andYPos:screenHeight*.52 withScrnWid:.72*screenWidth withScrnHt:.001*screenHeight ofColor:lineColor];
        [scrollView addSubview:lineView];

    }
    return;
    
}


-(void)addforgotButton
{
    forgotPswdButton=[UIButton buttonWithType:UIButtonTypeSystem];
    
    [forgotPswdButton setTitle:@"Forgot password?" forState:UIControlStateNormal];
    forgotPswdButton.tintColor=logintextGreyColor;
    forgotPswdButton.titleLabel.textColor = [UIColor redColor];
    forgotPswdButton.backgroundColor=[UIColor clearColor];
    [forgotPswdButton setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    forgotPswdButton.titleLabel.font=[UIFont fontWithName:RobotoLight size:.017*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    [forgotPswdButton sizeToFit];
    forgotPswdButton.frame=CGRectMake(0, 0, screenWidth*.5, screenHeight*.055);
    forgotPswdButton.center=CGPointMake(screenWidth*.5,screenHeight*.73);
    
    [forgotPswdButton addTarget:self action:@selector(forgotPswdTouched) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:forgotPswdButton];
    
    
}

-(void)addButton:(BOOL)isExist
{/*
    facebookButton=[UIButton buttonWithType:UIButtonTypeSystem];
    facebookButton.frame=CGRectMake(0, 0, screenWidth*.365, screenHeight*.07);
   // [facebookButton setTitle:@"Facebook" forState:UIControlStateNormal];
    facebookButton.tintColor=[UIColor whiteColor];
    facebookButton.backgroundColor=[UIColor clearColor];
    //[facebookButton setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    facebookButton.titleLabel.font=[UIFont fontWithName:RobotoLight size:.02*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    
    facebookButton.userInteractionEnabled=NO;
    
    facebookButton.layer.borderColor = lineColor.CGColor;
    facebookButton.layer.borderWidth = 0.5*ScreenHeightFactor;
    //facebookButton.layer.bounds=cg(.02*screenWidth, .8*screenHeight);
    
    //  [facebookButton sizeToFit];
    [facebookButton addTarget:self action:@selector(facebookTouched) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:facebookButton];
    
    
    googlePlusButton=[UIButton buttonWithType:UIButtonTypeSystem];
    googlePlusButton.frame=CGRectMake(0, 0, screenWidth*.365, screenHeight*.07);
  //  [googlePlusButton setTitle:@"Google +" forState:UIControlStateNormal];
    googlePlusButton.tintColor=[UIColor whiteColor];
    googlePlusButton.backgroundColor=[UIColor clearColor];
    [googlePlusButton setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    googlePlusButton.titleLabel.font=[UIFont fontWithName:RobotoLight size:.02*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    
    googlePlusButton.layer.borderColor = lineColor.CGColor;
    googlePlusButton.layer.borderWidth = 0.5*ScreenHeightFactor;
    [googlePlusButton addTarget:self action:@selector(googleTouched) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:googlePlusButton];
    
    googlePlusButton.userInteractionEnabled=NO;
    
    fbImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"loginfacebook.png")]];
    
   // [scrollView addSubview:fbImg];
    
    googleImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed: isiPhoneiPad(@"google.png")]];
    
  //  [scrollView addSubview:googleImg];
    
//    if(isExist)
//    {
        facebookButton.center=CGPointMake(screenWidth/2-facebookButton.frame.size.width/2,screenHeight*.85);
        googlePlusButton.center=CGPointMake(screenWidth/2+googlePlusButton.frame.size.width/2,screenHeight*.85);
        fbImg.center=CGPointMake(screenWidth*.18, .85*screenHeight);
        googleImg.center=CGPointMake(screenWidth*.56, .85*screenHeight);
//    }
//    else
//    {
//        facebookButton.center=CGPointMake(screenWidth/2-facebookButton.frame.size.width/2,screenHeight*.70);
//        googlePlusButton.center=CGPointMake(screenWidth/2+googlePlusButton.frame.size.width/2,screenHeight*.70);
//        fbImg.center=CGPointMake(screenWidth*.18, .75*screenHeight);
//        googleImg.center=CGPointMake(screenWidth*.56, .75*screenHeight);
//    }
    
    NameAndTextButton *fb=[[NameAndTextButton alloc]initWithFrame:facebookButton.frame];
    [fb drawUi:@"Facebook" andImage:@"loginfacebook.png"];
    [fb setDelegate:self];
    fb.tag=1;
    [fb setCenter:facebookButton.center];
    [scrollView addSubview:fb];
    
    NameAndTextButton *googleView=[[NameAndTextButton alloc]initWithFrame:googlePlusButton.frame];
    [googleView drawUi:@"Google +" andImage:@"google.png"];
    [googleView setDelegate:self];
    googleView.tag=2;
    [googleView setCenter:googlePlusButton.center];
   [scrollView addSubview:googleView];
    
 */
    aboutUsButton=[UIButton buttonWithType:UIButtonTypeSystem];
    
    [aboutUsButton setTitle:@"About Us" forState:UIControlStateNormal];
    aboutUsButton.tintColor=logintextGreyColor;//logintextGreyColor;
    aboutUsButton.backgroundColor=[UIColor clearColor];
    [aboutUsButton setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    aboutUsButton.titleLabel.font=[UIFont fontWithName:RobotoLight size:.02*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    [aboutUsButton sizeToFit];
    aboutUsButton.frame=CGRectMake(0, 0, screenWidth*.5, screenHeight*.05);
    aboutUsButton.center=CGPointMake(screenWidth*.25,screenHeight-aboutUsButton.frame.size.height/2);
    aboutUsButton.layer.borderWidth=0.5f*ScreenHeightFactor;
    aboutUsButton.layer.borderColor=lineColor.CGColor;
    [aboutUsButton addTarget:self action:@selector(aboutUsTouched) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:aboutUsButton];
    
    
    helpButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [helpButton setTitle:@"Help" forState:UIControlStateNormal];
    helpButton.tintColor=logintextGreyColor;
    helpButton.backgroundColor=[UIColor clearColor];
    [helpButton setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    helpButton.titleLabel.font=[UIFont fontWithName:RobotoLight size:.02*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    [helpButton sizeToFit];
    helpButton.frame=CGRectMake(0, 0, screenWidth*.5, screenHeight*.05);
    helpButton.center=CGPointMake(screenWidth*.75,screenHeight-helpButton.frame.size.height/2);
    //    [[myButton layer] setBorderWidth:2.0f];
    //    [[myButton layer] setBorderColor:[UIColor greenColor].CGColor];
    helpButton.layer.borderWidth=0.5f*ScreenHeightFactor;
    helpButton.layer.borderColor=lineColor.CGColor;
    [helpButton addTarget:self action:@selector(helpTouched) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:helpButton];
}

-(void)addLoginBtn
{
    loginButton=[UIButton buttonWithType:UIButtonTypeSystem];
    
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    loginButton.tintColor=[[UIColor blackColor]colorWithAlphaComponent:0.8f];
    loginButton.backgroundColor=[UIColor colorWithRed:95.0f/255 green:147.0f/255 blue:196.0f/255 alpha:1];
    
    [loginButton setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    loginButton.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.02*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    [loginButton sizeToFit];
    loginButton.frame=CGRectMake(0, 0, screenWidth*.73, screenHeight*.07);
    loginButton.center=CGPointMake(screenWidth*.5,screenHeight*.57);
    [loginButton addTarget:self action:@selector(logInBtnTouched) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:loginButton];
    
}

-(void)addNewUser
{
    newUserButton=[UIButton buttonWithType:UIButtonTypeSystem];
    
    [newUserButton setTitle:@"Create Account" forState:UIControlStateNormal];
    newUserButton.tintColor=[[UIColor blackColor]colorWithAlphaComponent:0.8f];
    newUserButton.backgroundColor=buttonGreenColor;
    
    [newUserButton setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    newUserButton.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.02*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    [newUserButton sizeToFit];
    newUserButton.frame=CGRectMake(0, 0, screenWidth*.73, screenHeight*.07);
    newUserButton.center=CGPointMake(screenWidth*.5,screenHeight*.65);
    [newUserButton addTarget:self action:@selector(newUserTouched) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:newUserButton];
    
    
    /* [newUserButton setTitle:@"New user? Sign Up." forState:UIControlStateNormal];
     newUserButton.tintColor=logintextGreyColor;
     newUserButton.backgroundColor=[UIColor clearColor];
     [newUserButton setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
     newUserButton.titleLabel.font=[UIFont fontWithName:RobotoLight size:.017*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
     [newUserButton sizeToFit];
     newUserButton.frame=CGRectMake(0, 0, screenWidth*.5, screenHeight*.055);
     newUserButton.center=CGPointMake(screenWidth*.75,screenHeight*.85);
     
     [newUserButton addTarget:self action:@selector(newUserTouched) forControlEvents:UIControlEventTouchUpInside];
     [scrollView addSubview:newUserButton];
     
     
     lineView=[[PC_DataManager sharedManager] drawLineView_withXPos:.75*screenWidth andYPos:.86*screenHeight withScrnWid:.33*screenWidth withScrnHt:.001*screenHeight ofColor:logintextGreyColor];
     [scrollView addSubview:lineView];*/
}


-(void)addAttributesLabel
{
    int i=0;
    for(NSString *str in signUpTextAttsArray)
    {
        ttLabel=[[TTTAttributedLabel alloc]init];
        displayValueSize = [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[[signUpTextAttsSizeArray objectAtIndex:i]floatValue]]}];
        
        ttLabel.font=[UIFont fontWithName:@"Roboto Light" size:[[signUpTextAttsSizeArray objectAtIndex:i] floatValue]];
        NSString *labelText = str;
        ttLabel.frame=CGRectMake([[signUpTextAttsPosPXArray objectAtIndex:i]floatValue],[[signUpTextAttsPosPYArray objectAtIndex:i]floatValue],displayValueSize.width,displayValueSize.height);
        
        //ttLabel.numberOfLines=0;
        ttLabel.text = labelText;
        // ttLabel.center=CGPointMake(screenWidth/2, [[signUpTextAttsPosPYArray objectAtIndex:i]floatValue]);
        
        NSRange r = [labelText rangeOfString:labelText];
        [ttLabel sizeToFit];
        [ttLabel addLinkToURL:[NSURL URLWithString:@"http://www.google.com"] withRange:r];
        ttLabel.delegate=self;
        ttLabel.textAlignment=NSTextAlignmentCenter;
        [scrollView addSubview:ttLabel];
        i++;
        [ttLabelobjectArray addObject:ttLabel];
    }
    
}


#pragma mark TOUCH functionalities

-(void)logInBtnTouched
{
    
    if(enterEmail.text.length==0 && enterPsWd.text.length==0)
    {
        [self showAlertWithTitle:@"Alert" andMsg:@"Please enter both email ID and password."];
        [enterEmail becomeFirstResponder];
    }
    else if(enterEmail.text.length==0)
    {
        [self showAlertWithTitle:@"Invalid Email ID" andMsg:@"Your email ID may not be correct. Please check."];
        [enterEmail becomeFirstResponder];
    }
    else if(enterPsWd.text.length==0)
    {
        [self showAlertWithTitle:@"Alert" andMsg:@"Please enter password."];
        [enterPsWd becomeFirstResponder];
    }

    else if(![[PC_DataManager sharedManager]NSStringIsValidEmail:enterEmail.text])
    {
        [self showAlertWithTitle:@"Invalid Email ID" andMsg:@"Your email ID may not be correct. Please check."];
        [enterEmail becomeFirstResponder];
    }
    else
    {
        isAuthenticate=YES;
        loginButton.userInteractionEnabled=NO;
        authenticateUser = [[AuthenticateUser alloc] init];
        [authenticateUser initService:@{@"user":enterEmail.text, @"pass":enterPsWd.text}];
        [authenticateUser setDelegate:self];
        
        [self addLoaderView];
    }
}

#pragma mark SERVICES CONNECTION DELEGATE
-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
    loginButton.userInteractionEnabled=YES;
    [self removeLoaderView];
}

-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection{
    
    [self removeLoaderView];
    NSLog(@"here i am  %@", dictionary);
    if([connection.serviceName isEqualToString:@"CheckDeviceIDExists"])
    {
        NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"CheckDeviceIDExistsResponse" resultKey:@"CheckDeviceIDExistsResult"];
        if([dict isKindOfClass:[NSArray class]])
        {
            
            NSMutableArray *errDict= dict.mutableCopy;
            NSDictionary *dictionary  = [errDict firstObject];
            if([[dictionary valueForKey:@"ErrorDesc"]isEqualToString:@"Device ID Already Exists."])
            {
                [self isDeviceTokenExist:YES];
            }
            else
            {
                [self isDeviceTokenExist:NO];
            }
        }
        return;
    }
    
    else if(isAuthenticate)
    {
        loginButton.userInteractionEnabled=YES;
        
        
        isAuthenticate=NO;
        NSDictionary * dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"AuthenticateUserResponse" resultKey:@"AuthenticateUserResult"];
        if(!dict)
        {
            return;
        }
        
        //        if(![PC_DataManager sharedManager].parentObjectInstance.parentId || [PC_DataManager sharedManager].parentObjectInstance.parentId.length==0)
        //        {
        for (NSDictionary *accessDict in dict) {
            
            [PC_DataManager sharedManager].parentObjectInstance.firstName=[accessDict objectForKey:@"FirstName"];
            [PC_DataManager sharedManager].parentObjectInstance.parentId=[NSString stringWithFormat:@"%@",[accessDict objectForKey:@"ProfileID"]];
            [PC_DataManager sharedManager].parentObjectInstance.lastName=[NSString stringWithFormat:@"%@",[accessDict objectForKey:@"LastName"]];
            profileStatus=[NSString stringWithFormat:@"%@",[accessDict objectForKey:@"ProfileStatus"]];
            [[PC_DataManager sharedManager] writeParentObjToDisk];
        }
        //        }
        [self whichScreenToOpen];
        
    }
    else if(forgetpassword==YES)
    {
        forgetpassword=NO;
        NSDictionary * dict= [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"ForgetPasswordResponse" resultKey:@"ForgetPasswordResult"];
        if(!dict)
        {
            return;
        }
       // [self resetPassword];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SuccessFul" message:@"Reset Code is sent to your Email Id" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
        ForgotPassword_VC *forget=[[ForgotPassword_VC alloc]init];
        [self presentViewController:forget animated:YES completion:nil];
    }
    else
    {
        NSDictionary *dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:@"ResetPasswordResponse" resultKey:@"ResetPasswordResult"];
        if(!dict)
        {
            return;
        }
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"SuccessFul" message:@"New Password is sent to your Email Id." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    // [[[UIApplication sharedApplication]keyWindow].rootViewController presentViewController:naviCtrl animated:NO completion:nil];
    
}

-(void)whichScreenToOpen
{
    [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"isLoggedOut"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSLog(@"log in value= %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"isLoggedOut"]);
    if([profileStatus isEqualToString:@"2"]||[[[NSUserDefaults standardUserDefaults]valueForKey:@"RegistrationCompleted"]boolValue])
    {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"RegistrationCompleted"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        AccessProfileViewController *access=[[AccessProfileViewController alloc]init];
        [self.navigationController pushViewController:access animated:YES];
    }
    else if([profileStatus isEqualToString:@"1"])
    {
        AllyProfileController *sign=[[AllyProfileController alloc]init];
        sign.parentClassName=@"SignUp";
        [self.navigationController pushViewController:sign animated:YES];
    }
    
    else if([profileStatus isEqualToString:@"0"])
    {
        //[self.navigationController setNavigationBarHidden:NO animated:YES];
        ChildProfileController *sign=[[ChildProfileController alloc]init];
        sign.parentClassName=@"SignUp";
        [self.navigationController pushViewController:sign animated:YES];
    }
    
    /*   if([[[NSUserDefaults standardUserDefaults]objectForKey:@"isLoggedOut"]isEqualToString:@"0"])
     {
     
     if([[[NSUserDefaults standardUserDefaults]valueForKey:@"Confirmed"] isEqualToString:@"1"])
     {
     ConfirmationProfileViewController *sign=[[ConfirmationProfileViewController alloc]init];
     [self.navigationController pushViewController:sign animated:YES];
     }
     else if([[[NSUserDefaults standardUserDefaults]valueForKey:@"Confirmed"] isEqualToString:@"2"])
     {
     [self.navigationController setNavigationBarHidden:NO animated:YES];
     ChildProfileController *sign=[[ChildProfileController alloc]init];
     
     [self.navigationController pushViewController:sign animated:YES];
     }
     
     else if([[[NSUserDefaults standardUserDefaults]valueForKey:@"Confirmed"] isEqualToString:@"3"])
     {
     AllyProfileController *sign=[[AllyProfileController alloc]init];
     [self.navigationController pushViewController:sign animated:YES];
     }
     else if([[[NSUserDefaults standardUserDefaults]valueForKey:@"RegistrationCompleted"] isEqualToString:@"1"])
     {
     [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"isLoggedOut"];
     AccessProfileViewController *access=[[AccessProfileViewController alloc]init];
     [self.navigationController pushViewController:access animated:YES];
     }
     else
     {
     [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"isLoggedOut"];
     AccessProfileViewController *access=[[AccessProfileViewController alloc]init];
     [self.navigationController pushViewController:access animated:YES];
     }
     }
     else
     {
     [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"isLoggedOut"];
     AccessProfileViewController *access=[[AccessProfileViewController alloc]init];
     [self.navigationController pushViewController:access animated:YES];
     }*/
}

-(void)facebookTouched
{
    [PC_DataManager sharedManager].faceBookTouched=YES;
    [PC_DataManager sharedManager].googleTouched=NO;
    
    if ([FBSession activeSession].state != FBSessionStateOpen &&
        [FBSession activeSession].state != FBSessionStateOpenTokenExtended) {
        
        [self.appDelegate openActiveSessionWithPermissions:@[@"public_profile", @"email"] allowLoginUI:YES];
        
    }
    else{
        // Close an existing session.
        [[FBSession activeSession] closeAndClearTokenInformation];
        
        NSLog(@"You are not logged in.");//' = @"You are not logged in.";
    }
    
}


-(void)resetPassword
{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"Enter code to reset password" message:@"" delegate:self cancelButtonTitle:@"SEND" otherButtonTitles:nil, nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    resetCode=[alertView textFieldAtIndex:0];
    resetCode.delegate= self;
    [resetCode setPlaceholder:@"Enter code"];
    [resetCode setValue:logintextGreyColor forKeyPath:@"_placeholderLabel.textColor"];
    [alertView setDelegate:self];
    [alertView show];
    // alertView=nil;
    
}
#pragma mark UI alert view delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        if(resetCode.text.length>0)
        {
            ResetPassword  *resetPassword = [[ResetPassword alloc] init];
            [resetPassword initService:@{
                                         @"EmailAddress":enterEmail.text,
                                         @"Code"        :resetCode.text
                                         }];
            [resetPassword setDelegate:self];
            [self addLoaderView];
        }
    }
}

-(void)googleTouched
{
    [PC_DataManager sharedManager].faceBookTouched=NO;
    [PC_DataManager sharedManager].googleTouched=YES;
    
    AppDelegate *appDelegate = (AppDelegate *)
    [[UIApplication sharedApplication] delegate];
    
    static NSString * const kClientID =
    @"987598936725-h6rnun8e6ciq5neuu3de1iequrj8r7g3.apps.googleusercontent.com";
    
    signIn = [GPPSignIn sharedInstance];
    signIn.delegate = self;
    signIn.shouldFetchGoogleUserEmail = YES;
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.clientID = kClientID;
    signIn.scopes = [NSArray arrayWithObjects:kGTLAuthScopePlusLogin, kGTLAuthScopePlusMe,nil];
    //  signIn.scopes = @[ @"email" ];
    // signIn.actions = [NSArray arrayWithObjects:@"http://schemas.google.com/ListenActivity",nil];
    [signIn authenticate];
    NSLog(@"%@", signIn.authentication.userEmail);
    
}


- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
     [self addLoaderView];
    if(error) {
        NSLog(@"%@", signIn.authentication.userEmail);
    }
    else
    {
        
        GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
        
        NSLog(@"email %@ ", [NSString stringWithFormat:@"Email: %@",[GPPSignIn sharedInstance].authentication.userEmail]);
        NSLog(@"Received error %@ and auth object %@",error, auth);
        GTLServicePlus* plusService = [[GTLServicePlus alloc] init];
        plusService.retryEnabled = YES;
        [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
        
        [plusService executeQuery:query
                completionHandler:^(GTLServiceTicket *ticket,
                                    GTLPlusPerson *person,
                                    NSError *error) {
                    [self removeLoaderView];
                    if (error) {
                        GTMLoggerError(@"Error: %@", error);
                    } else {
                        // Retrieve the display name and "about me" text
                        
                        NSLog(@"Email= %@", [GPPSignIn sharedInstance].authentication.userEmail);
                        NSLog(@"GoogleID=%@", person.identifier);
                        NSLog(@"User Name=%@", [person.name.givenName stringByAppendingFormat:@" %@", person.name.familyName]);
                        NSLog(@"Gender=%@", person.image);
                        
                        
                        NSString *strimag=[person.image valueForKey:@"url"];
                        
                        // [self setImageFromURL:[NSURL URLWithString:strimag]];
                        NSData *receivedData = [NSData dataWithContentsOfURL:[NSURL URLWithString:strimag]];
                        
                        [PC_DataManager sharedManager].parentObjectInstance.emailAdd=[GPPSignIn sharedInstance].authentication.userEmail;
                        [PC_DataManager sharedManager].parentObjectInstance.firstName=person.name.givenName;
                        [PC_DataManager sharedManager].parentObjectInstance.lastName=person.name.familyName;
                        [PC_DataManager sharedManager].parentObjectInstance.image=[[PC_DataManager sharedManager]encodeImage:[[UIImage alloc] initWithData:receivedData]];
                        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"SignUpinfromGoogle"];
                        [self newUserTouched];
                    }
                }];
    }
    
}


-(void)newUserTouched
{
    ProfileSetUpViewController *profile=[[ProfileSetUpViewController alloc]init];
    [self.navigationController pushViewController:profile animated:YES];
}

-(void)forgotPswdTouched
{
    ForgotPassword_VC *forget=[[ForgotPassword_VC alloc]init];
    [self presentViewController:forget animated:YES completion:nil];
   /* if (!(enterEmail.text.length==0) && [[PC_DataManager sharedManager]NSStringIsValidEmail:enterEmail.text])
    {
        
        forgetpassword =YES;
        forgetPassword = [[ForgetPassword alloc] init];
        [forgetPassword initService:@{@"EmailAddress":enterEmail.text}];
        [forgetPassword setDelegate:self];
        [self addLoaderView];
    }
    
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Invalid Data" message:@"Your email ID may not be correct. Please check." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
    //    forgetPassword = [[ForgetPassword alloc] init];
    //    [forgetPassword initService:@{}];
    //    [forgetPassword setDelegate:self];
    //    NSLog(@"forgotPswdTouched.send the password to your mail account.");
    //
    
    */
}

-(void)aboutUsTouched
{
    // WelcomeScreenViewController *welcome=[[WelcomeScreenViewController alloc]init];
    //[self.navigationController pushViewController:welcome animated:YES];
    //  [self presentViewController:welcome animated:YES completion:nil];
    
    AboutUs *abtUs=[[AboutUs alloc]init];
    [self.navigationController pushViewController:abtUs animated:YES];
    
    NSLog(@"aboutUsTouched. call php desc page.");
}

-(void)helpTouched
{
    ContactUs *abtUs=[[ContactUs alloc]init];
    [self.navigationController pushViewController:abtUs animated:YES];
    NSLog(@"helpTouched. call help services page.");
}


#pragma mark ORIENTATION change frame set
-(void)potraitModeFrames
{
    
    loginButton.center=CGPointMake(screenWidth/2, loginButton.center.y);
    
    enterEmail.frame=CGRectMake(enterEmail.frame.origin.x, enterEmail.frame.origin.y, .9*screenWidth, enterEmail.frame.size.height);
    enterPsWd.frame=CGRectMake(enterPsWd.frame.origin.x, enterPsWd.frame.origin.y, .9*screenWidth, enterPsWd.frame.size.height);
    
    int i=0;
    for (UILabel *label in ttLabelobjectArray) {
        label.center=CGPointMake(screenWidth/2, [[signUpTextAttsPosPYArray objectAtIndex:i]floatValue]);
        i++;
    }
}

-(void)landScapeModeFrames
{
    
    loginButton.center=CGPointMake(screenHeight/2, loginButton.center.y);
    enterEmail.frame=CGRectMake(enterEmail.frame.origin.x, enterEmail.frame.origin.y, .8*screenHeight, enterEmail.frame.size.height);
    enterPsWd.frame=CGRectMake(enterPsWd.frame.origin.x, enterPsWd.frame.origin.y, .8*screenHeight, enterPsWd.frame.size.height);
    
    int i=0;
    for (TTTAttributedLabel *label in ttLabelobjectArray) {
        label.center=CGPointMake(screenHeight/2, [[signUpTextAttsPosPYArray objectAtIndex:i]floatValue]);
        i++;
    }
}



-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // [self getHtWd];
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        NSLog(@"Landscape left");
        scrollView.frame=CGRectMake(0, 0, screenHeight, screenWidth);
        scrollView.contentSize = CGSizeMake(screenWidth,screenHeight);
        [self landScapeModeFrames];
        // self.lblInfo.text = @"Landscape left";
    }
    
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        NSLog(@"Portrait");
        scrollView.frame=CGRectMake(0, 0, screenWidth, screenHeight);
        scrollView.contentSize = CGSizeMake(screenWidth, screenHeight);
        [self potraitModeFrames];
    }
}



#pragma mark KEYBOARD delegates
-(BOOL)becomeFirstResponder
{
    return YES;
}

-(BOOL)resignFirstResponder
{
    return YES;
}

-(void)resignOnTap:(id)sender
{
    [enterPsWd resignFirstResponder];
    [enterEmail resignFirstResponder];
}
#pragma mark
#pragma mark Keyboard notifications

-(void)addKeyBoardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}


- (void)keyboardWillShow:(NSNotification *)note
{
    scrollView.scrollEnabled=YES;
    scrollView.frame=CGRectMake(0, 0, screenWidth, screenHeight/2);
    NSDictionary* info = [note userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [scrollView setContentOffset:CGPointMake(0, kbSize.height) animated:YES];
}

- (void)keyboardWillHide:(NSNotification *)note
{
    isKeyBoard=NO;
    scrollView.scrollEnabled=NO;
    scrollView.frame=CGRectMake(0, 0, screenWidth, screenHeight);
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    // [self ResetToolBar:note];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [enterPsWd resignFirstResponder];
    if(enterPsWd.text.length==0)
    {
        enterPsWd.placeholder=@"Password";
    }
    [enterEmail resignFirstResponder];
    if(enterEmail.text.length==0)
    {
        enterEmail.placeholder=@"Email";
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];
    textField.placeholder=@"";
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//-(void)checkBox
//{
//    checkbox = [[UIButton alloc] initWithFrame:CGRectMake([[checkboxPosPXArray objectAtIndex:0]floatValue], [[checkboxPosPYArray objectAtIndex:0]floatValue],screenWidth*.05,screenHeight*.03)];
//    [checkbox setBackgroundImage:[UIImage imageNamed: isiPhoneiPad( @"check-box_login.png")] forState:UIControlStateNormal];
//    [checkbox setBackgroundImage:[UIImage imageNamed:  isiPhoneiPad( @"checked-login.png")] forState:UIControlStateSelected];
//
//    [checkbox addTarget:self action:@selector(checkboxSelected:) forControlEvents:UIControlEventTouchUpInside];
//
//    [scrollView addSubview:checkbox];
//}
//
//-(void)checkboxSelected:(id)sender
//{
//    if([checkbox isSelected]==YES)
//    {
//        [checkbox setSelected:NO];
//    }
//    else
//    {
//        [checkbox setSelected:YES];
//    }
//}

#pragma mark facebook signUp
#pragma mark FaceBookSpecificFunctions


-(void)openFbSession
{
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended)
    {
        [FBSession.activeSession closeAndClearTokenInformation];
        //[self openFaceBookController];
    }
    else
    {
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile",@"email"/*, @"user_friends", @"read_friendlists"*/]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error)
         {
             
             NSLog(@"successful Login");
             [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"LoginfromFaceBook"];
             if(FBSession.activeSession.state == FBSessionStateOpen)
             {
                 NSLog(@"****************Login************");
                 [self openFaceBookController];
             }
             else{
                 AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
                 [appDelegate sessionStateChanged:session state:state error:error];
             }
             
         }];
    }
}

-(void)handleFBSessionStateChangeWithNotification:(NSNotification *)notification{
    // Get the session, state and error values from the notification's userInfo dictionary.
    NSDictionary *userInfo = [notification userInfo];
    
    FBSessionState sessionState = [[userInfo objectForKey:@"state"] integerValue];
    NSError *error = [userInfo objectForKey:@"error"];
    
    [self addLoaderView];
    //    self.lblStatus.text = @"Logging you in...";
    //    [self.activityIndicator startAnimating];
    //    self.activityIndicator.hidden = NO;
    
    // Handle the session state.
    // Usually, the only interesting states are the opened session, the closed session and the failed login.
    if (!error) {
        // In case that there's not any error, then check if the session opened or closed.
        if (sessionState == FBSessionStateOpen) {
            // The session is open. Get the user information and update the UI.
            
            //            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            //
            //                if (!error) {
            //                    NSLog(@"%@", result);
            //                }
            //
            //            }];
            
            
            [FBRequestConnection startWithGraphPath:@"me"
                                         parameters:@{@"fields": @"first_name, last_name, picture.type(normal), email"}
                                         HTTPMethod:@"GET"
                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                      if (!error) {
                                          
                                          // Set the use full name.
                                          [PC_DataManager sharedManager].parentObjectInstance.firstName = [NSString stringWithFormat:@"%@",
                                                                                                           [result objectForKey:@"first_name"] ];
                                          
                                          [PC_DataManager sharedManager].parentObjectInstance.lastName = [NSString stringWithFormat:@"%@",
                                                                                                          [result objectForKey:@"last_name"]];
                                          // Set the e-mail address.
                                          [PC_DataManager sharedManager].parentObjectInstance.emailAdd = [result objectForKey:@"email"];
                                          
                                          // Get the user's profile picture.
                                          NSURL *pictureURL = [NSURL URLWithString:[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
                                          
                                          //            NSData *d1 =[NSData dataWithContentsOfURL:pictureURL];
                                          //                UIImage *img=[UIImage imageWithData:d1];
                                          //
                                          
                                          [PC_DataManager sharedManager].parentObjectInstance.image=[[PC_DataManager sharedManager]encodeImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:pictureURL]]];
                                          [self removeLoaderView];
                                          NSLog(@"[PC_DataManager sharedManager].parentObjectInstance.emailAdd:  %@",[PC_DataManager sharedManager].parentObjectInstance.emailAdd);
                                          
                                          NSLog(@"[PC_DataManager sharedManager].parentObjectInstance.image:  %@",[PC_DataManager sharedManager].parentObjectInstance.image);
                                          NSLog(@"[PC_DataManager sharedManager].parentObjectInstance.name:  %@",[PC_DataManager sharedManager].parentObjectInstance.firstName);
                                          NSLog(@"[PC_DataManager sharedManager].parentObjectInstance.name:  %@",[PC_DataManager sharedManager].parentObjectInstance.lastName );
                                          
                                          [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"SignUpfromFaceBook"];
                                          [self openFaceBookController];
                                          
                                      }
                                      else{
                                          NSLog(@"%@", [error localizedDescription]);
                                      }
                                  }];
            
            
            // [self.btnToggleLoginState setTitle:@"Logout" forState:UIControlStateNormal];
            
        }
        else if (sessionState == FBSessionStateClosed || sessionState == FBSessionStateClosedLoginFailed){
            // A session was closed or the login was failed. Update the UI accordingly.
            //            [self.btnToggleLoginState setTitle:@"Login" forState:UIControlStateNormal];
            //            self.lblStatus.text = @"You are not logged in.";
            //            self.activityIndicator.hidden = YES;
            
            [self removeLoaderView];
            
        }
    }
    else{
        // In case an error has occurred, then just log the error and update the UI accordingly.
        NSLog(@"Error: %@", [error localizedDescription]);
        
        //        [self hideUserInfo:YES];
        //        [self.btnToggleLoginState setTitle:@"Login" forState:UIControlStateNormal];
    }
}






-(void)openFaceBookController
{
    ProfileSetUpViewController *profile2=[[ProfileSetUpViewController alloc]init];
    [self.navigationController pushViewController:profile2 animated:YES];
    //    FaceBookFriendsViewController *faceBookFriendController=[[FaceBookFriendsViewController alloc]init];
    //    [self.navigationController pushViewController:faceBookFriendController animated:YES];
    //   [self.navigationController pushViewController:[[FBUserSettingsViewController alloc] init] animated:YES];
}


#pragma mark VALIDATIONS

-(BOOL)validateData
{
    if(enterEmail.text.length==0 || enterPsWd.text.length==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Invalid Data" message:@"Email and password fields can't be blank" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (!(enterEmail.text.length==0) && ![[PC_DataManager sharedManager]NSStringIsValidEmail:enterEmail.text])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Invalid Data" message:@"Plaese check your email Id" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
        NSLog(@"validate from server for correct details");
        //if([enterEmail.text isEqualToString:[PC_DataManager sharedManager].parentObjectInstance.emailAdd])
        if(!(enterEmail.text.length==0) && !(enterPsWd.text.length==0))
        {
            return ([self serverValidation]);
        }
        else
        {
            NSLog(@"account doesnot exist");
        }
    }
    return NO;
}

#pragma mark ServerValidation/ user existence

-(void)isUserExist
{
    
    [self whichScreenToOpen];
    
    
    //    if([[NSUserDefaults standardUserDefaults]valueForKey:@"RegistrationCompleted"])
    //    {
    //        [[PC_DataManager sharedManager] loadLiveDataFromCoreData];
    //
    //
    //
    //        AccessProfileViewController *access=[[AccessProfileViewController alloc]init];
    //         UINavigationController *naviCtrl=[[UINavigationController alloc]initWithRootViewController:access];
    //        [self presentViewController:naviCtrl animated:YES completion:nil];
    //        //UINavigationController *navigation=[[UINavigationController alloc]initWithRootViewController:access];
    //       // [self.navigationController pushViewController:access animated:YES];
    ////        TabBarViewController *app=[[TabBarViewController alloc]init];
    ////        NSLog(@"%@",app);
    ////        ParentViewProfile *parentProfile=[[ParentViewProfile alloc]init];
    ////        [self.navigationController pushViewController:parentProfile animated:YES];
    //    }
    //
}


-(BOOL)serverValidation
{
    BOOL isExist;
    
    //check and validate from server
    isExist=YES;
    [[NSUserDefaults standardUserDefaults]setValue:enterEmail.text forKey:@"loginDetails"];
    
    return isExist;
}




#pragma mark activity indicator
/*-(void)showLoaderView:(BOOL)show withText:(NSString *)text
 {
 static UILabel *label;
 static UIActivityIndicatorView *activity;
 static UIView *loaderView;
 
 if(show)
 {
 
 loaderView=[[UIView alloc] initWithFrame:self.view.bounds];
 [loaderView setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.4]];
 
 label=[[UILabel alloc] initWithFrame:CGRectMake(0, (loaderView.bounds.size.height/2)-10, loaderView.bounds.size.width, 20)];
 [label setFont:[UIFont systemFontOfSize:14.0]];
 [label setText:text];
 [label setTextAlignment:NSTextAlignmentCenter];
 [loaderView addSubview:label];
 
 activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
 
 activity.center=CGPointMake(label.center.x, label.frame.origin.y+label.frame.size.height+10+activity.frame.size.height/2);
 
 [activity startAnimating];
 [loaderView addSubview:activity];
 [self.view addSubview:loaderView];
 }else
 {
 
 [label removeFromSuperview];
 [activity removeFromSuperview];
 [loaderView removeFromSuperview];
 label=nil;
 activity=nil;
 loaderView=nil;
 }
 }
 */

-(void)showAlertWithTitle:(NSString *)heading andMsg:(NSString*)msg
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:heading message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

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

#pragma mark OTHER functionalities
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark DEVICE TOKEN CHECK
-(void)checkDeviceToken:(NSString *)string
{
    //isDeviceTokenExist=YES;
    CheckDeviceIDExists *check=[[CheckDeviceIDExists alloc]init];
    [check initService:@{
                         @"DeviceID":string
                         }];
    [check setDelegate:self];
    check.serviceName=@"CheckDeviceIDExists";
    [self addLoaderView];
}

-(void)ifAlreadyExist:(BOOL)isExist
{
    //SignUpViewController *sign1=[[SignUpViewController alloc]init];
    // [sign isDeviceTokenExist:isExist];
}

//-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
//}
//
//-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection{
//
//    NSLog(@"here i am  %@", dictionary);
//}

#pragma mark nameTextDelegate
-(void)TouchAtNameTextView:(NameAndTextButton *)touchView
{
    if(touchView.tag==1)
    {
        [self facebookTouched];
    }
    else if(touchView.tag==2)
    {
        [self googleTouched];
    }
}

#pragma mark resetData
-(void)resetData
{
    lockImg.alpha=0.0;
    userImg.alpha=0.0;
    enterEmail.alpha=0.0f;
    enterEmail.userInteractionEnabled=NO;
    enterPsWd.alpha=0.f;
    enterPsWd.userInteractionEnabled=NO;
    forgotPswdButton.userInteractionEnabled=NO;
    forgotPswdButton.alpha=0.0f;
}


@end
