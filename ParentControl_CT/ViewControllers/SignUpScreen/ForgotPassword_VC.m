//
//  ForgotPassword_VC.m
//  ParentControl_CT
//
//  Created by Veenus Chhabra on 19/10/15.
//  Copyright © 2015 ImagineInteractive. All rights reserved.
//

#import "ForgotPassword_VC.h"
#import "PC_DataManager.h"
#import "Constant.h"
#import "ShowActivityLoadingView.h"
#import "ForgetPassword.h"
#import "ResetPassword.h"
#import "CheckPassword.h"
#import "AboutUs.h"
#import "ContactUs.h"

@interface ForgotPassword_VC ()<UITextFieldDelegate,UrlConnectionDelegate>

@end

@implementation ForgotPassword_VC
{
    UIImageView *bkGndImg;
    UIImageView *titleImg;
    UIImageView *lockImg;
    UILabel     *subTitle;
    UILabel     *subHead;
    
    UIButton    *helpButton;
    UIButton    *aboutUsButton;
    UIButton    *continueButton;
    
    UITextField *enterCode;
    UITextField *enterEmail;
    UITextField *enterPassword;
    UITextField *reEnterPassword;
    
    UITextField *activeField;
    NSString    *currentScreen;
    UIView      *lineView;
    
    UIScrollView *scrollView;
    ShowActivityLoadingView *loaderView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[PC_DataManager sharedManager]getWidthHeight];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self updateView];
    //    [self drawVerifyCodescreen];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=YES;
}
-(void)updateView{
    [self drawBackGround];
}

-(void)drawBackGround
{
    if(!scrollView)
    {
        scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        [scrollView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:scrollView];
        
        bkGndImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"loginBgImg.png")]];
        bkGndImg.frame=CGRectMake(0, 0, screenWidth, screenHeight);
        [scrollView addSubview:bkGndImg];
        
        [self drawTitle];
        [self drawBottomButtons];
        [self drawEnterEmailScreen];
        [self addContinueButton];
    }
}
-(void)drawTitle
{
    titleImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"pinwiLogo.png")]];
    titleImg.center=CGPointMake(screenWidth/2, .16*screenHeight);
    [scrollView addSubview:titleImg];
    
    lockImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:isiPhoneiPad(@"lock.png")]];
    lockImg.center=CGPointMake(screenWidth/2, .37*screenHeight);
    [scrollView addSubview:lockImg];
    
    subTitle=[[UILabel alloc]init];
    //    [subTitle setText:@"Verify Your Code."];
    subTitle.font=[UIFont fontWithName:RobotoRegular size:ScreenHeightFactor*16];
    subTitle.frame=CGRectMake(cellPaddingReg,titleImg.frame.origin.y+titleImg.frame.size.height+20*ScreenHeightFactor,screenWidth-2*cellPaddingReg,ScreenHeightFactor*25);
    subTitle.textColor=[[UIColor whiteColor]colorWithAlphaComponent:0.6f];
    subTitle.textAlignment=NSTextAlignmentCenter;
    subTitle.center=CGPointMake(screenWidth/2, subTitle.center.y);
    [scrollView addSubview:subTitle];
    
    subHead=[[UILabel alloc]init];
    //    [subHead setText:@"Enter the Code below and\n Click Continue to update your password."];
    subHead.font=[UIFont fontWithName:RobotoRegular size:ScreenHeightFactor*13];
    subHead.frame=CGRectMake(cellPaddingReg,screenHeight*.42,screenWidth-cellPaddingReg,ScreenHeightFactor*30);
    subHead.textColor=[[UIColor whiteColor]colorWithAlphaComponent:0.6f];
    subHead.textAlignment=NSTextAlignmentCenter;
    subHead.numberOfLines=2;
    subHead.center=CGPointMake(screenWidth/2, subHead.center.y);
    [scrollView addSubview:subHead];
    
    //    subHead.backgroundColor=appBackgroundColor;
    //    subTitle.backgroundColor=AmusersRed;
    
}

-(void)drawBottomButtons
{
    aboutUsButton=[UIButton buttonWithType:UIButtonTypeSystem];
    
    [aboutUsButton setTitle:@"About Us" forState:UIControlStateNormal];
    aboutUsButton.tintColor=Aboutuscolor;//logintextGreyColor;
    aboutUsButton.backgroundColor=[UIColor clearColor];
    [aboutUsButton setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    aboutUsButton.titleLabel.font=[UIFont fontWithName:RobotoLight size:.02*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    [aboutUsButton sizeToFit];
    aboutUsButton.frame=CGRectMake(0, 0, screenWidth*.5, screenHeight*.05);
    aboutUsButton.center=CGPointMake(screenWidth*.25,screenHeight-aboutUsButton.frame.size.height/2);
    aboutUsButton.layer.borderWidth=0.5f*ScreenHeightFactor;
    aboutUsButton.layer.borderColor=lineColor.CGColor;
    [aboutUsButton addTarget:self action:@selector(aboutUsButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:aboutUsButton];
    
    
    helpButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [helpButton setTitle:@"Help" forState:UIControlStateNormal];
    helpButton.tintColor=Aboutuscolor;
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
    [helpButton addTarget:self action:@selector(helpButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:helpButton];
}

-(void)drawVerifyCodescreen
{
    [enterEmail removeFromSuperview];
    [lineView removeFromSuperview];
    [subTitle setText:@"Verify Your Code."];
    subHead.frame=CGRectMake(cellPaddingReg,screenHeight*.42,screenWidth-cellPaddingReg,ScreenHeightFactor*50);
    [subHead setText:@"Enter the Code below and\n Click Continue to update your password."];
    
    enterCode = [self setUptextField:enterCode forString:@"Enter Code" withXpos:cellPaddingReg*2 withYpos:screenHeight*.53 withWidth:screenWidth-4*cellPaddingReg withHieght:screenHeight*.05 isSecuretext:NO];
    
    currentScreen=PinWiCheckPassword;
}

-(void)drawEnterEmailScreen
{
    [subTitle setText:@"Forget Password."];
    [subHead setText:@"Enter your registered email id and click Continue."];
    
    enterEmail = [self setUptextField:enterEmail forString:@"Email ID" withXpos:cellPaddingReg*2 withYpos:screenHeight*.5 withWidth:screenWidth-4*cellPaddingReg withHieght:screenHeight*.05 isSecuretext:NO];
    [enterEmail setKeyboardType:UIKeyboardTypeEmailAddress];
    enterEmail.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    currentScreen=PinWiForgetPassword;
}

-(void)updatePassword
{
    [enterCode removeFromSuperview];
    [lineView removeFromSuperview];
    [subHead removeFromSuperview];
    [self removeLoaderView];
    [subTitle setText:@"Update Password."];
    //    subHead.frame=CGRectMake(cellPaddingReg,screenHeight*.42,screenWidth-cellPaddingReg,ScreenHeightFactor*30);
    //    [subHead setText:@"Enter your registered email id and click Continue."];
    
    enterPassword = [self setUptextField:enterPassword forString:@"New Password" withXpos:cellPaddingReg*2 withYpos:screenHeight*.45 withWidth:screenWidth-4*cellPaddingReg withHieght:screenHeight*.05 isSecuretext:YES];
    
    reEnterPassword = [self setUptextField:reEnterPassword forString:@"Confirm New Password" withXpos:cellPaddingReg*2 withYpos:screenHeight*.53 withWidth:screenWidth-4*cellPaddingReg withHieght:screenHeight*.05 isSecuretext:YES];
    
    [continueButton setTitle:@"Save" forState:UIControlStateNormal];
    
    currentScreen=PinWiResetPassword;
}

-(UITextField*)setUptextField:(UITextField*)textField1 forString:(NSString*)str withXpos:(float)x withYpos:(float)y withWidth:(float)wd withHieght:(float)ht isSecuretext:(BOOL)secured
{
    UITextField *textField=textField1;
    textField=[[UITextField alloc]initWithFrame:CGRectMake(x,y,wd,ht)];
    textField.placeholder = str;
    [textField setValue:logintextGreyPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    textField.textColor=logintextGreyColor;
    textField.tintColor=[UIColor whiteColor];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    [textField setFont:[UIFont fontWithName:RobotoRegular size:12*ScreenHeightFactor]];
    [scrollView addSubview:textField];
    textField.delegate=self;
    
    if(secured)
    {
        textField.secureTextEntry=secured;
    }
    
    lineView= [[PC_DataManager sharedManager] drawLineView_withXPos:textField.center.x andYPos:textField.center.y+.02*screenHeight withScrnWid:textField.frame.size.width withScrnHt:.001*screenHeight ofColor:lineTextColor];
    [scrollView addSubview:lineView];
    
    return textField;
}

-(void)addContinueButton
{
    continueButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [continueButton setTitle:@"Continue" forState:UIControlStateNormal];
    continueButton.tintColor=[UIColor blackColor];
    continueButton.backgroundColor=buttonGreenColor;
    [continueButton setContentEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    continueButton.titleLabel.font=[UIFont fontWithName:RobotoRegular size:.023*sqrtf(powf(screenWidth, 2)+powf(screenHeight, 2))];
    [continueButton sizeToFit];
    continueButton.frame=CGRectMake(cellPaddingReg*2, .8*screenHeight, screenWidth-4*cellPaddingReg, .066*screenHeight);
    continueButton.center=CGPointMake(screenWidth*.5,screenHeight*.67);
    [continueButton addTarget:self action:@selector(continueBtnTouched) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:continueButton];
}

-(void)continueBtnTouched
{
    if([currentScreen isEqualToString:PinWiForgetPassword])
    {
        if (!(enterEmail.text.length==0) && [[PC_DataManager sharedManager]NSStringIsValidEmail:enterEmail.text])
        {
            ForgetPassword *forgetPassword = [[ForgetPassword alloc] init];
            [forgetPassword initService:@{@"EmailAddress":enterEmail.text}];
            [forgetPassword setDelegate:self];
            forgetPassword.serviceName=PinWiForgetPassword;
            [self addLoaderView];
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Invalid Data" message:@"Your email ID may not be correct. Please check." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else if([currentScreen isEqualToString:PinWiCheckPassword])
    {
        if (enterCode.text.length!=0)
        {
            CheckPassword  *checkPassword = [[CheckPassword alloc] init];
            [checkPassword initService:@{
                                         @"EmailAddress"       :enterEmail.text,
                                         @"Code"               :enterCode.text,
                                         }];
            [checkPassword setDelegate:self];
            checkPassword.serviceName=PinWiCheckPassword;
            [self addLoaderView];
            
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Incomplete Data" message:@"Please enter verification code sent to you." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else if([currentScreen isEqualToString:PinWiResetPassword])
    {
        if (enterPassword.text.length!=0 && reEnterPassword.text.length!=0 && [enterPassword.text isEqualToString:reEnterPassword.text])
        {
            NSLog(@"password : %@",enterPassword.text);
            NSLog(@"new password : %@",reEnterPassword.text);
            
            
            ResetPassword  *resetPassword = [[ResetPassword alloc] init];
            [resetPassword initService:@{
                                         @"EmailAddress"       :enterEmail.text,
                                         @"NewPassword"        :enterPassword.text,
                                         @"ConfirmPassword"    :reEnterPassword.text
                                         }];
            [resetPassword setDelegate:self];
            resetPassword.serviceName=PinWiResetPassword;
            [self addLoaderView];
            
        }
        else
        {
            UIAlertView *alert;
            if(enterPassword.text.length==0)
            {
                alert =[[UIAlertView alloc]initWithTitle:@"Incomplete Data" message:@"Please enter the password." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            }
            else if(reEnterPassword.text.length==0)
            {
                alert =[[UIAlertView alloc]initWithTitle:@"Incomplete Data" message:@"Please enter and confirm the password." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            }
            else if (![enterPassword.text isEqualToString:reEnterPassword.text])
            {
                alert =[[UIAlertView alloc]initWithTitle:@"Invalid Data" message:@"The two passwords entered are not same. Please check." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            }
            [alert show];
        }
    }
}
-(void)aboutUsTouched
{
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

#pragma mark textfield delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    activeField=textField;
}
-(BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark KeyBoard Notification
-(void) keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0.0, kbSize.height+64, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    CGPoint point=activeField.frame.origin;
    //point.y+=64;
    if (!CGRectContainsPoint(aRect,point))
    {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

-(void) keyboardWillHide:(NSNotification *)notification
{
    UIEdgeInsets contentInsets=UIEdgeInsetsMake(0, 0.0,0.0, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    NSLog(@"Live=%f",self.view.frame.size.height/2.0f);
}

#pragma mark SERVICES CONNECTION DELEGATE
-(void)connectionFailedWithError:(NSString *)errorMessage withService:(UrlConnection *)connection{
    [self removeLoaderView];
    if([connection.serviceName isEqualToString:PinWiResetPassword])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"Something went wrong. Please Try Again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)connectionDidFinishLoadingData:(NSDictionary *)dictionary withService:(UrlConnection *)connection{
    
    [self removeLoaderView];
    if([connection.serviceName isEqualToString:PinWiForgetPassword])
    {
        NSDictionary * dict= [connection getJsonWithXmlDictionary:dictionary ResponseKey:PinWiForgetPasswordResponse resultKey:PinWiForgetPasswordResult];
        if(!dict)
        {
            return;
        }
        // [self resetPassword];
        [self drawVerifyCodescreen];
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Forgot Password" message:@"A verification code has been sent to code to your registered email ID." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([connection.serviceName isEqualToString:PinWiCheckPassword])
    {
        NSDictionary * dict= [connection getJsonWithXmlDictionary:dictionary ResponseKey:PinWiCheckPasswordResponse resultKey:PinWiCheckPasswordResult];
        if(!dict)
        {
            return;
        }
        // [self resetPassword];
        [self updatePassword];
    }
    else  if([connection.serviceName isEqualToString:PinWiResetPassword])
    {
        NSDictionary *dict = [connection getJsonWithXmlDictionary:dictionary ResponseKey:PinWiResetPasswordResponse resultKey:PinWiResetPasswordResult];
        if(!dict)
        {
            return;
        }
        [self dismissViewControllerAnimated:YES completion:nil];
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
